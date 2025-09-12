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
@onready var synchronized: VBoxContainer = $CollapsibleContent/TabContainer/Synchronized
@onready var interactive: VBoxContainer = $CollapsibleContent/TabContainer/Interactive

@onready var assets_folder_dialog: FileDialog = $CollapsibleContent/AssetsFolderDialog
@onready var dist_folder_dialog: FileDialog = $CollapsibleContent/DistFolderDialog
@onready var save_feedback_label: Label = $CollapsibleContent/SaveFeedbackLabel
@onready var save_feedback_timer: Timer = $CollapsibleContent/SaveFeedbackTimer


func _on_header_button_pressed() -> void:
	pass # Replace with function body.


func _on_generate_playlists_pressed() -> void:
	pass # Replace with function body.


func _on_docs_button_pressed() -> void:
	pass # Replace with function body.
