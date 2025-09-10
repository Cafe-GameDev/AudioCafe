@tool
extends EditorPlugin

const PANEL_SCENE_PATH = "res://addons/AudioCafe/scenes/cafe_panel.tscn"
const GROUP_SCENE_PATH = "res://addons/AudioCafe/scenes/audio_panel.tscn"

var plugin_panel: ScrollContainer
var group_panel: VBoxContainer

func _enter_tree():
	_create_plugin_panel()
	_register_custom_types()

func _exit_tree():
	if is_instance_valid(group_panel):
		group_panel.free()

	if is_instance_valid(plugin_panel):
		var content_container = plugin_panel.get_node_or_null("VBoxContainer")
		if content_container and content_container.get_child_count() == 0:
			if plugin_panel.get_parent() != null:
				remove_control_from_docks(plugin_panel)
			plugin_panel.free()

	_unregister_custom_types()

func _create_plugin_panel():
	plugin_panel = get_editor_interface().get_base_control().find_child("CafeEngine", true, false)
	if plugin_panel:
		_ensure_group("AudioCafe")
		return

	var panel_scene := load(PANEL_SCENE_PATH)
	if panel_scene is PackedScene:
		plugin_panel = panel_scene.instantiate()
		plugin_panel.name = "CafeEngine"
		add_control_to_dock(DOCK_SLOT_RIGHT_UL, plugin_panel)
		_ensure_group("AudioCafe")
	else:
		push_error("Could not load main panel scene for CafeEngine.")

func _ensure_group(group_name: String) -> VBoxContainer:
	if not plugin_panel:
		return null

	var content_container = plugin_panel.get_node_or_null("VBoxContainer")
	if not content_container:
		return null

	group_panel = content_container.find_child(group_name, false)
	if group_panel:
		if group_panel.has_method("set_editor_interface"):
			group_panel.set_editor_interface(get_editor_interface())
		return group_panel

	var group_scene = load(GROUP_SCENE_PATH)
	if group_scene and group_scene is PackedScene:
		group_panel = group_scene.instantiate()
		group_panel.name = group_name
		
		if group_panel.has_method("set_editor_interface"):
			group_panel.set_editor_interface(get_editor_interface())

		const AUDIO_CONFIG_PATH = "res://addons/AudioCafe/resources/audio_config.tres"
		var audio_config_res = ResourceLoader.load(AUDIO_CONFIG_PATH)

		if not audio_config_res:
			audio_config_res = preload("res://addons/AudioCafe/scripts/audio_config.gd").new()
			var dir = AUDIO_CONFIG_PATH.get_base_dir()
			if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir)):
				DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
			ResourceSaver.save(audio_config_res, AUDIO_CONFIG_PATH)
		
		if audio_config_res and group_panel.has_method("set_audio_config"):
			group_panel.set_audio_config(audio_config_res)

		content_container.add_child(group_panel)
		return group_panel
	
	return null

func _register_custom_types():
	add_custom_type("AudioPathMapping", "Resource", preload("res://addons/AudioCafe/scripts/audio_path_mapping.gd"), null)

func _unregister_custom_types():
	remove_custom_type("AudioPathMapping")