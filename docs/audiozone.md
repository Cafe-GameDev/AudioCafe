# AudioZone (2D/3D)

Os nós `AudioZone2D` e `AudioZone3D` são áreas que detectam a entrada e saída de corpos (`PhysicsBody2D/3D`) para disparar eventos de áudio. Eles herdam de `Area2D` e `Area3D` do Godot.

## Casos de Uso

- Tocar música ambiente específica quando o jogador entra em uma área (e.g., uma vila, uma caverna).
- Ativar sons de ambiente, como o som de um rio quando o jogador se aproxima dele.
- Criar gatilhos sonoros para eventos de script.

## Configuração

1.  Adicione um nó `AudioZone2D` ou `AudioZone3D` à sua cena.
2.  Adicione um `CollisionShape2D` ou `CollisionShape3D` como filho para definir a área de detecção.
3.  No `Inspector` do `AudioZone`, configure as seguintes propriedades:

    - **`zone_name`**: Um nome único para identificar esta zona. É essencial para saber qual zona disparou um evento.
    - **`target_group`**: (Opcional) Se definido, a zona só reagirá a corpos que pertençam a este grupo. Ideal para filtrar e detectar apenas o jogador, por exemplo.
    - **`target_class_name`**: (Opcional) Se definido, a zona só reagirá a nós cujo tipo de classe corresponda a este nome.

Se nem `target_group` nem `target_class_name` forem definidos, a zona reagirá a qualquer corpo que entrar nela.

## Uso

O `AudioZone` não toca sons diretamente. Em vez disso, ele emite um `signal` quando um corpo alvo entra ou sai de sua área. A intenção é que um sistema central (como o `CafeAudioManager` ou um script seu) escute esses eventos e decida qual ação tomar.

### Signal `zone_event_triggered`

Este é o único signal emitido pelo `AudioZone`.

- **`zone_event_triggered(zone_name: String, event_type: String, body: Node)`**:
    - **`zone_name`**: O nome que você deu à zona no `Inspector`.
    - **`event_type`**: `"entered"` ou `"exited"`.
    - **`body`**: O nó que entrou ou saiu da zona.

### Exemplo de Integração

O `CafeAudioManager` escuta automaticamente todos os eventos de `AudioZone` e os retransmite globalmente através de seu próprio signal `zone_event_triggered`. Você pode criar um script para gerenciar a música ambiente com base nesses eventos.

```gdscript
# music_manager.gd
extends Node

func _ready():
    CafeAudioManager.zone_event_triggered.connect(_on_zone_event)

func _on_zone_event(zone_name: String, event_type: String, body: Node):
    # Verifica se o corpo é o jogador (assumindo que o jogador está no grupo "player")
    if not body.is_in_group("player"):
        return

    if event_type == "entered":
        if zone_name == "CaveZone":
            CafeAudioManager.play_music_requested.emit("music_cave_theme")
        elif zone_name == "VillageZone":
            CafeAudioManager.play_music_requested.emit("music_village_theme")
    elif event_type == "exited":
        if zone_name == "CaveZone" or zone_name == "VillageZone":
            # Retorna para a música padrão do nível
            CafeAudioManager.play_music_requested.emit("music_overworld_theme")
```
