## Projeto de Lei: Lei de Refatoração da Interface do AudioPanel

**Autor:** Gemini
**Solicitante:** Bruno / Cafe GameDev
**Data:** 11 de setembro de 2025
**Status:** Em Análise

### Preâmbulo

Considerando a aprovação do "Projeto de Lei: Lei de Refatoração do AudioCafe para Integração Nativa de Áudio", que estabelece a transição para o uso de recursos de áudio nativos do Godot Engine;
Considerando a necessidade de uma interface de usuário intuitiva e funcional para gerenciar os novos recursos de áudio e o fluxo de trabalho do plugin;
Propõe-se a presente Lei para detalhar a refatoração da interface do `AudioPanel`, garantindo que todas as novas funcionalidades sejam acessíveis e que a experiência do usuário seja aprimorada.

**Art. 1º** Fica estabelecida a refatoração completa do nó `AudioPanel` (cena `audio_panel.tscn` e script `audio_panel.gd`), que passará a conter a seguinte estrutura e funcionalidades:

    **I - Estrutura Principal (Fora do `TabContainer`):**
        **a) Botão de Cabeçalho (`HeaderButton`):** Manterá a funcionalidade de expandir/colapsar o conteúdo do painel, exibindo o nome "AudioCafe".
        **b) Botão "Gerar Playlists":** Um novo botão será posicionado de forma proeminente (substituindo o antigo "Generate Audio Manifest"). Sua função será iniciar o processo de escaneamento dos `assets_paths` e a geração/atualização dos recursos `AudioStreamPlaybackPlaylist` na `dist_path`.
        **c) Botão "Docs":** Manterá a funcionalidade de abrir a documentação do projeto.
        **d) Barra de Progresso (`ManifestProgressBar`):** Será reativada e terá seu funcionamento garantido para exibir o progresso da geração das playlists, que é um processo potencialmente longo.
        **e) Rótulo de Status (`ManifestStatusLabel`):** Exibirá mensagens de status e feedback durante a geração.
        **f) Rótulo de Feedback de Salvamento (`SaveFeedbackLabel`):** Manterá a funcionalidade de feedback visual para salvamento de configurações.
        **g) Diálogos de Seleção de Pasta:**
            1.  **`AssetsFolderDialog`:** Um novo `FileDialog` configurado para permitir a seleção de **múltiplas pastas** (modo `file_mode = 2`, `access = 2`, com `multi_select = true`). Será utilizado para definir os `assets_paths`.
            2.  **`DistFolderDialog`:** Um novo `FileDialog` configurado para permitir a seleção de **uma única pasta** (modo `file_mode = 2`, `access = 2`, com `multi_select = false`). Será utilizado para definir a `dist_path`.

    **II - Estrutura do `TabContainer`:** O `TabContainer` será refatorado para conter as seguintes abas, em substituição às abas existentes:

        **a) Aba "Settings":**
            1.  **Seção "Assets Paths":** Conterá uma lista dinâmica de `LineEdit`s (com botões "..." para abrir o `AssetsFolderDialog` e "X" para remover) para que o usuário possa adicionar e gerenciar múltiplos caminhos de assets.
            2.  **Seção "Dist Path":** Conterá um `LineEdit` (com botão "..." para abrir o `DistFolderDialog`) para que o usuário possa definir o caminho único de destino para os recursos gerados.

        **b) Aba "Defaults":**
            1.  Manterá a estrutura e funcionalidade atuais para a configuração das chaves de áudio padrão (ex: `default_click_key`, `master_volume`, etc.), permitindo que qualquer programador as acesse via `AudioConfig`.

        **c) Aba "Playlists":**
            1.  **Lista de Playlists:** Exibirá uma lista dinâmica de todas as `AudioStreamPlaybackPlaylist`s geradas, com seus nomes lógicos (derivados dos nomes das pastas de assets).
            2.  **Botões de Geração de Derivados:** Para cada item na lista de playlists, serão adicionados dois botões:
                *   **Botão "Gerar Interactive":** Ao ser clicado, iniciará o processo de criação de um recurso `AudioStreamPlaybackInteractive` a partir da playlist selecionada.
                *   **Botão "Gerar Synchronized":** Ao ser clicado, iniciará o processo de criação de um recurso `AudioStreamSynchronized` a partir da playlist selecionada.

        **d) Aba "Syncs":**
            1.  **Lista de Recursos Sincronizados:** Exibirá uma lista dinâmica de todos os recursos `AudioStreamSynchronized` gerados.
            2.  **Botão "Remover":** Para cada item na lista, um botão para remover/apagar o recurso `AudioStreamSynchronized` correspondente.

        **e) Aba "Interactives":**
            1.  **Lista de Recursos Interativos:** Exibirá uma lista dinâmica de todos os recursos `AudioStreamPlaybackInteractive` gerados.
            2.  **Botão "Remover":** Para cada item na lista, um botão para remover/apagar o recurso `AudioStreamPlaybackInteractive` correspondente.
            3.  **Funcionalidade de Multi-seleção para Interactive:** Será implementado um mecanismo que permita ao usuário selecionar múltiplas playlists da aba "Playlists" para gerar um único `AudioStreamPlaybackInteractive`, conforme a funcionalidade de transição entre playlists.

**Art. 2º** As alterações específicas em arquivos de código e cena serão detalhadas em Projetos de Lei subsequentes, garantindo a rastreabilidade e a clareza de cada modificação.
