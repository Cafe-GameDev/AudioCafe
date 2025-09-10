@tool
class_name SFXTextEdit
extends TextEdit

@export_group("SFX Settings")
@export var focus_entered_sfx_key: String
@export var hover_sfx_key: String

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	focus_entered.connect(_on_focus_entered)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_focus_entered():
	if not focus_entered_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(focus_entered_sfx_key, "SFX", self)

func _on_mouse_entered():
	if not hover_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(hover_sfx_key, "SFX", self)

func _on_mouse_exited():
	pass

func _on_audio_config_updated(config: AudioConfig):
	if focus_entered_sfx_key.is_empty():
		focus_entered_sfx_key = config.default_focus_key
	if hover_sfx_key.is_empty():
		hover_sfx_key = config.default_hover_key
