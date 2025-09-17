@tool
extends EditorScript
class_name GenerateAudioRandomized

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var source_playlist_path: String = "" # Path to AudioStreamPlaylist
@export var target_randomized_name: String = ""

func _run():
	if source_playlist_path.is_empty() or target_randomized_name.is_empty():
		emit_signal("generation_finished", false, "Caminho da playlist de origem ou nome do randomized de destino não pode ser vazio.")
		return

	var audio_manifest = load(GenerateAudioManifest.MANIFEST_SAVE_FILE)
	if not audio_manifest:
		audio_manifest = AudioManifest.new()

	var playlist = load(source_playlist_path)
	if not playlist or not playlist is AudioStreamPlaylist:
		emit_signal("generation_finished", false, "Recurso de playlist inválido: %s" % source_playlist_path)
		return

	var randomized_stream = AudioStreamRandomizer.new()
	var streams_to_add: Array[AudioStream] = []

	for i in range(playlist.stream_count):
		var stream = playlist.get("stream_%d" % i)
		if stream:
			streams_to_add.append(stream)

	for stream in streams_to_add:
		var current_index = randomized_stream.streams_count
		randomized_stream.set("stream_%d/stream" % current_index, stream)
		randomized_stream.streams_count = current_index + 1

	var new_path = audio_config.randomized_save_path.path_join(target_randomized_name + "_randomized.tres")

	var error = ResourceSaver.save(randomized_stream, new_path)
	if error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioStreamRandomizer: %s" % error)
		return

	# Update AudioManifest
	var final_key = target_randomized_name.to_lower()
	# Remove old playlist entry
	var playlist_key = source_playlist_path.get_file().get_basename().replace("_playlist", "")
	if audio_manifest.music_data.has(playlist_key):
		audio_manifest.music_data.erase(playlist_key)
		# Add new randomized entry to music_data if it was music
		audio_manifest.music_data[final_key] = new_path
	elif audio_manifest.sfx_data.has(playlist_key):
		audio_manifest.sfx_data.erase(playlist_key)
		# Add new randomized entry to sfx_data if it was sfx
		audio_manifest.sfx_data[final_key] = new_path

	audio_manifest.randomized_streams[final_key] = new_path
	
	var manifest_save_error = ResourceSaver.save(audio_manifest, GenerateAudioManifest.MANIFEST_SAVE_FILE)
	if manifest_save_error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioManifest: %s" % manifest_save_error)
		return

	emit_signal("generation_finished", true, "AudioStreamRandomizer gerado com sucesso em: %s" % new_path)
