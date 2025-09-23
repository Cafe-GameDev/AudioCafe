@tool
extends EditorInspectorPlugin
class_name InspectorPlugin

func can_handle(object):
    return object is AudioStreamPlayer2D or object is AudioStreamPlayer3D

func parse_begin(object):
    if not object.has_meta("resource_position"):
        var rp = ResourcePosition.new()
        object.set_meta("resource_position", rp)
    
    var property_plugin = PropertyPlugin.new()
    property_plugin.resource_position = object.get_meta("resource_position")
    
    add_property_editor("resource_position", property_plugin)
