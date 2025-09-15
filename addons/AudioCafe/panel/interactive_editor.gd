@tool
extends "res://addons/AudioCafe/panel/resource_editor_base.gd"
class_name InteractiveEditor

@onready var resource_name_label: Label = $HBoxContainer/ResourceNameLabel
@onready var edit_button: Button = $HBoxContainer/EditButton

@export var audio_stream_interactive: AudioStreamInteractive:
	set(value):
		audio_stream_interactive = value
		if is_instance_valid(audio_stream_interactive):
			resource_path = audio_stream_interactive.resource_path
			_on_resource_path_changed()

func _ready():
	if Engine.is_editor_hint():
		edit_button.pressed.connect(Callable(self, "_on_edit_button_pressed"))
		_on_resource_path_changed()

func _on_resource_path_changed():
	if is_instance_valid(audio_stream_interactive):
		resource_name_label.text = audio_stream_interactive.resource_path.get_file().replace(".tres", "")
		resource_type = "AudioStreamInteractive"

func _on_edit_button_pressed():
	_edit_resource()
