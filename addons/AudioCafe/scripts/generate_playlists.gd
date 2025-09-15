@tool
extends EditorScript
class_name GeneratePlaylists

signal progress_updated(current: int, total: int)
signal generation_finished(success: bool, message: String)

var _total_files_to_scan = 0
var _files_scanned = 0

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")

func _run():
	_total_files_to_scan = 0
	_files_scanned = 0
	# audio_config.key_resource = {} # Não limpar aqui, pois pode conter outros tipos de recursos

	print("Generating AudioStreamPlaybackPlaylists...")
	
	var success = true
	var message = ""

	# Primeiro, conta o total de arquivos para o progresso
	for path in audio_config.assets_paths:
		_count_audio_files_in_directory(path)

	for asset_path in audio_config.assets_paths:
		if not _process_asset_folder_to_playlist(asset_path):
			success = false
			message = "Falha ao processar o caminho de assets: %s" % asset_path
			break
		if not success:
			break
	
	if success:
		print("AudioStreamPlaybackPlaylists geradas e salvas com sucesso.")
		audio_config._save_and_emit_changed() # Salva o audio_config atualizado
	else:
		push_error(message)

	emit_signal("generation_finished", success, message)

func _count_audio_files_in_directory(current_path: String):
	var dir = DirAccess.open(current_path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		if dir.current_is_dir():
			_count_audio_files_in_directory(current_path.path_join(file_or_dir_name))
		elif file_or_dir_name.ends_with(".ogg") or file_or_dir_name.ends_with(".wav"):
			_total_files_to_scan += 1
		file_or_dir_name = dir.get_next()

func _process_asset_folder_to_playlist(asset_folder_path: String) -> bool:
	var dir = DirAccess.open(asset_folder_path)
	print("DEBUG: Tentando abrir diretório: %s" % asset_folder_path)
	if not dir:
		printerr("GeneratePlaylists: Falha ao abrir o diretório de assets: %s" % asset_folder_path)
		return false
	
	var playlist_name = asset_folder_path.get_file().to_lower().replace(" ", "_")
	if playlist_name.is_empty():
		playlist_name = asset_folder_path.get_basename().to_lower().replace(" ", "_")

	var playlist_save_path = audio_config.dist_path.path_join(playlist_name + "_playlist.tres")
	
	var playlist_resource: AudioStreamPlaylist
	if ResourceLoader.exists(playlist_save_path):
		playlist_resource = ResourceLoader.load(playlist_save_path)
		if not playlist_resource is AudioStreamPlaylist:
			printerr("GeneratePlaylists: Recurso existente em %s não é um AudioStreamPlaybackPlaylist." % playlist_save_path)
			playlist_resource = AudioStreamPlaylist.new()
			
	else:
		playlist_resource = AudioStreamPlaylist.new()
		

	var audio_streams: Array[AudioStream] = []
	_collect_audio_streams_from_directory(asset_folder_path, audio_streams)

	playlist_resource.playlist = audio_streams
	
	var save_dir = playlist_save_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(save_dir)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(save_dir))

	var error = ResourceSaver.save(playlist_resource, playlist_save_path)
	if error != OK:
		printerr("GeneratePlaylists: Falha ao salvar AudioStreamPlaybackPlaylist em %s: %s" % [playlist_save_path, error])
		return false
	
	audio_config.key_resource[playlist_name] = playlist_save_path
	print("  - Gerada AudioStreamPlaybackPlaylist '%s' em: %s" % [playlist_name, playlist_save_path])
	return true

func _collect_audio_streams_from_directory(current_path: String, audio_streams: Array[AudioStream]):
	var dir = DirAccess.open(current_path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		if dir.current_is_dir():
			_collect_audio_streams_from_directory(current_path.path_join(file_or_dir_name), audio_streams)
		elif file_or_dir_name.ends_with(".ogg") or file_or_dir_name.ends_with(".wav"):
			_files_scanned += 1
			emit_signal("progress_updated", _files_scanned, _total_files_to_scan)
			
			var resource_path = current_path.path_join(file_or_dir_name)
			var audio_stream = ResourceLoader.load(resource_path)
			if audio_stream is AudioStream:
				audio_streams.append(audio_stream)
			else:
				printerr("GeneratePlaylists: Recurso em %s não é um AudioStream válido." % resource_path)
		file_or_dir_name = dir.get_next()
