@tool
extends "res://addons/AudioCafe/panel/resource_editor_base.gd"
class_name PlaylistEditor

@onready var resource_name_label: Label = $HBoxContainer/ResourceNameLabel
@onready var edit_button: Button = $HBoxContainer/EditButton

@export var audio_stream_playlist: AudioStreamPlaylist:
	set(value):
		audio_stream_playlist = value
		if is_instance_valid(audio_stream_playlist):
			resource_path = audio_stream_playlist.resource_path
			_on_resource_path_changed()

func _ready():
	if Engine.is_editor_hint():
		edit_button.pressed.connect(Callable(self, "_on_edit_button_pressed"))
		_on_resource_path_changed()

func _on_resource_path_changed():
	if is_instance_valid(audio_stream_playlist):
		resource_name_label.text = audio_stream_playlist.resource_path.get_file().replace(".tres", "")
		resource_type = "AudioStreamPlaylist"

func _on_edit_button_pressed():
	_edit_resource()
	# Aqui você pode adicionar a lógica para abrir um sub-painel de edição
	# ou manipular o recurso diretamente no inspetor do Godot (se for o caso).
	# Como o usuário quer edição "no painel", isso implicaria em criar UI aqui.
	# Por enquanto, a base apenas imprime.
