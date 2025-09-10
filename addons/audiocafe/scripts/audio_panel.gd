@tool
extends VBoxContainer

@onready var generate_assets_button: Button = $CollapsibleContent/HBoxContainer/GenerateAssetsButton
@onready var tab_container: TabContainer = $CollapsibleContent/TabContainer
@onready var path_mappings_container: VBoxContainer = $CollapsibleContent/TabContainer/Config/ConfigVBox/PathMappingsContainer
@onready var add_new_mapping_button: Button = $CollapsibleContent/TabContainer/Config/ConfigVBox/AddNewMappingButton

@onready var playlists_container: VBoxContainer = $CollapsibleContent/TabContainer/Audio Assets/AssetsVBox/PlaylistsContainer
@onready var sync_container: VBoxContainer = $CollapsibleContent/TabContainer/Audio Assets/AssetsVBox/SyncContainer
@onready var interactive_container: VBoxContainer = $CollapsibleContent/TabContainer/Audio Assets/AssetsVBox/InteractiveContainer

@onready var save_file_dialog: FileDialog = $SaveFileDialog

@onready var progress_bar: ProgressBar = $CollapsibleContent/GenerationProgressBar
@onready var status_label: Label = $CollapsibleContent/GenerationStatusLabel

@export var audio_config: AudioConfig

var generate_assets_script_instance: EditorScript
var sync_converter_script_instance: EditorScript
var interactive_converter_script_instance: EditorScript
var editor_interface: EditorInterface

func set_editor_interface(interface: EditorInterface):
	editor_interface = interface

func set_audio_config(config: AudioConfig):
	audio_config = config
	_load_config_to_ui()

func _ready():
	if not is_node_ready(): await ready
	generate_assets_script_instance = load("res://addons/AudioCafe/scripts/generate_audio_assets.gd").new()
	sync_converter_script_instance = load("res://addons/AudioCafe/scripts/playlist_to_synchronized_converter.gd").new()
	interactive_converter_script_instance = load("res://addons/AudioCafe/scripts/playlist_to_interactive_converter.gd").new()
	if Engine.is_editor_hint() and editor_interface:
		generate_assets_button.icon = editor_interface.get_base_control().get_theme_icon("Reload", "EditorIcons")
	_load_config_to_ui()
	_connect_ui_signals()

func _load_config_to_ui():
	if not audio_config: return
	for child in path_mappings_container.get_children(): child.queue_free()
	for mapping in audio_config.path_mappings: _create_path_mapping_entry(mapping)
	_populate_asset_sections()

func _connect_ui_signals():
	generate_assets_button.pressed.connect(_on_generate_assets_pressed)
	add_new_mapping_button.pressed.connect(_on_add_new_mapping_pressed)

func _create_path_mapping_entry(mapping: Dictionary):
	var entry_box = HBoxContainer.new()
	path_mappings_container.add_child(entry_box)
	var category_edit = LineEdit.new()
	category_edit.placeholder_text = "Category Name"
	category_edit.text = mapping.get("category", "")
	category_edit.size_flags_horizontal = SIZE_EXPAND_FILL
	category_edit.text_changed.connect(func(new_text): mapping["category"] = new_text)
	entry_box.add_child(category_edit)
	var source_edit = LineEdit.new()
	source_edit.placeholder_text = "Source Path"
	source_edit.text = mapping.get("source", "")
	source_edit.size_flags_horizontal = SIZE_EXPAND_FILL
	source_edit.text_changed.connect(func(new_text): mapping["source"] = new_text)
	entry_box.add_child(source_edit)
	var target_edit = LineEdit.new()
	target_edit.placeholder_text = "Target Path"
	target_edit.text = mapping.get("target", "")
	target_edit.size_flags_horizontal = SIZE_EXPAND_FILL
	target_edit.text_changed.connect(func(new_text): mapping["target"] = new_text)
	entry_box.add_child(target_edit)
	var remove_button = Button.new()
	remove_button.text = "X"
	remove_button.pressed.connect(func():
		audio_config.path_mappings.erase(mapping)
		entry_box.queue_free()
	)
	entry_box.add_child(remove_button)

func _on_add_new_mapping_pressed():
	var new_mapping = {"category": "", "source": "", "target": ""}
	audio_config.path_mappings.append(new_mapping)
	_create_path_mapping_entry(new_mapping)

