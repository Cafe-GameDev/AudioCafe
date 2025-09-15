@tool
extends VBoxContainer
class_name ResourceEditorBase

@export var resource_path: String = "":
	set(value):
		resource_path = value
		_on_resource_path_changed()

@export var resource_type: String = ""

func _on_resource_path_changed():
	pass # Implement in derived classes

func _edit_resource():
	if resource_path.is_empty():
		push_error("Resource path is empty.")
		return
	
	var loaded_resource = ResourceLoader.load(resource_path)
	if not loaded_resource:
		push_error("Failed to load resource at path: %s" % resource_path)
		return
	
	# This is where the custom editing logic would go.
	# For now, we'll just print a message.
	print("Editing resource: %s (Type: %s)" % [resource_path, resource_type])
	# In a real scenario, you might add custom UI elements here
	# or use a more advanced editor plugin feature if available.
