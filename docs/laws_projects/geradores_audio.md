## Projeto de Lei: Lei de Criação e Refatoração de Geradores de Áudio

**Autor:** Gemini
**Solicitante:** Bruno / Cafe GameDev
**Data:** 11 de setembro de 2025
**Status:** Em Análise

### Preâmbulo

Considerando a aprovação do "Projeto de Lei: Lei de Refatoração do AudioCafe para Integração Nativa de Áudio", que estabelece a transição para o uso de recursos de áudio nativos do Godot Engine;
Considerando a necessidade de detalhar os componentes responsáveis pela criação e manipulação desses novos recursos de áudio;
Propõe-se a presente Lei para descrever os novos geradores de playlists, interativos e sincronizados, que serão fundamentais para a nova arquitetura do plugin AudioCafe.

**Art. 1º** Fica estabelecida a criação e/ou refatoração dos seguintes módulos geradores de recursos de áudio, que atuarão em conformidade com as diretrizes da Lei de Refatoração do AudioCafe:

    **I - Gerador de Playlists (Refatoração de `generate_audio_manifest.gd`)**
        **a) Responsabilidade:** Este módulo será o principal responsável por escanear os `assets_paths` definidos no `audio_config.gd` e criar ou atualizar os recursos `AudioStreamPlaybackPlaylist` nativos do Godot.
        **b) Funcionamento:**
            1.  Para cada pasta encontrada nos `assets_paths` que contenha arquivos de áudio (`.ogg`, `.wav`), será gerado ou atualizado um arquivo `.tres` do tipo `AudioStreamPlaybackPlaylist` na `dist_path`.
            2.  O nome do arquivo `.tres` será derivado do nome da pasta de origem (ex: `pasta_exemplo_playlist.tres`).
            3.  Todos os arquivos de áudio dentro da pasta (e suas subpastas, se aplicável) serão adicionados à propriedade `playlist` do recurso `AudioStreamPlaybackPlaylist`.
            4.  Em caso de atualização (pasta já possui um `.tres` correspondente), o script carregará o recurso existente, comparará e atualizará sua lista de áudio, e o salvará novamente, garantindo a persistência de outras propriedades que possam ter sido configuradas manualmente.
            5.  O `audio_config.gd` será atualizado com o mapeamento da chave lógica (derivada do nome da pasta) para o caminho do recurso `AudioStreamPlaybackPlaylist` gerado.
        **c) Localização:** `addons/AudioCafe/scripts/generate_audio_manifest.gd` (refatorado).

    **II - Gerador de Interativos (Novo Script)**
        **a) Responsabilidade:** Este módulo será responsável por criar recursos `AudioStreamPlaybackInteractive` a partir de uma ou múltiplas `AudioStreamPlaybackPlaylist`s existentes.
        **b) Funcionamento:**
            1.  Receberá como entrada uma lista de caminhos para recursos `AudioStreamPlaybackPlaylist` previamente gerados.
            2.  Criará um novo recurso `AudioStreamPlaybackInteractive` (`.tres`) na `dist_path` ou em uma subpasta específica para interativos.
            3.  Configurará o `AudioStreamPlaybackInteractive` para referenciar as playlists fornecidas, permitindo transições e lógicas de reprodução complexas.
            4.  Poderá expor parâmetros adicionais na UI para configurar fades, transições e outras propriedades específicas do `AudioStreamPlaybackInteractive`.
            5.  Não excluirá as playlists originais.
        **c) Localização:** `addons/AudioCafe/scripts/generate_interactive.gd` (novo).

    **III - Gerador de Sincronizados (Novo Script)**
        **a) Responsabilidade:** Este módulo será responsável por criar recursos `AudioStreamSynchronized` a partir de uma `AudioStreamPlaybackPlaylist` existente.
        **b) Funcionamento:**
            1.  Receberá como entrada o caminho para um recurso `AudioStreamPlaybackPlaylist` previamente gerado.
            2.  Criará um novo recurso `AudioStreamSynchronized` (`.tres`) na `dist_path` ou em uma subpasta específica para sincronizados.
            3.  Configurará o `AudioStreamSynchronized` para referenciar a playlist fornecida, permitindo a sincronização precisa com outros `AudioStreamSynchronized`s.
            4.  Não excluirá a playlist original.
        **c) Localização:** `addons/AudioCafe/scripts/generate_synchronized.gd` (novo).

**Art. 2º** As alterações específicas em arquivos de código e cena serão detalhadas em Projetos de Lei subsequentes, garantindo a rastreabilidade e a clareza de cada modificação.
