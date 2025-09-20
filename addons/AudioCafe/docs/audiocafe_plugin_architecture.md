# Arquitetura do Plugin AudioCafe

Este documento detalha a arquitetura do plugin AudioCafe, descrevendo seus componentes principais e como eles interagem para fornecer um fluxo de trabalho otimizado para gerenciamento de áudio no Godot Engine.

## Visão Geral

O AudioCafe é projetado como um conjunto modular de scripts e recursos que se integram perfeitamente ao editor do Godot. Ele automatiza a criação de recursos de áudio (`AudioStreamPlaylist`, `AudioStreamRandomizer`, `AudioStreamSynchronized`) a partir de arquivos de áudio brutos e os organiza em um `AudioManifest` centralizado para fácil acesso em tempo de execução.

## Componentes da Arquitetura

### 1. Interação do Usuário (`User Interaction`)

Representa o usuário final interagindo com o plugin através da interface do editor.

### 2. Núcleo do Plugin do Editor (`Editor Plugin Core`)

*   **`editor_plugin.gd`**: O script principal do plugin. Ele estende `EditorPlugin` e é responsável por inicializar a UI do painel do AudioCafe, gerenciar seu ciclo de vida (entrada e saída da árvore do editor) e garantir que o `audio_config.tres` seja carregado ou criado.
*   **`editor_export_plugin.gd`**: Um plugin de exportação que estende `EditorExportPlugin`. Sua função é garantir que todos os recursos de áudio gerados pelo AudioCafe sejam incluídos corretamente nas builds exportadas do seu jogo, evitando problemas de recursos ausentes.

### 3. UI do Editor (`Editor UI`)

*   **`audio_panel.tscn`**: A cena que define a estrutura visual do painel do AudioCafe no editor. Contém todos os elementos da interface, como botões, campos de entrada e rótulos.
*   **`audio_panel.gd`**: O script associado ao `audio_panel.tscn`. Ele controla a lógica da interface do usuário, como carregar/salvar configurações, exibir o status da geração, mostrar os áudios gerados e acionar o processo de geração do manifesto.

### 4. Recursos de Configuração e Manifesto (`Configuration & Manifest Resources`)

*   **`audio_config.gd`**: Um script `Resource` que define a estrutura das configurações do plugin. Contém propriedades como `assets_paths`, `dist_path`, e flags para geração de diferentes tipos de `AudioStream`.
*   **`audio_config.tres`**: A instância persistente do `audio_config.gd`. Armazena as configurações do usuário e é editável diretamente no editor.
*   **`audio_manifest.gd`**: Um script `Resource` que define a estrutura do manifesto de áudio. Contém dicionários para armazenar referências a `AudioStreamPlaylist`, `AudioStreamRandomizer`, `AudioStreamSynchronized` e `AudioStreamInteractive`.
*   **`audio_manifest.tres`**: A instância persistente do `audio_manifest.gd`. É o catálogo centralizado de todos os recursos de áudio gerados ou coletados, usado para acesso em tempo de execução.

### 5. Lógica de Geração de Áudio (`Audio Generation Logic`)

*   **`generate_audio_manifest.gd`**: O script principal responsável por orquestrar o processo de geração. Ele escaneia os diretórios de assets, carrega os `AudioStream` brutos, cria os recursos `.tres` (playlists, randomizers, synchronized) e atualiza o `audio_manifest.tres` com as referências.

### 6. Recursos de Áudio Gerados (`Generated Audio Resources (dist/)`)

Estes são os arquivos `.tres` que o plugin cria no diretório de distribuição (`dist_path`) configurado pelo usuário:

*   **`AudioStreamPlaylist.tres`**: Recursos que contêm listas ordenadas de `AudioStream` para reprodução sequencial.
*   **`AudioStreamRandomizer.tres`**: Recursos que contêm coleções de `AudioStream` para reprodução aleatória.
*   **`AudioStreamSynchronized.tres`**: Recursos que permitem a reprodução sincronizada de múltiplos `AudioStream`.
*   **`AudioStreamInteractive.tres`**: Recursos `AudioStreamInteractive` existentes que são criados manualmente pelo usuário e cujas referências são coletadas pelo plugin para inclusão no manifesto.

### 7. Godot Engine (`Core Godot Engine`)

