# Fluxograma de Operação do AudioCafe

Este fluxograma detalha o fluxo de trabalho principal do plugin AudioCafe, desde a ativação até o uso dos recursos de áudio gerados.

```mermaid
flowchart TD
    A[Plugin Ativado] --> B[AudioPanel instanciado]
    B --> C[AudioConfig criado zerado]
    C --> D[Usuário configura no AudioPanel]
    D --> D1[Define assets_paths]
    D --> D2[Define dist_paths]
    
    D --> E[Usuário clica "Update Audio Manifest"]
    
    E --> F[GenerateAudioManifest roda]
    F --> F1[Escaneia assets_paths]
    F --> F2[Gera Playlists]
    F --> F3[Gera Randomizers]
    F --> F4[Gera Synchronized]
    F --> F5[Coleta Interactives já existentes]
    
    F --> G[Salva Resources no dist]
    G --> G1[Arquivos .tres criados (playlist, randomizer, synchronized)]
    G --> G2[Referências salvas no AudioManifest]
    
    G --> H[AudioManifest atualizado]
    H --> I[AudioPanel recebe referências]
    I --> J[Usuário vê lista de Playlists/Randomizers/Synchronized]
    
    J --> K[Usuário acessa via código]
    K --> K1[Direto: @onready var my_playlist = preload("res://dist/ui_click_playlist.tres")]
    K --> K2[Centralizado: AudioManifest.randomizer.ui_click]
    
    J --> L[Usuário cria Interactive manualmente]
    L --> M[Interactive usa resources já gerados]
```

## Descrição Detalhada do Fluxo

*   **A. Plugin Ativado**: O processo começa com a ativação do plugin AudioCafe no Godot Engine.

*   **B. AudioPanel Instanciado**: O `editor_plugin.gd` instancia o `AudioPanel` (a interface do usuário do plugin) no editor.

*   **C. AudioConfig Criado/Carregado**: O `AudioPanel` garante que uma instância de `audio_config.tres` exista. Se não existir, uma nova é criada com configurações padrão.

*   **D. Usuário Configura no AudioPanel**: O usuário interage com a interface do `AudioPanel` para definir as configurações do plugin.
    *   **D1. Define `assets_paths`**: O usuário especifica os diretórios onde os arquivos de áudio brutos (`.ogg`, `.wav`) estão localizados.
    *   **D2. Define `dist_paths`**: O usuário especifica o diretório onde os recursos de áudio gerados (`.tres`) e o `audio_manifest.tres` serão salvos.

*   **E. Usuário Clica "Update Audio Manifest"**: Após configurar os caminhos, o usuário aciona o processo de geração clicando no botão correspondente no `AudioPanel`.

*   **F. `GenerateAudioManifest` Roda**: O script `generate_audio_manifest.gd` é executado, iniciando a lógica de processamento.
    *   **F1. Escaneia `assets_paths`**: O script percorre os diretórios definidos em `assets_paths` em busca de arquivos de áudio.
    *   **F2. Gera Playlists**: Para cada grupo de áudios, gera um `AudioStreamPlaylist.tres` (se a opção estiver ativada).
    *   **F3. Gera Randomizers**: Para cada grupo de áudios, gera um `AudioStreamRandomizer.tres` (se a opção estiver ativada).
    *   **F4. Gera Synchronized**: Para cada grupo de áudios, gera um `AudioStreamSynchronized.tres` (se a opção estiver ativada).
    *   **F5. Coleta Interactives já existentes**: Escaneia o `dist_path` em busca de recursos `AudioStreamInteractive.tres` criados manualmente pelo usuário.

*   **G. Salva Resources no `dist_path`**: Os recursos de áudio gerados são salvos no diretório de distribuição.
    *   **G1. Arquivos `.tres` Criados**: Os arquivos `AudioStreamPlaylist.tres`, `AudioStreamRandomizer.tres` e `AudioStreamSynchronized.tres` são criados no disco.
    *   **G2. Referências Salvas no AudioManifest**: O `audio_manifest.tres` é atualizado com os caminhos e UIDs de todos os recursos gerados e coletados.

*   **H. AudioManifest Atualizado**: O `audio_manifest.tres` agora contém o catálogo completo dos áudios do projeto.

*   **I. AudioPanel Recebe Referências**: O `AudioPanel` é notificado sobre a conclusão da geração e recarrega o `audio_manifest.tres`.

*   **J. Usuário Vê Lista de Playlists/Randomizers/Synchronized**: O `AudioPanel` exibe uma lista atualizada dos recursos de áudio disponíveis, permitindo ao usuário verificar o resultado da geração.

*   **K. Usuário Acessa Via Código**: Em tempo de execução, o código do jogo pode acessar os recursos de áudio.
    *   **K1. Acesso Direto**: O usuário pode carregar um `.tres` diretamente usando `preload()` ou `load()` se souber o caminho exato.
    *   **K2. Acesso Centralizado**: A forma recomendada é acessar os recursos através do `audio_manifest.tres` (ex: `AudioManifest.randomizer.ui_click`), que fornece um ponto de acesso centralizado e organizado.

*   **L. Usuário Cria Interactive Manualmente**: O usuário pode criar recursos `AudioStreamInteractive.tres` manualmente no editor.

*   **M. Interactive Usa Resources Já Gerados**: Esses recursos interativos podem, por sua vez, referenciar outros recursos de áudio (playlists, randomizers) que foram gerados pelo AudioCafe.