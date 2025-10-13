# Audio Manifest

The `AudioManifest` is a `Resource` (`.tres` file) that acts as a centralized catalog for all audio resources managed by the AudioManager plugin. It provides a single point of access for mapping audio keys to their corresponding generated `AudioStream` resources, facilitating runtime access and export optimization.

## Key Properties

*   `playlists`: A dictionary mapping keys (derived from folder names or file names) to `AudioStreamPlaylist` resources.
*   `randomizer`: A dictionary mapping keys to `AudioStreamRandomizer` resources.
*   `synchronized`: A dictionary mapping keys to `AudioStreamSynchronized` resources.
*   `interactive`: A dictionary mapping keys to manually created `AudioStreamInteractive` resources found within the distribution path.

## Purpose

*   **Centralized Access**: Provides a single, easy-to-access resource for retrieving any generated or collected audio stream at runtime.
*   **Organization**: Keeps all audio resources organized and easily discoverable.
*   **Export Optimization**: Ensures that all referenced audio resources are correctly included in exported game builds, preventing missing resource issues.