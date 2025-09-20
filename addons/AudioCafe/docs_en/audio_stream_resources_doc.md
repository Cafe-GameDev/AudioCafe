# AudioStream Resources Documentation in AudioCafe

The AudioCafe plugin utilizes and generates various types of `AudioStream` resources from the Godot Engine to offer a flexible and powerful audio management system. Understanding these resources is fundamental to getting the most out of the plugin.

## 1. AudioStream (Base)

`AudioStream` is the base class for all audio resources in Godot. It represents an audio stream that can be played. In AudioCafe, you do not interact directly with the base `AudioStream`, but rather with its specialized variations.

## 2. AudioStreamPlaylist

An `AudioStreamPlaylist` is a resource that contains an ordered list of `AudioStream`s. It is ideal for playing a sequence of sounds, such as background music, dialogues, or sound effects that should occur in a specific order.

**How AudioCafe uses it:**
AudioCafe generates `AudioStreamPlaylist.tres` for each audio "key" found in your `assets_paths`. If you have a folder `res://assets/music/level1/` with `intro.ogg`, `loop.ogg`, `outro.ogg`, AudioCafe can generate a playlist `music_level1_playlist.tres` containing these three files in the order they were found (or an order defined by you, if the plugin allows).

**Example Usage (via `AudioManifest`):**
```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _ready():
    var level1_music_playlist = audio_manifest.playlists["music_level1"]
    # level1_music_playlist[0] is the path to the .tres
    # level1_music_playlist[1] is the stream count
    # level1_music_playlist[2] is the resource UID

    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = load(level1_music_playlist[0])
    audio_player.play()
```

## 3. AudioStreamRandomizer

An `AudioStreamRandomizer` is a resource that contains a collection of `AudioStream`s and plays one of them randomly each time it is triggered. It is perfect for sound effects that need variation to avoid repetition and make the experience more organic (e.g., footsteps, gunshots, impacts).

**How AudioCafe uses it:**
For each audio "key", AudioCafe can generate an `AudioStreamRandomizer.tres` that groups all variations of a sound. For example, if you have `res://assets/sfx/hit/hit_01.ogg`, `hit_02.ogg`, `hit_03.ogg`, AudioCafe will create `sfx_hit_randomizer.tres` which, when played, will randomly choose one of these three sounds.

**Example Usage (via `AudioManifest`):**
```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _on_player_hit():
    var hit_sfx_randomizer = audio_manifest.randomizer["sfx_hit"]
    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = load(hit_sfx_randomizer[0])
    audio_player.play()
```

## 4. AudioStreamSynchronized

The `AudioStreamSynchronized` is a more advanced resource that allows synchronizing the playback of multiple `AudioStream`s. This is useful for creating complex audio layers that should start and stop together, or for effects that depend on a rhythmic base.

**How AudioCafe uses it:**
AudioCafe can generate `AudioStreamSynchronized.tres` for audio keys that would benefit from layered playback. It groups the `AudioStream`s associated with a key and configures them to play in sync.

**Example Usage (via `AudioManifest`):**
```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _start_ambience():
    var ambience_sync = audio_manifest.synchronized["ambience_forest"]
    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = load(ambience_sync[0])
    audio_player.play()
```

## 5. AudioStreamInteractive

`AudioStreamInteractive` is a resource that allows creating dynamic and interactive audio, where playback can change based on game parameters (e.g., player distance, health state, etc.). Unlike the others, AudioCafe **does not automatically generate** `AudioStreamInteractive`. Instead, it **collects references** to instances of `AudioStreamInteractive.tres` that you manually create in the editor and includes them in the `AudioManifest`.

**How AudioCafe uses it:**
You create an `AudioStreamInteractive.tres` in the Godot editor, configure its parameters, and save it in one of your `dist_paths` (or in a subdirectory that AudioCafe scans for interactive resources). In the next manifest generation, AudioCafe will detect this resource and add it to the `interactive` dictionary of the `AudioManifest`.

**Manual Creation Example (in the Editor):**
1.  In the "FileSystem" panel, right-click on a folder (e.g., `res://dist/interactive/`).
2.  Select "New Resource...".
3.  Search for `AudioStreamInteractive` and create it.
4.  Configure the `AudioStreamInteractive` in the inspector (add streams, define transition parameters, etc.).
5.  Save the resource (e.g., `res://dist/interactive/player_footsteps_interactive.tres`).

**Example Usage (via `AudioManifest`):**
```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _on_player_move():
    var footsteps_interactive_path = audio_manifest.interactive["player_footsteps_interactive"]
    var footsteps_interactive = load(footsteps_interactive_path)

    # Example: Update an AudioStreamInteractive parameter
    # footsteps_interactive.set_parameter("speed", player_velocity.length())

    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = footsteps_interactive
    audio_player.play()
```

---

This documentation serves as a quick guide to the types of `AudioStream` that AudioCafe manages or references. For more in-depth details on configuring each `AudioStream` (especially `AudioStreamInteractive`), please consult the official Godot Engine documentation.