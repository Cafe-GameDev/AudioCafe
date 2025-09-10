@tool
class_name SFXLineEdit
extends LineEdit

@export_group("SFX Settings")
@export var text_submitted_sfx_key: String
@export var hover_sfx_key: String

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	text_submitted.connect(_on_text_submitted)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_text_submitted(new_text: String):
	if not text_submitted_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(text_submitted_sfx_key, "SFX", self)

func _on_mouse_entered():
	if not hover_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(hover_sfx_key, "SFX", self)

func _on_mouse_exited():
	pass

func _on_audio_config_updated(config: AudioConfig):
	if text_submitted_sfx_key.is_empty():
		text_submitted_sfx_key = config.default_text_input_key
	if hover_sfx_key.is_empty():
		hover_sfx_key = config.default_hover_key