## Projeto de Lei: Lei de Refatoração do AudioCafe para Integração Nativa de Áudio (Revisada e Aprimorada)

**Autor:** Gemini
**Solicitante:** Bruno / Cafe GameDev
**Data:** 11 de setembro de 2025
**Status:** Em Análise

**Art. 1º** Fica estabelecida a refatoração do plugin AudioCafe com o objetivo primordial de integrar e utilizar os recursos de áudio nativos do Godot Engine, em especial `AudioStreamPlaybackPlaylist`, `AudioStreamPlaybackInteractive` e `AudioStreamSynchronized`, a partir da versão 4.3 do motor.

**Art. 2º** A presente Lei visa otimizar o fluxo de trabalho do usuário, aproveitando a performance e as funcionalidades avançadas dos recursos nativos do Godot, em substituição ao sistema de manifesto customizado atualmente empregado para a gestão de ativos de áudio.

**Art. 3º** Para a consecução dos objetivos previstos nesta Lei, serão implementadas as seguintes diretrizes gerais:
    **I -** Unificação dos caminhos de assets de áudio em uma única configuração de `assets_paths` (Array de Strings), eliminando a distinção entre SFX e Música.
    **II -** Definição de uma única `dist_path` (String) onde todos os recursos de áudio gerados (`.tres`) serão salvos, mantendo a organização através de subpastas dinamicamente criadas com base na nomenclatura dos `assets_paths`.
    **III -** O processo de geração de recursos de áudio será focado **exclusivamente na criação de `AudioStreamPlaybackPlaylist`s nativas**. Mesmo que uma pasta contenha apenas um único arquivo de áudio, será gerada uma `AudioStreamPlaybackPlaylist` contendo esse arquivo.
    **IV -** As `AudioStreamPlaybackPlaylist`s geradas deverão ser atualizadas dinamicamente caso o conteúdo de suas pastas de origem seja alterado (adição/remoção de arquivos), sem a necessidade de recriar o recurso do zero.
    **V -** O `audio_config.gd` será atualizado para incluir as propriedades `assets_paths`, `dist_path`, e um dicionário `key_resource` que mapeará as chaves lógicas (derivadas dos `assets_paths`) para os caminhos dos recursos `.tres` gerados.
    **VI -** Adaptação da interface do usuário no editor para refletir as novas funcionalidades de gerenciamento e geração de playlists, bem como a criação de recursos derivados (`Interactive` e `Synchronized`).

**Art. 4º** As alterações específicas em arquivos de código e cena serão detalhadas em Projetos de Lei subsequentes, garantindo a rastreabilidade e a clareza de cada modificação.
