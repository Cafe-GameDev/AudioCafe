@tool
extends EditorInspectorPlugin
class_name InspectorPlugin

func _can_handle(object: Object) -> bool:
	return object is AudioStreamPlayer2D or object is AudioStreamPlayer3D

func _parse_property(object: Object, type: int, name: String, hint_type: int, hint_string: String, usage_flags: int, wide: bool) -> bool:
	return false # Não precisamos mais disso, pois _parse_end adiciona a propriedade.

func _parse_end(object: Object):
	# Este método é chamado depois que todas as propriedades padrão foram analisadas.
	# Adicionamos nossa propriedade customizada aqui.

	var custom_editor_property = preload("res://addons/AudioCafe/scripts/editor_property.gd").new()
	custom_editor_property.set_object_and_property(object, "spatial_config") # O nome da propriedade que queremos injetar
	custom_editor_property.set_label("Spatial Audio Config")
	
	# Adiciona o EditorProperty customizado como um controle.
	# Isso fará com que ele apareça no inspetor.
	add_custom_control(custom_editor_property)