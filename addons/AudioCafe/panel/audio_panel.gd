@tool
extends VBoxContainer

@onready var header_button: Button = $HeaderButton
@onready var generate_playlists: Button = $CollapsibleContent/HBoxContainer/GeneratePlaylists
@onready var docs_button: Button = $CollapsibleContent/HBoxContainer/DocsButton
@onready var gen_status_label: Label = $CollapsibleContent/GenStatusLabel

@onready var assets_paths_grid_container: GridContainer = $CollapsibleContent/TabContainer/Settings/AssetsPathsSection/AssetsPathsGridContainer
@onready var dist_path_grid_container: GridContainer = $CollapsibleContent/TabContainer/Settings/DistPathSection/DistPathGridContainer

@onready var add_assets_path_button: Button = $CollapsibleContent/TabContainer/Settings/AssetsPathsSection/AddAssetsPathButton
@onready var add_dist_path_button: Button = $CollapsibleContent/TabContainer/Settings/DistPathSection/AddDistPathButton

@onready var playlists: VBoxContainer = $CollapsibleContent/TabContainer/Playlists
@onready var synchronized: VBoxContainer = $CollapsibleContent/TabContainer/Sync
@onready var interactive: VBoxContainer = $CollapsibleContent/TabContainer/Interactive

@onready var assets_folder_dialog: FileDialog = $CollapsibleContent/AssetsFolderDialog
@onready var dist_folder_dialog: FileDialog = $CollapsibleContent/DistFolderDialog
@onready var save_feedback_label: Label = $CollapsibleContent/SaveFeedbackLabel
@onready var save_feedback_timer: Timer = $CollapsibleContent/SaveFeedbackTimer

const ARROW_BIG_DOWN_DASH = preload("res://addons/AudioCafe/icons/arrow-big-down-dash.svg")
const ARROW_BIG_UP_DASH = preload("res://addons/AudioCafe/icons/arrow-big-up-dash.svg")

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")

const DOCS : String = "https://cafegame.dev/plugins/audiocafe"

var generate_manifest_script_instance: EditorScript

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

	var manifest_script_res = load("res://addons/AudioCafe/scripts/generate_audio_manifest.gd")
	if manifest_script_res:
		generate_manifest_script_instance = manifest_script_res.new()
	else:
		push_error("generate_audio_manifest.gd script not found!")
		return
	
	if Engine.is_editor_hint():
		_load_config_to_ui()
		_connect_ui_signals()
		add_assets_path_button.pressed.connect(Callable(self, "_on_add_assets_path_button_pressed"))
		add_dist_path_button.pressed.connect(Callable(self, "_on_add_dist_path_button_pressed"))
		assets_folder_dialog.dir_selected.connect(Callable(self, "_on_assets_folder_dialog_dir_selected"))
		dist_folder_dialog.dir_selected.connect(Callable(self, "_on_dist_folder_dialog_dir_selected"))
		
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
			header_button_node.icon = ARROW_BIG_UP_DASH
		else:
			collapsible_content_node.custom_minimum_size.y = 0
			header_button_node.icon = ARROW_BIG_DOWN_DASH
	else:
		_is_expanded = false
		collapsible_content_node.visible = false
		collapsible_content_node.custom_minimum_size.y = 0
		header_button_node.icon = ARROW_BIG_DOWN_DASH


func _load_config_to_ui():
	if not audio_config: return
	
	print("--- Loading config to UI ---")
	
	# Load Assets Paths
	if assets_paths_grid_container:
		for child in assets_paths_grid_container.get_children():
			child.queue_free()
		for path in audio_config.assets_paths:
			_create_path_entry(path)
	
	# Load Dist Path
	if dist_path_grid_container and audio_config.dist_path:
		for child in dist_path_grid_container.get_children():
			child.queue_free()
		_create_path_entry(audio_config.dist_path, true)

	# Load Default Keys (assuming these are still in the tscn)
	# ... (add logic for default keys if they exist in the tscn)

	# Load Volume Settings (assuming these are still in the tscn)
	# ... (add logic for volume settings if they exist in the tscn)

	# Update Playlists, Syncs, Interactives (from key_resource)
	_update_generated_resources_ui()
	
	print("--- Finished loading config to UI ---")

func _connect_ui_signals():
	# Connect signals for default keys and volume sliders if they exist in the tscn
	# ...
	pass

func _on_config_text_changed(new_text: String, config_property: String):
	if audio_config:
		var line_edit: LineEdit = null
		# This part needs to be adapted based on how default keys are structured in the tscn
		# For now, assuming direct access if they exist
		
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
			print("Configuration updated: %s = %s" % [config_property, new_text])
		else:
			if line_edit:
				line_edit.add_theme_color_override("font_color", INVALID_COLOR)
				line_edit.tooltip_text = error_message

func _on_volume_slider_value_changed(new_value: float, bus_name: String, value_label: Label, config_property: String):
	if audio_config:
		audio_config.set(config_property, new_value)
		_update_volume_label(value_label, new_value)
		print("Volume atualizado para %s: %s" % [bus_name, new_value])

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

