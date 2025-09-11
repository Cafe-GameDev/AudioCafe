## Projeto de Lei: Lei de Refatoração do AudioCafe para Integração Nativa de Áudio (Revisada e Aprimorada)

**Autor:** Gemini
**Solicitante:** Bruno / Cafe GameDev
**Data:** 11 de setembro de 2025
**Status:** Em Análise

### Preâmbulo

Considerando a constante evolução do Godot Engine e a introdução de recursos de áudio nativos mais robustos e eficientes a partir da versão 4.3;
Considerando a necessidade de otimizar o fluxo de trabalho no desenvolvimento de projetos, garantindo maior performance e aproveitamento das funcionalidades intrínsecas do motor;
Considerando a oportunidade de aprimorar o plugin AudioCafe, alinhando-o às melhores práticas e capacidades oferecidas pelo Godot;
Propõe-se a presente Lei para estabelecer as diretrizes de refatoração do plugin AudioCafe.

**Art. 1º** Fica estabelecida a refatoração do plugin AudioCafe para integrar e utilizar os recursos de áudio nativos do Godot Engine, em especial `AudioStreamPlaybackPlaylist`, `AudioStreamPlaybackInteractive` e `AudioStreamSynchronized`.

**Art. 2º** A presente refatoração visa aprimorar a gestão de ativos de áudio, substituindo o sistema de manifesto customizado por uma abordagem que capitalize nas funcionalidades avançadas do motor.

**Art. 3º** Para a consecução dos objetivos previstos nesta Lei, serão implementadas as seguintes diretrizes gerais:
    **I -** Unificação dos caminhos de assets de áudio em uma única configuração de `assets_paths` (Array de Strings), eliminando a distinção entre SFX e Música.
    **II -** Definição de uma única `dist_path` (String) onde todos os recursos de áudio gerados (`.tres`) serão salvos, mantendo a organização através de subpastas dinamicamente criadas com base na nomenclatura dos `assets_paths`.
    **III -** O processo de geração de recursos de áudio será focado **exclusivamente na criação de `AudioStreamPlaybackPlaylist`s nativas**. Mesmo que uma pasta contenha apenas um único arquivo de áudio, será gerada uma `AudioStreamPlaybackPlaylist` contendo esse arquivo.
    **IV -** As `AudioStreamPlaybackPlaylist`s geradas deverão ser atualizadas dinamicamente caso o conteúdo de suas pastas de origem seja alterado (adição/remoção de arquivos), sem a necessidade de recriar o recurso do zero.
    **V -** O `audio_config.gd` será atualizado para incluir as propriedades `assets_paths`, `dist_path`, e um dicionário `key_resource` que mapeará as chaves lógicas (derivadas dos `assets_paths`) para os caminhos dos recursos `.tres` gerados.
    **VI -** Adaptação da interface do usuário no editor para refletir as novas funcionalidades de gerenciamento e geração de playlists, bem como a criação de recursos derivados (`Interactive` e `Synchronized`).

**Art. 4º** As alterações específicas em arquivos de código e cena serão detalhadas em Projetos de Lei subsequentes, garantindo a rastreabilidade e a clareza de cada modificação.