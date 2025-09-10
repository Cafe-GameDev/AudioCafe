# Guia: Usando AudioPosition com uma Máquina de Estado

O nó `AudioPosition` foi projetado especificamente para se integrar facilmente com máquinas de estado (`State Machines`), um padrão comum para gerenciar a lógica de personagens e inimigos.

Este guia mostrará como configurar sons para diferentes estados de um personagem, como "parado", "andando" e "pulando".

## 1. Configurando o AudioPosition

Primeiro, adicione um nó `AudioPosition2D` (ou `3D`) como filho do seu nó de personagem.

No `Inspector` do `AudioPosition`, vamos configurar a propriedade `State Audio`. Crie entradas para cada estado do seu personagem que terá um som associado.

- **State Key**: O nome do estado (e.g., "idle", "walk", "jump").
- **SFX Key**: A chave do som do `AudioManifest` que deve tocar para esse estado.

**Exemplo de Configuração:**

| State Key | SFX Key (Value)      |
|-----------|----------------------|
| `walk`    | `player_footsteps`   |
| `jump`    | `player_jump`        |
| `land`    | `player_land`        |
| `hurt`    | `player_hurt`        |

*Nota: O estado "idle" geralmente não tem som, então não precisamos adicioná-lo.*

## 2. Integrando com o Script da Máquina de Estado

Agora, no script do seu personagem, vamos chamar a função `set_state()` do `AudioPosition` sempre que o estado mudar.

Vamos supor que você tenha uma máquina de estado simples controlada por uma variável `state`.

```gdscript
# player.gd
extends CharacterBody2D

# Enum para os estados, para evitar erros de digitação
enum State { IDLE, WALK, JUMP, FALL }

@onready var audio_position: AudioPosition2D = $AudioPosition2D

var current_state: State = State.IDLE

func _physics_process(delta):
    # ... sua lógica de movimento e física aqui ...

    # Determina o novo estado com base nas condições atuais
    var new_state = determine_state()
    
    # Se o estado mudou, atualiza e toca o som
    if new_state != current_state:
        change_state(new_state)

func determine_state() -> State:
    if not is_on_floor():
        return State.JUMP if velocity.y < 0 else State.FALL
    else:
        if velocity.is_zero_approx():
            return State.IDLE
        else:
            return State.WALK

func change_state(new_state: State):
    # Lógica para quando o estado antigo termina (se houver)
    match current_state:
        State.FALL:
            # Se estávamos caindo e agora mudamos de estado, significa que aterrissamos
            audio_position.set_state("land")

    # Define o novo estado
    current_state = new_state
    
    # Lógica para quando o novo estado começa
    match current_state:
        State.WALK:
            audio_position.set_state("walk")
            # O som de passos deve ser em loop. Certifique-se de que o áudio importado
            # tenha a opção de loop ativada.
        State.JUMP:
            audio_position.set_state("jump")
        State.IDLE:
            # Para o som de passos quando o personagem para
            if audio_position.stream and audio_position.playing:
                audio_position.stop()
```

## 3. Sons Secundários (Dano, etc.)

E se o personagem levar dano? O som de "dano" pode ocorrer em qualquer estado (`idle`, `walk`, `jump`). Usar `set_state("hurt")` mudaria o som principal.

Para isso, usamos `play_secondary_sound()`. Esta função toca um som "por cima" do som do estado atual, sem interrompê-lo.

```gdscript
# player.gd

func take_damage(amount):
    # ... sua lógica de vida ...
    
    # Toca o som de dano sem alterar o estado de áudio atual
    audio_position.play_secondary_sound("hurt")
```

Com essa estrutura, seu `AudioPosition` está perfeitamente sincronizado com a lógica da sua máquina de estado, tornando o áudio do personagem dinâmico e reativo.