func _on_generate_playlists_pressed() -> void:
	if generate_manifest_script_instance:
		gen_status_label.text = "Gerando Playlists..."
		gen_status_label.visible = true
		generate_playlists.disabled = true

		generate_manifest_script_instance.connect("progress_updated", Callable(self, "_on_manifest_progress_updated"))
		generate_manifest_script_instance.connect("generation_finished", Callable(self, "_on_manifest_generation_finished"))

		generate_manifest_script_instance._run()
	else:
		push_error("generate_audio_manifest.gd script instance not available!")

func _on_manifest_progress_updated(current: int, total: int):
	# Assuming manifest_progress_bar exists in the tscn
	# If not, this will cause an error. User needs to add it.
	# For now, I'll assume it exists based on the law document.
	if has_node("CollapsibleContent/ManifestProgressBar"):
		var manifest_progress_bar = get_node("CollapsibleContent/ManifestProgressBar")
		manifest_progress_bar.max_value = total
		manifest_progress_bar.value = current
		gen_status_label.text = "Gerando Playlists... (%d/%d)" % [current, total]

func _on_manifest_generation_finished(success: bool, message: String):
	# Assuming manifest_progress_bar exists in the tscn
	if has_node("CollapsibleContent/ManifestProgressBar"):
		get_node("CollapsibleContent/ManifestProgressBar").visible = false
	generate_playlists.disabled = false

	if success:
		gen_status_label.text = "Playlists Geradas com Sucesso!"
		_load_config_to_ui() # Recarrega a UI para mostrar as novas playlists
	else:
		gen_status_label.text = "Erro na Geração de Playlists: %s" % message

	# Desconecta os sinais para evitar múltiplas conexões
	if generate_manifest_script_instance.is_connected("progress_updated", Callable(self, "_on_manifest_progress_updated")):
		generate_manifest_script_instance.disconnect("progress_updated", Callable(self, "_on_manifest_progress_updated"))
	if generate_manifest_script_instance.is_connected("generation_finished", Callable(self, "_on_manifest_generation_finished")):
		generate_manifest_script_instance.disconnect("generation_finished", Callable(self, "_on_manifest_generation_finished"))

func _update_generated_resources_ui():
	# Limpa as listas existentes
	for child in playlists.get_children():
		child.queue_free()
	for child in synchronized.get_children():
		child.queue_free()
	for child in interactive.get_children():
		child.queue_free()

	if not audio_config or audio_config.key_resource.is_empty():
		return

	for key in audio_config.key_resource.keys():
		var resource_path = audio_config.key_resource[key]
		var resource = ResourceLoader.load(resource_path)
		if resource:
			if resource is AudioStreamPlaybackPlaylist:
				_add_playlist_entry(key, resource_path)
			# Adicionar lógica para AudioStreamSynchronized e AudioStreamPlaybackInteractive aqui
		else:
			push_error("Falha ao carregar recurso: %s" % resource_path)

func _add_playlist_entry(key: String, path: String):
	var hbox = HBoxContainer.new()
	var label = Label.new()
	label.text = key
	hbox.add_child(label)

	var generate_interactive_button = Button.new()
	generate_interactive_button.text = "Gerar Interactive"
	generate_interactive_button.pressed.connect(Callable(self, "_on_generate_interactive_pressed").bind(path))
	hbox.add_child(generate_interactive_button)

	var generate_synchronized_button = Button.new()
	generate_synchronized_button.text = "Gerar Synchronized"
	generate_synchronized_button.pressed.connect(Callable(self, "_on_generate_synchronized_pressed").bind(path))
	hbox.add_child(generate_synchronized_button)

	playlists.add_child(hbox)

func _on_generate_interactive_pressed(playlist_path: String):
	# Lógica para gerar AudioStreamPlaybackInteractive
	print("Gerar Interactive a partir de: ", playlist_path)

func _on_generate_synchronized_pressed(playlist_path: String):
	# Lógica para gerar AudioStreamSynchronized
	print("Gerar Synchronized a partir de: ", playlist_path)

func _on_save_feedback_timer_timeout():
	save_feedback_label.visible = false

func _on_add_assets_path_button_pressed():
	_create_path_entry("")
	_update_audio_config_paths()

func _on_add_dist_path_button_pressed() -> void:
	# Para o dist_path, queremos apenas um LineEdit, então vamos abrir o FileDialog diretamente
	dist_folder_dialog.current_dir = audio_config.dist_path if not audio_config.dist_path.is_empty() else "res://"
	dist_folder_dialog.popup_centered()

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
		header_button_node.icon = ARROW_BIG_UP_DASH
	else:
		tween.tween_property(collapsible_content_node, "custom_minimum_size:y", 0, 0.3)
		tween.tween_callback(Callable(collapsible_content_node, "set_visible").bind(false))
		header_button_node.icon = ARROW_BIG_DOWN_DASH

func _on_docs_button_pressed() -> void:
	OS.shell_open(DOCS)