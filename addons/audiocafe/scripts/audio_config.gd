@tool
extends Resource
class_name AudioConfig

signal config_changed

@export var path_mappings: Array[Dictionary] = []

@export_group("Generation Defaults")
@export var default_playlist_loop: bool = false

@export_group("Volume Settings")
@export_range(0.0, 1.0, 0.01) var master_volume: float = 1.0:
	set(value):
		if master_volume != value:
			master_volume = value
			_save_and_emit_changed()

@export_range(0.0, 1.0, 0.01) var sfx_volume: float = 1.0:
	set(value):
		if sfx_volume != value:
			sfx_volume = value
			_save_and_emit_changed()

@export_range(0.0, 1.0, 0.01) var music_volume: float = 1.0:
	set(value):
		if music_volume != value:
			music_volume = value
			_save_and_emit_changed()

var generated_playlists: Dictionary = {}
var generated_synchronized: Dictionary = {}
var generated_interactive: Dictionary = {}

func _save_and_emit_changed():
	if self.resource_path and not self.resource_path.is_empty():
		ResourceSaver.save(self, self.resource_path)
	emit_signal("config_changed")