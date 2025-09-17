# Máquina de Estados no Godot Engine: Gerenciando Comportamentos Complexos

## Introdução

Em jogos, personagens e objetos frequentemente exibem comportamentos que mudam drasticamente com base em seu contexto atual. Uma "Máquina de Estados" (State Machine) é um padrão de design poderoso para gerenciar essa complexidade, permitindo que um objeto esteja em um de vários estados possíveis, e que seu comportamento mude de acordo com o estado atual.

Este tutorial focará na lógica por trás da implementação de uma Máquina de Estados no Godot, utilizando uma abordagem de "estados combinados" para um player, onde o estado final é uma composição de múltiplos estados menores. O objetivo é entender as "engrenagens" do motor por trás do comportamento, e não apenas a animação visual.

## Conceito de Estados Combinados

Imagine um player que pode estar se movendo, realizando uma ação, empunhando uma arma e sob o efeito de alguma condição. O estado final do player não é apenas "correndo", mas sim "correndo" + "atacando" + "com espada" + "envenenado". Essa abordagem permite uma granularidade maior e uma representação mais rica do comportamento do player.

Vamos definir as categorias de estados para o nosso player:

*   **Moves (Movimentos):** `IDLE`, `WALK`, `RUN`, `JUMP`, `FALL`, `PUSH`, `PULL`
*   **Actions (Ações):** `NONE`, `ATTACK`, `DASH`, `SPIN`
*   **Weapons (Armas):** `NONE`, `SWORD`, `KATANA`, `PISTOL`, `BOW`
*   **Effects (Efeitos):** `NONE`, `STRENGTH`, `POISON`, `FLAMED`

O estado final do player será uma combinação desses estados. Por exemplo:
`RUN` + `ATTACK` + `SWORD` + `NONE`

## Modelando a Máquina de Estados

Para representar esses estados, podemos usar um sistema de flags (bandeiras) ou um dicionário de estados. A abordagem de flags é eficiente para verificar a presença de múltiplos estados simultaneamente.

### Representação dos Estados

Podemos usar `Enums` para cada categoria de estado e uma variável para armazenar o estado atual de cada categoria.

```gdscript
extends Node

enum MoveState { IDLE, WALK, RUN, JUMP, FALL, PUSH, PULL }
enum ActionState { NONE, ATTACK, DASH, SPIN }
enum WeaponState { NONE, SWORD, KATANA, PISTOL, BOW }
enum EffectState { NONE, STRENGTH, POISON, FLAMED }

var current_move_state: MoveState = MoveState.IDLE
var current_action_state: ActionState = ActionState.NONE
var current_weapon_state: WeaponState = WeaponState.NONE
var current_effect_state: EffectState = EffectState.NONE

func get_current_player_state() -> Dictionary:
    return {
        "move": current_move_state,
        "action": current_action_state,
        "weapon": current_weapon_state,
        "effect": current_effect_state
    }
```

### Lógica de Transição e Validação

A chave para uma Máquina de Estados robusta é a lógica de transição e a validação de estados. Nem todas as combinações de estados são válidas (ex: não se pode `JUMP` e `RUN` ao mesmo tempo, ou `ATTACK` com `NONE` weapon).

Podemos criar funções para tentar mudar o estado, que incluirão a lógica de validação.

