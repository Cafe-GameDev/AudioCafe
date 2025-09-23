@tool
extends EditorProperty
class_name PropertyPlugin

var resource_position: ResourcePosition

func _init():
	# Aqui você pode criar UI customizada
	var label = Label.new()
	label.text = "Resource Position"
	add_child(label)

	var button = Button.new()
	button.text = "Editar Resource"
	button.pressed.connect(_on_edit_pressed)
	add_child(button)

func _on_edit_pressed():
	# Abre o inspetor do resource real
	if resource_position:
		emit_changed("resource_position", resource_position)

func update_property():
	# Atualiza o valor da prop
	emit_changed("resource_position", resource_position)
