# 🎵 AudioCafe

[![Godot Asset Library](https://img.shields.io/badge/Godot_Asset_Library-AudioCafe-478cbf?style=for-the-badge&logo=godot-engine)](https://godotengine.org/asset-library/asset/link-to-asset) <!-- Placeholder -->
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**AudioCafe** é um sistema de gerenciamento de áudio robusto para Godot 4, parte da suíte **CafeEngine**. Ele transforma pastas de arquivos de som em `AudioStreamPlaylist`s, `AudioStreamRandomizer`s e outros `Resource`s de áudio dinâmicos, prontos para uso e exportação.

## Filosofia

Seguindo a filosofia da CafeEngine, o AudioCafe é orientado a `Resources`. Isso significa que a lógica de áudio é encapsulada, reutilizável e gerenciada diretamente pelo Inspector do Godot, proporcionando um fluxo de trabalho nativo e intuitivo.

## Funcionalidades

- **Geração Automática:** Cria `AudioStreamPlaylist`, `AudioStreamRandomizer`, e `AudioStreamSynchronized` a partir de suas pastas de assets.
- **Manifesto de Áudio:** Gera um `AudioManifest.tres` que cataloga todos os seus recursos de áudio, garantindo que eles sejam exportados corretamente e facilmente acessíveis em tempo de execução.
- **Componentes de Posição:** Nós `AudioPosition2D` e `AudioPosition3D` para fácil posicionamento de som no jogo.

## Instalação

1. Instale a suíte **CafeEngine** a partir da Godot Asset Library ou do GitHub.
2. Ative o plugin **AudioCafe** nas configurações do projeto (`Project -> Project Settings -> Plugins`).