```gdscript
func set_move_state(new_state: MoveState) -> bool:
    if is_valid_move_transition(new_state):
        current_move_state = new_state
        _on_state_changed()
        return true
    return false

func set_action_state(new_state: ActionState) -> bool:
    if is_valid_action_transition(new_state):
        current_action_state = new_state
        _on_state_changed()
        return true
    return false

func set_weapon_state(new_state: WeaponState) -> bool:
    if is_valid_weapon_transition(new_state):
        current_weapon_state = new_state
        _on_state_changed()
        return true
    return false

func set_effect_state(new_state: EffectState) -> bool:
    if is_valid_effect_transition(new_state):
        current_effect_state = new_state
        _on_state_changed()
        return true
    return false

func is_valid_move_transition(new_state: MoveState) -> bool:
    # Exemplo de validação: Não pode pular se já estiver caindo
    if new_state == MoveState.JUMP and current_move_state == MoveState.FALL:
        return false
    # Exemplo: Não pode correr se estiver empurrando
    if new_state == MoveState.RUN and current_move_state == MoveState.PUSH:
        return false
    return true

func is_valid_action_transition(new_state: ActionState) -> bool:
    # Exemplo de validação: Não pode atacar sem uma arma (a menos que seja um ataque desarmado)
    if new_state == ActionState.ATTACK and current_weapon_state == WeaponState.NONE:
        # Permitir ataque desarmado, mas pode ser uma regra diferente para seu jogo
        return true
    # Exemplo: Não pode dar dash se já estiver atacando
    if new_state == ActionState.DASH and current_action_state == ActionState.ATTACK:
        return false
    return true

func is_valid_weapon_transition(new_state: WeaponState) -> bool:
    # Exemplo de validação: Não pode trocar de arma enquanto ataca
    if current_action_state == ActionState.ATTACK:
        return false
    return true

func is_valid_effect_transition(new_state: EffectState) -> bool:
    # Exemplo de validação: Não pode ter dois efeitos de buff ao mesmo tempo
    if new_state == EffectState.STRENGTH and current_effect_state != EffectState.NONE:
        return false
    return true

func _on_state_changed():
    # Este método será chamado sempre que um estado mudar.
    # Aqui você pode notificar outros sistemas (animação, UI, lógica de combate)
    # sobre a mudança no estado combinado do player.
    var player_state = get_current_player_state()
    print("Novo estado do player: ", player_state)
    # Exemplo: Reagir a um estado específico
    if player_state.move == MoveState.JUMP and player_state.action == ActionState.NONE:
        print("Player está pulando sem ação!")
    if player_state.weapon == WeaponState.PISTOL and player_state.action == ActionState.ATTACK:
        print("Player está atirando com a pistola!")
```

### Exemplo de Uso

Em um script de player, você chamaria esses métodos para tentar mudar os estados:

```gdscript
# No script do seu player (ex: Player.gd)
# ... (código da State Machine acima pode ser um singleton ou um nó filho)

func _physics_process(delta):
    # Lógica de input para mudar o estado de movimento
    if Input.is_action_pressed("move_right"):
        set_move_state(MoveState.RUN)
    elif Input.is_action_pressed("move_left"):
        set_move_state(MoveState.WALK)
    else:
        set_move_state(MoveState.IDLE)

    # Lógica de input para mudar o estado de ação
    if Input.is_action_just_pressed("attack"):
        set_action_state(ActionState.ATTACK)
    elif Input.is_action_just_released("attack"):
        set_action_state(ActionState.NONE)

    # Lógica para trocar de arma
    if Input.is_action_just_pressed("equip_sword"):
        set_weapon_state(WeaponState.SWORD)
    elif Input.is_action_just_pressed("equip_pistol"):
        set_weapon_state(WeaponState.PISTOL)

    # Lógica para aplicar efeitos
    if Input.is_action_just_pressed("apply_strength"):
        set_effect_state(EffectState.STRENGTH)
```

## Benefícios dessa Abordagem

*   **Modularidade**: Cada categoria de estado é gerenciada de forma independente, facilitando a adição ou modificação de estados sem afetar outras partes.
*   **Clareza**: O estado do player é explicitamente definido pela combinação de seus sub-estados, tornando a lógica mais fácil de entender.
*   **Escalabilidade**: Adicionar novas categorias de estado ou novos estados dentro de uma categoria é relativamente simples.
*   **Depuração**: É mais fácil identificar o que está acontecendo com o player, pois seu estado é uma composição clara.
*   **Reatividade**: O método `_on_state_changed()` atua como um ponto central para reagir a qualquer mudança no estado combinado, notificando outros sistemas.

## Considerações Avançadas

*   **Sub-Máquinas de Estados**: Para estados muito complexos (ex: um estado `ATTACK` que tem seus próprios sub-estados como `WINDUP`, `HIT`, `RECOVERY`), você pode aninhar Máquinas de Estados.
*   **Eventos e Sinais**: Em vez de chamar diretamente `set_move_state()`, você pode emitir sinais que a Máquina de Estados escuta, desacoplando ainda mais a lógica.
*   **Prioridade de Estados**: Alguns estados podem ter prioridade sobre outros (ex: `FALL` pode ter prioridade sobre `RUN`). A lógica de validação deve refletir isso.
*   **Dados de Estado**: Cada estado pode ter dados associados (ex: `ATTACK` pode ter um `damage_multiplier` que depende da `WeaponState`).

Esta abordagem de Máquina de Estados combinada oferece uma estrutura flexível e poderosa para gerenciar o comportamento complexo de um player no Godot, permitindo que você construa sistemas robustos e fáceis de manter.
