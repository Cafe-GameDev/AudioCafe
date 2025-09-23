@tool
extends EditorInspectorPlugin
class_name InspectorPlugin

func can_handle(object):
	return object is AudioStreamPlayer2D or object is AudioStreamPlayer3D

func parse_property(object, type, path, hint, hint_text, usage, wide):
	# Intercepta a propriedade fake
	if path == "resource_position":
		# Se ainda não existe, cria
		if not object.has_meta("resource_position"):
			object.set_meta("resource_position", ResourcePosition.new())

		var editor = PropertyPlugin.new()
		editor.resource_position = object.get_meta("resource_position")
		add_property_editor(path, editor)
		return true  # Diz ao inspetor que lidamos com essa prop

	return false
