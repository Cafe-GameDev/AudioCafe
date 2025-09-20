# Diagrama Unificado do `AudioPanel`

Este diagrama ilustra a arquitetura e as interações do `AudioPanel`, a interface de usuário principal do plugin AudioCafe dentro do editor Godot.

## Visão Geral

O `AudioPanel` é o ponto de interação do usuário com o plugin. Ele permite configurar os caminhos de assets e distribuição, visualizar os recursos de áudio gerados e acionar o processo de geração do manifesto. Ele unifica a apresentação e o controle das configurações e do estado do sistema de áudio do projeto.

## Componentes Principais

### AudioPanel (UI do Editor)

*   **`audio_panel.tscn`**: A cena que define a estrutura visual do painel, incluindo botões, campos de texto, abas e rótulos.
*   **`audio_panel.gd`**: O script que controla a lógica da UI. Ele carrega e salva as configurações, exibe os dados do manifesto, aciona a lógica de geração e carrega os ícones SVG para a interface.

### Recursos

*   **`audio_config.tres`**: A instância persistente das configurações do plugin. O `AudioPanel` lê e escreve neste recurso.
*   **`audio_manifest.tres`**: A instância persistente do manifesto de áudio. O `AudioPanel` lê este recurso para exibir os áudios gerados.
*   **`Ícones SVG`**: Recursos visuais utilizados na interface do painel para melhorar a usabilidade e a estética.

### Lógica de Geração

*   **`generate_audio_manifest.gd`**: O script principal que contém a lógica para escanear diretórios, gerar os recursos de áudio (`.tres`) e atualizar o `audio_manifest.tres`. O `AudioPanel` aciona este script.

## Fluxo de Interação

1.  **Definição da Estrutura Visual**: O `audio_panel.tscn` estabelece o layout e os elementos visuais do painel.
2.  **Controle da UI**: O `audio_panel.gd` gerencia a interação do usuário com a UI, carregando e salvando as configurações no `audio_config.tres`.
3.  **Exibição do Manifesto**: O `audio_panel.gd` lê o `audio_manifest.tres` para apresentar ao usuário uma lista dos recursos de áudio gerados (playlists, randomizers, synchronized, interactive).
4.  **Acionamento da Geração**: Quando o usuário clica no botão de geração, o `audio_panel.gd` invoca o `generate_audio_manifest.gd` para iniciar o processo.
5.  **Fornecimento de Configurações**: O `audio_config.tres` alimenta o `audio_panel.gd` com os caminhos de assets e distribuição configurados.
6.  **Atualização do Manifesto**: O `generate_audio_manifest.gd` atualiza o `audio_manifest.tres` após a conclusão da geração.
7.  **Carregamento de Ícones**: O `audio_panel.gd` carrega os ícones SVG para uso na interface.

```mermaid
graph TD
    subgraph AudioPanel (UI do Editor)
        AP_TSCN[audio_panel.tscn]:::scene
        AP_GD[audio_panel.gd]:::script
    end

    subgraph Recursos
        AC_RES[audio_config.tres]:::resource
        AM_RES[audio_manifest.tres]:::resource
        ICONS[Ícones SVG]:::resource
    end

    subgraph Lógica de Geração
        GAM[generate_audio_manifest.gd]:::script
    end

    AP_TSCN -- "Define estrutura visual" --> AP_GD
    AP_GD -- "Controla UI, carrega/salva config" --> AC_RES
    AP_GD -- "Exibe dados do manifesto" --> AM_RES
    AP_GD -- "Aciona geração" --> GAM
    AP_GD -- "Carrega" --> ICONS

    AC_RES -- "Fornece configurações (assets_paths, dist_path)" --> AP_GD
    AM_RES -- "Fornece listas de áudio gerado" --> AP_GD
    GAM -- "Atualiza" --> AM_RES

    style AP_GD fill:#f9f,stroke:#333,stroke-width:2px
    style AP_TSCN fill:#EEFFDD,stroke:#66CC33,stroke-width:1px
    style AC_RES fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style AM_RES fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    style ICONS fill:#F0F0F0,stroke:#999999,stroke-width:0.5px
    style GAM fill:#f9f,stroke:#333,stroke-width:2px

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    classDef scene fill:#EEFFDD,stroke:#66CC33,stroke-width:1px
```