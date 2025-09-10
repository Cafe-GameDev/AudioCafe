@tool
class_name SFXVolumeSlider
extends Slider

@export_group("SFX Settings")
@export var value_changed_sfx_key: String
@export var hover_sfx_key: String

@export_group("Volume Control")
@export var audio_bus_name: String = "Master"

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	value_changed.connect(_on_value_changed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	_update_slider_from_bus_volume()

func _on_value_changed(new_value: float):
	if not value_changed_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(value_changed_sfx_key, "SFX", self)

	var linear_volume = new_value / max_value
	CafeAudioManager.apply_volume_to_bus(audio_bus_name, linear_volume)

func _on_mouse_entered():
	if not hover_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(hover_sfx_key, "SFX", self)

func _on_mouse_exited():
	pass

func _update_slider_from_bus_volume():
	var bus_index = AudioServer.get_bus_index(audio_bus_name)
	if bus_index != -1:
		var db_volume = AudioServer.get_bus_volume_db(bus_index)
		var linear_volume = db_to_linear(db_volume)
		value = linear_volume * max_value
	else:
		printerr("SFXVolumeSlider: Audio bus '%s' not found. Cannot initialize slider volume." % audio_bus_name)

func _on_audio_config_updated(config: AudioConfig):
	if value_changed_sfx_key.is_empty():
		value_changed_sfx_key = config.default_slider_key
	if hover_sfx_key.is_empty():
		hover_sfx_key = config.default_hover_key