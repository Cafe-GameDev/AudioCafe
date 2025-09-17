@tool
extends EditorScript
class_name GenerateAudioPlaylist

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var audio_manifest: AudioManifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

var randomized_resource_path: String = ""

func _run():
	if randomized_resource_path.is_empty():
		emit_signal("generation_finished", false, "Caminho do recurso randomized não fornecido.")
		return

	var randomized = load(randomized_resource_path)
	if not randomized or not randomized is AudioStreamRandomized:
		emit_signal("generation_finished", false, "Recurso randomized inválido: " + randomized_resource_path)
		return

	var playlist_stream = AudioStreamPlaylist.new()
	for i in range(randomized.stream_count):
		var stream = randomized.get("stream_%d" % i)
		if stream:
			playlist_stream.add_stream(stream)

	var file_name = randomized_resource_path.get_file().get_basename().replace("_randomized", "")
	var new_path = audio_config.get_playlist_save_path().path_join(file_name + "_playlist.tres")

	var target_dir = audio_config.get_playlist_save_path()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(target_dir)):
		var error_make_dir = DirAccess.make_dir_recursive(target_dir)
		if error_make_dir != OK:
			emit_signal("generation_finished", false, "Falha ao criar o diretório: %s, Erro: %s" % [target_dir, error_make_dir])
			return

	var error = ResourceSaver.save(playlist_stream, new_path)
	if error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioStreamPlaylist: %s" % error)
		return

	# Atualizar AudioManifest
	var original_key = file_name.to_lower()
	if audio_manifest.randomized.has(original_key):
		audio_manifest.randomized.erase(original_key)
	audio_manifest.playlists[original_key] = new_path
	ResourceSaver.save(audio_manifest, audio_manifest.resource_path)

	# Excluir o arquivo randomized original
	var error_remove = DirAccess.remove(randomized_resource_path)
	if error_remove != OK:
		push_error("Falha ao remover o arquivo randomized original: %s, Erro: %s" % [randomized_resource_path, error_remove])

	emit_signal("generation_finished", true, "AudioStreamPlaylist gerado com sucesso: " + new_path)