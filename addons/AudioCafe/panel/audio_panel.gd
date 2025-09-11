extends VBoxContainer

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var docs : String = "https://cafegame.dev/plugins/audiocafe"

@onready var generate_playlists: Button = $CollapsibleContent/HBoxContainer/GeneratePlaylists
@onready var docs_button: Button = $CollapsibleContent/HBoxContainer/DocsButton

@onready var manifest_progress_bar: ProgressBar = $CollapsibleContent/ManifestProgressBar
@onready var manifest_status_label: Label = $CollapsibleContent/ManifestStatusLabel

@onready var rest_folder_dialog: FileDialog = $CollapsibleContent/RestFolderDialog
@onready var save_feedback_label: Label = $CollapsibleContent/SaveFeedbackLabel
@onready var save_feedback_timer: Timer = $CollapsibleContent/SaveFeedbackTimer

@onready var assets_paths_grid_container: GridContainer = $CollapsibleContent/TabContainer/Settings/AssetsPathsSection/AssetsPathsGridContainer
@onready var add_assets_path_button: Button = $CollapsibleContent/TabContainer/Settings/AssetsPathsSection/AddAssetsPathButton

@onready var rest_path_grid_container: GridContainer = $CollapsibleContent/TabContainer/Settings/RestPathSection/RestPathGridContainer
@onready var add_rest_path_button: Button = $CollapsibleContent/TabContainer/Settings/RestPathSection/AddRestPathButton

@onready var default_click_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultClickKeyLineEdit
@onready var default_slider_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultSliderKeyLineEdit
@onready var default_hover_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultHoverKeyLineEdit
@onready var default_confirm_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultConfirmKeyLineEdit
@onready var default_cancel_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultCancelKeyLineEdit
@onready var default_toggle_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultToggleKeyLineEdit
@onready var default_select_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultSelectKeyLineEdit
@onready var default_text_input_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultTextInputKeyLineEdit
@onready var default_scroll_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultScrollKeyLineEdit
@onready var default_focus_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultFocusKeyLineEdit
@onready var default_error_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultErrorKeyLineEdit
@onready var default_warning_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultWarningKeyLineEdit
@onready var default_success_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultSuccessKeyLineEdit
@onready var default_open_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultOpenKeyLineEdit
@onready var default_close_key_line_edit: LineEdit = $CollapsibleContent/TabContainer/Keys/DefaultCloseKeyLineEdit



var _is_expanded: bool = false
var _expanded_height: float = 0.0
var editor_interface: EditorInterface

func set_editor_interface(interface: EditorInterface):
	editor_interface = interface

func set_audio_config(config: AudioConfig):
	if audio_config and audio_config.is_connected("config_changed", Callable(self, "_show_save_feedback")):
		audio_config.disconnect("config_changed", Callable(self, "_show_save_feedback"))
	audio_config = config
	if audio_config:
		audio_config.connect("config_changed", Callable(self, "_show_save_feedback"))

func _show_save_feedback():
	save_feedback_label.visible = true
	save_feedback_timer.start()

func _ready():
	if not is_node_ready():
		await ready
	
	if Engine.is_editor_hint():
		call_deferred("_initialize_panel_state")

func _initialize_panel_state():
	if not has_node("HeaderButton") or not has_node("CollapsibleContent"):
		push_error("HeaderButton or CollapsibleContent node not found. Please ensure they exist and are correctly named.")
		return

	var collapsible_content_node = get_node("CollapsibleContent")
	var header_button_node = get_node("HeaderButton")

	collapsible_content_node.visible = true
	collapsible_content_node.custom_minimum_size.y = -1 


	_expanded_height = collapsible_content_node.size.y

	if audio_config:
		_is_expanded = audio_config.is_panel_expanded
		collapsible_content_node.visible = _is_expanded
		if _is_expanded:
			collapsible_content_node.custom_minimum_size.y = _expanded_height
			header_button_node.icon = editor_interface.get_base_control().get_theme_icon("ArrowUp", "EditorIcons") if editor_interface else null
		else:
			collapsible_content_node.custom_minimum_size.y = 0
			header_button_node.icon = editor_interface.get_base_control().get_theme_icon("ArrowDown", "EditorIcons") if editor_interface else null
	else:
		_is_expanded = false
		collapsible_content_node.visible = false
		collapsible_content_node.custom_minimum_size.y = 0
		header_button_node.icon = editor_interface.get_base_control().get_theme_icon("ArrowDown", "EditorIcons") if editor_interface else null

func _on_header_button_pressed():
	if not is_node_ready():
		await ready

	if not has_node("CollapsibleContent") or not has_node("HeaderButton"):
		push_error("CollapsibleContent or HeaderButton node not found. Please ensure they exist and are correctly named.")
		return

	var collapsible_content_node = get_node("CollapsibleContent")
	var header_button_node = get_node("HeaderButton")

	_is_expanded = not _is_expanded

	if audio_config:
		audio_config.is_panel_expanded = _is_expanded
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	if _is_expanded:
		collapsible_content_node.visible = true
		tween.tween_property(collapsible_content_node, "custom_minimum_size:y", _expanded_height, 0.3)
		header_button_node.text = "AudioCafe" 
		header_button_node.icon = editor_interface.get_base_control().get_theme_icon("ArrowUp", "EditorIcons")
	else:
		tween.tween_property(collapsible_content_node, "custom_minimum_size:y", 0, 0.3)
		tween.tween_callback(Callable(collapsible_content_node, "set_visible").bind(false))
		header_button_node.text = "AudioCafe"
		header_button_node.icon = editor_interface.get_base_control().get_theme_icon("ArrowDown", "EditorIcons")

func _on_generate_playlists_pressed() -> void:
	pass

func _on_docs_button_pressed() -> void:
	OS.shell_open(docs)

func _on_save_feedback_timer_timeout():
	save_feedback_label.visible = false
