# AudioPosition (2D/3D)

Os nós `AudioPosition2D` e `AudioPosition3D` são componentes especializados para tocar sons que se originam de um ponto específico no seu mundo de jogo. Eles herdam de `AudioStreamPlayer2D` e `AudioStreamPlayer3D` respectivamente, adicionando funcionalidades para facilitar a integração com sistemas de jogo, como máquinas de estado.

## Casos de Uso

- Sons de passos de um personagem.
- Efeitos sonoros de um inimigo (ataque, dano).
- Sons de objetos no ambiente (e.g., uma tocha crepitando).

## Configuração

1.  Adicione um nó `AudioPosition2D` ou `AudioPosition3D` como filho do objeto que emitirá o som (e.g., seu nó de Personagem).
2.  No `Inspector`, você encontrará a propriedade `State Audio`. Esta é a principal funcionalidade do `AudioPosition`.

### State Audio

`State Audio` é um dicionário onde você mapeia **chaves de estado** (Strings) para **chaves de SFX** (do seu `AudioManifest`).

- **Chave (Key)**: Um nome que representa um estado do seu objeto. Por exemplo: "walk", "jump", "attack".
- **Valor (Value)**: A chave do SFX que deve ser tocada quando este estado for ativado. Por exemplo: "sfx_player_walk", "sfx_player_jump".

## Uso em Código

Uma vez configurado, você pode controlar o `AudioPosition` a partir do script do seu personagem ou objeto.

### `set_state(state_key: String)`

Esta é a função principal. Chame-a para tocar o som associado a um estado. O `AudioPosition` irá:
1.  Verificar se a `state_key` existe no dicionário `State Audio`.
2.  Obter a chave de SFX correspondente.
3.  Consultar o `AudioManifest` para encontrar um UID de áudio aleatório para essa chave de SFX.
4.  Carregar e tocar o som.

**Exemplo: Máquina de Estado Simples**

Imagine que você tem um script de personagem com uma máquina de estado. Para um exemplo mais detalhado e completo, veja o guia [Usando AudioPosition com uma Máquina de Estado](./StateMachineIntegration.md).

```gdscript
# player.gd
extends CharacterBody2D

@onready var audio_position: AudioPosition2D = $AudioPosition2D

var state = "idle"

func _physics_process(delta):
    # ... lógica de movimento ...

    var new_state = "idle"
    if is_on_floor():
        if velocity.x != 0:
            new_state = "walk"
        if Input.is_action_just_pressed("jump"):
            new_state = "jump"
    else:
        new_state = "fall" # Supondo que você tenha um estado de queda

    if new_state != state:
        state = new_state
        # Apenas chama set_state se houver um som para o estado
        if state == "walk" or state == "jump":
            audio_position.set_state(state)
```

### `play_secondary_sound(sfx_key: String)`

Esta função permite tocar um som adicional sem interromper o som principal (o som do estado atual). Ela cria um `AudioStreamPlayer` temporário como filho, toca o som solicitado e se autodestrói quando termina.

É útil para sons que podem ocorrer durante qualquer estado, como um som de "dano recebido".

```gdscript
# player.gd

func take_damage():
    # ... lógica de dano ...
    $AudioPosition2D.play_secondary_sound("sfx_player_hurt")
```
