# `audio_config.tres` Resource

The `audio_config.tres` is a persistent instance of the `audio_config.gd` script. It acts as the primary storage for all AudioCafe plugin configurations within your Godot project.

## Purpose

This resource centralizes user-defined preferences and settings for the plugin, ensuring they are saved between editor sessions and persist with the project.

## Interactions

*   **`audio_config.gd`**: The `audio_config.tres` is an instance of this script, inheriting its properties and logic.
*   **`AudioPanel`**: The AudioCafe user interface panel in the Godot editor reads and allows editing of this resource's properties. Any changes made in the UI are saved directly to this `.tres` file.
*   **`GenerateAudioManifest`**: The script responsible for generating the audio manifest reads the `assets_paths` and `dist_path` (asset and distribution paths) configurations from this resource to know where to look for audio files and where to save the generated resources.

## Content

The `audio_config.tres` stores crucial information such as:

*   **`is_panel_expanded`**: Expansion/collapse state of the plugin panel in the UI.
*   **`gen_playlist`**: Boolean indicating whether the plugin should generate `AudioStreamPlaylist` resources.
*   **`gen_randomizer`**: Boolean indicating whether the plugin should generate `AudioStreamRandomizer` resources.
*   **`gen_synchronized`**: Boolean indicating whether the plugin should generate `AudioStreamSynchronized` resources.
*   **`assets_paths`**: An array of strings containing the paths to the directories where the plugin should look for raw audio files (`.ogg`, `.wav`).
*   **`dist_path`**: A string defining the directory path where the generated audio resources (`.tres`) and the `audio_manifest.tres` will be saved.

## Editing

This resource can be edited directly through the `AudioPanel` in the Godot editor, providing an intuitive way to configure the plugin's behavior.

```mermaid
graph TD
    AC_RES[audio_config.tres]:::resource
    AC_GD[audio_config.gd]:::script
    AP[AudioPanel]
    GAM[GenerateAudioManifest]

    AC_RES -- "Instance of" --> AC_GD
    AC_RES -- "Editable in editor" --> AP
    AC_RES -- "Read by" --> GAM

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AC_RES fill:#f9f,stroke:#333,stroke-width:2px

    %% Description
    AC_RES -- "Persistent instance of AudioConfig, editable in the editor, which stores plugin configurations."
```