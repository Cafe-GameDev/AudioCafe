@tool
extends EditorScript
class_name GenerateAudioManifest

signal progress_updated(current: int, total: int)
signal generation_finished(success: bool, message: String)

const MANIFEST_SAVE_FILE = "res://addons/AudioCafe/resources/audio_manifest.tres"
const MAX_SYNC_STREAMS = 64

var _total_files_to_scan = 0
var _files_scanned = 0

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")

func _run():
	_total_files_to_scan = 0
	_files_scanned = 0

	for path in audio_config.assets_paths:
		_count_files_in_directory(path)

	var collected_streams: Dictionary = {} # {final_key: [res_path1, res_path2, ...]}

	var success_collection = _collect_streams_by_key(audio_config.assets_paths, collected_streams)

	var audio_manifest = AudioManifest.new()
	var overall_success = true
	var message = ""

	var playlist_dist_save_path = audio_config.get_playlist_save_path()
	var randomized_dist_save_path = audio_config.get_randomized_save_path()
	var interactive_dist_save_path = audio_config.get_interactive_save_path()
	var synchronized_dist_save_path = audio_config.get_synchronized_save_path()

	var dist_dir_access = DirAccess.open("res://")
	if not dist_dir_access:
		printerr("Falha ao abrir o diretório 'res://'.")
		emit_signal("generation_finished", false, "Falha ao acessar o diretório base do projeto.")
		return

	for path_to_create in [playlist_dist_save_path, randomized_dist_save_path, interactive_dist_save_path, synchronized_dist_save_path]:
		var relative_path = path_to_create.replace("res://", "")
		if not dist_dir_access.dir_exists(relative_path):
			var error = dist_dir_access.make_dir_recursive(relative_path)
			if error != OK:
				printerr("Falha ao criar o diretório: %s, Erro: %s" % [path_to_create, error])
				overall_success = false
				message = "Falha ao criar diretórios de distribuição."
				break
	
	if not overall_success:
		emit_signal("generation_finished", overall_success, message)
		return

	if success_collection:
		for final_key in collected_streams.keys():
			var streams_for_key = collected_streams[final_key]
			
			# Processar AudioStreamPlaylist
			var playlist_file_path = "%s%s_playlist.tres" % [playlist_dist_save_path, final_key]
			var playlist: AudioStreamPlaylist
			if FileAccess.file_exists(playlist_file_path):
				playlist = load(playlist_file_path)
				if playlist == null:
					playlist = AudioStreamPlaylist.new()
			else:
				playlist = AudioStreamPlaylist.new()

			playlist.stream_count = 0
			for res_path in streams_for_key:
				var stream = load(res_path)
				if stream:
					playlist.add_stream(stream)
			
			var err = ResourceSaver.save(playlist, playlist_file_path)
			if err != OK:
				printerr("Falha ao salvar playlist %s: %s" % [playlist_file_path, err])
				overall_success = false
				message = "Falha ao salvar playlists."
				break
			
			audio_manifest.playlists[final_key] = [playlist_file_path, str(playlist.stream_count), ResourceLoader.get_resource_uid(playlist_file_path)]

			# Processar AudioStreamRandomizer
			var randomizer_file_path = "%s%s_randomizer.tres" % [randomized_dist_save_path, final_key]
			var randomizer: AudioStreamRandomizer
			if FileAccess.file_exists(randomizer_file_path):
				randomizer = load(randomizer_file_path)
				if randomizer == null:
					randomizer = AudioStreamRandomizer.new()
			else:
				randomizer = AudioStreamRandomizer.new()
			
			while randomizer.get_stream_count() > 0:
				randomizer.remove_stream(0)
			
			for res_path in streams_for_key:
				var stream = load(res_path)
				if stream:
					randomizer.add_stream(stream, 1.0) # Peso padrão de 1.0
			
			err = ResourceSaver.save(randomizer, randomizer_file_path)
			if err != OK:
				printerr("Falha ao salvar randomizer %s: %s" % [randomizer_file_path, err])
				overall_success = false
				message = "Falha ao salvar randomizers."
				break
			
			audio_manifest.randomizer[final_key] = [randomizer_file_path, str(randomizer.get_stream_count()), ResourceLoader.get_resource_uid(randomizer_file_path)]

			# Processar AudioStreamSynchronized
			var synchronized_file_path = "%s%s_synchronized.tres" % [synchronized_dist_save_path, final_key]
			var synchronized_res: AudioStreamSynchronized
			if FileAccess.file_exists(synchronized_file_path):
				synchronized_res = load(synchronized_file_path)
				if synchronized_res == null:
					synchronized_res = AudioStreamSynchronized.new()
			else:
				synchronized_res = AudioStreamSynchronized.new()
			
			var sync_streams_array: Array[AudioStream] = []
			var n_streams := mini(streams_for_key.size(), MAX_SYNC_STREAMS) # Limita o número de streams para synchronized
			for i in range(n_streams):
				var stream = load(streams_for_key[i])
				if stream:
					sync_streams_array.append(stream)
			
			synchronized_res.sync_streams = sync_streams_array
			
			err = ResourceSaver.save(synchronized_res, synchronized_file_path)
			if err != OK:
				printerr("Falha ao salvar synchronized %s: %s" % [synchronized_file_path, err])
				overall_success = false
				message = "Falha ao salvar synchronized streams."
				break
			
			audio_manifest.synchronized[final_key] = [synchronized_file_path, str(synchronized_res.sync_streams.size()), ResourceLoader.get_resource_uid(synchronized_file_path)]

	else:
		overall_success = false
		message = "Falha ao coletar streams de áudio."

	var collected_interactive_streams: Dictionary = {}
	if not _scan_directory_for_resources(interactive_dist_save_path, "AudioStreamInteractive", collected_interactive_streams):
		overall_success = false
		message = "Falha ao coletar AudioStreamInteractive."
	else:
		audio_manifest.interactive = collected_interactive_streams

	if overall_success:
		var err = ResourceSaver.save(audio_manifest, MANIFEST_SAVE_FILE)
		if err != OK:
			overall_success = false
			message = "Falha ao salvar AudioManifest.tres: %s" % err
		
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
		elif file_or_dir_name.to_lower().ends_with(".ogg") or file_or_dir_name.to_lower().ends_with(".wav"):
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
		elif file_or_dir_name.to_lower().ends_with(".ogg") or file_or_dir_name.to_lower().ends_with(".wav"):
			_files_scanned += 1
			emit_signal("progress_updated", _files_scanned, _total_files_to_scan)

			var resource_path = current_path.path_join(file_or_dir_name)
			# Store resource path instead of loading the stream directly for memory optimization
			var relative_dir_path = resource_path.replace(root_path, "").trim_prefix("/").get_base_dir().trim_suffix("/")
			var final_key = ""
			if not relative_dir_path.is_empty():
				final_key = relative_dir_path.replace("/", "_").to_lower()
			else:
				final_key = file_or_dir_name.get_basename().to_lower()

			if not collected_streams.has(final_key):
				collected_streams[final_key] = []
			
			# Deduplicação de caminhos
			var unique_paths: Array[String> = collected_streams[final_key]
			if not unique_paths.has(resource_path):
				unique_paths.append(resource_path)
				collected_streams[final_key] = unique_paths
			
		file_or_dir_name = dir.get_next()

	return true

func _scan_directory_for_resources(current_path: String, resource_class_name: String, collected_resources: Dictionary) -> bool:
	var dir = DirAccess.open(current_path)
	if not dir:
		printerr("GenerateAudioManifest: Falha ao abrir o diretório: %s" % current_path)
		return false
	
	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		if dir.current_is_dir():
			if not _scan_directory_for_resources(current_path.path_join(file_or_dir_name), resource_class_name, collected_resources):
				return false
		elif file_or_dir_name.to_lower().ends_with(".tres"):
			var resource_path = current_path.path_join(file_or_dir_name)
			var loaded_resource = load(resource_path)
			if loaded_resource and loaded_resource.get_class() == resource_class_name:
				var final_key = file_or_dir_name.get_basename().to_lower()
				collected_resources[final_key] = [resource_path, str(loaded_resource.get_stream_count() if loaded_resource.has_method("get_stream_count") else 0), ResourceLoader.get_resource_uid(resource_path)]
			
		file_or_dir_name = dir.get_next()

	return true