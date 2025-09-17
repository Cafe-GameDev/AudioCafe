@tool
extends EditorScript
class_name GenerateAudioPlaylist

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var source_resource_path: String = "" # Path to AudioStreamRandomizer or raw audio files
@export var target_playlist_name: String = ""

func _run():
	if source_resource_path.is_empty() or target_playlist_name.is_empty():
		emit_signal("generation_finished", false, "Caminho do recurso de origem ou nome da playlist de destino não pode ser vazio.")
		return

	var audio_manifest = load(GenerateAudioManifest.MANIFEST_SAVE_FILE)
	if not audio_manifest:
		audio_manifest = AudioManifest.new()

	var playlist = AudioStreamPlaylist.new()
	var streams_to_add: Array[AudioStream] = []

	var source_resource = load(source_resource_path)

	if source_resource is AudioStreamRandomizer:
		# Convert from AudioStreamRandomizer to AudioStreamPlaylist
		for i in range(source_resource.streams_count):
			var stream = source_resource.get("stream_%d/stream" % i)
			if stream:
				streams_to_add.append(stream)
		
		# Remove old entry from manifest if it exists
		var base_name = source_resource_path.get_file().get_basename().replace("_randomized", "")
		if audio_manifest.music_data.has(base_name):
			audio_manifest.music_data.erase(base_name)
		if audio_manifest.sfx_data.has(base_name):
			audio_manifest.sfx_data.erase(base_name)
		if audio_manifest.randomized_streams.has(base_name):
			audio_manifest.randomized_streams.erase(base_name)

	elif source_resource is AudioStreamPlaylist:
		# If the source is already a playlist, we are essentially re-saving it or creating a copy
		for i in range(source_resource.stream_count):
			var stream = source_resource.get("stream_%d" % i)
			if stream:
				streams_to_add.append(stream)
	else:
		# Assume source_resource_path points to a directory with raw audio files
		# This part would need a more robust implementation to scan a directory
		# For now, let's assume it's a direct conversion from a resource.
		emit_signal("generation_finished", false, "Tipo de recurso de origem não suportado para conversão direta para playlist.")
		return

	for stream in streams_to_add:
		var current_index = playlist.stream_count
		playlist.set("stream_%d" % current_index, stream)
		playlist.stream_count = current_index + 1

	var new_path = audio_config.playlist_save_path.path_join(target_playlist_name + "_playlist.tres")

	var error = ResourceSaver.save(playlist, new_path)
	if error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioStreamPlaylist: %s" % error)
		return

	# Update AudioManifest
	var final_key = target_playlist_name.to_lower()
	if final_key.begins_with("music_") or final_key.ends_with("_music"):
		audio_manifest.music_data[final_key] = new_path
	else:
		audio_manifest.sfx_data[final_key] = new_path
	
	var manifest_save_error = ResourceSaver.save(audio_manifest, GenerateAudioManifest.MANIFEST_SAVE_FILE)
	if manifest_save_error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioManifest: %s" % manifest_save_error)
		return

	emit_signal("generation_finished", true, "AudioStreamPlaylist gerado/atualizado com sucesso em: %s" % new_path)
