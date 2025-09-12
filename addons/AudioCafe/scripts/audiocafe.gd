@tool
class_name AudioCafe
extends Node

signal config_updated

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")

func _ready():
	if Engine.is_editor_hint():
		# Certifica-se de que o config.tres está carregado no editor
		if audio_config == null:
			audio_config = load("res://addons/AudioCafe/resources/audio_config.tres")
		reload_config()

func reload_config():
	if audio_config:
		# Recarrega o recurso para garantir que as últimas alterações sejam lidas
		# No editor, reatribuir o resource_path força o recarregamento.
		# Em tempo de execução, o recurso já estará atualizado se salvo.
		if Engine.is_editor_hint():
			audio_config = load(audio_config.resource_path)
		
		_check_for_duplicate_audio_keys()
		
		emit_signal("config_updated")
		print("AudioConfig recarregado e sinal 'config_updated' emitido.")

func _check_for_duplicate_audio_keys():
	var all_paths = []
	all_paths.append_array(audio_config.sfx_paths)
	all_paths.append_array(audio_config.music_paths)
	
	var seen_keys = {}
	for path in all_paths:
		var dir = DirAccess.open(path)
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir() and file_name.ends_with(".ogg"): # Assumindo .ogg para áudio
					var key = file_name.get_basename()
					if seen_keys.has(key):
						printerr("Chave de áudio duplicada encontrada: '%s'. A primeira ocorrência em '%s' será usada. Duplicata em '%s'." % [key, seen_keys[key], path])
					else:
						seen_keys[key] = path
				file_name = dir.get_next()
			dir.list_dir_end()
		else:
			printerr("Não foi possível abrir o diretório de áudio: %s" % path)
