@tool
extends EditorExportPlugin

func _export_begin(features, is_debug, path, flags):
	var generate_assets_script = load("res://addons/AudioCafe/scripts/generate_audio_assets.gd")
	if generate_assets_script:
		var script_instance = generate_assets_script.new()
		script_instance._run()
		script_instance.free()
