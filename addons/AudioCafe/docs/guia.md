# Guia Completo do AudioCafe

Bem-vindo ao guia completo do AudioCafe, um plugin para Godot Engine projetado para otimizar e acelerar o fluxo de trabalho de gerenciamento de áudio em seus projetos. Este guia cobrirá desde a instalação até o uso avançado dos recursos de áudio gerados.

## 1. Visão Geral do AudioCafe

O AudioCafe automatiza a criação de recursos `AudioStreamPlaylist`, `AudioStreamRandomizer` e `AudioStreamSynchronized` a partir de seus arquivos de áudio brutos (`.ogg`, `.wav`). Ele organiza esses recursos em um `AudioManifest` centralizado, que serve como um catálogo para fácil acesso em tempo de execução. O plugin também coleta referências a `AudioStreamInteractive` criados manualmente.

## 2. Instalação

1.  **Baixe o Plugin**: Obtenha a versão mais recente do AudioCafe no repositório oficial ou no Godot Asset Library.
2.  **Copie para o Projeto**: Descompacte o conteúdo do plugin na pasta `addons/` do seu projeto Godot. A estrutura deve ser `res://addons/AudioCafe/`.
3.  **Ative o Plugin**: No Godot Editor, vá em `Projeto -> Configurações do Projeto -> Plugins`. Encontre "AudioCafe" na lista e certifique-se de que seu status esteja como "Ativo".

Após a ativação, um novo painel chamado "AudioCafe" aparecerá em uma das docks do editor (geralmente à direita).

## 3. Configuração Inicial no AudioPanel

O `AudioPanel` é a interface principal do AudioCafe. Para acessá-lo, clique na aba "AudioCafe" na dock do editor.

### 3.1. Seções do Painel

O painel é dividido em abas:

*   **Settings (Configurações)**: Onde você define os caminhos de assets e distribuição.
*   **Playlists**: Exibe as playlists geradas.
*   **Interactive**: Exibe os streams interativos coletados.

### 3.2. Configurando Caminhos

Na aba "Settings", você encontrará duas seções cruciais:

*   **Assets Paths (Caminhos dos Assets)**:
    *   Clique em "Add Asset Path" para adicionar um novo campo.
    *   Clique no botão "..." ao lado do campo para abrir um seletor de diretório.
    *   Selecione as pastas do seu projeto onde você armazena seus arquivos de áudio brutos (`.ogg`, `.wav`). Você pode adicionar múltiplos caminhos.
    *   **Exemplo**: `res://assets/music`, `res://assets/sfx/ui`, `res://assets/sfx/combat`.

*   **Dist / Playlists Path (Caminho de Distribuição)**:
    *   Clique em "Add Dist Path" para adicionar um campo (apenas um caminho de distribuição é permitido).
    *   Clique no botão "..." para selecionar a pasta onde o AudioCafe salvará os recursos `.tres` gerados (playlists, randomizers, synchronized) e o `audio_manifest.tres`.
    *   **Recomendado**: Crie uma pasta dedicada, como `res://dist/audio` ou `res://generated/audio`.

### 3.3. Opções de Geração

No `AudioPanel`, você também pode ter opções para habilitar/desabilitar a geração de diferentes tipos de recursos (Playlist, Randomizer, Synchronized). Certifique-se de que as opções desejadas estejam marcadas.

### 3.4. Salvando Configurações

As configurações são salvas automaticamente no `audio_config.tres` sempre que você as altera no painel. Um feedback visual "Saved!" aparecerá brevemente.

## 4. Gerando o Manifesto de Áudio

Após configurar os caminhos, você pode gerar o manifesto:

1.  Clique no botão **"Generate Playlists"** (ou similar, dependendo da versão) no `AudioPanel`.
2.  O plugin escaneará os `Assets Paths` configurados, processará os arquivos de áudio e criará os recursos `.tres` no `Dist Path`.
3.  O `audio_manifest.tres` será atualizado com as referências a todos os recursos gerados e coletados.
4.  Uma mensagem de status aparecerá no painel, indicando o sucesso ou falha da geração.
5.  As abas "Playlists" e "Interactive" serão atualizadas para exibir os recursos disponíveis.

## 5. Usando os Recursos de Áudio Gerados

O `audio_manifest.tres` é o seu catálogo central. Você pode carregá-lo em qualquer script e acessar os recursos de áudio por chaves.

```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _ready():
    # Exemplo de acesso a uma playlist
    var music_playlist_data = audio_manifest.playlists["music_level1"]
    if music_playlist_data:
        var music_path = music_playlist_data[0] # Caminho para o .tres
        var music_stream_count = music_playlist_data[1] # Contagem de streams
        var music_uid = music_playlist_data[2] # UID do recurso

        var audio_player = AudioStreamPlayer.new()
        add_child(audio_player)
        audio_player.stream = load(music_path)
        audio_player.play()
    else:
        print("Playlist 'music_level1' não encontrada no manifesto.")

    # Exemplo de acesso a um randomizer
    var sfx_randomizer_data = audio_manifest.randomizer["sfx_hit"]
    if sfx_randomizer_data:
        var sfx_path = sfx_randomizer_data[0]
        var sfx_player = AudioStreamPlayer.new()
        add_child(sfx_player)
        sfx_player.stream = load(sfx_path)
        sfx_player.play()
    else:
        print("Randomizer 'sfx_hit' não encontrado no manifesto.")

    # Exemplo de acesso a um interactive stream (criado manualmente)
    var interactive_sfx_path = audio_manifest.interactive["player_footsteps_interactive"]
    if interactive_sfx_path:
        var interactive_stream = load(interactive_sfx_path)
        var interactive_player = AudioStreamPlayer.new()
        add_child(interactive_player)
        interactive_player.stream = interactive_stream
        interactive_player.play()
        # Se for um AudioStreamInteractive, você pode interagir com ele:
        # interactive_stream.set_parameter("speed", player_velocity.length())
    else:
        print("Interactive stream 'player_footsteps_interactive' não encontrado no manifesto.")
```

