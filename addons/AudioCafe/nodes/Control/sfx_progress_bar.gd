@tool
class_name SFXProgressBar
extends ProgressBar

@export_group("SFX Settings")
@export var value_changed_sfx_key: String

var _previous_value: float

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	_previous_value = value
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float):
	if not value_changed_sfx_key.is_empty() and new_value != _previous_value:
		CafeAudioManager.play_sfx_requested.emit(value_changed_sfx_key, "SFX", self)
	_previous_value = new_value

func _on_audio_config_updated(config: AudioConfig):
	if value_changed_sfx_key.is_empty():
		value_changed_sfx_key = config.default_slider_key