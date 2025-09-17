@tool
extends EditorScript
class_name GenerateAudioSynchronized

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var source_resource_path: String = "" # Path to AudioStreamPlaylist or AudioStreamRandomizer
@export var target_synchronized_name: String = ""

func _run():
	if source_resource_path.is_empty() or target_synchronized_name.is_empty():
		emit_signal("generation_finished", false, "Caminho do recurso de origem ou nome do synchronized de destino não pode ser vazio.")
		return

	var audio_manifest = load(GenerateAudioManifest.MANIFEST_SAVE_FILE)
	if not audio_manifest:
		audio_manifest = AudioManifest.new()

	var source_resource = load(source_resource_path)
	if not source_resource:
		emit_signal("generation_finished", false, "Recurso de origem inválido: %s" % source_resource_path)
		return

	var synchronized_stream = AudioStreamSynchronized.new()
	var streams_to_add: Array[AudioStream] = []

	if source_resource is AudioStreamPlaylist:
		for i in range(source_resource.stream_count):
			var stream = source_resource.get("stream_%d" % i)
			if stream:
				streams_to_add.append(stream)
	elif source_resource is AudioStreamRandomizer:
		for i in range(source_resource.streams_count):
			var stream = source_resource.get("stream_%d/stream" % i)
			if stream:
				streams_to_add.append(stream)
	else:
		emit_signal("generation_finished", false, "Tipo de recurso de origem não suportado para synchronized: %s" % source_resource_path)
		return

	for stream in streams_to_add:
		var current_index = synchronized_stream.stream_count
		synchronized_stream.set("stream_%d/stream" % current_index, stream)
		synchronized_stream.set("stream_%d/volume" % current_index, 0.0) # Default volume
		synchronized_stream.stream_count = current_index + 1

	var new_path = audio_config.synchronized_save_path.path_join(target_synchronized_name + "_synchronized.tres")

	var error = ResourceSaver.save(synchronized_stream, new_path)
	if error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioStreamSynchronized: %s" % error)
		return

	# Update AudioManifest
	var final_key = target_synchronized_name.to_lower()
	audio_manifest.synchronized_streams[final_key] = new_path
	
	var manifest_save_error = ResourceSaver.save(audio_manifest, GenerateAudioManifest.MANIFEST_SAVE_FILE)
	if manifest_save_error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioManifest: %s" % manifest_save_error)
		return

	emit_signal("generation_finished", true, "AudioStreamSynchronized gerado com sucesso em: %s" % new_path)
