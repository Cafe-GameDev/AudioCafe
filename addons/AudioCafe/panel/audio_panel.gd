@tool
extends VBoxContainer

@onready var header_button: Button = $HeaderButton
@onready var generate_playlists: Button = $CollapsibleContent/HBoxContainer/GeneratePlaylists
@onready var docs_button: Button = $CollapsibleContent/HBoxContainer/DocsButton
@onready var gen_status_label: Label = $CollapsibleContent/GenStatusLabel

@onready var tab_container: TabContainer = $CollapsibleContent/TabContainer

@onready var assets_paths_grid_container: GridContainer = tab_container.get_node("Settings/AssetsPathsSection/AssetsPathsGridContainer")
@onready var add_assets_path_button: Button = tab_container.get_node("Settings/AssetsPathsSection/AddAssetsPathButton")
@onready var assets_folder_dialog: FileDialog = $CollapsibleContent/AssetsFolderDialog

@onready var dist_path_line_edit: LineEdit = tab_container.get_node("Settings/DistPathSection/DistPathLineEdit")
@onready var add_dist_path_button: Button = tab_container.get_node("Settings/DistPathSection/AddDistPathButton")
@onready var dist_folder_dialog: FileDialog = $CollapsibleContent/DistFolderDialog

@onready var default_click_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultClickKeyLineEdit")
@onready var default_slider_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultSliderKeyLineEdit")
@onready var default_hover_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultHoverKeyLineEdit")
@onready var default_confirm_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultConfirmKeyLineEdit")
@onready var default_cancel_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultCancelKeyLineEdit")
@onready var default_toggle_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultToggleKeyLineEdit")
@onready var default_select_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultSelectKeyLineEdit")
@onready var default_text_input_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultTextInputKeyLineEdit")
@onready var default_scroll_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultScrollKeyLineEdit")
@onready var default_focus_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultFocusKeyLineEdit")
@onready var default_error_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultErrorKeyLineEdit")
@onready var default_warning_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultWarningKeyLineEdit")
@onready var default_success_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultSuccessKeyLineEdit")
@onready var default_open_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultOpenKeyLineEdit")
@onready var default_close_key_line_edit: LineEdit = tab_container.get_node("Defaults/DefaultKeyGridContainer/DefaultCloseKeyLineEdit")

@onready var master_volume_slider: HSlider = tab_container.get_node("Defaults/VolumeGridContainer/MasterVolumeSlider")
@onready var master_volume_value_label: Label = tab_container.get_node("Defaults/VolumeGridContainer/MasterVolumeValueLabel")
@onready var sfx_volume_slider: HSlider = tab_container.get_node("Defaults/VolumeGridContainer/SFXVolumeSlider")
@onready var sfx_volume_value_label: Label = tab_container.get_node("Defaults/VolumeGridContainer/SFXVolumeValueLabel")
@onready var music_volume_slider: HSlider = tab_container.get_node("Defaults/VolumeGridContainer/MusicVolumeSlider")
@onready var music_volume_value_label: Label = tab_container.get_node("Defaults/VolumeGridContainer/MusicVolumeValueLabel")

@onready var playlists_vbox_container: VBoxContainer = tab_container.get_node("Playlists/PlaylistsVBoxContainer")
@onready var syncs_vbox_container: VBoxContainer = tab_container.get_node("Syncs/SyncsVBoxContainer")
@onready var interactives_vbox_container: VBoxContainer = tab_container.get_node("Interactives/InteractivesVBoxContainer")

@onready var manifest_progress_bar: ProgressBar = $CollapsibleContent/ManifestProgressBar
@onready var manifest_status_label: Label = $CollapsibleContent/GenStatusLabel

@onready var save_feedback_label: Label = $CollapsibleContent/SaveFeedbackLabel
@onready var save_feedback_timer: Timer = $CollapsibleContent/SaveFeedbackTimer

@export var audio_config: AudioConfig = preload("res://addons/AudioCafe/resources/audio_config.tres")

const DOCS : String = "https://cafegame.dev/plugins/audiocafe"

const VALID_COLOR = Color(1.0, 1.0, 1.0, 1.0)
const INVALID_COLOR = Color(1.0, 0.2, 0.2, 1.0)

const ARROW_BIG_DOWN_DASH = preload("res://addons/AudioCafe/icons/arrow-big-down-dash.svg")
const ARROW_BIG_UP_DASH = preload("res://addons/AudioCafe/icons/arrow-big-up-dash.svg")

var _is_expanded: bool = false
var _expanded_height: float = 0.0

