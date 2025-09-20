# `audio_manifest.gd` Script

The `audio_manifest.gd` is a resource script (`Resource`) that defines the structure of the AudioCafe plugin's centralized audio manifest. It serves as a container for references to all audio resources generated or collected by the plugin.

## Purpose

This script provides the data structure for `audio_manifest.tres`, which is the main catalog for accessing audio resources at runtime. It organizes different types of `AudioStream` (playlists, randomizers, synchronized, interactive) into dictionaries, allowing for easy and programmatic access.

## Extends

`Resource`

## Exported Properties (`@export`)

The following variables are exported, making them persistent in `audio_manifest.tres` and accessible at runtime:

*   **`playlists: Dictionary`**: A dictionary where keys are audio identifiers (usually based on directory or file names) and values are arrays containing:
    1.  The path (`String`) to the `AudioStreamPlaylist.tres` resource.
    2.  The count (`String`) of streams within the playlist.
    3.  The UID (`int`) of the `AudioStreamPlaylist.tres` resource.

*   **`randomizer: Dictionary`**: A dictionary similar to `playlists`, but for `AudioStreamRandomizer.tres` resources.
    1.  The path (`String`) to the `AudioStreamRandomizer.tres` resource.
    2.  The count (`String`) of streams within the randomizer.
    3.  The UID (`int`) of the `AudioStreamRandomizer.tres` resource.

*   **`synchronized: Dictionary`**: A dictionary similar to `playlists`, but for `AudioStreamSynchronized.tres` resources.
    1.  The path (`String`) to the `AudioStreamSynchronized.tres` resource.
    2.  The count (`String`) of streams within the synchronized.
    3.  The UID (`int`) of the `AudioStreamSynchronized.tres` resource.

*   **`interactive: Dictionary`**: A dictionary where keys are audio identifiers and values are the paths (`String`) to `AudioStreamInteractive.tres` resources manually created by the user and collected by the plugin.

## Interactions

*   **`audio_manifest.tres`**: Is the persistent instance of this script, which is updated by `GenerateAudioManifest`.
*   **`GenerateAudioManifest`**: This script populates the dictionaries of `audio_manifest.gd` with references to the generated or collected audio resources.
*   **User Code (Runtime)**: The game code accesses the properties of this script (via `audio_manifest.tres`) to load and play audio.

```mermaid
graph TD
    AM_GD[audio_manifest.gd]:::script
    AM_RES[audio_manifest.tres]:::resource
    GAM[GenerateAudioManifest]

    AM_GD -- "Extends Resource" --> AM_RES
    AM_GD -- "@export vars: playlists, randomizer, synchronized, interactive" --> AM_RES
    GAM -- "Updates" --> AM_GD

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AM_GD fill:#f9f,stroke:#333,stroke-width:2px

    %% Description
    AM_GD -- "Resource that stores the final mapping of audio keys to generated resources (Playlists, Randomizers, Synchronized, Interactive)."
```