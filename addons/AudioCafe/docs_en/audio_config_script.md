# `audio_config.gd` Script

The `audio_config.gd` is a resource script (`Resource`) that defines the structure and behavior of the AudioCafe plugin's configurations. It serves as the foundation for the persistent `audio_config.tres` resource.

## Purpose

This script encapsulates all configurable properties of the plugin, such as asset paths, distribution paths, and generation flags. It also manages the automatic saving of these configurations and the emission of a signal when configurations are changed, allowing the editor UI to react to these changes.

## Extends

`Resource`

## Signals

*   **`config_changed`**: Emitted whenever one of the resource's `@export` properties is changed and saved. The `AudioPanel` listens for this signal to update its interface or display save feedback.

## Exported Properties (`@export`)

The following variables are exported, making them editable in the Godot inspector and persistent in `audio_config.tres`:

*   **`is_panel_expanded: bool`**: Controls whether the AudioCafe panel in the editor UI is expanded or collapsed.
*   **`gen_playlist: bool`**: If `true`, the plugin will generate `AudioStreamPlaylist` resources for found audio files.
*   **`gen_randomizer: bool`**: If `true`, the plugin will generate `AudioStreamRandomizer` resources for found audio files.
*   **`gen_synchronized: bool`**: If `true`, the plugin will generate `AudioStreamSynchronized` resources for found audio files.
*   **`assets_paths: Array[String]`**: An array of paths (e.g., `res://assets/music/`, `res://assets/sfx/`) where the plugin should look for raw audio files (`.ogg`, `.wav`).
*   **`dist_path: String`**: The base path (e.g., `res://dist/audio/`) where the generated `.tres` resources (playlists, randomizers, synchronized) and the `audio_manifest.tres` will be saved.

## Methods

*   **`get_playlist_save_path() -> String`**: Returns the full path to the directory where playlists will be saved, based on `dist_path`.
*   **`get_randomized_save_path() -> String`**: Returns the full path to the directory where randomizers will be saved, based on `dist_path`.
*   **`get_interactive_save_path() -> String`**: Returns the full path to the directory where interactive streams will be collected/referenced, based on `dist_path`.
*   **`get_synchronized_save_path() -> String`**: Returns the full path to the directory where synchronized streams will be saved, based on `dist_path`.
*   **`_save_and_emit_changed()`**: An internal method that saves the `AudioConfig` instance to disk (at the defined `resource_path`, which is `audio_config.tres`) and emits the `config_changed` signal. This method is automatically called by the setters of the `@export` properties.

## Interactions

*   **`audio_config.tres`**: Is the persistent instance of this script.
*   **`AudioPanel`**: Loads and displays the properties defined in this script, and reacts to the `config_changed` signal.
*   **`GenerateAudioManifest`**: Accesses the properties of this script to determine input and output paths and which types of audio resources should be generated.

```mermaid
graph TD
    AC_GD[audio_config.gd]:::script
    AC_RES[audio_config.tres]:::resource
    AP[AudioPanel]

    AC_GD -- "Extends Resource" --> AC_RES
    AC_GD -- "@export vars: is_panel_expanded, gen_playlist, gen_randomizer, gen_synchronized, assets_paths, dist_path" --> AC_RES
    AC_GD -- "signal config_changed" --> AP
    AC_GD -- "_save_and_emit_changed(): Saves and emits signal" --> AC_RES

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AC_GD fill:#f9f,stroke:#333,stroke-width:2px

    %% Description
    AC_GD -- "Resource that stores plugin configurations (asset paths, distribution path, panel state). Emits 'config_changed' signal when saved."
```