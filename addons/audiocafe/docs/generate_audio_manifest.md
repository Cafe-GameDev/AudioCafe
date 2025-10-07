# Generate Audio Manifest

The `GenerateAudioManifest` script (`generate_audio_manifest.gd`) is an `EditorScript` responsible for the core logic of scanning audio files, generating various `AudioStream` resources, and compiling them into the `AudioManifest`.

## Key Responsibilities

*   **Audio File Scanning**: Recursively scans directories specified in `AudioConfig.assets_paths` for `.ogg` and `.wav` audio files.
*   **Resource Generation**: Based on the `AudioConfig` settings, it generates:
    *   `AudioStreamPlaylist` resources for each unique key (derived from folder structure or file names).
    *   `AudioStreamRandomizer` resources.
    *   `AudioStreamSynchronized` resources.
*   **Interactive Stream Collection**: Scans the distribution path for manually created `AudioStreamInteractive` resources and includes them in the manifest.
*   **Directory Management**: Creates necessary distribution directories if they don't exist.
*   **Manifest Population**: Populates the `AudioManifest.tres` with references to all generated and collected audio streams, along with their UIDs.
*   **Progress and Feedback**: Emits signals for progress updates and generation completion, allowing the UI to provide feedback to the user.
*   **Error Handling**: Reports errors encountered during file operations or resource saving.