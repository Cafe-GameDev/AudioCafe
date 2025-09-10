@tool
class_name SFXOptionButton
extends OptionButton

@export_group("SFX Settings")
@export var item_selected_sfx_key: String
@export var hover_sfx_key: String

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	item_selected.connect(_on_item_selected)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_item_selected(index: int):
	if not item_selected_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(item_selected_sfx_key, "SFX", self)

func _on_mouse_entered():
	if not hover_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(hover_sfx_key, "SFX", self)

func _on_mouse_exited():
	pass

func _on_audio_config_updated(config: AudioConfig):
	if item_selected_sfx_key.is_empty():
		item_selected_sfx_key = config.default_select_key
	if hover_sfx_key.is_empty():
		hover_sfx_key = config.default_hover_key
