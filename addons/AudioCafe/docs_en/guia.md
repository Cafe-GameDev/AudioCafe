# Complete AudioCafe Guide

Welcome to the complete AudioCafe guide, a Godot Engine plugin designed to optimize and accelerate the audio management workflow in your projects. This guide will cover everything from installation to advanced usage of generated audio resources.

## 1. AudioCafe Overview

AudioCafe automates the creation of `AudioStreamPlaylist`, `AudioStreamRandomizer`, and `AudioStreamSynchronized` resources from your raw audio files (`.ogg`, `.wav`). It organizes these resources into a centralized `AudioManifest`, which serves as a catalog for easy runtime access. The plugin also collects references to manually created `AudioStreamInteractive`s.

## 2. Installation

1.  **Download the Plugin**: Get the latest version of AudioCafe from the official repository or the Godot Asset Library.
2.  **Copy to Project**: Unzip the plugin content into your Godot project's `addons/` folder. The structure should be `res://addons/AudioCafe/`.
3.  **Activate the Plugin**: In the Godot Editor, go to `Project -> Project Settings -> Plugins`. Find "AudioCafe" in the list and ensure its status is "Active".

After activation, a new panel named "AudioCafe" will appear in one of the editor's docks (usually on the right).

## 3. Initial Configuration in AudioPanel

The `AudioPanel` is AudioCafe's main interface. To access it, click on the "AudioCafe" tab in the editor's dock.

### 3.1. Panel Sections

The panel is divided into tabs:

*   **Settings**: Where you define asset and distribution paths.
*   **Playlists**: Displays generated playlists.
*   **Interactive**: Displays collected interactive streams.

### 3.2. Configuring Paths

In the "Settings" tab, you will find two crucial sections:

*   **Assets Paths**:
    *   Click "Add Asset Path" to add a new field.
    *   Click the "..." button next to the field to open a directory selector.
    *   Select the folders in your project where you store your raw audio files (`.ogg`, `.wav`). You can add multiple paths.
    *   **Example**: `res://assets/music`, `res://assets/sfx/ui`, `res://assets/sfx/combat`.

*   **Dist / Playlists Path (Distribution Path)**:
    *   Click "Add Dist Path" to add a field (only one distribution path is allowed).
    *   Click the "..." button to select the folder where AudioCafe will save the generated `.tres` resources (playlists, randomizers, synchronized) and `audio_manifest.tres`.
    *   **Recommended**: Create a dedicated folder, such as `res://dist/audio` or `res://generated/audio`.

### 3.3. Generation Options

In the `AudioPanel`, you may also have options to enable/disable the generation of different resource types (Playlist, Randomizer, Synchronized). Make sure the desired options are checked.

### 3.4. Saving Configurations

Configurations are automatically saved to `audio_config.tres` whenever you change them in the panel. A visual feedback "Saved!" will briefly appear.

## 4. Generating the Audio Manifest

After configuring the paths, you can generate the manifest:

1.  Click the **"Generate Playlists"** button (or similar, depending on the version) in the `AudioPanel`.
2.  The plugin will scan the configured `Assets Paths`, process the audio files, and create the `.tres` resources in the `Dist Path`.
3.  The `audio_manifest.tres` will be updated with references to all generated and collected resources.
4.  A status message will appear in the panel, indicating the success or failure of the generation.
5.  The "Playlists" and "Interactive" tabs will be updated to display the available resources.

## 5. Using Generated Audio Resources

The `audio_manifest.tres` is your central catalog. You can load it in any script and access audio resources by keys.

```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _ready():
    # Example of accessing a playlist
    var music_playlist_data = audio_manifest.playlists["music_level1"]
    if music_playlist_data:
        var music_path = music_playlist_data[0] # Path to the .tres
        var music_stream_count = music_playlist_data[1] # Stream count
        var music_uid = music_playlist_data[2] # Resource UID

        var audio_player = AudioStreamPlayer.new()
        add_child(audio_player)
        audio_player.stream = load(music_path)
        audio_player.play()
    else:
        print("Playlist 'music_level1' not found in manifest.")

    # Example of accessing a randomizer
    var sfx_randomizer_data = audio_manifest.randomizer["sfx_hit"]
    if sfx_randomizer_data:
        var sfx_path = sfx_randomizer_data[0]
        var sfx_player = AudioStreamPlayer.new()
        add_child(sfx_player)
        sfx_player.stream = load(sfx_path)
        sfx_player.play()
    else:
        print("Randomizer 'sfx_hit' not found in manifest.")

    # Example of accessing an interactive stream (manually created)
    var interactive_sfx_path = audio_manifest.interactive["player_footsteps_interactive"]
    if interactive_sfx_path:
        var interactive_stream = load(interactive_sfx_path)
        var interactive_player = AudioStreamPlayer.new()
        add_child(interactive_player)
        interactive_player.stream = interactive_stream
        interactive_player.play()
        # If it's an AudioStreamInteractive, you can interact with it:
        # interactive_stream.set_parameter("speed", player_velocity.length())
    else:
        print("Interactive stream 'player_footsteps_interactive' not found in manifest.")
```

