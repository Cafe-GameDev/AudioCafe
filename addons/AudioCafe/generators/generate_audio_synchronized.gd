@tool
extends EditorScript
class_name GenerateAudioSynchronized

signal generation_finished(success: bool, message: String)

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var audio_manifest: AudioManifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

var original_resource_path: String = ""

func _run():
	if original_resource_path.is_empty():
		emit_signal("generation_finished", false, "Caminho do recurso original não fornecido.")
		return

	var original_resource = load(original_resource_path)
	if not original_resource:
		emit_signal("generation_finished", false, "Recurso original inválido: " + original_resource_path)
		return

	var synchronized_stream = AudioStreamSynchronized.new()
	if original_resource is AudioStreamPlaylist:
		synchronized_stream.set_playlist(original_resource)
	elif original_resource is AudioStreamRandomized:
		synchronized_stream.set_randomized(original_resource)
	else:
		emit_signal("generation_finished", false, "Tipo de recurso original não suportado para sincronização.")
		return

	var file_name = original_resource_path.get_file().get_basename()
	if file_name.ends_with("_playlist"):
		file_name = file_name.replace("_playlist", "")
	elif file_name.ends_with("_randomized"):
		file_name = file_name.replace("_randomized", "")

	var new_path = audio_config.get_synchronized_save_path().path_join(file_name + "_synchronized.tres")

	var target_dir = audio_config.get_synchronized_save_path()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(target_dir)):
		var error_make_dir = DirAccess.make_dir_recursive(target_dir)
		if error_make_dir != OK:
			emit_signal("generation_finished", false, "Falha ao criar o diretório: %s, Erro: %s" % [target_dir, error_make_dir])
			return

	var error = ResourceSaver.save(synchronized_stream, new_path)
	if error != OK:
		emit_signal("generation_finished", false, "Falha ao salvar AudioStreamSynchronized: %s" % error)
		return

	# Atualizar AudioManifest
	var original_key = file_name.to_lower()
	audio_manifest.synchronized[original_key] = new_path
	ResourceSaver.save(audio_manifest, audio_manifest.resource_path)

	emit_signal("generation_finished", true, "AudioStreamSynchronized gerado com sucesso: " + new_path)