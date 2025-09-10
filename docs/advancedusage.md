# Tópicos Avançados e Receitas

Esta seção aborda casos de uso mais específicos e responde a perguntas comuns sobre como estender ou utilizar o AudioCafe de maneiras criativas.

## Como tocar um som diretamente pelo código?

Embora os nós de Controle e o `AudioPosition` cubram muitos casos, às vezes você precisa tocar um som imperativamente a partir de um script. Para isso, emita o signal `play_sfx_requested` do `CafeAudioManager`.

```gdscript
func _on_player_powerup():
    # Toca um som de power-up
    CafeAudioManager.play_sfx_requested.emit("sfx_powerup_collect")
    
    # Você também pode especificar um bus de áudio diferente
    # CafeAudioManager.play_sfx_requested.emit("sfx_voice_line", "Voice")
```

## Como tocar uma sequência de SFX?

Se você precisa que vários sons toquem em uma ordem específica, um após o outro, você pode usar `await` com o sinal `finished` de um `AudioStreamPlayer`. Como o `CafeAudioManager` usa um pool de players compartilhados, a abordagem mais segura é criar um player dedicado para a sua sequência.

```gdscript
# Script que controla a sequência
extends Node

var sfx_sequence = ["ui_notification_1", "ui_notification_2", "ui_success"]
var sequence_player = AudioStreamPlayer.new()

func _ready():
    add_child(sequence_player)

func play_my_sequence():
    for sfx_key in sfx_sequence:
        # Pede para o manager tocar o som, mas em nosso player dedicado
        CafeAudioManager.play_sfx_requested.emit(sfx_key, "SFX", sequence_player)
        # Espera o som atual terminar antes de ir para o próximo
        await sequence_player.finished
    print("Sequência de SFX concluída!")
```

## Como integrar com o AnimationPlayer?

Sincronizar sons com animações é um caso de uso muito comum. A melhor maneira de fazer isso é usando uma "Call Method Track".

1.  **Adicione um `AnimationPlayer`** à sua cena.
2.  Crie sua animação (por exemplo, uma animação de ataque).
3.  Adicione uma nova trilha do tipo **"Call Method Track"**.

    ![Add Call Method Track](https://i.imgur.com/your-image-url.png) <!-- Placeholder para imagem -->

4.  Selecione o nó que contém o script que irá tocar o som (pode ser o nó raiz do personagem ou o próprio `AudioPosition`).
5.  Nos pontos da animação onde você quer que o som toque (ex: no meio de um swing de espada), clique com o botão direito na Call Method Track e insira uma nova chave.
6.  Na janela que se abre, digite o nome da função que você quer chamar. Por exemplo, `play_swing_sfx`.
7.  No script do seu personagem, crie essa função:

```gdscript
# player.gd

func play_swing_sfx():
    # Se você tem um AudioPosition, pode usar o play_secondary_sound
    $AudioPosition2D.play_secondary_sound("sfx_sword_swing")
    
    # Ou, se não estiver usando AudioPosition para isso, pode chamar o manager globalmente
    # CafeAudioManager.play_sfx_requested.emit("sfx_sword_swing")
```
Agora, toda vez que a `AnimationPlayer` passar por aquela chave, a função `play_swing_sfx` será chamada, tocando o som em perfeita sincronia com a animação.

## Como criar um controle de UI customizado com SFX?

Se você criar seu próprio componente de UI e quiser que ele tenha SFX integrado, o processo é simples:

1.  Faça seu script herdar de `AudioCafe` em vez de seu tipo de `Control` base. Isso lhe dará acesso ao `audio_config`.
2.  Exporte variáveis `String` para as chaves de SFX que você precisa (e.g., `@export var custom_event_sfx_key: String`).
3.  Conecte-se ao `signal` relevante do seu controle.
4.  Na função de callback do signal, emita o `play_sfx_requested` do `CafeAudioManager`.
5.  (Opcional) No `_ready`, implemente a lógica para usar a chave padrão do `audio_config` se a sua chave customizada estiver vazia.

**Exemplo: Um botão customizado que toca som no `focus_entered`**

```gdscript
@tool
class_name MyCustomButton
extends AudioCafe # Herda de AudioCafe em vez de Button

@export_group("SFX Settings")
@export var pressed_sfx_key: String
@export var focus_sfx_key: String # Nosso evento customizado

func _ready():
    # Conecta aos signals do nó Button base
    var button = get_parent() as Button
    button.pressed.connect(_on_pressed)
    button.focus_entered.connect(_on_focus_entered)
    
    # Carrega as chaves padrão
    if CafeAudioManager:
        _on_audio_config_updated(CafeAudioManager.audio_config)

func _on_pressed():
    if not pressed_sfx_key.is_empty():
        CafeAudioManager.play_sfx_requested.emit(pressed_sfx_key)

func _on_focus_entered():
    if not focus_sfx_key.is_empty():
        CafeAudioManager.play_sfx_requested.emit(focus_sfx_key)

func _on_audio_config_updated(config: AudioConfig):
    if pressed_sfx_key.is_empty():
        pressed_sfx_key = config.default_click_key
    if focus_sfx_key.is_empty():
        focus_sfx_key = config.default_focus_key
```

## Como usar `AudioZone` para criar ambiente sonoro?

Você pode usar múltiplos `AudioZone`s para criar um ambiente sonoro complexo.

**Exemplo: Som de Floresta com um Rio**

1.  Crie um `AudioZone` grande que cubra toda a área da floresta. Dê a ele o `zone_name` de "ForestZone".
2.  Dentro da "ForestZone", crie um `AudioZone` menor que siga o curso de um rio. Dê a ele o `zone_name` de "RiverZone".
3.  Crie um script `environment_manager.gd` para gerenciar os sons.

```gdscript
# environment_manager.gd
extends Node

var forest_player = AudioStreamPlayer.new()
var river_player = AudioStreamPlayer.new()

func _ready():
    add_child(forest_player)
    add_child(river_player)
    
    # Carregue os sons de ambiente
    forest_player.stream = load("res://assets/sfx/ambience/forest_loop.ogg")
    river_player.stream = load("res://assets/sfx/ambience/river_loop.ogg")
    
    CafeAudioManager.zone_event_triggered.connect(_on_zone_event)

func _on_zone_event(zone_name: String, event_type: String, body: Node):
    if not body.is_in_group("player"): return

    if zone_name == "ForestZone":
        if event_type == "entered":
            forest_player.play()
        else:
            forest_player.stop()
    
    if zone_name == "RiverZone":
        if event_type == "entered":
            river_player.play()
        else:
            river_player.stop()
```
