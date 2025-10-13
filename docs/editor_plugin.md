# Editor Plugin

The `EditorPlugin` (`editor_plugin.gd`) is the entry point for the AudioManager plugin within the Godot editor. It extends `EditorPlugin` and is responsible for integrating the plugin's functionalities into the Godot environment.

## Key Responsibilities

*   **Autoload Singleton**: Ensures the `AudioManager` scene (`audio_manager.tscn`) is added as an autoload singleton, making it globally accessible in the game.
*   **UI Integration**: Creates and manages the plugin's UI panel (the "CafeEngine" `ScrollContainer` which contains the `AudioPanel`), adding it to the editor's dock.
*   **Custom Type Registration**: Registers custom types like `AudioPosition2D` and `AudioPosition3D`, making them available in the editor for scene creation.
*   **Lifecycle Management**: Handles the plugin's lifecycle events (`_enter_tree` for initialization and `_exit_tree` for cleanup), ensuring proper setup and teardown.
*   **AudioConfig Management**: Loads or creates the `AudioConfig` resource and passes it to the `AudioPanel` for configuration.