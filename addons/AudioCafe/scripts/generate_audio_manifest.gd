@tool
extends EditorScript
class_name GenerateAudioManifest

signal progress_updated(current: int, total: int)
signal generation_finished(success: bool, message: String)

const MANIFEST_SAVE_FILE = "res://addons/AudioCafe/resources/audio_manifest.tres"

var _total_files_to_scan = 0
var _files_scanned = 0

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")

func _run():
	_total_files_to_scan = 0
	_files_scanned = 0

	# Step 1: Count files for progress bar using assets_paths
	for path in audio_config.assets_paths:
		_count_files_in_directory(path)

	var collected_streams: Dictionary = {} # {final_key: [stream1, stream2, ...]}

	# Step 2: Collect all streams by their final_key using assets_paths
	var success_collection = _collect_streams_by_key(audio_config.assets_paths, collected_streams)

	var audio_manifest = AudioManifest.new()
	var overall_success = true
	var message = ""

	var base_dist_path = audio_config.dist_path.trim_suffix("/")
	var playlist_dist_save_path = base_dist_path + "/playlist/"
	var random_dist_save_path = base_dist_path + "/random/"
	var sync_dist_save_path = base_dist_path + "/sync/"
	var interactive_dist_save_path = base_dist_path + "/interactive/"

	var dist_dir_access = DirAccess.open("res://")
	if not dist_dir_access:
		printerr("Falha ao abrir o diretório 'res://'.")
		emit_signal("generation_finished", false, "Falha ao acessar o diretório base do projeto.")
		return

	for path_to_create in [playlist_dist_save_path, random_dist_save_path, sync_dist_save_path, interactive_dist_save_path]:
		var relative_path = path_to_create.replace("res://", "")
		if not dist_dir_access.dir_exists(relative_path):
			var error = dist_dir_access.make_dir_recursive(relative_path)
			if error != OK:
				printerr("Falha ao criar o diretório: %s, Erro: %s" % [path_to_create, error])
				overall_success = false
				message = "Falha ao criar diretórios de distribuição."
				break
			else:
				print("Diretório criado: %s" % path_to_create)
	
	if not overall_success:
		emit_signal("generation_finished", overall_success, message)
		return

	# Step 3: Process collected streams into playlists
	if success_collection:
		for final_key in collected_streams.keys():
			var streams_for_key = collected_streams[final_key]
			var playlist_file_path = "%s%s_playlist.tres" % [playlist_dist_save_path, final_key]
			
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
				printerr("Falha ao salvar playlist %s: %s" % [playlist_file_path, err])
				overall_success = false
				message = "Falha ao salvar playlists."
				break
			
			# Determine if it's music or sfx based on the key (this is a simplification, might need refinement)
			# For now, let's assume if the key contains "music" it's music, otherwise sfx.
			# A melhor abordagem seria ter pastas separadas para music e sfx nos assets_paths
			# ou uma forma de categorizar os arquivos.
			if final_key.begins_with("music_") or final_key.ends_with("_music"):
				audio_manifest.music_data[final_key] = playlist_file_path
			else:
				audio_manifest.sfx_data[final_key] = playlist_file_path
	else:
		overall_success = false
		message = "Falha ao coletar streams de áudio."

	# Step 4: Save the main AudioManifest
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

func _collect_streams_by_key(paths: Array[String], collected_streams: Dictionary) -> bool:
	for path in paths:
		if not _scan_directory_for_streams(path, collected_streams, path):
			return false
	return true

func _scan_directory_for_streams(current_path: String, collected_streams: Dictionary, root_path: String) -> bool:
	var dir = DirAccess.open(current_path)
	if not dir:
		printerr("GenerateAudioManifest: Failed to open directory: %s" % current_path)
		return false
	
	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		if dir.current_is_dir():
			if not _scan_directory_for_streams(current_path.path_join(file_or_dir_name), collected_streams, root_path):
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