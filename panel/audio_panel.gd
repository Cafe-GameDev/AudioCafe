@tool
extends VBoxContainer
class_name AudioPanel

@onready var header_button: Button = $HeaderButton
@onready var generate_albuns: Button = $CollapsibleContent/HBoxContainer/GenerateAlbuns
@onready var docs_button: Button = $CollapsibleContent/HBoxContainer/DocsButton
@onready var gen_status_label: Label = $CollapsibleContent/GenStatusLabel

@onready var assets_paths_grid_container: GridContainer = $CollapsibleContent/TabContainer/Settings/AssetsPathsSection/AssetsPathsGridContainer
@onready var dist_path_grid_container: GridContainer = $CollapsibleContent/TabContainer/Settings/DistPathSection/DistPathGridContainer

@onready var add_assets_path_button: Button = $CollapsibleContent/TabContainer/Settings/AssetsPathsSection/AddAssetsPathButton
@onready var add_dist_path_button: Button = $CollapsibleContent/TabContainer/Settings/DistPathSection/AddDistPathButton

@onready var albuns_vbox_container: VBoxContainer = $CollapsibleContent/TabContainer/Albuns
@onready var albuns_rich_text_label: RichTextLabel = $CollapsibleContent/TabContainer/Albuns/AlbunsRichTextLabel

@onready var interactive_vbox_container: VBoxContainer = $CollapsibleContent/TabContainer/Interactive
@onready var interactive_rich_text_label: RichTextLabel = $CollapsibleContent/TabContainer/Interactive/InteractiveRichTextLabel

@onready var assets_folder_dialog: FileDialog = $CollapsibleContent/AssetsFolderDialog
@onready var dist_folder_dialog: FileDialog = $CollapsibleContent/DistFolderDialog
@onready var save_feedback_label: Label = $CollapsibleContent/SaveFeedbackLabel
@onready var save_feedback_timer: Timer = $CollapsibleContent/SaveFeedbackTimer

const ARROW_BIG_DOWN_DASH = preload("res://addons/audio_manager/icons/arrow-big-down-dash.svg")
const ARROW_BIG_UP_DASH = preload("res://addons/audio_manager/icons/arrow-big-up-dash.svg")

const AUDIO_MANIFEST_PATH = "res://addons/audio_manager/resources/audio_manifest.tres"

@export var audio_config: AudioConfig = preload("res://addons/audio_manager/resources/audio_config.tres")

@export var audio_manifest: AudioManifest = preload("res://addons/audio_manager/resources/audio_manifest.tres")

const DOCS : String = "https://www.cafegame.dev/cafeengine/audiomanager"

const VALID_COLOR = Color(1.0, 1.0, 1.0, 1.0)
const INVALID_COLOR = Color(1.0, 0.2, 0.2, 1.0)

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
		_load_config_to_ui()
		_initialize_panel_state()
		
		
		if not add_assets_path_button.pressed.is_connected(Callable(self, "_on_add_assets_path_button_pressed")):
			add_assets_path_button.pressed.connect(Callable(self, "_on_add_assets_path_button_pressed"))
		if not add_dist_path_button.pressed.is_connected(Callable(self, "_on_add_dist_path_button_pressed")):
			add_dist_path_button.pressed.connect(Callable(self, "_on_add_dist_path_button_pressed"))
		if not assets_folder_dialog.dir_selected.is_connected(Callable(self, "_on_assets_folder_dialog_dir_selected")):
			assets_folder_dialog.dir_selected.connect(Callable(self, "_on_assets_folder_dialog_dir_selected"))
		if not dist_folder_dialog.dir_selected.is_connected(Callable(self, "_on_dist_folder_dialog_dir_selected")):
			dist_folder_dialog.dir_selected.connect(Callable(self, "_on_dist_folder_dialog_dir_selected"))

func _initialize_panel_state():
	if not has_node("HeaderButton") or not has_node("CollapsibleContent"):
		push_error("HeaderButton or CollapsibleContent node not found. Ensure they exist and are correctly named.")
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
			header_button_node.icon = ARROW_BIG_DOWN_DASH
		else:
			collapsible_content_node.custom_minimum_size.y = 0
			header_button_node.icon = ARROW_BIG_UP_DASH
	else:
		_is_expanded = false
		collapsible_content_node.visible = false
		collapsible_content_node.custom_minimum_size.y = 0
		header_button_node.icon = ARROW_BIG_UP_DASH

