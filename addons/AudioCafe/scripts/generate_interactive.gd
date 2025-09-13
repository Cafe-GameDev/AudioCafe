@tool
extends EditorScript
class_name GenerateInteractive

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var playlist_keys: Array[String] = [] # Chaves das playlists a serem usadas
@export var interactive_name: String = "new_interactive" # Nome para o recurso interativo

func _run():
	print("Generating AudioStreamPlaybackInteractive...")
	
	var success = true
	var message = ""

	if playlist_keys.is_empty():
		success = false
		message = "Nenhuma chave de playlist fornecida para gerar o interativo."
		emit_signal("generation_finished", success, message)
		return

	var interactive_resource = AudioStreamPlaybackInteractive.new()
	var loaded_playlists: Array[AudioStreamPlaybackPlaylist] = []

	for key in playlist_keys:
		if audio_config.key_resource.has(key):
			var playlist_path = audio_config.key_resource[key]
			var playlist = ResourceLoader.load(playlist_path)
			if playlist is AudioStreamPlaybackPlaylist:
				loaded_playlists.append(playlist)
			else:
				printerr("GenerateInteractive: Recurso em %s não é um AudioStreamPlaybackPlaylist válido." % playlist_path)
				success = false
				message = "Recurso inválido para a chave de playlist: %s" % key
				break
		else:
			printerr("GenerateInteractive: Chave de playlist '%s' não encontrada no audio_config.key_resource." % key)
			success = false
			message = "Chave de playlist não encontrada: %s" % key
			break

	if not success:
		emit_signal("generation_finished", success, message)
		return

	if loaded_playlists.is_empty():
		success = false
		message = "Nenhuma playlist válida foi carregada para gerar o interativo."
		emit_signal("generation_finished", success, message)
		return

	# Configura o AudioStreamPlaybackInteractive com as playlists
	# Nota: A API do AudioStreamPlaybackInteractive pode variar. 
	# Aqui, estamos assumindo uma forma básica de adicionar playlists.
	# Pode ser necessário ajustar dependendo de como você quer que as transições funcionem.
	for playlist in loaded_playlists:
		# Exemplo: Adicionar cada playlist como um 'clip' ou 'segmento' se a API permitir.
		# Para este exemplo, vamos apenas adicionar a primeira playlist como o stream principal
		# e as outras como transições ou clips, dependendo da sua implementação desejada.
		# Como não há uma propriedade 'playlist' direta no Interactive, 
		# vamos usar a primeira playlist como base e as outras como clips.
		# Isso é um placeholder e precisará ser refinado com a lógica exata de transição.
		if interactive_resource.base_stream == null:
			interactive_resource.base_stream = playlist.playlist[0] if not playlist.playlist.is_empty() else null
		# interactive_resource.add_clip(playlist.playlist[0]) # Exemplo de como adicionar clips, se a API permitir

	var save_dir = audio_config.dist_path.path_join("interactives")
	var interactive_save_path = save_dir.path_join(interactive_name.to_lower().replace(" ", "_") + ".tres")

	var dir_access = DirAccess.new()
	if not dir_access.dir_exists_absolute(ProjectSettings.globalize_path(save_dir)):
		dir_access.make_dir_recursive_absolute(ProjectSettings.globalize_path(save_dir))

	var error = ResourceSaver.save(interactive_resource, interactive_save_path)
	if error != OK:
		success = false
		message = "Falha ao salvar AudioStreamPlaybackInteractive em %s: %s" % [interactive_save_path, error]
	else:
		print("  - Gerado AudioStreamPlaybackInteractive '%s' em: %s" % [interactive_name, interactive_save_path])
		audio_config.key_resource[interactive_name.to_lower().replace(" ", "_")] = interactive_save_path
		audio_config._save_and_emit_changed()

	emit_signal("generation_finished", success, message)
