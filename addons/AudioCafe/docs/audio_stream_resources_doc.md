# Documentação dos Recursos AudioStream no AudioCafe

O plugin AudioCafe utiliza e gera diversos tipos de recursos `AudioStream` do Godot Engine para oferecer um sistema de gerenciamento de áudio flexível e poderoso. Compreender esses recursos é fundamental para tirar o máximo proveito do plugin.

## 1. AudioStream (Base)

`AudioStream` é a classe base para todos os recursos de áudio no Godot. Ele representa um fluxo de áudio que pode ser reproduzido. No AudioCafe, você não interage diretamente com `AudioStream` base, mas sim com suas variações especializadas.

## 2. AudioStreamPlaylist

Um `AudioStreamPlaylist` é um recurso que contém uma lista ordenada de `AudioStream`s. Ele é ideal para reproduzir uma sequência de sons, como músicas de fundo, diálogos ou efeitos sonoros que devem ocorrer em uma ordem específica.

**Como o AudioCafe utiliza:**
O AudioCafe gera `AudioStreamPlaylist.tres` para cada "chave" de áudio encontrada nos seus `assets_paths`. Se você tiver uma pasta `res://assets/music/level1/` com `intro.ogg`, `loop.ogg`, `outro.ogg`, o AudioCafe pode gerar uma playlist `music_level1_playlist.tres` contendo esses três arquivos na ordem em que foram encontrados (ou uma ordem definida por você, se o plugin permitir).

**Exemplo de Uso (via `AudioManifest`):**
```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _ready():
    var level1_music_playlist = audio_manifest.playlists["music_level1"]
    # level1_music_playlist[0] é o caminho para o .tres
    # level1_music_playlist[1] é a contagem de streams
    # level1_music_playlist[2] é o UID do recurso

    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = load(level1_music_playlist[0])
    audio_player.play()
```

## 3. AudioStreamRandomizer

Um `AudioStreamRandomizer` é um recurso que contém uma coleção de `AudioStream`s e reproduz um deles aleatoriamente a cada vez que é acionado. É perfeito para efeitos sonoros que precisam de variação para evitar repetição e tornar a experiência mais orgânica (ex: passos, tiros, impactos).

**Como o AudioCafe utiliza:**
Para cada "chave" de áudio, o AudioCafe pode gerar um `AudioStreamRandomizer.tres` que agrupa todas as variações de um som. Por exemplo, se você tiver `res://assets/sfx/hit/hit_01.ogg`, `hit_02.ogg`, `hit_03.ogg`, o AudioCafe criará `sfx_hit_randomizer.tres` que, ao ser reproduzido, escolherá um desses três sons aleatoriamente.

**Exemplo de Uso (via `AudioManifest`):**
```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _on_player_hit():
    var hit_sfx_randomizer = audio_manifest.randomizer["sfx_hit"]
    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = load(hit_sfx_randomizer[0])
    audio_player.play()
```

## 4. AudioStreamSynchronized

O `AudioStreamSynchronized` é um recurso mais avançado que permite sincronizar a reprodução de múltiplos `AudioStream`s. Isso é útil para criar camadas de áudio complexas que devem começar e parar juntas, ou para efeitos que dependem de uma base rítmica.

**Como o AudioCafe utiliza:**
O AudioCafe pode gerar `AudioStreamSynchronized.tres` para chaves de áudio que se beneficiariam de reprodução em camadas. Ele agrupa os `AudioStream`s associados a uma chave e os configura para serem reproduzidos em sincronia.

**Exemplo de Uso (via `AudioManifest`):**
```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _start_ambience():
    var ambience_sync = audio_manifest.synchronized["ambience_forest"]
    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = load(ambience_sync[0])
    audio_player.play()
```

## 5. AudioStreamInteractive

`AudioStreamInteractive` é um recurso que permite criar áudio dinâmico e interativo, onde a reprodução pode mudar com base em parâmetros do jogo (ex: distância do jogador, estado de saúde, etc.). Diferente dos outros, o AudioCafe **não gera** `AudioStreamInteractive` automaticamente. Em vez disso, ele **coleta referências** a instâncias de `AudioStreamInteractive.tres` que você cria manualmente no editor e as inclui no `AudioManifest`.

**Como o AudioCafe utiliza:**
Você cria um `AudioStreamInteractive.tres` no editor do Godot, configura seus parâmetros e o salva em um dos seus `dist_paths` (ou em um subdiretório que o AudioCafe escaneia para recursos interativos). Na próxima geração do manifesto, o AudioCafe detectará esse recurso e o adicionará ao dicionário `interactive` do `AudioManifest`.

**Exemplo de Criação Manual (no Editor):**
1.  No painel "FileSystem", clique com o botão direito em uma pasta (ex: `res://dist/interactive/`).
2.  Selecione "New Resource...".
3.  Procure por `AudioStreamInteractive` e crie-o.
4.  Configure o `AudioStreamInteractive` no inspetor (adicione streams, defina parâmetros de transição, etc.).
5.  Salve o recurso (ex: `res://dist/interactive/player_footsteps_interactive.tres`).

**Exemplo de Uso (via `AudioManifest`):**
```gdscript
@onready var audio_manifest = preload("res://addons/AudioCafe/resources/audio_manifest.tres")

func _on_player_move():
    var footsteps_interactive_path = audio_manifest.interactive["player_footsteps_interactive"]
    var footsteps_interactive = load(footsteps_interactive_path)

    # Exemplo: Atualizar um parâmetro do AudioStreamInteractive
    # footsteps_interactive.set_parameter("speed", player_velocity.length())

    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    audio_player.stream = footsteps_interactive
    audio_player.play()
```

---

Esta documentação serve como um guia rápido para os tipos de `AudioStream` que o AudioCafe gerencia ou referencia. Para detalhes mais aprofundados sobre a configuração de cada `AudioStream` (especialmente `AudioStreamInteractive`), consulte a documentação oficial do Godot Engine.
