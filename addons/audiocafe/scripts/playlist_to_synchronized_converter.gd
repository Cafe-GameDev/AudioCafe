@tool
extends EditorScript

func convert(playlist_path: String, save_path: String) -> bool:
	var playlist = load(playlist_path)
	if not playlist is AudioStreamPlaylist:
		push_error("Source file is not an AudioStreamPlaylist.")
		return false

	var sync_stream = AudioStreamSynchronized.new()
	for i in playlist.get_stream_count():
		sync_stream.add_stream(playlist.get_stream(i))

	var error = ResourceSaver.save(sync_stream, save_path)
	if error != OK:
		push_error("Failed to save synchronized stream at %s. Error: %s" % [save_path, error])
		return false

	return true