O ambiente principal onde o plugin opera e interage com as funcionalidades nativas do motor, como acesso a diretórios (`DirAccess`), carregamento/salvamento de recursos (`ResourceLoader`, `ResourceSaver`) e gerenciamento de plugins (`EditorPlugin`).

## Fluxo de Operação

### Inicialização e Configuração

1.  O usuário ativa o plugin no Godot Engine.
2.  `editor_plugin.gd` é carregado e instancia a UI do `audio_panel.tscn`.
3.  `audio_panel.gd` carrega ou cria `audio_config.tres`.
4.  O usuário configura `assets_paths` e `dist_path` no `AudioPanel`.
5.  As configurações são salvas em `audio_config.tres`.

### Geração do Manifesto

1.  O usuário clica em "Generate Playlists" no `AudioPanel`.
2.  `audio_panel.gd` aciona `generate_audio_manifest.gd`.
3.  `generate_audio_manifest.gd` lê `audio_config.tres` para obter os caminhos.
4.  Ele escaneia os `assets_paths` em busca de arquivos de áudio (`.ogg`, `.wav`).
5.  Gera `AudioStreamPlaylist.tres`, `AudioStreamRandomizer.tres` e `AudioStreamSynchronized.tres` no `dist_path`.
6.  Coleta referências a `AudioStreamInteractive.tres` existentes no `dist_path`.
7.  Atualiza `audio_manifest.tres` com os caminhos e UIDs de todos os recursos gerados/coletados.
8.  `AudioPanel` é notificado, lê o `audio_manifest.tres` atualizado e exibe os áudios disponíveis.

### Uso em Tempo de Execução

1.  O código do jogo carrega `audio_manifest.tres`.
2.  Acessa os recursos de áudio desejados (ex: `audio_manifest.playlists["ui_click"]`) para obter o caminho do `.tres`.
3.  Carrega o `.tres` e o utiliza com um `AudioStreamPlayer`.

