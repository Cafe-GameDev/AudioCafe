@tool
extends EditorInspectorPlugin
class_name InspectorPlugin

func can_handle(object):
	return object is AudioStreamPlayer2D or object is AudioStreamPlayer3D

func parse_begin(object):
	# Cria a instância do ResourcePosition se não existir
	if not object.has_meta("resource_position"):
		object.set_meta("resource_position", ResourcePosition.new())

	# Cria o EditorProperty customizado
	var prop_plugin = PropertyPlugin.new()
	prop_plugin.resource_position = object.get_meta("resource_position")

	# Adiciona o editor customizado para a propriedade "resource_position"
	add_property_editor("resource_position", prop_plugin)
