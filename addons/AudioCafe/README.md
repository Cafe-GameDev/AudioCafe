# AudioCafe: Audio Workflow Accelerator for Godot Engine

## Overview

AudioCafe is a revolutionary plugin for the Godot Engine, designed to drastically optimize and accelerate the audio management workflow in your projects. With an unwavering focus on User Experience (UX), AudioCafe transforms the way you handle audio resources, from organization to runtime integration.

Forget the tedious task of manually creating `AudioStreamPlaylist`, `AudioStreamRandomizer`, or `AudioStreamSynchronized` for every sound or music in your game. AudioCafe acts as a **Workflow Accelerator**, automating the generation of these resources from your raw audio files (`.ogg`, `.wav`), and organizing them into a centralized `AudioManifest`.

The plugin's strong point is its **AudioPanel**, an intuitive and powerful interface directly within the Godot editor. Through it, you configure your asset paths, define where generated resources should be saved, and, with a single click, generate a complete and ready-to-use audio manifest.

## Key Features

*   **Automated Resource Generation**: Create `AudioStreamPlaylist`, `AudioStreamRandomizer`, and `AudioStreamSynchronized` from your audio files intelligently and automatically.
*   **Centralized AudioManifest**: A single resource (`audio_manifest.tres`) that acts as a catalog, mapping audio keys to generated resources, facilitating runtime access.
*   **Intuitive Interface (AudioPanel)**: Easily configure asset and distribution paths, visualize generated resources, and trigger manifest generation directly in the editor.
*   **AudioStreamInteractive Support**: Although it doesn't generate them, AudioCafe collects references to manually created `AudioStreamInteractive`s, integrating them into your manifest.
*   **Export Optimization**: Ensures that all generated audio resources are correctly included in your exported builds.
*   **UX Focus**: Designed to be simple, efficient, and pleasant to use, freeing you to focus on creativity.

## Why Use AudioCafe?

*   **Time Saving**: Automate repetitive and time-consuming audio setup tasks.
*   **Impeccable Organization**: Keep your audio resources organized and easily accessible through a central manifest.
*   **Flexibility**: Support for various `AudioStream` types to meet different audio needs (music, random SFX, synchronized audio).
*   **Seamless Integration**: Works natively within the Godot Engine, complementing your existing workflow.
*   **Foundation for Robust Systems**: The generated manifest serves as the backbone for building complex and dynamic audio systems in your Godot game.

With AudioCafe, you don't just manage audio; you accelerate the creation of immersive and dynamic sound experiences in your Godot games.