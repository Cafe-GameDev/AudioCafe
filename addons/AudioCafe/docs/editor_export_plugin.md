# Script `editor_export_plugin.gd`

O `editor_export_plugin.gd` é um script que estende a funcionalidade `EditorExportPlugin` do Godot Engine. Ele é crucial para garantir que os recursos de áudio gerados pelo AudioCafe sejam corretamente incluídos nas builds exportadas do seu projeto.

## Propósito

Quando um jogo Godot é exportado, nem todos os recursos são automaticamente incluídos. Recursos gerados dinamicamente ou referenciados de forma específica podem ser omitidos se não forem explicitamente tratados. Este plugin de exportação garante que o `audio_manifest.tres` e todos os `.tres` de áudio referenciados por ele (playlists, randomizers, synchronized, interactive) sejam empacotados na build final, tornando-os disponíveis em tempo de execução.

## Extends

`EditorExportPlugin`

## Métodos Implementados

*   **`_export_begin(features, is_debug, path, flags)`**: Este método é chamado no início do processo de exportação. Ele pode ser usado para realizar configurações ou verificações antes que os arquivos sejam empacotados. Atualmente, não possui implementação específica no AudioCafe, mas é parte da interface `EditorExportPlugin`.
    *   `features`: Array de strings com os recursos de exportação ativos (ex: `"windows"`, `"debug"`).
    *   `is_debug`: Booleano indicando se a exportação é para uma build de depuração.
    *   `path`: O caminho completo para o arquivo de saída da exportação.
    *   `flags`: Flags de exportação adicionais.

*   **`_export_file(path, type, features)`**: Este método é chamado para cada arquivo que está sendo considerado para inclusão na exportação. É aqui que a lógica para incluir recursos específicos pode ser implementada. No contexto do AudioCafe, este método seria usado para garantir que o `audio_manifest.tres` e todos os `.tres` de áudio gerados sejam incluídos.
    *   `path`: O caminho do arquivo que está sendo processado.
    *   `type`: O tipo de recurso do arquivo (ex: `"PackedScene"`, `"Resource"`).
    *   `features`: Array de strings com os recursos de exportação ativos.

## Como Funciona no AudioCafe

Embora a implementação atual mostre apenas `pass` para os métodos, a intenção é que este plugin seja ativado para garantir a inclusão dos recursos de áudio. Em uma implementação completa, `_export_file` seria usado para:

1.  Identificar o `audio_manifest.tres`.
2.  Adicionar o `audio_manifest.tres` à lista de arquivos a serem exportados.
3.  Iterar sobre os dicionários dentro do `audio_manifest.tres` (playlists, randomizers, synchronized, interactive).
4.  Para cada recurso de áudio listado no manifesto, garantir que seu `.tres` correspondente seja também adicionado à exportação.

Isso evita que os áudios gerados funcionem perfeitamente no editor, mas falhem em builds exportadas devido à ausência dos arquivos `.tres`.

```mermaid
graph TD
    EEC[editor_export_plugin.gd]:::script
    GE[Godot Engine]

    EEC -- "Extends" --> GE
    EEC -- "_export_begin(features, is_debug, path, flags)" --> GE
    EEC -- "_export_file(path, type, features)" --> GE

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    style EEC fill:#f9f,stroke:#333,stroke-width:2px

    %% Descrição
    EEC -- "Plugin de exportação do editor. Garante que os recursos de áudio sejam incluídos na build final."
```