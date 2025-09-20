# Script `audio_config.gd`

O `audio_config.gd` é um script de recurso (`Resource`) que define a estrutura e o comportamento das configurações do plugin AudioCafe. Ele é a base para o recurso persistente `audio_config.tres`.

## Propósito

Este script encapsula todas as propriedades configuráveis do plugin, como caminhos de assets, caminhos de distribuição e flags de geração. Ele também gerencia o salvamento automático dessas configurações e a emissão de um sinal quando as configurações são alteradas, permitindo que a UI do editor reaja a essas mudanças.

## Extends

`Resource`

## Sinais

*   **`config_changed`**: Emitido sempre que uma das propriedades `@export` do recurso é alterada e salva. O `AudioPanel` escuta este sinal para atualizar sua interface ou exibir feedback de salvamento.

## Propriedades Exportadas (`@export`)

As seguintes variáveis são exportadas, tornando-as editáveis no inspetor do Godot e persistentes no `audio_config.tres`:

*   **`is_panel_expanded: bool`**: Controla se o painel do AudioCafe na UI do editor está expandido ou recolhido.
*   **`gen_playlist: bool`**: Se `true`, o plugin gerará recursos `AudioStreamPlaylist` para os áudios encontrados.
*   **`gen_randomizer: bool`**: Se `true`, o plugin gerará recursos `AudioStreamRandomizer` para os áudios encontrados.
*   **`gen_synchronized: bool`**: Se `true`, o plugin gerará recursos `AudioStreamSynchronized` para os áudios encontrados.
*   **`assets_paths: Array[String]`**: Um array de caminhos (ex: `res://assets/music/`, `res://assets/sfx/`) onde o plugin deve procurar por arquivos de áudio (`.ogg`, `.wav`).
*   **`dist_path: String`**: O caminho base (ex: `res://dist/audio/`) onde os recursos `.tres` gerados (playlists, randomizers, synchronized) e o `audio_manifest.tres` serão salvos.

## Métodos

*   **`get_playlist_save_path() -> String`**: Retorna o caminho completo para o diretório onde as playlists serão salvas, baseado em `dist_path`.
*   **`get_randomized_save_path() -> String`**: Retorna o caminho completo para o diretório onde os randomizers serão salvos, baseado em `dist_path`.
*   **`get_interactive_save_path() -> String`**: Retorna o caminho completo para o diretório onde os streams interativos serão coletados/referenciados, baseado em `dist_path`.
*   **`get_synchronized_save_path() -> String`**: Retorna o caminho completo para o diretório onde os streams sincronizados serão salvos, baseado em `dist_path`.
*   **`_save_and_emit_changed()`**: Um método interno que salva a instância do `AudioConfig` no disco (no `resource_path` definido, que é `audio_config.tres`) e emite o sinal `config_changed`. Este método é chamado automaticamente pelos `setters` das propriedades `@export`.

## Interações

*   **`audio_config.tres`**: É a instância persistente deste script.
*   **`AudioPanel`**: Carrega e exibe as propriedades definidas neste script, e reage ao sinal `config_changed`.
*   **`GenerateAudioManifest`**: Acessa as propriedades deste script para determinar os caminhos de entrada e saída e quais tipos de recursos de áudio devem ser gerados.

```mermaid
graph TD
    AC_GD[audio_config.gd]:::script
    AC_RES[audio_config.tres]:::resource
    AP[AudioPanel]

    AC_GD -- "Extends Resource" --> AC_RES
    AC_GD -- "@export vars: is_panel_expanded, gen_playlist, gen_randomizer, gen_synchronized, assets_paths, dist_path" --> AC_RES
    AC_GD -- "signal config_changed" --> AP
    AC_GD -- "_save_and_emit_changed(): Salva e emite sinal" --> AC_RES

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AC_GD fill:#f9f,stroke:#333,stroke-width:2px

    %% Descrição
    AC_GD -- "Recurso que armazena as configurações do plugin (caminhos de assets, caminho de distribuição, estado do painel). Emite sinal 'config_changed' ao ser salvo."
```