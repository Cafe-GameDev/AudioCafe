@tool
extends EditorScript
class_name GenerateAudioManifest

signal progress_updated(current: int, total: int)
signal generation_finished(success: bool, message: String)

const MANIFEST_SAVE_FILE = "res://addons/AudioCafe/resources/audio_manifest.tres"
const PLAYLIST_DIST_SAVE_PATH = "res://addons/AudioCafe/dist/playlist/"
const RANDOM_DIST_SAVE_PATH = "res://addons/AudioCafe/dist/random/"
const SYNC_DIST_SAVE_PATH = "res://addons/AudioCafe/dist/sync/"
const INTERACTIVE_DIST_SAVE_PATH = "res://addons/AudioCafe/dist/interactive/"

var _total_files_to_scan = 0
var _files_scanned = 0

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")

func _run():
	_total_files_to_scan = 0
	_files_scanned = 0

	# Step 1: Count files for progress bar
	for path in audio_config.sfx_paths:
		_count_files_in_directory(path)
	for path in audio_config.music_paths:
		_count_files_in_directory(path)

	var collected_sfx_streams: Dictionary = {} # {final_key: [stream1, stream2, ...]}
	var collected_music_streams: Dictionary = {} # {final_key: [stream1, stream2, ...]}

	# Step 2: Collect all streams by their final_key
	var success_sfx = _collect_streams_by_key(audio_config.sfx_paths, collected_sfx_streams, "sfx")
	var success_music = _collect_streams_by_key(audio_config.music_paths, collected_music_streams, "music")

	var audio_manifest = AudioManifest.new()
	var overall_success = true
	var message = ""

	# Ensure PLAYLIST_DIST_SAVE_PATH exists
	var dist_dir = DirAccess.open("res://")
	if not dist_dir.dir_exists(PLAYLIST_DIST_SAVE_PATH.replace("res://", "")):
		dist_dir.make_dir(PLAYLIST_DIST_SAVE_PATH.replace("res://", ""))
		print("Created directory: %s" % PLAYLIST_DIST_SAVE_PATH)

	# Step 3: Process collected SFX streams into playlists
	if success_sfx:
		for final_key in collected_sfx_streams.keys():
			var streams_for_key = collected_sfx_streams[final_key]
			var playlist_file_path = "%s%s_playlist.tres" % [PLAYLIST_DIST_SAVE_PATH, final_key]
			
			var playlist: AudioStreamPlaylist
			if FileAccess.file_exists(playlist_file_path):
				playlist = load(playlist_file_path)
				if playlist == null:
					playlist = AudioStreamPlaylist.new()
			else:
				playlist = AudioStreamPlaylist.new()

			# Clear existing streams in the playlist
			for i in range(playlist.stream_count):
				playlist.set("stream_%d" % i, null)
			playlist.stream_count = 0

			# Add new streams
			for stream in streams_for_key:
				var current_index = playlist.stream_count
				playlist.set("stream_%d" % current_index, stream)
				playlist.stream_count = current_index + 1
			
			var err = ResourceSaver.save(playlist, playlist_file_path)
			if err != OK:
				printerr("Falha ao salvar playlist SFX %s: %s" % [playlist_file_path, err])
				overall_success = false
				message = "Falha ao salvar playlists SFX."
				break
			audio_manifest.sfx_data[final_key] = playlist_file_path
	else:
		overall_success = false
		message = "Falha ao coletar streams SFX."

	# Step 4: Process collected Music streams into playlists
	if overall_success and success_music:
		for final_key in collected_music_streams.keys():
			var streams_for_key = collected_music_streams[final_key]
			var playlist_file_path = "%s%s_playlist.tres" % [PLAYLIST_DIST_SAVE_PATH, final_key]
			
			var playlist: AudioStreamPlaylist
			if FileAccess.file_exists(playlist_file_path):
				playlist = load(playlist_file_path)
				if playlist == null:
					playlist = AudioStreamPlaylist.new()
			else:
				playlist = AudioStreamPlaylist.new()

			# Clear existing streams in the playlist
			for i in range(playlist.stream_count):
				playlist.set("stream_%d" % i, null)
			playlist.stream_count = 0

			# Add new streams
			for stream in streams_for_key:
				var current_index = playlist.stream_count
				playlist.set("stream_%d" % current_index, stream)
				playlist.stream_count = current_index + 1
			
			var err = ResourceSaver.save(playlist, playlist_file_path)
			if err != OK:
				printerr("Falha ao salvar playlist Música %s: %s" % [playlist_file_path, err])
				overall_success = false
				message = "Falha ao salvar playlists Música."
				break
			audio_manifest.music_data[final_key] = playlist_file_path
	elif overall_success: # Only set message if previous steps were successful
		overall_success = false
		message = "Falha ao coletar streams Música."

	# Step 5: Save the main AudioManifest
	if overall_success:
		var err = ResourceSaver.save(audio_manifest, MANIFEST_SAVE_FILE)
		if err != OK:
			overall_success = false
			message = "Falha ao salvar AudioManifest.tres: %s" % err
		else:
			print("AudioManifest gerado e salvo em: %s" % MANIFEST_SAVE_FILE)

	emit_signal("generation_finished", overall_success, message)

func _count_files_in_directory(current_path: String):
	var dir = DirAccess.open(current_path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		if dir.current_is_dir():
			_count_files_in_directory(current_path.path_join(file_or_dir_name))
		elif file_or_dir_name.ends_with(".ogg") or file_or_dir_name.ends_with(".wav"):
			_total_files_to_scan += 1
		file_or_dir_name = dir.get_next()

func _collect_streams_by_key(paths: Array[String], collected_streams: Dictionary, audio_type: String) -> bool:
	for path in paths:
		if not _scan_directory_for_streams(path, collected_streams, audio_type, path):
			return false
	return true

func _scan_directory_for_streams(current_path: String, collected_streams: Dictionary, audio_type: String, root_path: String) -> bool:
	var dir = DirAccess.open(current_path)
	if not dir:
		printerr("GenerateAudioManifest: Failed to open directory: %s" % current_path)
		return false
	
	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		if dir.current_is_dir():
			if not _scan_directory_for_streams(current_path.path_join(file_or_dir_name), collected_streams, audio_type, root_path):
				return false
		elif file_or_dir_name.ends_with(".ogg") or file_or_dir_name.ends_with(".wav"):
			_files_scanned += 1
			emit_signal("progress_updated", _files_scanned, _total_files_to_scan)

			var resource_path = current_path.path_join(file_or_dir_name)
			var audio_stream = load(resource_path)
			if audio_stream == null:
				printerr("Falha ao carregar AudioStream: %s" % resource_path)
				file_or_dir_name = dir.get_next()
				continue

			var relative_dir_path = resource_path.replace(root_path, "").trim_prefix("/").get_base_dir().trim_suffix("/")
			var final_key = ""
			if not relative_dir_path.is_empty():
				final_key = relative_dir_path.replace("/", "_").to_lower()
			else:
				final_key = file_or_dir_name.get_basename().to_lower()

			if not collected_streams.has(final_key):
				collected_streams[final_key] = []
			collected_streams[final_key].append(audio_stream)
			
		file_or_dir_name = dir.get_next()

	return true
