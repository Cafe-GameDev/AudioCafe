class_name AudioZone3D
extends Area3D

signal zone_event_triggered(zone_name: String, event_type: String, body: Node)

@export_group("AudioZone Settings")
@export var zone_name: String = ""
@export var target_group: String = ""
@export var target_class_name: String = ""

func _ready():
	if zone_name.is_empty():
		printerr("AudioZone3D: 'zone_name' is empty. Please set a unique name for this zone.")
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node):
	if _is_target_body(body):
		zone_event_triggered.emit(zone_name, "entered", body)

func _on_body_exited(body: Node):
	if _is_target_body(body):
		zone_event_triggered.emit(zone_name, "exited", body)

func _is_target_body(body: Node) -> bool:
	if not target_group.is_empty() and body.is_in_group(target_group):
		return true
	if not target_class_name.is_empty() and body.get_class() == target_class_name:
		return true
	return target_group.is_empty() and target_class_name.is_empty() # If no target specified, all bodies are targets
