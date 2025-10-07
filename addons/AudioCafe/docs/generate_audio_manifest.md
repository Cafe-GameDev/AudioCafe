# Script `generate_audio_manifest.gd`

O `generate_audio_manifest.gd` é o coração do plugin AudioCafe, responsável por escanear os diretórios de assets, gerar os recursos de áudio (`.tres`) e atualizar o `audio_manifest.tres`. Ele estende `EditorScript`, o que permite que seja executado diretamente no editor do Godot.

## Propósito

Este script automatiza a criação de `AudioStreamPlaylist`, `AudioStreamRandomizer` e `AudioStreamSynchronized` a partir de arquivos de áudio brutos (`.ogg`, `.wav`). Ele também coleta referências a `AudioStreamInteractive` criados manualmente. O objetivo final é consolidar todas essas referências em um único `audio_manifest.tres`, que serve como um catálogo centralizado para o acesso de áudio em tempo de execução.

## Extends

`EditorScript`

## Sinais

*   **`progress_updated(current: int, total: int)`**: Emitido para indicar o progresso da varredura de arquivos, útil para exibir uma barra de progresso na UI.
*   **`generation_finished(success: bool, message: String)`**: Emitido ao final do processo de geração, informando se foi bem-sucedido e fornecendo uma mensagem de status.

## Propriedades Exportadas (`@export`)

*   **`audio_config: AudioConfig`**: Uma referência ao recurso `audio_config.tres`, que contém todas as configurações necessárias para a geração, como `assets_paths`, `dist_path` e as flags para gerar playlists, randomizers e synchronized streams.

## Constantes

*   **`MANIFEST_SAVE_FILE`**: O caminho para o arquivo `audio_manifest.tres` (`res://addons/audiocafe/resources/audio_manifest.tres`).

## Métodos Principais

*   **`_run()`**: Este é o método principal que orquestra todo o processo de geração. Ele é chamado pelo `AudioPanel` quando o usuário aciona a geração. O fluxo geral é:
    1.  Inicializa contadores de progresso.
    2.  Conta o total de arquivos de áudio a serem escaneados para o progresso.
    3.  Coleta todos os `AudioStream` brutos dos `assets_paths`, agrupando-os por uma chave final (gerada a partir do nome do diretório ou arquivo).
    4.  Garante que os diretórios de saída (`dist_path`) existam.
    5.  Chama `generate_playlist()`, `generate_randomizer()` e `generate_synchronized()` com base nas configurações do `audio_config`.
    6.  Coleta referências a `AudioStreamInteractive` existentes no `dist_path`.
    7.  Salva o `audio_manifest.tres` atualizado.
    8.  Emite o sinal `generation_finished`.

*   **`generate_playlist(audio_manifest: AudioManifest, collected_streams: Dictionary, playlist_dist_save_path: String, overall_success: bool, message: String) -> Array`**: Este método itera sobre os streams coletados e, para cada chave, cria ou atualiza um `AudioStreamPlaylist.tres` no `playlist_dist_save_path`. Ele adiciona todos os `AudioStream` brutos coletados à playlist e atualiza o `audio_manifest.playlists` com o caminho, contagem de streams e UID do recurso gerado.

*   **`generate_randomizer(audio_manifest: AudioManifest, collected_streams: Dictionary, randomizer_dist_save_path: String) -> Array`**: Similar a `generate_playlist`, mas cria ou atualiza `AudioStreamRandomizer.tres`. Ele adiciona os streams coletados ao randomizer, atribuindo um peso padrão de 1.0 a cada um, e atualiza `audio_manifest.randomizer`.

*   **`generate_synchronized(audio_manifest: AudioManifest, collected_streams: Dictionary, synchronized_dist_save_path: String) -> Array`**: Cria ou atualiza `AudioStreamSynchronized.tres`. Adiciona os streams coletados (limitado a `MAX_SYNCHRONIZED_STREAMS`) e atualiza `audio_manifest.synchronized`.

*   **`_count_files_in_directory(current_path: String)`**: Um método recursivo que percorre um diretório e seus subdiretórios para contar o número total de arquivos `.ogg` e `.wav`, usado para o cálculo do progresso.

*   **`_collect_streams_by_key(paths: Array[String], collected_streams: Dictionary) -> bool`**: Itera sobre os `assets_paths` configurados e chama `_scan_directory_for_streams` para cada um.

*   **`_scan_directory_for_streams(current_path: String, collected_streams: Dictionary, root_path: String) -> bool`**: Um método recursivo que escaneia um diretório em busca de arquivos `.ogg` e `.wav`. Para cada arquivo encontrado, ele carrega o `AudioStream` correspondente e o adiciona ao dicionário `collected_streams`, usando uma chave gerada a partir do caminho relativo do arquivo.

*   **`_scan_directory_for_resources(current_path: String, resource_class_name: String, collected_resources: Dictionary) -> bool`**: Um método recursivo genérico que escaneia um diretório em busca de recursos `.tres` de uma classe específica (usado para coletar `AudioStreamInteractive`).

## Fluxo de Interação

1.  **Configuração**: O `audio_config.tres` (editado via `AudioPanel`) fornece os caminhos de entrada e saída e as opções de geração.
2.  **Escaneamento**: O script percorre os `assets_paths` para encontrar todos os arquivos de áudio brutos.
3.  **Geração**: Com base nas opções do `audio_config`, ele cria instâncias de `AudioStreamPlaylist`, `AudioStreamRandomizer` e `AudioStreamSynchronized`, preenchendo-os com os `AudioStream` brutos.
4.  **Coleta de Interativos**: Ele também escaneia o `dist_path` para encontrar `AudioStreamInteractive` criados manualmente.
5.  **Atualização do Manifesto**: Todas as referências aos recursos gerados e coletados são salvas no `audio_manifest.tres`.
6.  **Notificação**: O `AudioPanel` é notificado sobre a conclusão da geração para atualizar sua UI.

```mermaid
graph TD
    GAM[generate_audio_manifest.gd]:::script
    AC_RES[audio_config.tres]:::resource
    AM_RES[audio_manifest.tres]:::resource
    GE[Godot Engine]
    GAR[Generated Audio Resources]

    GAM -- "Extends EditorScript" --> GE
    GAM -- "@export var: audio_config" --> AC_RES
    GAM -- "_run(): Orquestra a geração" --> AC_RES
    GAM -- "_run(): Escaneia diretórios" --> GE
    GAM -- "_run(): Gera/Atualiza" --> GAR
    GAM -- "_run(): Salva" --> AM_RES
    GAM -- "signal generation_finished" --> AP[AudioPanel]

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style GAM fill:#f9f,stroke:#333,stroke-width:2px

    %% Descrição
    GAM -- "Script principal para escanear diretórios, carregar AudioStreams, gerar os recursos de áudio (.tres) e atualizar o AudioManifest."
```