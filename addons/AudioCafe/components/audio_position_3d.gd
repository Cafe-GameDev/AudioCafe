@tool

class_name AudioPosition3D
extends AudioStreamPlayer3D

@export var resource_position: ResourcePosition = ResourcePosition.new()

func _ready():
	if Engine.is_editor_hint():
		return
