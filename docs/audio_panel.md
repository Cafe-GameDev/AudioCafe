# Audio Panel

The `AudioPanel` is the core graphical user interface (GUI) component of the AudioManager plugin, extending `VBoxContainer`. It provides an intuitive and powerful interface directly within the Godot editor for managing audio resources.

## Key Responsibilities

*   **Configuration**: Allows users to define asset paths (where raw audio files are located) and distribution paths (where generated audio resources will be saved).
*   **Generation Trigger**: Contains a button to initiate the generation of `AudioStreamPlaylist`, `AudioStreamRandomizer`, and `AudioStreamSynchronized` resources.
*   **Visualization**: Displays lists of generated albuns and collected interactive audio streams.
*   **State Management**: Persists its expanded/collapsed state using the `AudioConfig` resource.
*   **User Feedback**: Provides visual feedback for save operations and generation status.

## UI Elements

The `AudioPanel` includes various UI elements such as buttons for adding/removing paths, `LineEdit` for path input, `FileDialog` for folder selection, and `RichTextLabel` for displaying generated resource information.