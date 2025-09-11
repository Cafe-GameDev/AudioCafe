@tool
extends Resource
class_name AudioConfigOld

signal config_changed

@export var is_panel_expanded: bool = false:
	set(value):
		if is_panel_expanded != value:
			is_panel_expanded = value
			_save_and_emit_changed()

@export var music_data: Dictionary = {}
@export var sfx_data: Dictionary = {}

@export var assets_paths: Array[String] = []:
	set(value):
		if assets_paths != value:
			assets_paths = value
			_save_and_emit_changed()

@export var dist_path: String = "":
	set(value):
		if dist_path != value:
			dist_path = value
			_save_and_emit_changed()

@export var default_click_key: String = "ui_click":
	set(value):
		if default_click_key != value:
			default_click_key = value
			_save_and_emit_changed()

@export var default_hover_key: String = "ui_rollover":
	set(value):
		if default_hover_key != value:
			default_hover_key = value
			_save_and_emit_changed()

@export var default_slider_key: String = "ui_slider_changed":
	set(value):
		if default_slider_key != value:
			default_slider_key = value
			_save_and_emit_changed()

@export var default_confirm_key: String = "interface_confirmation":
	set(value):
		if default_confirm_key != value:
			default_confirm_key = value
			_save_and_emit_changed()

@export var default_cancel_key: String = "interface_back":
	set(value):
		if default_cancel_key != value:
			default_cancel_key = value
			_save_and_emit_changed()

@export var default_toggle_key: String = "interface_toggle":
	set(value):
		if default_toggle_key != value:
			default_toggle_key = value
			_save_and_emit_changed()

@export var default_select_key: String = "interface_select":
	set(value):
		if default_select_key != value:
			default_select_key = value
			_save_and_emit_changed()

@export var default_text_input_key: String = "interface_type":
	set(value):
		if default_text_input_key != value:
			default_text_input_key = value
			_save_and_emit_changed()

@export var default_scroll_key: String = "interface_scroll":
	set(value):
		if default_scroll_key != value:
			default_scroll_key = value
			_save_and_emit_changed()

@export var default_focus_key: String = "interface_focus":
	set(value):
		if default_focus_key != value:
			default_focus_key = value
			_save_and_emit_changed()

@export var default_error_key: String = "interface_error":
	set(value):
		if default_error_key != value:
			default_error_key = value
			_save_and_emit_changed()

@export var default_warning_key: String = "interface_warning":
	set(value):
		if default_warning_key != value:
			default_warning_key = value
			_save_and_emit_changed()

@export var default_success_key: String = "interface_success":
	set(value):
		if default_success_key != value:
			default_success_key = value
			_save_and_emit_changed()

@export var default_open_key: String = "interface_open":
	set(value):
		if default_open_key != value:
			default_open_key = value
			_save_and_emit_changed()

@export var default_close_key: String = "interface_close":
	set(value):
		if default_close_key != value:
			default_close_key = value
			_save_and_emit_changed()

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