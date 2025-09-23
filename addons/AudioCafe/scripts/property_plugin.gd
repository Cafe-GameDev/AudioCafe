@tool
extends EditorProperty
class_name PropertyPlugin

var resource_position: ResourcePosition

func _init():
    resource_position = ResourcePosition.new()
    # Controle customizado
    var label = Label.new()
    label.text = "Audio Position"
    add_child(label)

func update_property():
    emit_changed(get_edited_property(), resource_position)

func _set_read_only(read_only: bool) -> void:
    for child in get_children():
        if child is Control:
            child.editable = not read_only
