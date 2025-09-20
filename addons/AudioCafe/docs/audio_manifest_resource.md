# Recurso `audio_manifest.tres`

O `audio_manifest.tres` é uma instância persistente do script `audio_manifest.gd`. Ele serve como o catálogo centralizado de todos os recursos de áudio gerados ou coletados pelo plugin AudioCafe.

## Propósito

Este recurso é o ponto de acesso principal para o seu código em tempo de execução (runtime) para carregar e reproduzir os áudios gerenciados pelo AudioCafe. Ele mapeia chaves de áudio amigáveis para os caminhos e UIDs dos recursos `AudioStreamPlaylist`, `AudioStreamRandomizer`, `AudioStreamSynchronized` e `AudioStreamInteractive` gerados ou referenciados.

## Interações

*   **`audio_manifest.gd`**: O `audio_manifest.tres` é uma instância deste script, herdando suas propriedades de dicionário.
*   **`GenerateAudioManifest`**: O script `GenerateAudioManifest` é o responsável por criar e atualizar este recurso, preenchendo seus dicionários com as referências aos áudios gerados.
*   **`AudioPanel`**: O painel do editor lê este recurso para exibir ao usuário uma lista dos áudios que foram gerados e estão disponíveis.
*   **Usuário (Runtime)**: Durante a execução do jogo, o código do usuário acessa este manifesto para obter os recursos de áudio necessários para reprodução.

## Conteúdo

O `audio_manifest.tres` contém os seguintes dicionários, onde cada chave é um identificador único para o áudio e o valor é um array contendo o caminho do recurso `.tres`, a contagem de streams (se aplicável) e o UID do recurso:

*   **`playlists: Dictionary`**: Mapeia chaves para recursos `AudioStreamPlaylist.tres`.
    *   Exemplo de valor: `["res://dist/playlist/music_level1_playlist.tres", "3", 1234567890]`
*   **`randomizer: Dictionary`**: Mapeia chaves para recursos `AudioStreamRandomizer.tres`.
    *   Exemplo de valor: `["res://dist/randomizer/sfx_hit_randomizer.tres", "5", 9876543210]`
*   **`synchronized: Dictionary`**: Mapeia chaves para recursos `AudioStreamSynchronized.tres`.
    *   Exemplo de valor: `["res://dist/synchronized/ambience_forest_synchronized.tres", "2", 1122334455]`
*   **`interactive: Dictionary`**: Mapeia chaves para recursos `AudioStreamInteractive.tres` que foram criados manualmente e coletados pelo plugin.
    *   Exemplo de valor: `"res://dist/interactive/player_footsteps_interactive.tres"` (apenas o caminho, pois são recursos criados manualmente e não possuem contagem de streams gerenciada pelo plugin)

## Acesso em Tempo de Execução

Para acessar um recurso de áudio em seu código, você pode carregar o `audio_manifest.tres` e então usar as chaves para obter os caminhos dos recursos:

```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _ready():
    # Acessando uma playlist
    var music_path = audio_manifest.playlists["music_level1"][0]
    var music_stream = load(music_path)
    # ... usar music_stream com um AudioStreamPlayer

    # Acessando um randomizer
    var sfx_path = audio_manifest.randomizer["sfx_hit"][0]
    var sfx_stream = load(sfx_path)
    # ... usar sfx_stream com um AudioStreamPlayer

    # Acessando um interactive stream
    var interactive_path = audio_manifest.interactive["player_footsteps_interactive"]
    var interactive_stream = load(interactive_path)
    # ... usar interactive_stream com um AudioStreamPlayer
```

```mermaid
graph TD
    AM_RES[audio_manifest.tres]:::resource
    AM_GD[audio_manifest.gd]:::script
    GAM[GenerateAudioManifest]
    AP[AudioPanel]
    U[Usuário (Runtime)]

    AM_RES -- "Instância de" --> AM_GD
    AM_RES -- "Atualizado por" --> GAM
    AM_RES -- "Lido por" --> AP
    AM_RES -- "Acessado por" --> U

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AM_RES fill:#f9f,stroke:#333,stroke-width:2px

    %% Descrição
    AM_RES -- "Instância persistente de AudioManifest, atualizada pelo plugin, que mapeia chaves de áudio para recursos gerados."
```