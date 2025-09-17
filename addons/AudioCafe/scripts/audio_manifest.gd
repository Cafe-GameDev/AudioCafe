@tool
extends Resource
class_name AudioManifest

@export var playlists: Dictionary[String, PackedStringArray] = {}
@export var randomizer: Dictionary[String, PackedStringArray] = {}
@export var interactive: Dictionary[String, PackedStringArray] = {}
@export var synchronized: Dictionary[String, PackedStringArray] = {}
