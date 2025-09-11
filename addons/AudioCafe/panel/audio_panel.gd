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
var editor_interface_ref: EditorInterface # Renamed to avoid conflict with parameter

func set_editor_interface(interface: EditorInterface):
	editor_interface_ref = interface

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
		# _load_config_to_ui() # This will be called by _initialize_panel_state
		# _initialize_panel_state will now receive editor_interface and audio_config
		pass # No direct call to _initialize_panel_state here anymore

func _initialize_panel_state(editor_interface_param: EditorInterface, audio_config_param: AudioConfig):
	# Set the references passed from editor_plugin.gd
	editor_interface_ref = editor_interface_param
	audio_config = audio_config_param

	# Now call _load_config_to_ui() and the rest of the initialization
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
			header_button.icon = editor_interface_ref.get_base_control().get_theme_icon("ArrowUp", "EditorIcons") if editor_interface_ref else null
		else:
			collapsible_content_node.custom_minimum_size.y = 0
			header_button.icon = editor_interface_ref.get_base_control().get_theme_icon("ArrowDown", "EditorIcons") if editor_interface_ref else null
	else:
		_is_expanded = false
		collapsible_content_node.visible = false
		collapsible_content_node.custom_minimum_size.y = 0
		header_button.icon = editor_interface_ref.get_base_control().get_theme_icon("ArrowDown", "EditorIcons") if editor_interface_ref else null

func _on_header_button_pressed():
	if not is_instance_valid(header_button) or not is_instance_valid(get_node("CollapsibleContent")):
		push_error("HeaderButton or CollapsibleContent node not found. Please ensure they exist and are correctly named.")
		return

	var collapsible_content_node = get_node("CollapsibleContent")

	_is_expanded = not _is_expanded

	if audio_config:
		audio_config.is_panel_expanded = _is_expanded
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	if _is_expanded:
		collapsible_content_node.visible = true
		tween.tween_property(collapsible_content_node, "custom_minimum_size:y", _expanded_height, 0.3)
		header_button.text = "AudioCafe" 
		header_button.icon = editor_interface_ref.get_base_control().get_theme_icon("ArrowUp", "EditorIcons")
	else:
		tween.tween_property(collapsible_content_node, "custom_minimum_size:y", 0, 0.3)
		tween.tween_callback(Callable(collapsible_content_node, "set_visible").bind(false))
		header_button.text = "AudioCafe"
		header_button.icon = editor_interface_ref.get_base_control().get_theme_icon("ArrowDown", "EditorIcons")

func _on_generate_playlists_pressed() -> void:
	pass # Not implemented in this phase

func _on_docs_button_pressed() -> void:
	OS.shell_open(docs)

func _on_save_feedback_timer_timeout():
	save_feedback_label.visible = false

func _load_config_to_ui():
	if not is_instance_valid(tab_container): return
	if audio_config:
		# Load Assets Paths
		_clear_grid_container(assets_paths_grid_container)
		for path in audio_config.assets_paths:
			_create_path_entry(path, assets_paths_grid_container, true) # true for assets_path

		# Load Dist Path
		_clear_grid_container(dist_path_grid_container) # Clear existing before adding
		if not audio_config.dist_path.is_empty():
			_create_path_entry(audio_config.dist_path, dist_path_grid_container, false) # false for dist_path

		# Load Default Keys (existing logic)
		default_click_key_line_edit.text = audio_config.default_click_key
		default_slider_key_line_edit.text = audio_config.default_slider_key
		default_hover_key_line_edit.text = audio_config.default_hover_key
		default_confirm_key_line_edit.text = audio_config.default_confirm_key
		default_cancel_key_line_edit.text = audio_config.default_cancel_key
		default_toggle_key_line_edit.text = audio_config.default_toggle_key
		default_select_key_line_edit.text = audio_config.default_select_key
		default_text_input_key_line_edit.text = audio_config.default_text_input_key
		default_scroll_key_line_edit.text = audio_config.default_scroll_key
		default_focus_key_line_edit.text = audio_config.default_focus_key
		default_error_key_line_edit.text = audio_config.default_error_key
		default_warning_key_line_edit.text = audio_config.default_warning_key
		default_success_key_line_edit.text = audio_config.default_success_key
		default_open_key_line_edit.text = audio_config.default_open_key
		default_close_key_line_edit.text = audio_config.default_close_key

		# Load Volume Settings (existing logic)
		master_volume_slider.value = audio_config.master_volume
		_update_volume_label(master_volume_value_label, audio_config.master_volume)
		sfx_volume_slider.value = audio_config.sfx_volume
		_update_volume_label(sfx_volume_value_label, audio_config.sfx_volume)
		music_volume_slider.value = audio_config.music_volume
		_update_volume_label(music_volume_value_label, audio_config.music_volume)

