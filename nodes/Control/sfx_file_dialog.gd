@tool
class_name SFXFileDialog
extends FileDialog

@export_group("SFX Settings")
@export var dir_selected_sfx_key: String
@export var file_selected_sfx_key: String
@export var confirmed_sfx_key: String
@export var hover_sfx_key: String

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	dir_selected.connect(_on_dir_selected)
	file_selected.connect(_on_file_selected)
	confirmed.connect(_on_confirmed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_dir_selected(dir: String):
	if not dir_selected_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(dir_selected_sfx_key, "SFX", self)

func _on_file_selected(path: String):
	if not file_selected_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(file_selected_sfx_key, "SFX", self)

func _on_confirmed():
	if not confirmed_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(confirmed_sfx_key, "SFX", self)

func _on_mouse_entered():
	if not hover_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(hover_sfx_key, "SFX", self)

func _on_mouse_exited():
	pass

func _on_audio_config_updated(config: AudioConfig):
	if dir_selected_sfx_key.is_empty():
		dir_selected_sfx_key = config.default_select_key
	if file_selected_sfx_key.is_empty():
		file_selected_sfx_key = config.default_select_key
	if confirmed_sfx_key.is_empty():
		confirmed_sfx_key = config.default_confirm_key
	if hover_sfx_key.is_empty():
		hover_sfx_key = config.default_hover_key