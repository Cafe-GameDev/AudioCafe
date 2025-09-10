class_name AudioPosition3D
extends AudioStreamPlayer3D

@export var state_audio: Dictionary[String, PackedStringArray] = {}

var _audio_manifest: AudioManifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func set_state(state_key: String):
	if not _audio_manifest:
		printerr("AudioManifest not loaded in AudioPosition3D.")
		return

	if not state_audio.has(state_key):
		printerr("State key '%s' not found in state_audio." % state_key)
		return

	var sfx_key = state_audio[state_key]
	if not _audio_manifest.sfx_data.has(sfx_key):
		printerr("SFX key '%s' not found in AudioManifest for state '%s'." % [sfx_key, state_key])
		return

	var sfx_uids = _audio_manifest.sfx_data[sfx_key]
	if sfx_uids.is_empty():
		printerr("SFX category '%s' is empty in AudioManifest." % sfx_key)
		return

	var random_uid_str = sfx_uids.pick_random()
	var uid_int = random_uid_str.replace("uid://", "").to_int()
	var resource_path = ResourceUID.get_id_path(uid_int)

	if resource_path.is_empty():
		printerr("Failed to get resource path for SFX UID: '%s'." % random_uid_str)
		return

	var sound_stream = load(resource_path)
	if not sound_stream:
		printerr("Failed to load SFX stream from path: '%s'." % resource_path)
		return

	stream = sound_stream
	play()

func play_secondary_sound(sfx_key: String):
	if not _audio_manifest:
		printerr("AudioManifest not loaded in AudioPosition3D.")
		return

	if not _audio_manifest.sfx_data.has(sfx_key):
		printerr("SFX key '%s' not found in AudioManifest for secondary sound." % sfx_key)
		return

	var sfx_uids = _audio_manifest.sfx_data[sfx_key]
	if sfx_uids.is_empty():
		printerr("SFX category '%s' is empty in AudioManifest for secondary sound." % sfx_key)
		return

	var random_uid_str = sfx_uids.pick_random()
	var uid_int = random_uid_str.replace("uid://", "").to_int()
	var resource_path = ResourceUID.get_id_path(uid_int)

	if resource_path.is_empty():
		printerr("Failed to get resource path for secondary SFX UID: '%s'." % random_uid_str)
		return

	var sound_stream = load(resource_path)
	if not sound_stream:
		printerr("Failed to load secondary SFX stream from path: '%s'." % resource_path)
		return

	var temp_player = AudioStreamPlayer3D.new()
	temp_player.stream = sound_stream
	add_child(temp_player)
	temp_player.play()
	temp_player.finished.connect(Callable(temp_player, "queue_free"))
