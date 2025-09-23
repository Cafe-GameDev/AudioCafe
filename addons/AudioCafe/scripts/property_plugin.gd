@tool
extends EditorProperty
class_name PropertyPlugin

var resource_position: ResourcePosition:
	set(value):
		resource_position = value
		_update_ui()

var _checkbox: CheckBox

func _init():
	var label = Label.new()
	label.text = "Resource Position"
	add_child(label)

	_checkbox = CheckBox.new()
	_checkbox.text = "Teste"
	_checkbox.pressed.connect(Callable(self, "_on_checkbox_pressed"))
	add_child(_checkbox)

func _update_ui():
	if resource_position:
		_checkbox.button_pressed = resource_position.teste
	else:
		_checkbox.button_pressed = false

func _on_checkbox_pressed():
	if resource_position:
		resource_position.teste = _checkbox.button_pressed
		emit_changed("resource_position", resource_position) # Notify inspector of change

func update_property():
	# This method is called by the inspector when the property value might have changed externally.
	# We need to update our UI to reflect the current value of resource_position.
	_update_ui()
