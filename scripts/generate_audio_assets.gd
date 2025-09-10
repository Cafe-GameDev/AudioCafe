@tool
extends EditorScript
signal progress_updated(current: int, total: int)
signal generation_finished(success: bool, message: String)

const MANIFEST_SAVE_PATH = "res://addons/AudioCafe/resources/audio_manifest.tres"

@export var audio_config: AudioConfig

var _total_files_to_scan = 0
var _files_scanned = 0

func _run():
	if not audio_config:
		push_error("AudioConfig not loaded.")
		emit_signal("generation_finished", false, "AudioConfig not loaded.")
		return

	_total_files_to_scan = 0
	_files_scanned = 0
	
	var v1_manifest = _generate_v1_manifest()
	if not v1_manifest:
		emit_signal("generation_finished", false, "Failed to generate v1 compatibility manifest.")
		return
	
	var success = _generate_v2_playlists(v1_manifest)
	if success:
		emit_signal("generation_finished", true, "Audio assets generated successfully.")
	else:
		emit_signal("generation_finished", false, "Failed during v2 playlist generation.")

func _generate_v1_manifest() -> AudioManifest:
	var audio_manifest = preload("res://addons/AudioCafe/scripts/audio_manifest.gd").new()
	
	var all_source_paths = []
	for mapping in audio_config.path_mappings:
		var source_path = mapping.get("source", "")
		if not source_path.is_empty() and not all_source_paths.has(source_path):
			all_source_paths.append(source_path)
			
	for path in all_source_paths:
		_scan_and_populate_v1_manifest(path, audio_manifest)
		
	var error = ResourceSaver.save(audio_manifest, MANIFEST_SAVE_PATH)
	if error != OK:
		push_error("Failed to save v1 AudioManifest: %s" % error)
		return null
	
	return audio_manifest

func _scan_and_populate_v1_manifest(current_path: String, manifest: AudioManifest):
	var dir = DirAccess.open(current_path)
	if not dir:
		push_error("Failed to open directory: %s" % current_path)
		return

	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		var full_path = current_path.path_join(file_or_dir_name)
		if dir.current_is_dir():
			_scan_and_populate_v1_manifest(full_path, manifest)
		elif file_or_dir_name.ends_with(".ogg") or file_or_dir_name.ends_with(".wav"):
			var uid = ResourceLoader.get_resource_uid(full_path)
			if uid != -1:
				var key = full_path.get_base_dir().get_file().to_lower()
				if not manifest.sfx_data.has(key):
					manifest.sfx_data[key] = []
				manifest.sfx_data[key].append(str(uid))
		file_or_dir_name = dir.get_next()

func _generate_v2_playlists(v1_manifest: AudioManifest) -> bool:
	audio_config.generated_playlists.clear()
	
	var all_keys = v1_manifest.sfx_data.keys()
	all_keys.append_array(v1_manifest.music_data.keys())
	
	_total_files_to_scan = all_keys.size()
	_files_scanned = 0

	for key in all_keys:
		_files_scanned += 1
		emit_signal("progress_updated", _files_scanned, _total_files_to_scan)
		
		var uids = v1_manifest.sfx_data.get(key, [])
		if uids.is_empty():
			uids = v1_manifest.music_data.get(key, [])

		var playlist = AudioStreamPlaylist.new()
		playlist.loop = audio_config.default_playlist_loop
		
		for uid_str in uids:
			var uid_int = uid_str.replace("uid://", "").to_int()
			var res_path = ResourceUID.get_id_path(uid_int)
			if not res_path.is_empty():
				var stream = load(res_path)
				if stream:
					playlist.add_stream(stream)

		var source_dir = ResourceUID.get_id_path(uids[0].replace("uid://", "").to_int()).get_base_dir()
		var target_mapping = _find_mapping_for_path(source_dir)
		
		if not target_mapping:
			push_warning("No target path mapping found for source: %s" % source_dir)
			continue

		var relative_path = source_dir.replace(target_mapping["source"], "")
		var save_path = target_mapping["target"].path_join(relative_path).path_join(key + ".tres")
		
		var dir = save_path.get_base_dir()
		if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir)):
			DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
			
		var error = ResourceSaver.save(playlist, save_path)
		if error != OK:
			push_error("Failed to save playlist resource '%s': %s" % [save_path, error])
			return false
		
		audio_config.generated_playlists[key] = save_path

	ResourceSaver.save(audio_config, audio_config.resource_path)
	return true

func _find_mapping_for_path(path: String) -> Dictionary:
	var best_match: Dictionary = {}
	var longest_path = -1
	
	for mapping in audio_config.path_mappings:
		var source_path = mapping.get("source", "")
		if path.begins_with(source_path):
			if source_path.length() > longest_path:
				longest_path = source_path.length()
				best_match = mapping
				
	return best_match