```mermaid
graph TD
    subgraph User Interaction
        U[Usuário]
    end

    subgraph Editor Plugin Core
        EP[editor_plugin.gd]:::script
        EP_UID[editor_plugin.gd.uid]:::uid
        EEC[EditorExportPlugin]:::script
        EEC_UID[editor_export_plugin.gd.uid]:::uid
    end

    subgraph Editor UI
        AP_TSCN[audio_panel.tscn]:::scene
        AP[audio_panel.gd]:::script
        AP_UID[audio_panel.gd.uid]:::uid
    end

    subgraph Configuration & Manifest Resources
        AC[audio_config.gd]:::script
        AC_UID[audio_config.gd.uid]:::uid
        AM[audio_manifest.gd]:::script
        AM_UID[audio_manifest.gd.uid]:::uid
        AC_RES[audio_config.tres]:::resource
        AM_RES[audio_manifest.tres]:::resource
    end

    subgraph Audio Generation Logic
        GAM[generate_audio_manifest.gd]:::script
        GAM_UID[generate_audio_manifest.gd.uid]:::uid
    end

    subgraph Generated Audio Resources (dist/)
        GAR_PL[AudioStreamPlaylist.tres]:::resource
        GAR_R[AudioStreamRandomizer.tres]:::resource
        GAR_S[AudioStreamSynchronized.tres]:::resource
        GAR_I[AudioStreamInteractive.tres]:::resource
    end

    subgraph Core Godot Engine
        GE[Godot Engine]
    end

    style EP fill:#f9f,stroke:#333,stroke-width:2px
    style EEC fill:#f9f,stroke:#333,stroke-width:2px
    style AP fill:#f9f,stroke:#333,stroke-width:2px
    style AC fill:#f9f,stroke:#333,stroke-width:2px
    style AM fill:#f9f,stroke:#333,stroke-width:2px
    style GAM fill:#f9f,stroke:#333,stroke-width:2px

    classDef script fill:#DDEEFF,stroke:#3366CC,stroke-width:1px
    classDef resource fill:#FFF0DD,stroke:#CC9933,stroke-width:1px
    classDef scene fill:#EEFFDD,stroke:#66CC33,stroke-width:1px
    classDef uid fill:#F0F0F0,stroke:#999999,stroke-width:0.5px

    %% Descrições dos Componentes
    EP -- "Plugin principal do editor. Instancia a UI do painel e gerencia o ciclo de vida do plugin."
    EEC -- "Plugin de exportação do editor. Garante que os recursos de áudio sejam incluídos na build final."
    AP_TSCN -- "Define a estrutura visual do painel do editor."
    AP -- "Controla a lógica da UI do painel. Carrega/salva configurações, exibe status e aciona a geração do manifesto."
    AC -- "Recurso que armazena as configurações do plugin (caminhos de assets, caminho de distribuição, estado do painel). Emite sinal 'config_changed' ao ser salvo."
    AM -- "Recurso que armazena o mapeamento final das chaves de áudio para os recursos gerados (Playlists, Randomizers, Synchronized, Interactive)."
    GAM -- "Script principal para escanear diretórios, carregar AudioStreams, gerar os recursos de áudio (.tres) e atualizar o AudioManifest."
    AC_RES -- "Instância persistente de AudioConfig, editável no editor."
    AM_RES -- "Instância persistente de AudioManifest, atualizada pelo plugin."
    GAR_PL -- "Recursos gerados dinamicamente que contêm listas de AudioStream para reprodução sequencial."
    GAR_R -- "Recursos gerados dinamicamente que contêm AudioStream para reprodução aleatória."
    GAR_S -- "Recursos gerados dinamicamente que contêm AudioStream para reprodução sincronizada."
    GAR_I -- "Recursos AudioStreamInteractive existentes, coletados e referenciados pelo manifesto."

    %% Fluxo de Inicialização e Configuração
    U -- "Ativa o plugin" --> GE
    GE --> EP: Carrega plugin.cfg
    EP --> AP_TSCN: Instancia cena do painel
    AP_TSCN --> AP: Carrega script do painel
    AP --> AC_RES: Carrega/Cria AudioConfig.tres
    AC_RES --> AP: Fornece configurações
    AP --> U: Exibe UI do painel

    U -- "Configura caminhos de assets e dist" --> AP
    AP --> AC_RES: Salva configurações (assets_paths, dist_path)
    AC_RES -- "Emite 'config_changed'" --> AP: Atualiza feedback de salvamento

    %% Fluxo de Geração do Manifesto
    U -- "Clica 'Generate Playlists'" --> AP
    AP --> GAM: Aciona _run() com audio_config
    GAM --> AC_RES: Lê assets_paths e dist_path
    GAM --> GE: Escaneia diretórios (DirAccess.open, DirAccess.list_dir_begin)
    GE --> GAM: Retorna arquivos de áudio (.ogg, .wav)

    GAM --> GAR_PL: Gera/Atualiza AudioStreamPlaylist.tres
    GAM --> GAR_R: Gera/Atualiza AudioStreamRandomizer.tres (se aplicável)
    GAM --> GAR_S: Gera/Atualiza AudioStreamSynchronized.tres (se aplicável)
    GAM --> GAR_I: Coleta referências de AudioStreamInteractive existentes
    GAM --> AM_RES: Atualiza AudioManifest.tres com caminhos e UIDs dos recursos gerados
    GAM -- "Emite 'generation_finished'" --> AP: Notifica sobre o resultado da geração

    AP --> AM_RES: Lê AudioManifest.tres atualizado
    AM_RES --> AP: Fornece listas de playlists/randomizers/synchronized
    AP --> U: Exibe listas atualizadas no painel

    %% Fluxo de Uso em Tempo de Execução
    U -- "Acessa áudio via código" --> AM_RES: Ex: AudioManifest.playlists.ui_click
    AM_RES --> GE: Fornece caminho/UID do recurso
    GE --> GAR_PL: Carrega AudioStreamPlaylist.tres
    GAR_PL --> U: Áudio disponível para reprodução

    U -- "Cria AudioStreamInteractive manualmente" --> GE: Cria .tres no editor
    GE --> GAR_I: Salva AudioStreamInteractive.tres
    GAM -- "Coleta Interactive existente" --> GAR_I: GAM inclui GAR_I na próxima geração
    GAR_I --> AM_RES: Referenciado no AudioManifest

    %% Outras Interações
    U -- "Clica 'Docs'" --> AP
    AP --> GE: Abre URL da documentação (OS.shell_open)

    %% UIDs
    EP_UID -- "Identificador único para editor_plugin.gd"
    EEC_UID -- "Identificador único para editor_export_plugin.gd"
    AP_UID -- "Identificador único para audio_panel.gd"
    AC_UID -- "Identificador único para audio_config.gd"
    AM_UID -- "Identificador único para audio_manifest.gd"
    GAM_UID -- "Identificador único para generate_audio_manifest.gd"
```