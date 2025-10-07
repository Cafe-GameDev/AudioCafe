@tool
extends EditorScript
# generate_audio_manifest.gd
#
# This EditorScript is responsible for automatically generating the AudioManifest.tres
# resource. The AudioManifest maps user-friendly string keys (derived from file
# and directory names) to Godot's unique resource IDs (UIDs) for all SFX and music
# files found in the configured root paths.
#
# This manifest is crucial for ensuring that audio resources are correctly referenced
# and loaded in exported game builds, where direct file paths might become invalid.
#
# To run this script:
# 1. Select the CafeAudioManager node in your scene.
# 2. In the FileSystem dock, right-click on 'generate_audio_manifest.gd'.
# 3. Select "Open in Script Editor".
# 4. In the Script Editor, go to File -> Run Script (or press F6).

# The absolute path where the generated AudioManifest.tres resource will be saved.
const MANIFEST_SAVE_PATH = "res://addons/CafeAudioManager/resources/audio_manifest.tres"

# The root path where SFX assets are located. This path is scanned recursively.
@export var sfx_root_path: String = "res://addons/CafeAudioManager/assets/sfx/"
# The root path where music assets are located. This path is scanned recursively.
@export var music_root_path: String = "res://addons/CafeAudioManager/assets/music/"

func _run():
	# Entry point for the EditorScript. Initiates the manifest generation process.
	print("Generating AudioManifest...")
	
	var audio_manifest = AudioManifest.new()
	
	# Scan SFX and music root paths and populate the manifest's data dictionaries.
	_scan_and_populate_library(sfx_root_path, audio_manifest.sfx_data, "sfx")
	_scan_and_populate_library(music_root_path, audio_manifest.music_data, "music")
	
	# Save the generated AudioManifest resource to the specified path.
	ResourceSaver.save(audio_manifest, MANIFEST_SAVE_PATH)
	print("AudioManifest generated and saved to: %s" % MANIFEST_SAVE_PATH)

# Recursively scans a given directory for audio files and populates the provided library dictionary.
# It generates user-friendly keys based on directory structure and file names,
# and stores the resource UIDs.
# @param current_path: The current directory path to scan.
# @param library: The dictionary (e.g., audio_manifest.sfx_data) to populate with audio keys and UIDs.
# @param audio_type: A string indicating the type of audio ("sfx" or "music") for logging purposes.
func _scan_and_populate_library(current_path: String, library: Dictionary, audio_type: String):
	var dir = DirAccess.open(current_path)
	if not dir:
		printerr("GenerateAudioManifest: Failed to open directory: %s" % current_path)
		return
	
	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		if dir.current_is_dir():
			# Recursively scan subdirectories.
			_scan_and_populate_library(current_path.path_join(file_or_dir_name), library, audio_type)
		elif file_or_dir_name.ends_with(".ogg") or file_or_dir_name.ends_with(".wav"): # Add other audio formats if needed
			var resource_path = current_path.path_join(file_or_dir_name)
			var uid = ResourceLoader.get_resource_uid(resource_path)
			print("  - Debug: Resource Path: %s, Raw UID: %s" % [resource_path, str(uid)])
			if uid != -1: # ResourceLoader.get_resource_uid returns -1 if not found
				# Determine the root path to remove for generating relative keys.
				var root_path_to_remove = sfx_root_path if audio_type == "sfx" else music_root_path
				# Get the relative directory path and format it into a key.
				var relative_dir_path = current_path.replace(root_path_to_remove, "").trim_suffix("/")
				var final_key = ""

				if not relative_dir_path.is_empty():
					# If in a subdirectory, use the directory structure for the key.
					final_key = relative_dir_path.replace("/", "_").to_lower()
				else:
					# If at the root of sfx_root_path or music_root_path, use the filename as key.
					final_key = file_or_dir_name.get_basename().to_lower()

				# Add the UID to the library under the generated key.
				if not library.has(final_key):
					library[final_key] = []
				library[final_key].append("uid://%s" % str(uid))
				print("  - Added %s audio '%s' with UID: uid://%s" % [audio_type, final_key, str(uid)])
		file_or_dir_name = dir.get_next()

# This function is deprecated and no longer used.
# Resource UIDs are now directly retrieved using `ResourceLoader.get_resource_uid()`.
func _get_uid_from_import_file(import_file_path: String) -> String:
	return ""
