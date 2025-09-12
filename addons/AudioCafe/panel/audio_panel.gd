extends VBoxContainer

@onready var header_button: Button = $HeaderButton
@onready var tab_container: TabContainer = $CollapsibleContent/TabContainer

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")
@export var docs : String = "https://cafegame.dev/plugins/audiocafe"

@onready var generate_playlists: Button = $CollapsibleContent/HBoxContainer/GeneratePlaylists
@onready var docs_button: Button = $CollapsibleContent/HBoxContainer/DocsButton

@onready var manifest_progress_bar: ProgressBar = $CollapsibleContent/ManifestProgressBar
@onready var manifest_status_label: Label = $CollapsibleContent/ManifestStatusLabel

@onready var assets_folder_dialog: FileDialog = $CollapsibleContent/AssetsFolderDialog
@onready var dist_folder_dialog: FileDialog = $CollapsibleContent/DistFolderDialog
@onready var save_feedback_label: Label = $CollapsibleContent/SaveFeedbackLabel
@onready var save_feedback_timer: Timer = $CollapsibleContent/SaveFeedbackTimer

@onready var assets_paths_grid_container: GridContainer = $CollapsibleContent/TabContainer/Settings/AssetsPathsSection/AssetsPathsGridContainer
@onready var add_assets_path_button: Button = $CollapsibleContent/TabContainer/Settings/AssetsPathsSection/AddAssetsPathButton

@onready var dist_path_grid_container: GridContainer = $CollapsibleContent/TabContainer/Settings/DistPathSection/DistPathGridContainer
@onready var dist_path_line_edit: LineEdit = $CollapsibleContent/TabContainer/Settings/DistPathSection/DistPathLineEdit
@onready var add_dist_path_button: Button = $CollapsibleContent/TabContainer/Settings/DistPathSection/AddDistPathButton

var _is_expanded: bool = false
var _expanded_height: float = 0.0

func set_audio_config(config: AudioConfig):
	if audio_config and audio_config.is_connected("config_changed", Callable(self, "_show_save_feedback")):
		audio_config.disconnect("config_changed", Callable(self, "_show_save_feedback"))
	audio_config = config
	if audio_config:
		audio_config.connect("config_changed", Callable(self, "_show_save_feedback"))
	_load_config_to_ui()

func _show_save_feedback():
	save_feedback_label.visible = true
	save_feedback_timer.start()

func _ready():
	if not is_node_ready():
		await ready
	
	if Engine.is_editor_hint():
		_connect_ui_signals()
		call_deferred("_initialize_panel_state")

func _initialize_panel_state():
	_load_config_to_ui()

	if not is_instance_valid(header_button) or not is_instance_valid(get_node("CollapsibleContent")):
		push_error("HeaderButton or CollapsibleContent node not found. Please ensure they exist and are correctly named.")
		return

	var collapsible_content_node = get_node("CollapsibleContent")

	collapsible_content_node.visible = true
	collapsible_content_node.custom_minimum_size.y = -1 


	_expanded_height = collapsible_content_node.size.y

	if audio_config:
		_is_expanded = audio_config.is_panel_expanded
		collapsible_content_node.visible = _is_expanded
		if _is_expanded:
			collapsible_content_node.custom_minimum_size.y = _expanded_height
		else:
			collapsible_content_node.custom_minimum_size.y = 0
	else:
		_is_expanded = false
		collapsible_content_node.visible = false
		collapsible_content_node.custom_minimum_size.y = 0


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
	else:
		tween.tween_property(collapsible_content_node, "custom_minimum_size:y", 0, 0.3)
		tween.tween_callback(Callable(collapsible_content_node, "set_visible").bind(false))

func _on_generate_playlists_pressed() -> void:
	pass

func _on_docs_button_pressed() -> void:
	OS.shell_open(docs)

func _on_save_feedback_timer_timeout():
	save_feedback_label.visible = false

func _load_config_to_ui():
	if not is_instance_valid(tab_container): return
	if audio_config:
		_clear_grid_container(assets_paths_grid_container)
		for path in audio_config.assets_paths:
			_create_path_entry(path, assets_paths_grid_container, true)

		_clear_grid_container(dist_path_grid_container)
		if not audio_config.dist_path.is_empty():
			_create_path_entry(audio_config.dist_path, dist_path_grid_container, false)

func _connect_ui_signals():
	header_button.pressed.connect(Callable(self, "_on_header_button_pressed"))

	add_assets_path_button.pressed.connect(Callable(self, "_on_add_assets_path_button_pressed"))
	assets_folder_dialog.dir_selected.connect(Callable(self, "_on_assets_folder_dialog_dir_selected"))

	add_dist_path_button.pressed.connect(Callable(self, "_on_add_dist_path_button_pressed"))
	dist_folder_dialog.dir_selected.connect(Callable(self, "_on_dist_folder_dialog_dir_selected"))

