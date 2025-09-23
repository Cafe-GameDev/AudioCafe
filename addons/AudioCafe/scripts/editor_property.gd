@tool
extends EditorProperty
class_name EditorProperty

var _object: Object
var _property_name: String
var _resource_picker: EditorResourcePicker

func _init():
	_resource_picker = EditorResourcePicker.new()
	_resource_picker.set_base_type("ResourcePosition")
	_resource_picker.connect("resource_changed", Callable(self, "_on_resource_changed"))
	add_child(_resource_picker)
	set_bottom_editor(_resource_picker)

func set_object_and_property(object: Object, property_name: String):
	_object = object
	_property_name = property_name
	# Tenta carregar o ResourcePosition existente do objeto (ex: de metadados)
	var current_resource = _object.get_meta(_property_name, null)
	if current_resource:
		_resource_picker.set_edited_resource(current_resource)

func _on_resource_changed(resource: Resource):
	# Quando o recurso é alterado no picker, salva-o nos metadados do objeto
	_object.set_meta(_property_name, resource)
	# Notifica o inspetor que a propriedade foi alterada
	emit_changed()
