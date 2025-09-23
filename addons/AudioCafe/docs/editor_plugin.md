# Script `editor_plugin.gd`

O `editor_plugin.gd` é o script principal do plugin AudioCafe, estendendo a classe `EditorPlugin` do Godot Engine. Ele é o ponto de entrada para a funcionalidade do plugin no editor, responsável por sua inicialização, configuração da interface do usuário e gerenciamento do ciclo de vida.

## Propósito

Este script orquestra a integração do AudioCafe no ambiente do editor Godot. Ele cria e gerencia o painel de interface do usuário do plugin, garante que o recurso de configuração (`audio_config.tres`) seja carregado ou criado, e lida com a limpeza de recursos quando o plugin é desativado.

## Extends

`EditorPlugin`

## Propriedades Chave

*   **`GROUP_SCENE_PATH`**: Uma constante que armazena o caminho para a cena do painel do AudioCafe (`res://addons/AudioCafe/panel/audio_panel.tscn`).
*   **`INSPECTOR_PLUGIN_PATH`**: Uma constante que armazena o caminho para o script do plugin do inspetor (`res://addons/AudioCafe/scripts/inspector_plugin.gd`).
*   **`plugin_panel: ScrollContainer`**: A referência ao contêiner principal do painel do plugin, que é adicionado à dock do editor.
*   **`group_panel: VBoxContainer`**: A referência ao painel específico do AudioCafe (instância de `audio_panel.tscn`) que é adicionado ao `plugin_panel`.
*   **`inspector_plugin_instance: EditorInspectorPlugin`**: A instância do `InspectorPlugin` que é adicionada e removida do editor.

## Métodos

*   **`_enter_tree()`**: Este método é chamado quando o plugin é ativado. Ele invoca `_create_plugin_panel()` para configurar a interface do usuário do plugin, instancia o `InspectorPlugin` e o adiciona ao editor.

*   **`_exit_tree()`**: Este método é chamado quando o plugin é desativado. Ele é responsável por liberar os recursos alocados, como o `group_panel` e o `plugin_panel`, para evitar vazamentos de memória e garantir uma desativação limpa.

*   **`_create_plugin_panel()`**: Um método interno que verifica se o painel principal do plugin (`CafeEngine`) já existe. Se não existir, ele cria um novo `ScrollContainer` com o nome "CafeEngine", configura suas propriedades de layout e o adiciona a uma dock do editor. Em seguida, chama `_ensure_group("AudioCafe")` para adicionar o painel específico do AudioCafe.

*   **`_ensure_group(group_name: String) -> VBoxContainer`**: Este método é responsável por carregar ou criar a cena `audio_panel.tscn` e adicioná-la ao `plugin_panel`. Ele também garante que o `audio_config.tres` seja carregado. Se o `audio_config.tres` não existir, ele é criado a partir de `audio_config.gd` e salvo no disco. Finalmente, ele define a instância do `AudioConfig` no `group_panel`.

## Fluxo de Operação

1.  **Ativação do Plugin**: Quando o usuário ativa o AudioCafe no gerenciador de plugins do Godot, o método `_enter_tree()` é chamado.
2.  **Criação do Painel Principal**: `_create_plugin_panel()` verifica a existência de um painel "CafeEngine". Se não houver, ele cria um `ScrollContainer` e o adiciona a uma dock do editor (por padrão, à direita superior).
3.  **Criação/Carregamento do Painel do AudioCafe**: `_ensure_group("AudioCafe")` é chamado. Ele carrega `audio_panel.tscn`, o instancia e o adiciona ao `ScrollContainer` principal.
4.  **Gerenciamento do `AudioConfig`**: Dentro de `_ensure_group`, o `audio_config.tres` é carregado. Se não for encontrado, uma nova instância de `audio_config.gd` é criada e salva como `audio_config.tres`. Esta instância é então passada para o `audio_panel.gd` através do método `set_audio_config()`.
5.  **Desativação do Plugin**: Quando o plugin é desativado, `_exit_tree()` é chamado para liberar os nós da cena e outros recursos, garantindo que o editor retorne ao seu estado original.

```mermaid
graph TD
    EP[editor_plugin.gd]:::script
    GE[Godot Engine]
    AP_TSCN[audio_panel.tscn]:::scene
    AC_RES[audio_config.tres]:::resource

    EP -- "Extends EditorPlugin" --> GE
    EP -- "_enter_tree(): Cria painel do plugin" --> AP_TSCN
    EP -- "_ensure_group(): Carrega/Cria" --> AC_RES
    EP -- "_exit_tree(): Libera recursos" --> GE

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef scene fill:#EEFFDD,stroke:#66CC33,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style EP fill:#f9f,stroke:#333,stroke-width:2px

    %% Descrição
    EP -- "Plugin principal do editor. Instancia a UI do painel e gerencia o ciclo de vida do plugin."
```