### 5.1. `AudioStreamPlaylist`

*   **O que é**: Uma lista ordenada de `AudioStream`s que são reproduzidos em sequência.
*   **Quando usar**: Música de fundo com intro/loop/outro, sequências de diálogo, efeitos sonoros complexos que precisam de uma ordem específica.
*   **Como o AudioCafe gera**: Para cada diretório ou grupo de arquivos de áudio, o AudioCafe cria um `AudioStreamPlaylist.tres` contendo todos os áudios desse grupo.

### 5.2. `AudioStreamRandomizer`

*   **O que é**: Uma coleção de `AudioStream`s onde um é escolhido aleatoriamente a cada reprodução.
*   **Quando usar**: Efeitos sonoros que precisam de variação para evitar repetição (passos, tiros, impactos, vozes de inimigos).
*   **Como o AudioCafe gera**: Para cada diretório ou grupo de arquivos de áudio, o AudioCafe cria um `AudioStreamRandomizer.tres` que agrupa todos os áudios, permitindo a reprodução aleatória.

### 5.3. `AudioStreamSynchronized`

*   **O que é**: Permite sincronizar a reprodução de múltiplos `AudioStream`s, útil para criar camadas de áudio complexas.
*   **Quando usar**: Ambientes sonoros em camadas, música dinâmica que adiciona ou remove elementos, efeitos que precisam de múltiplos componentes tocando juntos.
*   **Como o AudioCafe gera**: Para cada diretório ou grupo de arquivos de áudio, o AudioCafe pode criar um `AudioStreamSynchronized.tres` que agrupa os áudios para reprodução em sincronia.

### 5.4. `AudioStreamInteractive`

*   **O que é**: Um recurso avançado para áudio dinâmico e interativo, onde a reprodução pode mudar com base em parâmetros do jogo (distância, velocidade, estado).
*   **Quando usar**: Passos que mudam com a superfície, música que reage à intensidade da ação, sons de motor que variam com a velocidade.
*   **Como o AudioCafe utiliza**: O AudioCafe **não gera** `AudioStreamInteractive` automaticamente. Em vez disso, ele **coleta referências** a instâncias de `AudioStreamInteractive.tres` que você cria manualmente no editor e as inclui no `AudioManifest`.

    **Como Criar Manualmente um `AudioStreamInteractive`:**
    1.  No painel "FileSystem" do Godot, clique com o botão direito em uma pasta (preferencialmente dentro do seu `Dist Path`, ex: `res://dist/audio/interactive/`).
    2.  Selecione "New Resource...".
    3.  Procure por `AudioStreamInteractive` e crie-o.
    4.  Configure o `AudioStreamInteractive` no inspetor (adicione streams, defina parâmetros de transição, etc.) conforme a documentação oficial do Godot.
    5.  Salve o recurso (ex: `res://dist/audio/interactive/player_footsteps_interactive.tres`).
    6.  Execute a geração do manifesto no AudioCafe novamente para que ele colete a referência.

## 6. Melhores Práticas

*   **Organização de Assets**: Mantenha seus arquivos de áudio brutos bem organizados em pastas lógicas (ex: `music/`, `sfx/ui/`, `sfx/combat/`). O AudioCafe usa a estrutura de pastas para gerar as chaves do manifesto.
*   **Nomenclatura**: Use nomes de arquivos e pastas claros e consistentes. Isso se refletirá nas chaves do seu `AudioManifest`.
*   **`Dist Path` Dedicado**: Sempre use um diretório separado para os recursos gerados pelo AudioCafe (ex: `res://dist/audio`). Isso ajuda a manter seu projeto limpo e facilita o controle de versão.
*   **Controle de Versão**: Adicione o `audio_manifest.tres` e todos os `.tres` gerados no `Dist Path` ao seu sistema de controle de versão (Git, etc.).
*   **Re-geração Regular**: Sempre que adicionar, remover ou renomear arquivos de áudio brutos, execute a geração do manifesto no AudioCafe para manter seu `audio_manifest.tres` atualizado.
*   **Documentação Godot**: Para detalhes aprofundados sobre a configuração de `AudioStreamPlaylist`, `AudioStreamRandomizer`, `AudioStreamSynchronized` e `AudioStreamInteractive`, consulte a documentação oficial do Godot Engine.

Com este guia, você está pronto para aproveitar ao máximo o AudioCafe e acelerar o desenvolvimento de áudio em seus jogos Godot!