func _ready():
	if not is_node_ready():
		await ready

	if Engine.is_editor_hint():
		_load_config_to_ui()
		_connect_ui_signals()
		
		add_assets_path_button.pressed.connect(Callable(self, "_on_add_assets_path_button_pressed"))
		add_dist_path_button.pressed.connect(Callable(self, "_on_add_dist_path_button_pressed"))
		
		assets_folder_dialog.dir_selected.connect(Callable(self, "_on_assets_folder_dialog_dir_selected"))
		dist_folder_dialog.dir_selected.connect(Callable(self, "_on_dist_folder_dialog_dir_selected"))
		
		header_button.pressed.connect(Callable(self, "_on_header_button_pressed"))
		docs_button.pressed.connect(Callable(self, "_on_docs_button_pressed"))
		generate_playlists.pressed.connect(Callable(self, "_on_generate_playlists_pressed"))
		save_feedback_timer.timeout.connect(Callable(self, "_on_save_feedback_timer_timeout"))

		call_deferred("_initialize_panel_state")

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
	if not tab_container or not audio_config: return
	
	print("--- Loading config to UI ---")
	
	# Load Assets Paths
	if assets_paths_grid_container:
		for child in assets_paths_grid_container.get_children():
			child.queue_free()
		for path in audio_config.assets_paths:
			_create_path_entry(path)
	
	# Load Dist Path
	if dist_path_line_edit:
		dist_path_line_edit.text = audio_config.dist_path
		_validate_path_line_edit(dist_path_line_edit)

	# Load Default Keys
	if default_click_key_line_edit: default_click_key_line_edit.text = audio_config.default_click_key
	if default_hover_key_line_edit: default_hover_key_line_edit.text = audio_config.default_hover_key
	if default_slider_key_line_edit: default_slider_key_line_edit.text = audio_config.default_slider_key
	if default_confirm_key_line_edit: default_confirm_key_line_edit.text = audio_config.default_confirm_key
	if default_cancel_key_line_edit: default_cancel_key_line_edit.text = audio_config.default_cancel_key
	if default_toggle_key_line_edit: default_toggle_key_line_edit.text = audio_config.default_toggle_key
	if default_select_key_line_edit: default_select_key_line_edit.text = audio_config.default_select_key
	if default_text_input_key_line_edit: default_text_input_key_line_edit.text = audio_config.default_text_input_key
	if default_scroll_key_line_edit: default_scroll_key_line_edit.text = audio_config.default_scroll_key
	if default_focus_key_line_edit: default_focus_key_line_edit.text = audio_config.default_focus_key
	if default_error_key_line_edit: default_error_key_line_edit.text = audio_config.default_error_key
	if default_warning_key_line_edit: default_warning_key_line_edit.text = audio_config.default_warning_key
	if default_success_key_line_edit: default_success_key_line_edit.text = audio_config.default_success_key
	if default_open_key_line_edit: default_open_key_line_edit.text = audio_config.default_open_key
	if default_close_key_line_edit: default_close_key_line_edit.text = audio_config.default_close_key

	# Load Volume Settings
	if master_volume_slider: master_volume_slider.value = audio_config.master_volume
	if master_volume_value_label: _update_volume_label(master_volume_value_label, audio_config.master_volume)
	if sfx_volume_slider: sfx_volume_slider.value = audio_config.sfx_volume
	if sfx_volume_value_label: _update_volume_label(sfx_volume_value_label, audio_config.sfx_volume)
	if music_volume_slider: music_volume_slider.value = audio_config.music_volume
	if music_volume_value_label: _update_volume_label(music_volume_value_label, audio_config.music_volume)

	# Load Playlists, Syncs, Interactives (from key_resource)
	_update_generated_resources_ui()
	
	print("--- Finished loading config to UI ---")

func _connect_ui_signals():
	default_click_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_click_key"))
	default_hover_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_hover_key"))
	default_slider_key_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "default_slider_key"))
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

	master_volume_slider.value_changed.connect(func(new_value): _on_volume_slider_value_changed(new_value, "Master", master_volume_value_label, "master_volume"))
	sfx_volume_slider.value_changed.connect(func(new_value): _on_volume_slider_value_changed(new_value, "SFX", sfx_volume_value_label, "sfx_volume"))
	music_volume_slider.value_changed.connect(func(new_value): _on_volume_slider_value_changed(new_value, "Music", music_volume_value_label, "music_volume"))
	
	dist_path_line_edit.text_changed.connect(func(new_text): _on_config_text_changed(new_text, "dist_path"))

