@tool
extends EditorPlugin

const AUTOLOAD_NAME = "CafeAudioManager"
const AUTOLOAD_PATH = "res://addons/AudioCafe/scenes/cafe_audio_manager.tscn"
const PANEL_SCENE_PATH = "res://addons/AudioCafe/scenes/cafe_panel.tscn"
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

	_unregister_custom_types()


func _create_plugin_panel():
	# Procura por um painel existente
	plugin_panel = get_editor_interface().get_base_control().find_child("CafeEngine", true, false)
	if plugin_panel:
		print("Painel 'CafeEngine' já existente, reaproveitando.")
		_ensure_group("AudioCafe") # Garante que o grupo seja criado se não existir
		return

	# Se não existir, cria um novo
	var panel_scene := load(PANEL_SCENE_PATH)
	if panel_scene is PackedScene:
		plugin_panel = panel_scene.instantiate()
		plugin_panel.name = "CafeEngine"
		add_control_to_dock(DOCK_SLOT_RIGHT_UL, plugin_panel)
		print("Painel 'CafeEngine' criado.")
		_ensure_group("AudioCafe") # Cria o grupo no painel novo
	else:
		push_error("Não foi possível carregar a cena do painel principal do CafeEngine.")


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


func _register_custom_types():
	add_custom_type("AudioCafe", "Node", preload("res://addons/AudioCafe/scripts/audiocafe.gd"), null)
	add_custom_type("SFXAcceptDialog", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_accept_dialog.gd"), null)
	add_custom_type("SFXButton", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_button.gd"), null)
	add_custom_type("SFXCheckButton", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_check_button.gd"), null)
	add_custom_type("SFXColorPickerButton", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_color_picker_button.gd"), null)
	add_custom_type("SFXColorPicker", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_color_picker.gd"), null)
	add_custom_type("SFXConfirmationDialog", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_confirmation_dialog.gd"), null)
	add_custom_type("SFXFileDialog", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_file_dialog.gd"), null)
	add_custom_type("SFXItemList", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_item_list.gd"), null)
	add_custom_type("SFXLineEdit", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_line_edit.gd"), null)
	add_custom_type("SFXLinkButton", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_link_button.gd"), null)
	add_custom_type("SFXMenuButton", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_menu_button.gd"), null)
	add_custom_type("SFXOptionButton", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_option_button.gd"), null)
	add_custom_type("SFXPopupMenu", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_popup_menu.gd"), null)
	add_custom_type("SFXProgressBar", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_progress_bar.gd"), null)
	add_custom_type("SFXScrollContainer", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_scroll_container.gd"), null)
	add_custom_type("SFXSlider", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_slider.gd"), null)
	add_custom_type("SFXSpinBox", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_spin_box.gd"), null)
	add_custom_type("SFXTabContainer", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_tab_container.gd"), null)
	@tool
extends EditorPlugin

const PANEL_SCENE_PATH = "res://addons/AudioCafe/scenes/cafe_panel.tscn"
const GROUP_SCENE_PATH = "res://addons/AudioCafe/scenes/audio_panel.tscn"

var plugin_panel: ScrollContainer
var group_panel: VBoxContainer

func _enter_tree():
	# Cria o painel e o grupo
	_create_plugin_panel()
	
	# Registra tipos customizados (se houver)
	_register_custom_types()


func _exit_tree():
	if is_instance_valid(group_panel):
		group_panel.free()

	# Se o container do painel principal ficar vazio, remove ele também
	if is_instance_valid(plugin_panel):
		var content_container = plugin_panel.get_node_or_null("VBoxContainer")
		if content_container and content_container.get_child_count() == 0:
			if plugin_panel.get_parent() != null:
				remove_control_from_docks(plugin_panel)
			plugin_panel.free()

	_unregister_custom_types()


func _create_plugin_panel():
	# Procura por um painel existente
	plugin_panel = get_editor_interface().get_base_control().find_child("CafeEngine", true, false)
	if plugin_panel:
		print("Painel 'CafeEngine' já existente, reaproveitando.")
		_ensure_group("AudioCafe") # Garante que o grupo seja criado se não existir
		return

	# Se não existir, cria um novo
	var panel_scene := load(PANEL_SCENE_PATH)
	if panel_scene is PackedScene:
		plugin_panel = panel_scene.instantiate()
		plugin_panel.name = "CafeEngine"
		add_control_to_dock(DOCK_SLOT_RIGHT_UL, plugin_panel)
		print("Painel 'CafeEngine' criado.")
		_ensure_group("AudioCafe") # Cria o grupo no painel novo
	else:
		push_error("Não foi possível carregar a cena do painel principal do CafeEngine.")


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


func _register_custom_types():
	# Esta função registrará quaisquer novos nós ou recursos da v2.0, se necessário.
	pass


func _unregister_custom_types():
	# Esta função removerá quaisquer novos nós ou recursos da v2.0, se necessário.
	pass
	add_custom_type("SFXTextureProgressBar", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_texture_progress_bar.gd"), null)
	add_custom_type("SFXTree", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_tree.gd"), null)
	add_custom_type("SFXVolumeSlider", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_volume_slider.gd"), null)
	add_custom_type("SFXWindow", "AudioCafe", preload("res://addons/AudioCafe/nodes/Control/sfx_window.gd"), null)
	add_custom_type("AudioPosition2D", "AudioStreamPlayer2D", preload("res://addons/AudioCafe/nodes/2D/audio_position_2d.gd"), null)
	add_custom_type("AudioPosition3D", "AudioStreamPlayer3D", preload("res://addons/AudioCafe/nodes/3D/audio_position_3d.gd"), null)
	add_custom_type("AudioZone2D", "Area2D", preload("res://addons/AudioCafe/nodes/2D/audio_zone_2d.gd"), null)
	add_custom_type("AudioZone3D", "Area3D", preload("res://addons/AudioCafe/nodes/3D/audio_zone_3d.gd"), null)


func _unregister_custom_types():
	remove_custom_type("AudioCafe")
	remove_custom_type("SFXAcceptDialog")
	remove_custom_type("SFXButton")
	remove_custom_type("SFXCheckButton")
	remove_custom_type("SFXColorPickerButton")
	remove_custom_type("SFXColorPicker")
	remove_custom_type("SFXConfirmationDialog")
	remove_custom_type("SFXFileDialog")
	remove_custom_type("SFXItemList")
	remove_custom_type("SFXLineEdit")
	remove_custom_type("SFXLinkButton")
	remove_custom_type("SFXMenuButton")
	remove_custom_type("SFXOptionButton")
	remove_custom_type("SFXPopupMenu")
	remove_custom_type("SFXProgressBar")
	remove_custom_type("SFXScrollContainer")
	remove_custom_type("SFXSlider")
	remove_custom_type("SFXSpinBox")
	remove_custom_type("SFXTabContainer")
	remove_custom_type("SFXTextEdit")
	remove_custom_type("SFXTextureProgressBar")
	remove_custom_type("SFXTree")
	remove_custom_type("SFXVolumeSlider")
	remove_custom_type("SFXWindow")
	remove_custom_type("AudioPosition2D")
	remove_custom_type("AudioPosition3D")
	remove_custom_type("AudioZone2D")
	remove_custom_type("AudioZone3D")