func _load_config_to_ui():
	if not audio_config: return

	if audio_config.assets_paths.has(audio_config.dist_path):
		audio_config.assets_paths.erase(audio_config.dist_path)
		audio_config._save_and_emit_changed()
	
	if assets_paths_grid_container:
		for child in assets_paths_grid_container.get_children():
			child.queue_free()
		for path in audio_config.assets_paths:
			_create_path_entry(path, false)
	
	if dist_path_grid_container and not audio_config.dist_path.is_empty():
		for child in dist_path_grid_container.get_children():
			child.queue_free()
		_create_path_entry(audio_config.dist_path, true)

	_load_albuns_to_ui()
	_load_interactive_streams_to_ui()

func _load_albuns_to_ui():
	if not audio_manifest:
		push_error("AudioManifest not found at: " + AUDIO_MANIFEST_PATH)
		return

	var albuns_text = ""
	if not audio_manifest.playlists.is_empty():
		for key in audio_manifest.playlists.keys():
			albuns_text += "%s (%s)\n" % [key, audio_manifest.playlists[key][1]]

	if albuns_text.is_empty():
		albuns_text = "No playlists found."

	albuns_rich_text_label.bbcode_text = albuns_text

func _on_config_text_changed(new_text: String, config_property: String):
	if audio_config:
		var line_edit: LineEdit = null
		
		var is_valid = true
		var error_message = ""

		if new_text.is_empty():
			is_valid = false
			error_message = "Key cannot be empty."
		elif config_property == "dist_path" and not new_text.begins_with("res://"):
			is_valid = false
			error_message = "Path must start with 'res://'."

		if is_valid:
			if line_edit:
				line_edit.add_theme_color_override("font_color", VALID_COLOR)
				line_edit.tooltip_text = ""
			audio_config.set(config_property, new_text)
		else:
			if line_edit:
				line_edit.add_theme_color_override("font_color", INVALID_COLOR)
				line_edit.tooltip_text = error_message

func _on_volume_slider_value_changed(new_value: float, bus_name: String, value_label: Label, config_property: String):
	if audio_config:
		audio_config.set(config_property, new_value)
		_update_volume_label(value_label, new_value)

func _update_volume_label(label: Label, volume_value: float):
	label.text = str(int(volume_value * 100)) + "%"

func _create_path_entry(path_value: String, is_dist_path: bool = false):
	var path_entry = HBoxContainer.new()
	path_entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var line_edit = LineEdit.new()
	line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line_edit.text = path_value
	line_edit.placeholder_text = "res://path/to/folder"
	line_edit.text_changed.connect(Callable(self, "_on_path_line_edit_text_changed").bind(line_edit, is_dist_path))
	path_entry.add_child(line_edit)

	_validate_path_line_edit(line_edit)

	var browse_button = Button.new()
	browse_button.text = "..."
	browse_button.pressed.connect(Callable(self, "_on_browse_button_pressed").bind(line_edit, is_dist_path))
	path_entry.add_child(browse_button)

	var remove_button = Button.new()
	remove_button.text = "X"
	remove_button.pressed.connect(Callable(self, "_on_remove_path_button_pressed").bind(path_entry, is_dist_path))
	path_entry.add_child(remove_button)

	if is_dist_path:
		dist_path_grid_container.add_child(path_entry)
	else:
		assets_paths_grid_container.add_child(path_entry)

func _on_browse_asset_path_button_pressed(line_edit: LineEdit):
	assets_folder_dialog.current_dir = line_edit.text if not line_edit.text.is_empty() else "res://"
	assets_folder_dialog.popup_centered()
	assets_folder_dialog.set_meta("target_line_edit", line_edit)

func _on_asset_path_line_edit_text_changed(new_text: String, line_edit: LineEdit):
	_validate_path_line_edit(line_edit)
	_update_audio_config_paths()

func _on_browse_button_pressed(line_edit: LineEdit, is_dist_path: bool):
	if is_dist_path:
		dist_folder_dialog.current_dir = line_edit.text if not line_edit.text.is_empty() else "res://"
		dist_folder_dialog.popup_centered()
		dist_folder_dialog.set_meta("target_line_edit", line_edit)
	else:
		assets_folder_dialog.current_dir = line_edit.text if not line_edit.text.is_empty() else "res://"
		assets_folder_dialog.popup_centered()
		assets_folder_dialog.set_meta("target_line_edit", line_edit)

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
		audio_config.dist_path = localized_path
		_validate_path_line_edit(target_line_edit)

