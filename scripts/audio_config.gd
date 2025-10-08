@tool
extends Resource
class_name AudioConfig

signal config_changed

@export var is_panel_expanded: bool = true:
	set(value):
		if is_panel_expanded != value:
			is_panel_expanded = value
			_save_and_emit_changed()

@export var gen_playlist: bool = true:
	set(value):
		if gen_playlist != value:
			gen_playlist = value
			_save_and_emit_changed()

@export var gen_randomizer: bool = true:
	set(value):
		if gen_randomizer != value:
			gen_randomizer = value
			_save_and_emit_changed()

@export var gen_synchronized: bool = true:
	set(value):
		if gen_synchronized != value:
			gen_synchronized = value
			_save_and_emit_changed()

@export var assets_paths: Array[String] = ["res://assets"]:
	set(value):
		if assets_paths != value:
			assets_paths = value
			_save_and_emit_changed()

@export var dist_path: String = "res://dist":
	set(value):
		if dist_path != value:
			dist_path = value
			_save_and_emit_changed()

func get_albuns_save_path() -> String:
	return dist_path.trim_suffix("/") + "/playlist/"

func get_randomized_save_path() -> String:
	return dist_path.trim_suffix("/") + "/randomizer/"

func get_interactive_save_path() -> String:
	return dist_path.trim_suffix("/") + "/interactive/"

func get_synchronized_save_path() -> String:
	return dist_path.trim_suffix("/") + "/synchronized/"

func _save_and_emit_changed():
	if self.resource_path:
		var dir = self.resource_path.get_base_dir()
		if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir)):
			DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
		
		var error = ResourceSaver.save(self, self.resource_path)
		if error != OK:
			push_error("Failed to save AudioConfig resource: %s" % error)
	emit_changed()
	emit_signal("config_changed")
