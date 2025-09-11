# Tutorial: Áudio Básico de Personagem

Este tutorial mostra como usar o nó `AudioPosition` para adicionar sons de pulo e aterrissagem a um personagem, usando o sistema de estados da v1.0.

### Pré-requisitos

- O plugin AudioCafe v1.0 instalado e ativado.
- Uma cena de personagem básica com um script (`CharacterBody2D` é usado neste exemplo).
- Sons para pulo e aterrissagem em suas pastas de áudio (ex: `res://assets/audio/player/jump.ogg` e `res://assets/audio/player/land.ogg`).
- O `AudioManifest` já deve ter sido gerado.

---

### Passo 1: Adicione o Nó `AudioPosition`

1.  Abra a cena do seu personagem.
2.  Selecione o nó raiz do personagem.
3.  Adicione um nó filho do tipo **`AudioPosition2D`** (ou `AudioPosition3D` para jogos 3D).

### Passo 2: Configure os Estados de Áudio

1.  Selecione o nó `AudioPosition2D` que você acabou de adicionar.
2.  No painel **Inspector**, encontre a propriedade **`State Audio`**.
3.  Clique em "Add Key/Value Pair" duas vezes para criar duas entradas.
4.  Configure as entradas da seguinte forma:
    - **Entrada 1:**
        - **Key (String):** `jump`
        - **Value (String):** `player_jump` (ou a chave correspondente ao seu som de pulo no `AudioManifest`).
    - **Entrada 2:**
        - **Key (String):** `land`
        - **Value (String):** `player_land` (ou a chave correspondente ao seu som de aterrissagem).

O seu Inspector deve se parecer com isto:

![State Audio Config](https://i.imgur.com/your-image-url.png) <!-- Placeholder para imagem -->

### Passo 3: Integre com o Script do Personagem

Agora, vamos modificar o script do seu personagem para chamar o `AudioPosition` quando os eventos de pulo e aterrissagem ocorrerem.

Este é um exemplo completo de um script de `CharacterBody2D` que implementa essa lógica.

```gdscript
# player.gd
extends CharacterBody2D

# Enum para os estados, para evitar erros de digitação.
enum State { IDLE, WALK, JUMP, FALL }

# Pega uma referência ao nosso nó de áudio.
@onready var audio_position: AudioPosition2D = $AudioPosition2D

var current_state: State = State.IDLE

# Constantes de movimento
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
    if not is_on_floor():
        velocity.y += gravity * delta

    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    var direction = Input.get_axis("ui_left", "ui_right")
    velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    
    var new_state = _determine_state()
    if new_state != current_state:
        _change_state(new_state)

func _determine_state() -> State:
    if not is_on_floor():
        return State.FALL
    else:
        if Input.is_action_just_pressed("ui_accept"):
            return State.JUMP
        if not is_zero_approx(velocity.x):
            return State.WALK
        else:
            return State.IDLE

func _change_state(new_state: State):
    # Lógica para quando o estado antigo termina
    # Se estávamos caindo (FALL) e o novo estado é no chão (IDLE ou WALK), 
    # significa que acabamos de aterrissar.
    if current_state == State.FALL and (new_state == State.IDLE or new_state == State.WALK):
        audio_position.set_state("land") # Toca o som de aterrissagem

    current_state = new_state
    
    # Lógica para quando o novo estado começa
    if current_state == State.JUMP:
        audio_position.set_state("jump") # Toca o som de pulo
```

### Passo 4: Teste!

Rode a cena do seu jogo. Mova o personagem e pule. Você deverá ouvir o som de pulo quando a ação ocorre e o som de aterrissagem quando o personagem toca o chão após uma queda.
