@tool
extends EditorScript
class_name GenerateAudioRandomized

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var audio_manifest: AudioManifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

var playlist_resource_path: String = ""

func _run():
	if playlist_resource_path.is_empty():
		emit_signal("generation_finished", false, "Caminho do recurso da playlist não fornecido.")
		return

	var playlist = load(playlist_resource_path)
	if not playlist or not playlist is AudioStreamPlaylist:
		emit_signal("generation_finished", false, "Recurso de playlist inválido: " + playlist_resource_path)
		return

	var randomized_stream = AudioStreamRandomized.new()
	for i in range(playlist.stream_count):
		var stream = playlist.get("stream_%d" % i)
		if stream:
			randomized_stream.add_stream(stream)

	var file_name = playlist_resource_path.get_file().get_basename().replace("_playlist", "")
	var new_path = audio_config.get_randomized_save_path().path_join(file_name + "_randomized.tres")

	var target_dir = audio_config.get_randomized_save_path()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(target_dir)):
		var error_make_dir = DirAccess.make_dir_recursive(target_dir)
		if error_make_dir != OK:
			emit_signal("generation_finished", false, "Falha ao criar o diretório: %s, Erro: %s" % [target_dir, error_make_dir])
			return

	var error = ResourceSaver.save(randomized_stream, new_path)
	if error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioStreamRandomized: %s" % error)
		return

	# Atualizar AudioManifest
	var original_key = file_name.to_lower()
	if audio_manifest.playlists.has(original_key):
		audio_manifest.playlists.erase(original_key)
	audio_manifest.randomized[original_key] = new_path
	ResourceSaver.save(audio_manifest, audio_manifest.resource_path)

	# Excluir o arquivo da playlist original
	var error_remove = DirAccess.remove(playlist_resource_path)
	if error_remove != OK:
		push_error("Falha ao remover o arquivo da playlist original: %s, Erro: %s" % [playlist_resource_path, error_remove])

	emit_signal("generation_finished", true, "AudioStreamRandomized gerado com sucesso: " + new_path)