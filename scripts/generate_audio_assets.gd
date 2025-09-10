@tool
extends EditorScript
signal progress_updated(current: int, total: int)
signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig

var _files_scanned = 0
var _total_files = 0

func _run():
	if not audio_config:
		push_error("AudioConfig not loaded.")
		emit_signal("generation_finished", false, "AudioConfig not loaded.")
		return

	_files_scanned = 0
	_total_files = 0
	audio_config.generated_playlists.clear()

	for mapping in audio_config.path_mappings:
		var source_path = mapping.get("source", "")
		if not source_path.is_empty():
			_count_files_in_dir(source_path)

	for mapping in audio_config.path_mappings:
		var source_path = mapping.get("source", "")
		var target_path = mapping.get("target", "")
		if source_path.is_empty() or target_path.is_empty():
			continue
		
		_generate_playlists_for_mapping(source_path, source_path, target_path)

	ResourceSaver.save(audio_config, audio_config.resource_path)
	emit_signal("generation_finished", true, "Audio assets generated successfully.")

func _count_files_in_dir(path: String):
	var dir = DirAccess.open(path)
	if not dir:
		return
	for item in dir.get_files():
		if item.ends_with(".ogg") or item.ends_with(".wav"):
			_total_files += 1
	for item in dir.get_directories():
		_count_files_in_dir(path.path_join(item))

func _generate_playlists_for_mapping(base_source_path: String, current_source_path: String, base_target_path: String):
	var dir = DirAccess.open(current_source_path)
	if not dir:
		return

	var audio_files_in_current_dir: Array[String] = []
	for file_name in dir.get_files():
		if file_name.ends_with(".ogg") or file_name.ends_with(".wav"):
			audio_files_in_current_dir.append(current_source_path.path_join(file_name))

	if not audio_files_in_current_dir.is_empty():
		var playlist = AudioStreamPlaylist.new()
		playlist.loop = audio_config.default_playlist_loop
		
		for file_path in audio_files_in_current_dir:
			var stream = load(file_path)
			if stream:
				playlist.add_stream(stream)
			_files_scanned += 1
			emit_signal("progress_updated", _files_scanned, _total_files)

		var key = current_source_path.replace(base_source_path, "").trim_prefix("/").replace("/", "_").to_lower()
		if key.is_empty():
			key = current_source_path.get_file().to_lower()

		var relative_path = current_source_path.replace(base_source_path, "")
		var save_path = base_target_path.path_join(relative_path).path_join(key + ".tres")

		var save_dir = save_path.get_base_dir()
		if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(save_dir)):
			DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(save_dir))

		var error = ResourceSaver.save(playlist, save_path)
		if error == OK:
			audio_config.generated_playlists[key] = save_path

	for sub_dir_name in dir.get_directories():
		_generate_playlists_for_mapping(base_source_path, current_source_path.path_join(sub_dir_name), base_target_path)
