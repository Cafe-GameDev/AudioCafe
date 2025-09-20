# Unified `AudioPanel` Diagram

This diagram illustrates the architecture and interactions of the `AudioPanel`, the main user interface of the AudioCafe plugin within the Godot editor.

## Overview

The `AudioPanel` is the user's interaction point with the plugin. It allows configuring asset and distribution paths, visualizing generated audio resources, and triggering the manifest generation process. It unifies the presentation and control of the project's audio system settings and state.

## Key Components

### AudioPanel (Editor UI)

*   **`audio_panel.tscn`**: The scene that defines the visual structure of the panel, including buttons, text fields, tabs, and labels.
*   **`audio_panel.gd`**: The script that controls the UI logic. It loads and saves configurations, displays manifest data, triggers generation logic, and loads SVG icons for the interface.

### Resources

*   **`audio_config.tres`**: The persistent instance of the plugin's configurations. The `AudioPanel` reads from and writes to this resource.
*   **`audio_manifest.tres`**: The persistent instance of the audio manifest. The `AudioPanel` reads this resource to display the generated audio.
*   **`SVG Icons`**: Visual resources used in the panel interface to improve usability and aesthetics.

### Generation Logic

*   **`generate_audio_manifest.gd`**: The main script containing the logic to scan directories, generate audio resources (`.tres`), and update the `audio_manifest.tres`. The `AudioPanel` triggers this script.

## Interaction Flow

1.  **Visual Structure Definition**: `audio_panel.tscn` establishes the layout and visual elements of the panel.
2.  **UI Control**: `audio_panel.gd` manages user interaction with the UI, loading and saving configurations to `audio_config.tres`.
3.  **Manifest Display**: `audio_panel.gd` reads `audio_manifest.tres` to present the user with a list of generated audio resources (playlists, randomizers, synchronized, interactive).
4.  **Generation Trigger**: When the user clicks the generate button, `audio_panel.gd` invokes `generate_audio_manifest.gd` to start the process.
5.  **Configuration Provision**: `audio_config.tres` feeds `audio_panel.gd` with the configured asset and distribution paths.
6.  **Manifest Update**: `generate_audio_manifest.gd` updates `audio_manifest.tres` after generation is complete.
7.  **Icon Loading**: `audio_panel.gd` loads SVG icons for use in the interface.

```mermaid
graph TD
    subgraph AudioPanel (Editor UI)
        AP_TSCN[audio_panel.tscn]:::scene
        AP_GD[audio_panel.gd]:::script
    end

    subgraph Resources
        AC_RES[audio_config.tres]:::resource
        AM_RES[audio_manifest.tres]:::resource
        ICONS[SVG Icons]:::resource
    end

    subgraph Generation Logic
        GAM[generate_audio_manifest.gd]:::script
    end

    AP_TSCN -- "Defines visual structure" --> AP_GD
    AP_GD -- "Controls UI, loads/saves config" --> AC_RES
    AP_GD -- "Displays manifest data" --> AM_RES
    AP_GD -- "Triggers generation" --> GAM
    AP_GD -- "Loads" --> ICONS

    AC_RES -- "Provides configurations (assets_paths, dist_path)" --> AP_GD
    AM_RES -- "Provides lists of generated audio" --> AP_GD
    GAM -- "Updates" --> AM_RES

    style AP_GD fill:#f9f,stroke:#333,stroke-width:2px
    style AP_TSCN fill:#EEFFDD,stroke:#66CC33,stroke-width:1px
    style AC_RES fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AM_RES fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style ICONS fill:#F0F0F0,stroke:#999999,stroke-width:0.5px
    style GAM fill:#f9f,stroke:#333,stroke-width:2px

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    classDef scene fill:#EEFFDD,stroke:#66CC33,stroke-width:1px
