# Script `audio_manifest.gd`

O `audio_manifest.gd` é um script de recurso (`Resource`) que define a estrutura do manifesto de áudio centralizado do plugin AudioCafe. Ele serve como um contêiner para as referências de todos os recursos de áudio gerados ou coletados pelo plugin.

## Propósito

Este script fornece a estrutura de dados para o `audio_manifest.tres`, que é o catálogo principal para acessar os recursos de áudio em tempo de execução. Ele organiza os diferentes tipos de `AudioStream` (playlists, randomizers, synchronized, interactive) em dicionários, permitindo um acesso fácil e programático.

## Extends

`Resource`

## Propriedades Exportadas (`@export`)

As seguintes variáveis são exportadas, tornando-as persistentes no `audio_manifest.tres` e acessíveis em tempo de execução:

*   **`playlists: Dictionary`**: Um dicionário onde as chaves são identificadores de áudio (geralmente baseados nos nomes dos diretórios ou arquivos) e os valores são arrays contendo:
    1.  O caminho (`String`) para o recurso `AudioStreamPlaylist.tres`.
    2.  A contagem (`String`) de streams dentro da playlist.
    3.  O UID (`int`) do recurso `AudioStreamPlaylist.tres`.

*   **`randomizer: Dictionary`**: Um dicionário similar a `playlists`, mas para recursos `AudioStreamRandomizer.tres`.
    1.  O caminho (`String`) para o recurso `AudioStreamRandomizer.tres`.
    2.  A contagem (`String`) de streams dentro do randomizer.
    3.  O UID (`int`) do recurso `AudioStreamRandomizer.tres`.

*   **`synchronized: Dictionary`**: Um dicionário similar a `playlists`, mas para recursos `AudioStreamSynchronized.tres`.
    1.  O caminho (`String`) para o recurso `AudioStreamSynchronized.tres`.
    2.  A contagem (`String`) de streams dentro do synchronized.
    3.  O UID (`int`) do recurso `AudioStreamSynchronized.tres`.

*   **`interactive: Dictionary`**: Um dicionário onde as chaves são identificadores de áudio e os valores são os caminhos (`String`) para recursos `AudioStreamInteractive.tres` criados manualmente pelo usuário e coletados pelo plugin.

## Interações

*   **`audio_manifest.tres`**: É a instância persistente deste script, que é atualizada pelo `GenerateAudioManifest`.
*   **`GenerateAudioManifest`**: Este script preenche os dicionários de `audio_manifest.gd` com as referências aos recursos de áudio gerados ou coletados.
*   **Código do Usuário (Runtime)**: O código do jogo acessa as propriedades deste script (através do `audio_manifest.tres`) para carregar e reproduzir os áudios.

```mermaid
graph TD
    AM_GD[audio_manifest.gd]:::script
    AM_RES[audio_manifest.tres]:::resource
    GAM[GenerateAudioManifest]

    AM_GD -- "Extends Resource" --> AM_RES
    AM_GD -- "@export vars: playlists, randomizer, synchronized, interactive" --> AM_RES
    GAM -- "Atualiza" --> AM_GD

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AM_GD fill:#f9f,stroke:#333,stroke-width:2px

    %% Descrição
    AM_GD -- "Recurso que armazena o mapeamento final das chaves de áudio para os recursos gerados (Playlists, Randomizers, Synchronized, Interactive)."
```