# Future Components

This document outlines potential future components for the AudioCafe plugin, building upon the existing structure and functionality.

## Existing Components Overview

Currently, the `components` directory contains the following:

*   **AudioManager**: A `Node2D` script (`audio_manager.gd`) that likely serves as a central point for managing audio playback within a 2D context. It's added as an autoload singleton, making it globally accessible.
*   **AudioPosition2D**: An `AudioStreamPlayer2D` extension (`audio_position_2d.gd`) that includes a `ResourcePosition`. This suggests a component for playing 2D audio at a specific position, potentially with custom resource handling.
*   **AudioPosition3D**: Similar to `AudioPosition2D`, but extends `AudioStreamPlayer3D` (`audio_position_3d.gd`), indicating its use for 3D spatial audio with a `ResourcePosition`.
*   **ResourcePosition**: A custom `Resource` (`resource_position.gd`) that is used by `AudioPosition2D` and `AudioPosition3D`. This resource likely holds data related to the positioning or properties of audio streams.

## Potential Future Components

Based on the existing components, here are some ideas for future additions:

*   **AudioZone2D/3D**: Components that define an area (2D or 3D) where specific audio effects or ambient sounds are triggered when the player enters or exits. These could interact with the `AudioManager`.
*   **AudioTrigger**: A generic trigger node that can play a specific audio stream (from the `AudioManifest`) when an event occurs (e.g., collision, interaction).
*   **AudioMixerPreset**: A resource that allows defining and switching between different audio mixer bus configurations (e.g., "Quiet Mode", "Action Mode") at runtime.
*   **AudioSequencer**: A component for playing a sequence of audio streams with precise timing, useful for music or complex soundscapes.
*   **AudioParameterController**: A node that can dynamically control audio parameters (volume, pitch, bus effects) based on game state or player actions.
*   **AudioFeedback**: A component to provide visual feedback (e.g., UI animations, particle effects) in response to audio events.