func _populate_asset_sections():
	for child in playlists_container.get_children(): child.queue_free()
	for child in sync_container.get_children(): child.queue_free()
	for child in interactive_container.get_children(): child.queue_free()
	if not audio_config: return
	for key in audio_config.generated_playlists:
		_create_playlist_entry(key, audio_config.generated_playlists[key])
	for key in audio_config.generated_synchronized:
		_create_sync_entry(key, audio_config.generated_synchronized[key])
	for key in audio_config.generated_interactive:
		_create_interactive_entry(key, audio_config.generated_interactive[key])

func _create_playlist_entry(key: String, path: String):
	var entry = HBoxContainer.new()
	entry.add_child(Label.new()).text = key
	var sync_btn = Button.new(); sync_btn.text = "Sync"; entry.add_child(sync_btn)
	var inter_btn = Button.new(); inter_btn.text = "Inter"; entry.add_child(inter_btn)
	sync_btn.pressed.connect(func(): _convert_playlist(path, key, true))
	inter_btn.pressed.connect(func(): _convert_playlist(path, key, false))
	playlists_container.add_child(entry)

func _create_sync_entry(key: String, path: String):
	var entry = HBoxContainer.new()
	entry.add_child(Label.new()).text = key
	var del_btn = Button.new(); del_btn.text = "X"; entry.add_child(del_btn)
	del_btn.pressed.connect(func(): _delete_asset(key, path, "sync"))
	sync_container.add_child(entry)

func _create_interactive_entry(key: String, path: String):
	var entry = HBoxContainer.new()
	entry.add_child(Label.new()).text = key
	var del_btn = Button.new(); del_btn.text = "X"; entry.add_child(del_btn)
	del_btn.pressed.connect(func(): _delete_asset(key, path, "interactive"))
	interactive_container.add_child(entry)

func _convert_playlist(playlist_path: String, key: String, to_sync: bool):
	save_file_dialog.current_dir = playlist_path.get_base_dir()
	var new_name = key + ("_sync" if to_sync else "_interactive") + ".tres"
	save_file_dialog.current_file = new_name
	save_file_dialog.file_selected.connect(func(path):
		var success = false
		if to_sync:
			success = sync_converter_script_instance.convert(playlist_path, path)
			if success: audio_config.generated_synchronized[key + "_sync"] = path
		else:
			success = interactive_converter_script_instance.convert(playlist_path, path)
			if success: audio_config.generated_interactive[key + "_interactive"] = path
		if success:
			audio_config._save_and_emit_changed()
			_populate_asset_sections()
	, CONNECT_ONE_SHOT)
	save_file_dialog.popup_centered()

func _delete_asset(key: String, path: String, type: String):
	DirAccess.remove_absolute(path)
	if type == "sync":
		audio_config.generated_synchronized.erase(key)
	elif type == "interactive":
		audio_config.generated_interactive.erase(key)
	audio_config._save_and_emit_changed()
	_populate_asset_sections()

func _on_generate_assets_pressed():
	if generate_assets_script_instance:
		progress_bar.value = 0
		progress_bar.visible = true
		status_label.text = "Starting generation..."
		status_label.visible = true
		generate_assets_button.disabled = true
		generate_assets_script_instance.connect("progress_updated", Callable(self, "_on_generation_progress"))
		generate_assets_script_instance.connect("generation_finished", Callable(self, "_on_generation_finished"))
		generate_assets_script_instance.audio_config = audio_config
		generate_assets_script_instance._run()

func _on_generation_progress(current: int, total: int):
	progress_bar.max_value = total
	progress_bar.value = current
	status_label.text = "Generating... (%d/%d)" % [current, total]

func _on_generation_finished(success: bool, message: String):
	progress_bar.visible = false
	generate_assets_button.disabled = false
	status_label.text = message
	if success:
		_populate_asset_sections()
	if generate_assets_script_instance.is_connected("progress_updated", Callable(self, "_on_generation_progress")):
		generate_assets_script_instance.disconnect("progress_updated", Callable(self, "_on_generation_progress"))
	if generate_assets_script_instance.is_connected("generation_finished", Callable(self, "_on_generation_finished")):
		generate_assets_script_instance.disconnect("generation_finished", Callable(self, "_on_generation_finished"))
