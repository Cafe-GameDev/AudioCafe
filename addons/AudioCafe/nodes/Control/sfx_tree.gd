@tool
class_name SFXTree
extends Tree

@export_group("SFX Settings")
@export var item_selected_sfx_key: String
@export var item_toggle_sfx_key: String
@export var hover_sfx_key: String

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	item_selected.connect(_on_item_selected)
	item_collapsed.connect(_on_item_toggle)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_item_selected():
	if not item_selected_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(item_selected_sfx_key, "SFX", self)

func _on_item_toggle(item: TreeItem):
	if not item_toggle_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(item_toggle_sfx_key, "SFX", self)

func _on_mouse_entered():
	if not hover_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(hover_sfx_key, "SFX", self)

func _on_mouse_exited():
	pass

func _on_audio_config_updated(config: AudioConfig):
	if item_selected_sfx_key.is_empty():
		item_selected_sfx_key = config.default_select_key
	if item_toggle_sfx_key.is_empty():
		item_toggle_sfx_key = config.default_toggle_key
	if hover_sfx_key.is_empty():
		hover_sfx_key = config.default_hover_key
