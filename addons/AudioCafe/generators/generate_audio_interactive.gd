@tool
extends EditorScript
class_name GenerateAudioInteractive

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var source_playlist_paths: Array[String] = [] # Paths to AudioStreamPlaylists
@export var target_interactive_name: String = ""

func _run():
	if source_playlist_paths.is_empty() or target_interactive_name.is_empty():
		emit_signal("generation_finished", false, "Lista de playlists de origem ou nome do interactive de destino não pode ser vazio.")
		return

	var audio_manifest = load(GenerateAudioManifest.MANIFEST_SAVE_FILE)
	if not audio_manifest:
		audio_manifest = AudioManifest.new()

	var interactive_stream = AudioStreamInteractive.new()

	for path in source_playlist_paths:
		var playlist = load(path)
		if not playlist or not playlist is AudioStreamPlaylist:
			emit_signal("generation_finished", false, "Recurso de playlist inválido: %s" % path)
			return
		
		var clip_index = interactive_stream.clip_count
		interactive_stream.set("clip_%d/name" % clip_index, path.get_file().get_basename())
		interactive_stream.set("clip_%d/stream" % clip_index, playlist)
		interactive_stream.set("clip_%d/auto_advance" % clip_index, 0) # Default auto_advance
		interactive_stream.clip_count = clip_index + 1

	var new_path = audio_config.interactive_save_path.path_join(target_interactive_name + "_interactive.tres")

	var error = ResourceSaver.save(interactive_stream, new_path)
	if error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioStreamInteractive: %s" % error)
		return

	# Update AudioManifest
	var final_key = target_interactive_name.to_lower()
	audio_manifest.interactive_streams[final_key] = new_path
	
	var manifest_save_error = ResourceSaver.save(audio_manifest, GenerateAudioManifest.MANIFEST_SAVE_FILE)
	if manifest_save_error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioManifest: %s" % manifest_save_error)
		return

	emit_signal("generation_finished", true, "AudioStreamInteractive gerado com sucesso em: %s" % new_path)
