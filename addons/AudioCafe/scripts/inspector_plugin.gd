@tool
extends EditorInspectorPlugin
class_name InspectorPlugin

func _can_handle(object: Object) -> bool:
	return object is AudioStreamPlayer2D or object is AudioStreamPlayer3D

func _parse_begin(object: Object):
	var editor_property = ClassDB.instantiate("EditorPropertyResource")
	if not editor_property:
		push_error("Failed to instantiate EditorPropertyResource.")
		return
	editor_property.set_label("Spatial Audio Config")
	editor_property.set_object_and_property(object, "spatial_config")
	editor_property.set_base_type("ResourcePosition")
	add_custom_property("spatial_config", editor_property)

func _parse_property(object: Object, type: int, name: String, hint_type: int, hint_string: String, usage_flags: int, wide: bool) -> bool:
	return false # Não precisamos mais disso, pois _parse_begin adiciona a propriedade.
