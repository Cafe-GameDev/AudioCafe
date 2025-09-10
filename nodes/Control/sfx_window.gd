@tool
class_name SFXWindow
extends Window

@export_group("SFX Settings")
@export var close_requested_sfx_key: String
@export var hover_sfx_key: String

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	close_requested.connect(_on_close_requested)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_close_requested():
	if not close_requested_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(close_requested_sfx_key, "SFX", self)

func _on_mouse_entered():
	if not hover_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(hover_sfx_key, "SFX", self)

func _on_mouse_exited():
	pass

func _on_audio_config_updated(config: AudioConfig):
	if close_requested_sfx_key.is_empty():
		close_requested_sfx_key = config.default_close_key
	if hover_sfx_key.is_empty():
		hover_sfx_key = config.default_hover_key
