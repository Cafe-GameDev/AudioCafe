@tool
extends EditorPlugin


const AUTOLOAD_NAME = "AudioManager"
const AUTOLOAD_PATH = "res://addons/AudioCafe/components/audio_manager.tscn"
const GROUP_SCENE_PATH = "res://addons/AudioCafe/panel/audio_panel.tscn"

var plugin_panel: ScrollContainer
var group_panel: VBoxContainer

func _enter_tree():
	if not ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)
		print("CafeAudioManager Plugin: Autoload '%s' added." % AUTOLOAD_NAME)
	
	_create_plugin_panel()

func _exit_tree():
	if ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		remove_autoload_singleton(AUTOLOAD_NAME)
	
	if is_instance_valid(group_panel):
		group_panel.free()

	if is_instance_valid(plugin_panel):
		var content_container = plugin_panel.get_node_or_null("VBoxContainer")
		if content_container and content_container.get_child_count() == 0:
			if plugin_panel.get_parent() != null:
				remove_control_from_docks(plugin_panel)
			plugin_panel.free()

func _create_plugin_panel():
	plugin_panel = get_editor_interface().get_base_control().find_child("CafeEngine", true, false)
	if plugin_panel:
		_ensure_group("AudioCafe")
		return

	plugin_panel = ScrollContainer.new()
	plugin_panel.name = "CafeEngine"
	plugin_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	plugin_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	plugin_panel.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	plugin_panel.set_follow_focus(true)

	var vbox_container = VBoxContainer.new()
	vbox_container.name = "VBoxContainer"
	vbox_container.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	vbox_container.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	vbox_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	plugin_panel.add_child(vbox_container)

	add_control_to_dock(DOCK_SLOT_RIGHT_UL, plugin_panel)
	_ensure_group("AudioCafe")


func _ensure_group(group_name: String) -> VBoxContainer:
	if not plugin_panel:
		push_error("Referência ao painel principal 'CafeEngine' não encontrada.")
		return null

	var content_container = plugin_panel.get_node_or_null("VBoxContainer")
	if not content_container:
		push_error("O painel 'CafeEngine' não contém o 'VBoxContainer' esperado.")
		return null

	group_panel = content_container.find_child(group_name, false)
	if group_panel:
		const AUDIO_CONFIG_PATH = "res://addons/AudioCafe/resources/audio_config.tres"
		var audio_config_res = ResourceLoader.load(AUDIO_CONFIG_PATH)
		if not audio_config_res:
			audio_config_res = preload("res://addons/AudioCafe/resources/audio_config.gd").new()
			var dir = AUDIO_CONFIG_PATH.get_base_dir()
			if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir)):
				DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
			
			var error = ResourceSaver.save(audio_config_res, AUDIO_CONFIG_PATH)
			if error != OK:
				push_error("Failed to create and save a new AudioConfig resource: %s" % error)
		group_panel.set_audio_config(audio_config_res)
		return group_panel

	var group_scene = load(GROUP_SCENE_PATH)
	if group_scene and group_scene is PackedScene:
		group_panel = group_scene.instantiate()
		content_container.add_child(group_panel)
		group_panel.name = group_name

		const AUDIO_CONFIG_PATH = "res://addons/AudioCafe/resources/audio_config.tres"
		var audio_config_res = ResourceLoader.load(AUDIO_CONFIG_PATH)

		if not audio_config_res:
			audio_config_res = preload("res://addons/AudioCafe/resources/audio_config.gd").new()
			var dir = AUDIO_CONFIG_PATH.get_base_dir()
			if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir)):
				DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
			
			var error = ResourceSaver.save(audio_config_res, AUDIO_CONFIG_PATH)
			if error != OK:
				push_error("Failed to create and save a new AudioConfig resource: %s" % error)
		
		group_panel.set_audio_config(audio_config_res)

		return group_panel
	
	push_error("Não foi possível carregar a cena do grupo: " + group_name)
	return null