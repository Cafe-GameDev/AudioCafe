@tool
class_name SFXScrollContainer
extends ScrollContainer

@export_group("SFX Settings")
@export var scrolled_sfx_key: String
@export var hover_sfx_key: String

func _ready():
	if Engine.is_editor_hint():
		return

	if CafeAudioManager:
		CafeAudioManager.audio_config_updated.connect(Callable(self, "_on_audio_config_updated"))
		_on_audio_config_updated(CafeAudioManager.audio_config)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	var h_scroll_bar = get_h_scroll_bar()
	if h_scroll_bar:
		h_scroll_bar.value_changed.connect(_on_scrolled)
	var v_scroll_bar = get_v_scroll_bar()
	if v_scroll_bar:
		v_scroll_bar.value_changed.connect(_on_scrolled)

func _on_scrolled(value: float):
	if not scrolled_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(scrolled_sfx_key, "SFX", self)

func _on_mouse_entered():
	if not hover_sfx_key.is_empty():
		CafeAudioManager.play_sfx_requested.emit(hover_sfx_key, "SFX", self)

func _on_mouse_exited():
	pass

func _on_audio_config_updated(config: AudioConfig):
	if scrolled_sfx_key.is_empty():
		scrolled_sfx_key = config.default_scroll_key
	if hover_sfx_key.is_empty():
		hover_sfx_key = config.default_hover_key
