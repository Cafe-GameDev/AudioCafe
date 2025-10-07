# AudioCafe: Audio Workflow Accelerator for Godot Engine

## Overview

AudioCafe is a powerful Godot Engine plugin designed to streamline audio management. It automates the creation of `AudioStreamPlaylist`, `AudioStreamRandomizer`, and `AudioStreamSynchronized` resources from your raw audio files, organizing them into a centralized `AudioManifest`.

The plugin features an intuitive **AudioPanel** directly within the Godot editor, allowing you to configure asset paths, define resource save locations, and generate a complete audio manifest with ease.

## Key Features

*   **Automated Resource Generation**: Intelligently create various `AudioStream` types from `.ogg` and `.wav` files.
*   **Centralized AudioManifest**: A single `audio_manifest.tres` resource acts as a catalog for all your audio, simplifying runtime access.
*   **Intuitive AudioPanel**: Configure settings and trigger manifest generation directly in the editor.
*   **AudioStreamInteractive Support**: Collects references to manually created `AudioStreamInteractive`s into your manifest.
*   **Export Optimization**: Ensures all generated audio resources are included in your exported builds.

## Documentation

For detailed information on each component and how to use AudioCafe, please refer to the documentation files in the `docs/` directory:

*   [Cafe Panel](addons/audiocafe/docs/cafe_panel.md)
*   [Audio Panel](addons/audiocafe/docs/audio_panel.md)
*   [Audio Config](addons/audiocafe/docs/audio_config.md)
*   [Audio Manifest](addons/audiocafe/docs/audio_manifest.md)
*   [Editor Plugin](addons/audiocafe/docs/editor_plugin.md)
*   [Generate Audio Manifest](addons/audiocafe/docs/generate_audio_manifest.md)

## Why Use AudioCafe?

*   **Time Saving**: Automate repetitive audio setup tasks.
*   **Impeccable Organization**: Keep your audio resources organized and easily accessible.
*   **Flexibility**: Support for various `AudioStream` types to meet diverse audio needs.
*   **Seamless Integration**: Works natively within the Godot Engine.
*   **Foundation for Robust Systems**: Build complex and dynamic audio systems with a solid manifest backbone.

With AudioCafe, you don't just manage audio; you accelerate the creation of immersive and dynamic sound experiences in your Godot games.
