@tool

class_name AudioPosition2D
extends AudioStreamPlayer2D

@export var resource_position: ResourcePosition = ResourcePosition.new()

func _ready():
	if Engine.is_editor_hint():
		return