### 5.1. `AudioStreamPlaylist`

*   **What it is**: An ordered list of `AudioStream`s that are played in sequence.
*   **When to use**: Background music with intro/loop/outro, dialogue sequences, complex sound effects that need a specific order.
*   **How AudioCafe generates**: For each directory or group of audio files, AudioCafe creates an `AudioStreamPlaylist.tres` containing all audio from that group.

### 5.2. `AudioStreamRandomizer`

*   **What it is**: A collection of `AudioStream`s where one is chosen randomly for each playback.
*   **When to use**: Sound effects that need variation to avoid repetition (footsteps, gunshots, impacts, enemy voices).
*   **How AudioCafe generates**: For each directory or group of audio files, AudioCafe creates an `AudioStreamRandomizer.tres` that groups all audio, allowing random playback.

### 5.3. `AudioStreamSynchronized`

*   **What it is**: Allows synchronizing the playback of multiple `AudioStream`s, useful for creating complex audio layers.
*   **When to use**: Layered soundscapes, dynamic music that adds or removes elements, effects that need multiple components playing together.
*   **How AudioCafe generates**: For each directory or group of audio files, AudioCafe can create an `AudioStreamSynchronized.tres` that groups audio for synchronized playback.

### 5.4. `AudioStreamInteractive`

*   **What it is**: An advanced resource for dynamic and interactive audio, where playback can change based on game parameters (distance, speed, state).
*   **When to use**: Footsteps that change with the surface, music that reacts to action intensity, engine sounds that vary with speed.
*   **How AudioCafe uses it**: AudioCafe **does not automatically generate** `AudioStreamInteractive`. Instead, it **collects references** to instances of `AudioStreamInteractive.tres` that you manually create in the editor and includes them in the `AudioManifest`.

    **How to Manually Create an `AudioStreamInteractive`:**
    1.  In the Godot "FileSystem" panel, right-click on a folder (preferably within your `Dist Path`, e.g., `res://dist/audio/interactive/`).
    2.  Select "New Resource...".
    3.  Search for `AudioStreamInteractive` and create it.
    4.  Configure the `AudioStreamInteractive` in the inspector (add streams, define transition parameters, etc.) according to the official Godot documentation.
    5.  Save the resource (e.g., `res://dist/audio/interactive/player_footsteps_interactive.tres`).
    6.  Run the manifest generation in AudioCafe again so it collects the reference.

## 6. Best Practices

*   **Asset Organization**: Keep your raw audio files well-organized in logical folders (e.g., `music/`, `sfx/ui/`, `sfx/combat/`). AudioCafe uses the folder structure to generate manifest keys.
*   **Naming Convention**: Use clear and consistent file and folder names. This will be reflected in your `AudioManifest` keys.
*   **Dedicated `Dist Path`**: Always use a separate directory for resources generated by AudioCafe (e.g., `res://dist/audio`). This helps keep your project clean and facilitates version control.
*   **Version Control**: Add `audio_manifest.tres` and all generated `.tres` files in the `Dist Path` to your version control system (Git, etc.).
*   **Regular Re-generation**: Whenever you add, remove, or rename raw audio files, run the manifest generation in AudioCafe to keep your `audio_manifest.tres` updated.
*   **Godot Documentation**: For in-depth details on configuring `AudioStreamPlaylist`, `AudioStreamRandomizer`, `AudioStreamSynchronized`, and `AudioStreamInteractive`, consult the official Godot Engine documentation.

With this guide, you are ready to make the most of AudioCafe and accelerate audio development in your Godot games!