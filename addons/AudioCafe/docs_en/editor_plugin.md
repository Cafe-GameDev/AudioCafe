# `editor_plugin.gd` Script

The `editor_plugin.gd` is the main script of the AudioCafe plugin, extending the `EditorPlugin` class of the Godot Engine. It is the entry point for the plugin's functionality in the editor, responsible for its initialization, user interface configuration, and lifecycle management.

## Purpose

This script orchestrates the integration of AudioCafe into the Godot editor environment. It creates and manages the plugin's user interface panel, ensures that the configuration resource (`audio_config.tres`) is loaded or created, and handles resource cleanup when the plugin is disabled.

## Extends

`EditorPlugin`

## Key Properties

*   **`GROUP_SCENE_PATH`**: A constant that stores the path to the AudioCafe panel scene (`res://addons/AudioCafe/panel/audio_panel.tscn`).
*   **`plugin_panel: ScrollContainer`**: The reference to the main container of the plugin panel, which is added to the editor's dock.
*   **`group_panel: VBoxContainer`**: The reference to the specific AudioCafe panel (instance of `audio_panel.tscn`) that is added to the `plugin_panel`.

## Methods

*   **`_enter_tree()`**: This method is called when the plugin is activated. It invokes `_create_plugin_panel()` to configure the plugin's user interface.

*   **`_exit_tree()`**: This method is called when the plugin is deactivated. It is responsible for releasing allocated resources, such as `group_panel` and `plugin_panel`, to prevent memory leaks and ensure a clean deactivation.

*   **`_create_plugin_panel()`**: An internal method that checks if the main plugin panel (`CafeEngine`) already exists. If not, it creates a new `ScrollContainer` named "CafeEngine", configures its layout properties, and adds it to an editor dock. Then, it calls `_ensure_group("AudioCafe")` to add the specific AudioCafe panel.

*   **`_ensure_group(group_name: String) -> VBoxContainer`**: This method is responsible for loading or creating the `audio_panel.tscn` scene and adding it to the `plugin_panel`. It also ensures that `audio_config.tres` is loaded. If `audio_config.tres` does not exist, it is created from `audio_config.gd` and saved to disk. Finally, it sets the `AudioConfig` instance in the `group_panel`.

## Operation Flow

1.  **Plugin Activation**: When the user activates AudioCafe in the Godot plugin manager, the `_enter_tree()` method is called.
2.  **Main Panel Creation**: `_create_plugin_panel()` checks for the existence of a "CafeEngine" panel. If none exists, it creates a `ScrollContainer` and adds it to an editor dock (by default, top right).
3.  **AudioCafe Panel Creation/Loading**: `_ensure_group("AudioCafe")` is called. It loads `audio_panel.tscn`, instantiates it, and adds it to the main `ScrollContainer`.
4.  **`AudioConfig` Management**: Inside `_ensure_group`, `audio_config.tres` is loaded. If not found, a new instance of `audio_config.gd` is created and saved as `audio_config.tres`. This instance is then passed to `audio_panel.gd` via the `set_audio_config()` method.
5.  **Plugin Deactivation**: When the plugin is deactivated, `_exit_tree()` is called to free scene nodes and other resources, ensuring the editor returns to its original state.

```mermaid
graph TD
    EP[editor_plugin.gd]:::script
    GE[Godot Engine]
    AP_TSCN[audio_panel.tscn]:::scene
    AC_RES[audio_config.tres]:::resource

    EP -- "Extends EditorPlugin" --> GE
    EP -- "_enter_tree(): Creates plugin panel" --> AP_TSCN
    EP -- "_ensure_group(): Loads/Creates" --> AC_RES
    EP -- "_exit_tree(): Frees resources" --> GE

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef scene fill:#EEFFDD,stroke:#66CC33,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style EP fill:#f9f,stroke:#333,stroke-width:2px

    %% Description
    EP -- "Main editor plugin. Instantiates the panel UI and manages the plugin's lifecycle."
```