func _on_path_line_edit_text_changed(new_text: String, line_edit: LineEdit, is_dist_path: bool):
	_validate_path_line_edit(line_edit)
	if is_dist_path:
		audio_config.dist_path = new_text
	else:
		_update_audio_config_paths()

func _validate_path_line_edit(line_edit: LineEdit):
	var is_valid = true
	var error_message = ""

	if line_edit.text.is_empty():
		is_valid = false
		error_message = "Path cannot be empty."
	elif not line_edit.text.begins_with("res://"):
		is_valid = false
		error_message = "Path must start with 'res://'."

	if is_valid:
		line_edit.add_theme_color_override("font_color", VALID_COLOR)
		line_edit.tooltip_text = ""
	else:
		line_edit.add_theme_color_override("font_color", INVALID_COLOR)
		line_edit.tooltip_text = error_message

func _on_remove_path_button_pressed(path_entry: HBoxContainer, is_dist_path: bool):
	path_entry.get_parent().remove_child(path_entry)
	if is_dist_path:
		audio_config.dist_path = ""
	else:
		_update_audio_config_paths()
	path_entry.queue_free()

func _update_audio_config_paths():
	if not audio_config:
		return

	var new_assets_paths: Array[String] = []
	for child in assets_paths_grid_container.get_children():
		if child is HBoxContainer:
			var line_edit: LineEdit = child.get_child(0)
			if line_edit and not line_edit.text.is_empty() and line_edit.text.begins_with("res://"):
				new_assets_paths.append(line_edit.text)
	audio_config.assets_paths = new_assets_paths





func _on_save_feedback_timer_timeout():
	save_feedback_label.visible = false

func _load_interactive_streams_to_ui():
	if not interactive_rich_text_label: return

	var audio_manifest = load(AUDIO_MANIFEST_PATH)
	if not audio_manifest:
		push_error("AudioManifest not found at: " + AUDIO_MANIFEST_PATH)
		return

	var interactive_text = ""
	if not audio_manifest.interactive.is_empty():
		for key in audio_manifest.interactive.keys():
			interactive_text += "%s\n" % key
	else:
		interactive_text = "No interactive streams found."

	interactive_rich_text_label.bbcode_text = interactive_text



func _on_add_assets_path_button_pressed() -> void:
	_create_path_entry("", false)
	var new_line_edit = assets_paths_grid_container.get_child(assets_paths_grid_container.get_child_count() - 1).get_child(0)
	_on_browse_button_pressed(new_line_edit, false)

func _on_add_dist_path_button_pressed() -> void:
	if dist_path_grid_container:
		for child in dist_path_grid_container.get_children():
			child.queue_free()
	
	_create_path_entry("", true)
	var new_line_edit = dist_path_grid_container.get_child(dist_path_grid_container.get_child_count() - 1).get_child(0)
	_on_browse_button_pressed(new_line_edit, true)

func _on_header_button_pressed():
	if not is_node_ready():
		await ready

	if not has_node("CollapsibleContent") or not has_node("HeaderButton"):
		push_error("CollapsibleContent or HeaderButton node not found. Ensure they exist and are correctly named.")
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
		header_button_node.icon = ARROW_BIG_DOWN_DASH
	else:
		tween.tween_property(collapsible_content_node, "custom_minimum_size:y", 0, 0.3)
		tween.tween_callback(Callable(collapsible_content_node, "set_visible").bind(false))
		header_button_node.icon = ARROW_BIG_UP_DASH

func _on_docs_button_pressed() -> void:
	OS.shell_open(DOCS)

func _on_generate_albuns_pressed():
	if not audio_config: return

	gen_status_label.visible = true
	gen_status_label.text = "Generating albuns..."

	var generator = GenerateAlbuns.new()
	generator.audio_config = audio_config
	generator.connect("generation_finished", Callable(self, "_on_albuns_generation_finished"))
	generator._run()

func _on_albuns_generation_finished(success: bool, message: String):
	if success:
		gen_status_label.text = "Albuns generated successfully!"
		_load_config_to_ui()
		_load_interactive_streams_to_ui()
	else:
		gen_status_label.text = "Error generating albuns: %s" % message

	save_feedback_timer.start()
