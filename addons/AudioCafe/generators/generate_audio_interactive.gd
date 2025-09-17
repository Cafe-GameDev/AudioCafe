@tool
extends EditorScript
class_name GenerateAudioInteractive

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var audio_manifest: AudioManifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

var playlist_resource_paths: Array[String] = []
var interactive_name: String = ""

func _run():
	if playlist_resource_paths.is_empty() or interactive_name.is_empty():
		emit_signal("generation_finished", false, "Caminhos das playlists ou nome interativo não fornecidos.")
		return

	var interactive_stream = AudioStreamInteractive.new()

	for path in playlist_resource_paths:
		var playlist = load(path)
		if not playlist or not playlist is AudioStreamPlaylist:
			emit_signal("generation_finished", false, "Recurso de playlist inválido: " + path)
			return
		interactive_stream.add_clip(playlist)

	var new_path = audio_config.get_interactive_save_path().path_join(interactive_name + "_interactive.tres")

	var target_dir = audio_config.get_interactive_save_path()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(target_dir)):
		var error_make_dir = DirAccess.make_dir_recursive(target_dir)
		if error_make_dir != OK:
			emit_signal("generation_finished", false, "Falha ao criar o diretório: %s, Erro: %s" % [target_dir, error_make_dir])
			return

	var error = ResourceSaver.save(interactive_stream, new_path)
	if error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioStreamInteractive: %s" % error)
		return

	# Atualizar AudioManifest
	audio_manifest.interactive[interactive_name.to_lower()] = new_path
	ResourceSaver.save(audio_manifest, audio_manifest.resource_path)

	emit_signal("generation_finished", true, "AudioStreamInteractive gerado com sucesso: " + new_path)