func _on_config_text_changed(new_text: String, config_property: String):
	if audio_config:
		var line_edit: LineEdit = null
		if config_property == "dist_path":
			line_edit = dist_path_line_edit
		else:
			line_edit = get_node_or_null("Defaults/DefaultKeyGridContainer/" + config_property.capitalize() + "LineEdit")
		
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

func _create_path_entry(path_value: String):
	var path_entry = HBoxContainer.new()
	path_entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var line_edit = LineEdit.new()
	line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line_edit.text = path_value
	line_edit.placeholder_text = "res://path/to/folder"
	line_edit.text_changed.connect(Callable(self, "_on_asset_path_line_edit_text_changed").bind(line_edit))
	path_entry.add_child(line_edit)

	_validate_path_line_edit(line_edit)

	var browse_button = Button.new()
	browse_button.text = "..."
	browse_button.pressed.connect(Callable(self, "_on_browse_asset_path_button_pressed").bind(line_edit))
	path_entry.add_child(browse_button)

	var remove_button = Button.new()
	remove_button.text = "X"
	remove_button.pressed.connect(Callable(self, "_on_remove_asset_path_button_pressed").bind(path_entry))
	path_entry.add_child(remove_button)

	assets_paths_grid_container.add_child(path_entry)

func _on_browse_asset_path_button_pressed(line_edit: LineEdit):
	assets_folder_dialog.current_dir = line_edit.text if not line_edit.text.is_empty() else "res://"
	assets_folder_dialog.popup_centered()
	assets_folder_dialog.set_meta("target_line_edit", line_edit)

func _on_assets_folder_dialog_dir_selected(dir: String):
	var target_line_edit: LineEdit = assets_folder_dialog.get_meta("target_line_edit")
	if target_line_edit:
		var localized_path = ProjectSettings.localize_path(dir)
		target_line_edit.text = localized_path
		_update_audio_config_paths()

func _on_add_dist_path_button_pressed():
	dist_folder_dialog.current_dir = dist_path_line_edit.text if not dist_path_line_edit.text.is_empty() else "res://"
	dist_folder_dialog.popup_centered()

func _on_dist_folder_dialog_dir_selected(dir: String):
	var localized_path = ProjectSettings.localize_path(dir)
	dist_path_line_edit.text = localized_path
	audio_config.dist_path = localized_path

func _on_asset_path_line_edit_text_changed(new_text: String, line_edit: LineEdit):
	_validate_path_line_edit(line_edit)
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

func _on_remove_asset_path_button_pressed(path_entry: HBoxContainer):
	path_entry.get_parent().remove_child(path_entry)
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
	# Aqui você chamaria o script de geração de playlists
	# Por enquanto, apenas um placeholder
	manifest_status_label.text = "Gerando Playlists..."
	manifest_progress_bar.value = 0
	manifest_progress_bar.max_value = 100
	manifest_progress_bar.visible = true
	manifest_status_label.visible = true
	
	# Simulação de progresso
	var tween = create_tween()
	tween.tween_property(manifest_progress_bar, "value", 100, 2.0)
	await tween.finished
	
	manifest_status_label.text = "Playlists Geradas com Sucesso!"
	manifest_progress_bar.visible = false
	
	_update_generated_resources_ui()

func _update_generated_resources_ui():
	# Limpa as listas existentes
	for child in playlists_vbox_container.get_children():
		child.queue_free()
	for child in syncs_vbox_container.get_children():
		child.queue_free()
	for child in interactives_vbox_container.get_children():
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

	playlists_vbox_container.add_child(hbox)

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

func _calculate_expanded_height():
	if not is_node_ready():
		await ready

	if not has_node("CollapsibleContent"):
		push_error("CollapsibleContent node not found. Please ensure it exists and is correctly named.")
		return

	var collapsible_content_node = get_node("CollapsibleContent")

	collapsible_content_node.visible = true
	collapsible_content_node.custom_minimum_size.y = -1 

	_expanded_height = collapsible_content_node.size.y
	
	collapsible_content_node.custom_minimum_size.y = 0
	collapsible_content_node.visible = false

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
		header_button_node.text = "AudioCafe"
		header_button_node.icon = ARROW_BIG_UP_DASH
	else:
		tween.tween_property(collapsible_content_node, "custom_minimum_size:y", 0, 0.3)
		tween.tween_callback(Callable(collapsible_content_node, "set_visible").bind(false))
		header_button_node.text = "AudioCafe"
		header_button_node.icon = ARROW_BIG_DOWN_DASH

func _on_docs_button_pressed() -> void:
	OS.shell_open(DOCS)
