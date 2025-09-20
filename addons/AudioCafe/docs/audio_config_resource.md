# Recurso `audio_config.tres`

O `audio_config.tres` é uma instância persistente do script `audio_config.gd`. Ele atua como o principal armazenamento para todas as configurações do plugin AudioCafe dentro do seu projeto Godot.

## Propósito

Este recurso centraliza as preferências e configurações definidas pelo usuário para o plugin, garantindo que elas sejam salvas entre as sessões do editor e persistam com o projeto.

## Interações

*   **`audio_config.gd`**: O `audio_config.tres` é uma instância deste script, herdando suas propriedades e lógica.
*   **`AudioPanel`**: O painel de interface do usuário do AudioCafe no editor do Godot lê e permite a edição das propriedades deste recurso. Quaisquer alterações feitas na UI são salvas diretamente neste `.tres`.
*   **`GenerateAudioManifest`**: O script responsável pela geração do manifesto de áudio lê as configurações de `assets_paths` e `dist_path` (caminhos de assets e de distribuição) a partir deste recurso para saber onde procurar arquivos de áudio e onde salvar os recursos gerados.

## Conteúdo

O `audio_config.tres` armazena informações cruciais como:

*   **`is_panel_expanded`**: Estado de expansão/colapso do painel do plugin na UI.
*   **`gen_playlist`**: Booleano que indica se o plugin deve gerar recursos `AudioStreamPlaylist`.
*   **`gen_randomizer`**: Booleano que indica se o plugin deve gerar recursos `AudioStreamRandomizer`.
*   **`gen_synchronized`**: Booleano que indica se o plugin deve gerar recursos `AudioStreamSynchronized`.
*   **`assets_paths`**: Um array de strings contendo os caminhos para os diretórios onde o plugin deve procurar por arquivos de áudio brutos (`.ogg`, `.wav`).
*   **`dist_path`**: Uma string que define o caminho do diretório onde os recursos de áudio gerados (`.tres`) e o `audio_manifest.tres` serão salvos.

## Edição

Este recurso pode ser editado diretamente através do `AudioPanel` no editor do Godot, proporcionando uma maneira intuitiva de configurar o comportamento do plugin.

```mermaid
graph TD
    AC_RES[audio_config.tres]:::resource
    AC_GD[audio_config.gd]:::script
    AP[AudioPanel]
    GAM[GenerateAudioManifest]

    AC_RES -- "Instância de" --> AC_GD
    AC_RES -- "Editável no editor" --> AP
    AC_RES -- "Lido por" --> GAM

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AC_RES fill:#f9f,stroke:#333,stroke-width:2px

    %% Descrição
    AC_RES -- "Instância persistente de AudioConfig, editável no editor, que armazena as configurações do plugin."
```