# Audio Config

The `AudioConfig` is a `Resource` (`.tres` file) that serves as the central configuration object for the AudioManager plugin. It stores various settings and user preferences, ensuring that the plugin's behavior is persistent across editor sessions.

## Key Properties

*   `is_panel_expanded`: A boolean indicating whether the AudioPanel UI is expanded or collapsed.
*   `gen_playlist`: A boolean to enable/disable the generation of `AudioStreamPlaylist` resources.
*   `gen_randomizer`: A boolean to enable/disable the generation of `AudioStreamRandomizer` resources.
*   `gen_synchronized`: A boolean to enable/disable the generation of `AudioStreamSynchronized` resources.
*   `assets_paths`: An array of strings, each representing a `res://` path to a directory containing raw audio assets (`.ogg`, `.wav`).
*   `dist_path`: A string representing the `res://` path where all generated audio resources (playlists, randomizers, synchronized streams) will be saved.

## Functionality

*   **Persistence**: Automatically saves its state to `audio_config.tres` whenever a property changes, ensuring settings are retained.
*   **Path Management**: Provides helper functions (`get_albuns_save_path`, `get_randomized_save_path`, etc.) to construct full save paths for different types of generated audio resources.
*   **Signal Emission**: Emits a `config_changed` signal whenever a property is modified, allowing other parts of the plugin (like the `AudioPanel`) to react to changes.