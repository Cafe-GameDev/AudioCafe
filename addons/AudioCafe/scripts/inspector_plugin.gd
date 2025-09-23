@tool
extends EditorInspectorPlugin
class_name InspectorPlugin

func can_handle(object):
	return object is AudioStreamPlayer2D or object is AudioStreamPlayer3D

func parse_property(object, type, path, hint, hint_text, usage, wide):
	if can_handle(object):
		# Use a meta property to ensure the custom control is added only once per object.
		# This meta property is temporary and only exists during editor session.
		if not object.has_meta("_audiocafe_resource_position_editor_added"):
			object.set_meta("_audiocafe_resource_position_editor_added", true)

			if not object.has_meta("resource_position"):
				object.set_meta("resource_position", ResourcePosition.new())

			var editor = PropertyPlugin.new()
			editor.resource_position = object.get_meta("resource_position")
			add_custom_control(editor)
			return true # Indicate that we handled this property (even if it's a fake one)
	return false