func _create_path_entry(path_value: String, grid_container: GridContainer, is_assets_path: bool):
	var path_entry = HBoxContainer.new()
	path_entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var line_edit = LineEdit.new()
	line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line_edit.text = path_value
	line_edit.placeholder_text = "res://path/to/folder"
	line_edit.text_changed.connect(Callable(self, "_on_path_line_edit_text_changed").bind(line_edit, is_assets_path))
	path_entry.add_child(line_edit)

	_validate_path_line_edit(line_edit, is_assets_path)

	var browse_button = Button.new()
	browse_button.text = "..."
	browse_button.pressed.connect(Callable(self, "_on_browse_button_pressed").bind(line_edit, is_assets_path))
	path_entry.add_child(browse_button)

	var remove_button = Button.new()
	remove_button.text = "X"
	remove_button.pressed.connect(Callable(self, "_on_remove_path_button_pressed").bind(path_entry, is_assets_path))
	path_entry.add_child(remove_button)

	grid_container.add_child(path_entry)

func _on_add_assets_path_button_pressed():
	_create_path_entry("", assets_paths_grid_container, true)
	_update_audio_config_paths()

func _on_add_dist_path_button_pressed():
	_clear_grid_container(dist_path_grid_container)
	_create_path_entry("", dist_path_grid_container, false)
	_update_audio_config_paths()

func _on_browse_button_pressed(line_edit: LineEdit, is_assets_path: bool):
	if is_assets_path:
		assets_folder_dialog.current_dir = line_edit.text if not line_edit.text.is_empty() else "res://"
		assets_folder_dialog.popup_centered()
		assets_folder_dialog.set_meta("target_line_edit", line_edit)
	else:
		dist_folder_dialog.current_dir = line_edit.text if not line_edit.text.is_empty() else "res://"
		dist_folder_dialog.popup_centered()
		dist_folder_dialog.set_meta("target_line_edit", line_edit)

func _on_assets_folder_dialog_dir_selected(dir: String):
	var target_line_edit: LineEdit = assets_folder_dialog.get_meta("target_line_edit")
	if target_line_edit:
		var localized_path = ProjectSettings.localize_path(dir)
		target_line_edit.text = localized_path
		_update_audio_config_paths()

func _on_dist_folder_dialog_dir_selected(dir: String):
	var target_line_edit: LineEdit = dist_folder_dialog.get_meta("target_line_edit")
	if target_line_edit:
		var localized_path = ProjectSettings.localize_path(dir)
		target_line_edit.text = localized_path
		_update_audio_config_paths()

func _on_path_line_edit_text_changed(new_text: String, line_edit: LineEdit, is_assets_path: bool):
	_validate_path_line_edit(line_edit, is_assets_path)
	_update_audio_config_paths()

func _validate_path_line_edit(line_edit: LineEdit, is_assets_path: bool):
	var is_valid = true
	var error_message = ""

	if line_edit.text.is_empty():
		is_valid = false
		error_message = "Path cannot be empty."
	elif not line_edit.text.begins_with("res://"):
		is_valid = false
		error_message = "Path must start with 'res://'."

	if is_valid:
		line_edit.add_theme_color_override("font_color", _get_valid_color())
		line_edit.tooltip_text = ""
	else:
		line_edit.add_theme_color_override("font_color", _get_invalid_color())
		line_edit.tooltip_text = error_message

func _on_remove_path_button_pressed(path_entry: HBoxContainer, is_assets_path: bool):
	path_entry.get_parent().remove_child(path_entry)
	path_entry.queue_free()
	_update_audio_config_paths()

func _update_audio_config_paths():
	if not audio_config:
		return

	var new_assets_paths: Array[String] = []
	for child in assets_paths_grid_container.get_children():
		if child is HBoxContainer:
			var line_edit: LineEdit = child.get_child(0)
			if is_instance_valid(line_edit) and not line_edit.text.is_empty() and line_edit.text.begins_with("res://"):
				new_assets_paths.append(line_edit.text)
	audio_config.assets_paths = new_assets_paths

	var new_dist_path: String = ""
	if dist_path_grid_container.get_child_count() > 0:
		var line_edit: LineEdit = dist_path_grid_container.get_child(0).get_child(0)
		if is_instance_valid(line_edit) and not line_edit.text.is_empty() and line_edit.text.begins_with("res://"):
			new_dist_path = line_edit.text
	audio_config.dist_path = new_dist_path

func _clear_grid_container(grid_container: GridContainer):
	for child in grid_container.get_children():
		child.queue_free()

func _get_valid_color() -> Color:
	return Color(1.0, 1.0, 1.0, 1.0)

func _get_invalid_color() -> Color:
	return Color(1.0, 0.2, 0.2, 1.0)
