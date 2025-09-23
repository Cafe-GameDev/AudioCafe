@tool
extends %NODE%
AudioPosition

@export var resource_position: ResourcePosition = ResourcePosition.new()

func _ready():
    if Engine.is_editor_hint():
      return
