@tool
extends EditorScript
class_name GenerateSynchronized

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var playlist_key: String = "" # Chave da playlist a ser usada
@export var synchronized_name: String = "new_synchronized" # Nome para o recurso sincronizado

func _run():
	print("Generating AudioStreamSynchronized...")
	
	var success = true
	var message = ""

	if playlist_key.is_empty():
		success = false
		message = "Nenhuma chave de playlist fornecida para gerar o sincronizado."
		emit_signal("generation_finished", success, message)
		return

	var playlist_path = ""
	if audio_config.key_resource.has(playlist_key):
		playlist_path = audio_config.key_resource[playlist_key]
	else:
		printerr("GenerateSynchronized: Chave de playlist '%s' não encontrada no audio_config.key_resource." % playlist_key)
		success = false
		message = "Chave de playlist não encontrada: %s" % playlist_key
		emit_signal("generation_finished", success, message)
		return

	var playlist = ResourceLoader.load(playlist_path)
	if not playlist is AudioStreamPlaybackPlaylist:
		printerr("GenerateSynchronized: Recurso em %s não é um AudioStreamPlaybackPlaylist válido." % playlist_path)
		success = false
		message = "Recurso inválido para a chave de playlist: %s" % playlist_key
		emit_signal("generation_finished", success, message)
		return

	var synchronized_resource = AudioStreamSynchronized.new()
	synchronized_resource.base_stream = playlist # O AudioStreamSynchronized usa um AudioStream como base

	var save_dir = audio_config.dist_path.path_join("synchronized")
	var synchronized_save_path = save_dir.path_join(synchronized_name.to_lower().replace(" ", "_") + ".tres")

	var dir_access = DirAccess.new()
	if not dir_access.dir_exists_absolute(ProjectSettings.globalize_path(save_dir)):
		dir_access.make_dir_recursive_absolute(ProjectSettings.globalize_path(save_dir))

	var error = ResourceSaver.save(synchronized_resource, synchronized_save_path)
	if error != OK:
		success = false
		message = "Falha ao salvar AudioStreamSynchronized em %s: %s" % [synchronized_save_path, error]
	else:
		print("  - Gerado AudioStreamSynchronized '%s' em: %s" % [synchronized_name, synchronized_save_path])
		audio_config.key_resource[synchronized_name.to_lower().replace(" ", "_")] = synchronized_save_path
		audio_config._save_and_emit_changed()

	emit_signal("generation_finished", success, message)
