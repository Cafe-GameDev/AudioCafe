@tool
extends VBoxContainer

@onready var generate_assets_button: Button = $CollapsibleContent/HBoxContainer/GenerateAssetsButton
@onready var tab_container: TabContainer = $CollapsibleContent/TabContainer
@onready var path_mappings_container: VBoxContainer = $CollapsibleContent/TabContainer/Config/ConfigVBox/PathMappingsContainer
@onready var add_new_mapping_button: Button = $CollapsibleContent/TabContainer/Config/ConfigVBox/AddNewMappingButton

@onready var master_volume_slider: HSlider = $CollapsibleContent/TabContainer/Config/ConfigVBox/VolumeGridContainer/MasterVolumeSlider
@onready var master_volume_value_label: Label = $CollapsibleContent/TabContainer/Config/ConfigVBox/VolumeGridContainer/MasterVolumeValueLabel
@onready var sfx_volume_slider: HSlider = $CollapsibleContent/TabContainer/Config/ConfigVBox/VolumeGridContainer/SFXVolumeSlider
@onready var sfx_volume_value_label: Label = $CollapsibleContent/TabContainer/Config/ConfigVBox/VolumeGridContainer/SFXVolumeValueLabel
@onready var music_volume_slider: HSlider = $CollapsibleContent/TabContainer/Config/ConfigVBox/VolumeGridContainer/MusicVolumeSlider
@onready var music_volume_value_label: Label = $CollapsibleContent/TabContainer/Config/ConfigVBox/VolumeGridContainer/MusicVolumeValueLabel

@onready var assets_tree: Tree = $CollapsibleContent/TabContainer/Audio Assets/AssetsTree

@onready var progress_bar: ProgressBar = $CollapsibleContent/GenerationProgressBar
@onready var status_label: Label = $CollapsibleContent/GenerationStatusLabel

@onready var source_folder_dialog: FileDialog = $SourceFolderDialog
@onready var target_folder_dialog: FileDialog = $TargetFolderDialog

@export var audio_config: AudioConfig

var generate_assets_script_instance: EditorScript
var editor_interface: EditorInterface

func set_editor_interface(interface: EditorInterface):
	editor_interface = interface

func set_audio_config(config: AudioConfig):
	audio_config = config
	_load_config_to_ui()

func _ready():
	if not is_node_ready():
		await ready

	var generate_script_res = load("res://addons/AudioCafe/scripts/generate_audio_assets.gd")
	if generate_script_res:
		generate_assets_script_instance = generate_script_res.new()
	else:
		push_error("generate_audio_assets.gd script not found!")
		return

	if Engine.is_editor_hint() and editor_interface:
		generate_assets_button.icon = editor_interface.get_base_control().get_theme_icon("Reload", "EditorIcons")

	_load_config_to_ui()
	_connect_ui_signals()

func _load_config_to_ui():
	if not audio_config: return

	for child in path_mappings_container.get_children():
		child.queue_free()
	for mapping in audio_config.path_mappings:
		_create_path_mapping_entry(mapping)

	master_volume_slider.value = audio_config.master_volume
	_update_volume_label(master_volume_value_label, audio_config.master_volume)
	sfx_volume_slider.value = audio_config.sfx_volume
	_update_volume_label(sfx_volume_value_label, audio_config.sfx_volume)
	music_volume_slider.value = audio_config.music_volume
	_update_volume_label(music_volume_value_label, audio_config.music_volume)

	_populate_assets_tree()

func _connect_ui_signals():
	generate_assets_button.pressed.connect(_on_generate_assets_pressed)
	add_new_mapping_button.pressed.connect(_on_add_new_mapping_pressed)

	master_volume_slider.value_changed.connect(func(val): _on_volume_slider_changed(val, "master_volume", master_volume_value_label))
	sfx_volume_slider.value_changed.connect(func(val): _on_volume_slider_changed(val, "sfx_volume", sfx_volume_value_label))
	music_volume_slider.value_changed.connect(func(val): _on_volume_slider_changed(val, "music_volume", music_volume_value_label))

func _create_path_mapping_entry(mapping: Dictionary):
	var entry_box = HBoxContainer.new()
	entry_box.name = mapping.get("category", "new_mapping")
	path_mappings_container.add_child(entry_box)

	var category_edit = LineEdit.new()
	category_edit.placeholder_text = "Category Name"
	category_edit.text = mapping.get("category", "")
	category_edit.size_flags_horizontal = SIZE_EXPAND_FILL
	category_edit.text_changed.connect(func(new_text): mapping["category"] = new_text)
	entry_box.add_child(category_edit)

	var source_edit = LineEdit.new()
	source_edit.placeholder_text = "Source Path (e.g., res://assets/)"
	source_edit.text = mapping.get("source", "")
	source_edit.size_flags_horizontal = SIZE_EXPAND_FILL
	source_edit.text_changed.connect(func(new_text): mapping["source"] = new_text)
	entry_box.add_child(source_edit)

	var target_edit = LineEdit.new()
	target_edit.placeholder_text = "Target Path (e.g., res://playlists/)"
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
	var new_mapping = {
		"category": "new_category",
		"source": "",
		"target": ""
	}
	audio_config.path_mappings.append(new_mapping)
	_create_path_mapping_entry(new_mapping)

func _on_volume_slider_changed(value: float, config_property: String, label: Label):
	if audio_config:
		audio_config.set(config_property, value)
		_update_volume_label(label, value)

func _update_volume_label(label: Label, volume: float):
	label.text = "%d%%" % (volume * 100)

func _populate_assets_tree():
	assets_tree.clear()
	var root = assets_tree.create_item()
	if not audio_config or not audio_config.generated_playlists:
		return
	
	var sorted_keys = audio_config.generated_playlists.keys()
	sorted_keys.sort()
	
	for key in sorted_keys:
		var item = assets_tree.create_item(root)
		item.set_text(0, key)
		item.set_metadata(0, audio_config.generated_playlists[key])

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
		_populate_assets_tree()
	
	if generate_assets_script_instance.is_connected("progress_updated", Callable(self, "_on_generation_progress")):
		generate_assets_script_instance.disconnect("progress_updated", Callable(self, "_on_generation_progress"))
	if generate_assets_script_instance.is_connected("generation_finished", Callable(self, "_on_generation_finished")):
		generate_assets_script_instance.disconnect("generation_finished", Callable(self, "_on_generation_finished"))
