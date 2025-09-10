@tool
extends EditorScript

func convert(playlist_path: String, save_path: String) -> bool:
	var playlist = load(playlist_path)
	if not playlist is AudioStreamPlaylist:
		push_error("Source file is not an AudioStreamPlaylist.")
		return false

	var interactive_stream = AudioStreamInteractive.new()
	var last_clip_name = ""

	for i in playlist.get_stream_count():
		var stream = playlist.get_stream(i)
		var clip_name = stream.resource_path.get_file().get_basename()
		interactive_stream.add_clip(clip_name, stream)
		
		if i > 0:
			interactive_stream.add_transition(last_clip_name, clip_name, &"AutoAdvance")
		
		last_clip_name = clip_name

	var error = ResourceSaver.save(interactive_stream, save_path)
	if error != OK:
		push_error("Failed to save interactive stream at %s. Error: %s" % [save_path, error])
		return false

	return true
