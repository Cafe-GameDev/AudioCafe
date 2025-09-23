@tool
extends EditorProperty
class_name PropertyPlugin

var resource_position: ResourcePosition

func _init():
    resource_position = ResourcePosition.new()
    # Aqui você pode criar controles customizados
    var label = Label.new()
    label.text = "Audio Position"
    add_child(label)

func update_property():
    # Atualiza o resource no inspector
    emit_changed(get_edited_property(), resource_position)

func _set_read_only(read_only: bool):
    set_editable(!read_only)
