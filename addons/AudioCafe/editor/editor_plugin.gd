@tool
extends EditorPlugin

const AUTOLOAD_NAME = "CafeAudioManager"
const AUTOLOAD_PATH = "res://addons/AudioCafe/scenes/cafe_audio_manager.tscn"
const GROUP_SCENE_PATH = "res://addons/AudioCafe/scenes/audio_panel.tscn"

var generate_manifest_script_instance: EditorScript
var plugin_panel: ScrollContainer
var group_panel: VBoxContainer

func _enter_tree():
	# Adiciona autoload
	if not ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)
		print("CafeAudioManager Plugin: Autoload '%s' added." % AUTOLOAD_NAME)

	# Carrega script do manifest
	generate_manifest_script_instance = EditorScript.new()
	generate_manifest_script_instance.set_script(load("res://addons/AudioCafe/scripts/generate_audio_manifest.gd"))

	# Cria o painel e o grupo
	_create_plugin_panel()
	
	# Registra tipos customizados
	_register_custom_types()


func _exit_tree():
	if ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		remove_autoload_singleton(AUTOLOAD_NAME)

	if is_instance_valid(group_panel):
		group_panel.free()

	# Se o container do painel principal ficar vazio, remove ele também
	if is_instance_valid(plugin_panel):
		var content_container = plugin_panel.get_node_or_null("VBoxContainer")
		if content_container and content_container.get_child_count() == 0:
			if plugin_panel.get_parent() != null:
				remove_control_from_docks(plugin_panel)
			plugin_panel.free()


func _create_plugin_panel():
	# Procura por um painel existente
	plugin_panel = get_editor_interface().get_base_control().find_child("CafeEngine", true, false)
	if plugin_panel:
		print("Painel 'CafeEngine' já existente, reaproveitando.")
		_ensure_group("AudioCafe") # Garante que o grupo seja criado se não existir
		return

	# Se não existir, cria um novo
	plugin_panel = ScrollContainer.new()
	plugin_panel.name = "CafeEngine"
	plugin_panel.set_h_scroll_mode(ScrollContainer.SCROLL_MODE_DISABLED)
	plugin_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	plugin_panel.set_follow_focus(true)

	var vbox_container = VBoxContainer.new()
	vbox_container.set_name("VBoxContainer")
	vbox_container.set_layout_mode(Control.LAYOUT_MODE_CONTAINER)
	vbox_container.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	vbox_container.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	plugin_panel.add_child(vbox_container)

	add_control_to_dock(DOCK_SLOT_RIGHT_UL, plugin_panel)
	print("Painel 'CafeEngine' criado dinamicamente.")
	_ensure_group("AudioCafe") # Cria o grupo no painel novo


func _ensure_group(group_name: String) -> VBoxContainer:
	if not plugin_panel:
		push_error("Referência ao painel principal 'CafeEngine' não encontrada.")
		return null

	var content_container = plugin_panel.get_node_or_null("VBoxContainer")
	if not content_container:
		push_error("O painel 'CafeEngine' não contém o 'VBoxContainer' esperado.")
		return null

	# Procura pelo grupo existente
	group_panel = content_container.find_child(group_name, false)
	if group_panel:
		# Garante que referências importantes sejam passadas, caso o editor tenha recarregado
		if group_panel.has_method("set_editor_interface"):
			group_panel.set_editor_interface(get_editor_interface())
		return group_panel

	# Se não existir, cria um novo
	var group_scene = load(GROUP_SCENE_PATH)
	if group_scene and group_scene is PackedScene:
		group_panel = group_scene.instantiate()
		group_panel.name = group_name
		
		# Passa a referência do EditorInterface para o grupo
		if group_panel.has_method("set_editor_interface"):
			group_panel.set_editor_interface(get_editor_interface())

		# Carrega ou cria o audio_config.tres e passa para o grupo
		const AUDIO_CONFIG_PATH = "res://addons/AudioCafe/resources/audio_config.tres"
		var audio_config_res = ResourceLoader.load(AUDIO_CONFIG_PATH)

		if not audio_config_res:
			print("audio_config.tres not found. Creating a new one.")
			audio_config_res = preload("res://addons/AudioCafe/scripts/audio_config.gd").new()
			var dir = AUDIO_CONFIG_PATH.get_base_dir()
			if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir)):
				DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
			
			var error = ResourceSaver.save(audio_config_res, AUDIO_CONFIG_PATH)
			if error != OK:
				push_error("Failed to create and save a new AudioConfig resource: %s" % error)
			else:
				print("New audio_config.tres created at: " + AUDIO_CONFIG_PATH)
		
		if audio_config_res and group_panel.has_method("set_audio_config"):
			group_panel.set_audio_config(audio_config_res)
		else:
			push_error("audio_config.tres could not be loaded/created or set_audio_config is not available.")

		content_container.add_child(group_panel)
		return group_panel
	
	push_error("Não foi possível carregar a cena do grupo: " + group_name)
	return null
	