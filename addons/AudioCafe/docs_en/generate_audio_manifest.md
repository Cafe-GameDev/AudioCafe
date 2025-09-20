# `generate_audio_manifest.gd` Script

The `generate_audio_manifest.gd` is the core of the AudioCafe plugin, responsible for scanning asset directories, generating audio resources (`.tres`), and updating `audio_manifest.tres`. It extends `EditorScript`, which allows it to be executed directly in the Godot editor.

## Purpose

This script automates the creation of `AudioStreamPlaylist`, `AudioStreamRandomizer`, and `AudioStreamSynchronized` from raw audio files (`.ogg`, `.wav`). It also collects references to manually created `AudioStreamInteractive`s. The ultimate goal is to consolidate all these references into a single `audio_manifest.tres`, which serves as a centralized catalog for runtime audio access.

## Extends

`EditorScript`

## Signals

*   **`progress_updated(current: int, total: int)`**: Emitted to indicate file scanning progress, useful for displaying a progress bar in the UI.
*   **`generation_finished(success: bool, message: String)`**: Emitted at the end of the generation process, indicating whether it was successful and providing a status message.

## Exported Properties (`@export`)

*   **`audio_config: AudioConfig`**: A reference to the `audio_config.tres` resource, which contains all necessary configurations for generation, such as `assets_paths`, `dist_path`, and flags for generating playlists, randomizers, and synchronized streams.

## Constants

*   **`MANIFEST_SAVE_FILE`**: The path to the `audio_manifest.tres` file (`res://addons/AudioCafe/resources/audio_manifest.tres`).

## Main Methods

*   **`_run()`**: This is the main method that orchestrates the entire generation process. It is called by the `AudioPanel` when the user triggers generation. The general flow is:
    1.  Initializes progress counters.
    2.  Counts the total audio files to be scanned for progress.
    3.  Collects all raw `AudioStream`s from `assets_paths`, grouping them by a final key (generated from the directory or file name).
    4.  Ensures that output directories (`dist_path`) exist.
    5.  Calls `generate_playlist()`, `generate_randomizer()`, and `generate_synchronized()` based on `audio_config` settings.
    6.  Collects references to existing `AudioStreamInteractive`s in `dist_path`.
    7.  Saves the updated `audio_manifest.tres`.
    8.  Emits the `generation_finished` signal.

*   **`generate_playlist(audio_manifest: AudioManifest, collected_streams: Dictionary, playlist_dist_save_path: String, overall_success: bool, message: String) -> Array`**: This method iterates over the collected streams and, for each key, creates or updates an `AudioStreamPlaylist.tres` in `playlist_dist_save_path`. It adds all collected raw `AudioStream`s to the playlist and updates `audio_manifest.playlists` with the path, stream count, and UID of the generated resource.

*   **`generate_randomizer(audio_manifest: AudioManifest, collected_streams: Dictionary, randomizer_dist_save_path: String) -> Array`**: Similar to `generate_playlist`, but creates or updates `AudioStreamRandomizer.tres`. It adds the collected streams to the randomizer, assigning a default weight of 1.0 to each, and updates `audio_manifest.randomizer`.

*   **`generate_synchronized(audio_manifest: AudioManifest, collected_streams: Dictionary, synchronized_dist_save_path: String) -> Array`**: Creates or updates `AudioStreamSynchronized.tres`. Adds the collected streams (limited to `MAX_SYNCHRONIZED_STREAMS`) and updates `audio_manifest.synchronized`.

*   **`_count_files_in_directory(current_path: String)`**: A recursive method that traverses a directory and its subdirectories to count the total number of `.ogg` and `.wav` files, used for progress calculation.

*   **`_collect_streams_by_key(paths: Array[String], collected_streams: Dictionary) -> bool`**: Iterates over the configured `assets_paths` and calls `_scan_directory_for_streams` for each.

*   **`_scan_directory_for_streams(current_path: String, collected_streams: Dictionary, root_path: String) -> bool`**: A recursive method that scans a directory for `.ogg` and `.wav` files. For each file found, it loads the corresponding `AudioStream` and adds it to the `collected_streams` dictionary, using a key generated from the file's relative path.

*   **`_scan_directory_for_resources(current_path: String, resource_class_name: String, collected_resources: Dictionary) -> bool`**: A generic recursive method that scans a directory for `.tres` resources of a specific class (used to collect `AudioStreamInteractive`).

## Interaction Flow

1.  **Configuration**: The `audio_config.tres` (edited via `AudioPanel`) provides input and output paths and generation options.
2.  **Scanning**: The script traverses `assets_paths` to find all raw audio files.
3.  **Generation**: Based on `audio_config` options, it creates instances of `AudioStreamPlaylist`, `AudioStreamRandomizer`, and `AudioStreamSynchronized`, populating them with raw `AudioStream`s.
4.  **Interactive Collection**: It also scans `dist_path` for manually created `AudioStreamInteractive`s.
5.  **Manifest Update**: All references to generated and collected resources are saved in `audio_manifest.tres`.
6.  **Notification**: The `AudioPanel` is notified of generation completion to update its UI.

```mermaid
graph TD
    GAM[generate_audio_manifest.gd]:::script
    AC_RES[audio_config.tres]:::resource
    AM_RES[audio_manifest.tres]:::resource
    GE[Godot Engine]
    GAR[Generated Audio Resources]

    GAM -- "Extends EditorScript" --> GE
    GAM -- "@export var: audio_config" --> AC_RES
    GAM -- "_run(): Orchestrates generation" --> AC_RES
    GAM -- "_run(): Scans directories" --> GE
    GAM -- "_run(): Generates/Updates" --> GAR
    GAM -- "_run(): Saves" --> AM_RES
    GAM -- "signal generation_finished" --> AP[AudioPanel]

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style GAM fill:#f9f,stroke:#333,stroke-width:2px

    %% Description
    GAM -- "Main script for scanning directories, loading AudioStreams, generating audio resources (.tres), and updating the AudioManifest."
```