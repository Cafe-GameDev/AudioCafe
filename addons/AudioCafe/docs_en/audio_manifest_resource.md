# `audio_manifest.tres` Resource

The `audio_manifest.tres` is a persistent instance of the `audio_manifest.gd` script. It serves as the centralized catalog for all audio resources generated or collected by the AudioCafe plugin.

## Purpose

This resource is the main access point for your runtime code to load and play audio managed by AudioCafe. It maps friendly audio keys to the paths and UIDs of generated or referenced `AudioStreamPlaylist`, `AudioStreamRandomizer`, `AudioStreamSynchronized`, and `AudioStreamInteractive` resources.

## Interactions

*   **`audio_manifest.gd`**: The `audio_manifest.tres` is an instance of this script, inheriting its dictionary properties.
*   **`GenerateAudioManifest`**: The `GenerateAudioManifest` script is responsible for creating and updating this resource, populating its dictionaries with references to the generated audio.
*   **`AudioPanel`**: The editor panel reads this resource to display to the user a list of generated and available audio.
*   **User (Runtime)**: During game execution, user code accesses this manifest to obtain the necessary audio resources for playback.

## Content

The `audio_manifest.tres` contains the following dictionaries, where each key is a unique identifier for the audio and the value is an array containing the path to the `.tres` resource, the stream count (if applicable), and the resource's UID:

*   **`playlists: Dictionary`**: Maps keys to `AudioStreamPlaylist.tres` resources.
    *   Example value: `["res://dist/playlist/music_level1_playlist.tres", "3", 1234567890]`
*   **`randomizer: Dictionary`**: Maps keys to `AudioStreamRandomizer.tres` resources.
    *   Example value: `["res://dist/randomizer/sfx_hit_randomizer.tres", "5", 9876543210]`
*   **`synchronized: Dictionary`**: Maps keys to `AudioStreamSynchronized.tres` resources.
    *   Example value: `["res://dist/synchronized/ambience_forest_synchronized.tres", "2", 1122334455]`
*   **`interactive: Dictionary`**: Maps keys to `AudioStreamInteractive.tres` resources that were manually created and collected by the plugin.
    *   Example value: `"res://dist/interactive/player_footsteps_interactive.tres"` (only the path, as these are manually created resources and do not have stream counts managed by the plugin)

## Runtime Access

To access an audio resource in your code, you can load the `audio_manifest.tres` and then use the keys to get the resource paths:

```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _ready():
    # Accessing a playlist
    var music_path = audio_manifest.playlists["music_level1"][0]
    var music_stream = load(music_path)
    # ... use music_stream with an AudioStreamPlayer

    # Accessing a randomizer
    var sfx_path = audio_manifest.randomizer["sfx_hit"][0]
    var sfx_stream = load(sfx_path)
    # ... use sfx_stream with an AudioStreamPlayer

    # Accessing an interactive stream
    var interactive_path = audio_manifest.interactive["player_footsteps_interactive"]
    var interactive_stream = load(interactive_path)
    # ... use interactive_stream with an AudioStreamPlayer
```

```mermaid
graph TD
    AM_RES[audio_manifest.tres]:::resource
    AM_GD[audio_manifest.gd]:::script
    GAM[GenerateAudioManifest]
    AP[AudioPanel]
    U[User (Runtime)]

    AM_RES -- "Instance of" --> AM_GD
    AM_RES -- "Updated by" --> GAM
    AM_RES -- "Read by" --> AP
    AM_RES -- "Accessed by" --> U

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AM_RES fill:#f9f,stroke:#333,stroke-width:2px

    %% Description
    AM_RES -- "Persistent instance of AudioManifest, updated by the plugin, which maps audio keys to generated resources."
```