func _connect_ui_signals():
	header_button.pressed.connect(Callable(self, "_on_header_button_pressed"))

	# Connect Assets Paths buttons
	add_assets_path_button.pressed.connect(Callable(self, "_on_add_assets_path_button_pressed"))
	assets_folder_dialog.dir_selected.connect(Callable(self, "_on_assets_folder_dialog_dir_selected"))

	# Connect Dist Path button
	add_dist_path_button.pressed.connect(Callable(self, "_on_add_dist_path_button_pressed"))
	dist_folder_dialog.dir_selected.connect(Callable(self, "_on_dist_folder_dialog_dir_selected"))

	# Connect Default Keys (existing logic)
	default_click_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_click_key"))
	default_slider_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_slider_key"))
	default_hover_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_hover_key"))
	default_confirm_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_confirm_key"))
	default_cancel_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_cancel_key"))
	default_toggle_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_toggle_key"))
	default_select_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_select_key"))
	default_text_input_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_text_input_key"))
	default_scroll_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_scroll_key"))
	default_focus_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_focus_key"))
	default_error_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_error_key"))
	default_warning_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_warning_key"))
	default_success_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_success_key"))
	default_open_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_open_key"))
	default_close_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_close_key"))

	# Connect Volume Sliders (existing logic)
	master_volume_slider.value_changed.connect(func(new_value): _on_volume_slider_value_changed(new_value, "Master", master_volume_value_label, "master_volume"))
	sfx_volume_slider.value_changed.connect(func(new_value): _on_volume_slider_value_changed(new_value, "SFX", sfx_volume_value_label, "sfx_volume"))
	music_volume_slider.value_changed.connect(func(new_value): _on_volume_slider_value_changed(new_value, "Music", music_volume_value_label, "music_volume"))

func _on_config_text_changed(new_text: String, config_property: String):
	if audio_config:
		var line_edit: LineEdit = get_node_or_null("%" + config_property.capitalize() + "LineEdit")
		var is_valid = true
		var error_message = ""

		if new_text.is_empty():
			is_valid = false
			error_message = "Key cannot be empty."

		if is_valid:
			if line_edit:
				line_edit.add_theme_color_override("font_color", _get_valid_color())
				line_edit.tooltip_text = ""
			audio_config.set(config_property, new_text)
		else:
			if line_edit:
				line_edit.add_theme_color_override("font_color", _get_invalid_color())
				line_edit.tooltip_text = error_message

func _on_volume_slider_value_changed(new_value: float, bus_name: String, value_label: Label, config_property: String):
	if audio_config:
		audio_config.set(config_property, new_value)
		_update_volume_label(value_label, new_value)

func _update_volume_label(label: Label, volume_value: float):
	label.text = str(int(volume_value * 100)) + "%"

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
	_create_path_entry("", assets_paths_grid_container, true) # true for assets_path
	_update_audio_config_paths()

func _on_add_dist_path_button_pressed():
	# For dist_path, we only allow one entry, so we clear existing ones
	_clear_grid_container(dist_path_grid_container)
	_create_path_entry("", dist_path_grid_container, false) # false for dist_path
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

	# Update Assets Paths
	var new_assets_paths: Array[String] = []
	for child in assets_paths_grid_container.get_children():
		if child is HBoxContainer:
			var line_edit: LineEdit = child.get_child(0)
			if is_instance_valid(line_edit) and not line_edit.text.is_empty() and line_edit.text.begins_with("res://"):
				new_assets_paths.append(line_edit.text)
	audio_config.assets_paths = new_assets_paths

	# Update Dist Path (single entry)
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
	return Color(1.0, 1.0, 1.0, 1.0) # White

func _get_invalid_color() -> Color:
	return Color(1.0, 0.2, 0.2, 1.0) # Red