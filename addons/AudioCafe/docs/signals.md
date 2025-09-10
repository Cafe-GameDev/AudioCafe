# Sinais do AudioCafe

O AudioCafe utiliza o sistema de sinais do Godot para comunicar eventos de áudio importantes em todo o seu projeto. Você pode se conectar a esses sinais para acionar lógicas customizadas, atualizar a UI ou integrar com outros sistemas do seu jogo.

## CafeAudioManager Signals

Estes sinais são emitidos pelo singleton `CafeAudioManager` e podem ser acessados globalmente.

### `audio_config_updated(config: AudioConfig)`
Emitido sempre que o `AudioConfig` é recarregado ou modificado, por exemplo, através do painel do editor.
- **`config`**: A instância atualizada do recurso `AudioConfig`.

### `play_sfx_requested(sfx_key: String, bus: String, manager_node: Node)`
Este é um sinal que o `CafeAudioManager` escuta. Emita este sinal de qualquer lugar do seu código para solicitar a reprodução de um SFX.
- **`sfx_key`**: A chave do SFX a ser tocado (e.g., "ui_click").
- **`bus`**: O nome do bus de áudio onde o SFX será tocado (padrão: "SFX").
- **`manager_node`**: O nó que está solicitando o áudio.

### `play_music_requested(music_key: String, manager_node: Node)`
Este é um sinal que o `CafeAudioManager` escuta. Emita este sinal para solicitar a reprodução de uma música.
- **`music_key`**: A chave da música a ser tocada.
- **`manager_node`**: O nó que está solicitando a música.

### `music_track_changed(music_key: String)`
Emitido quando uma nova faixa de música começa a tocar.
- **`music_key`**: A chave da nova faixa de música.

### `volume_changed(bus_name: String, linear_volume: float)`
Emitido quando o volume de um bus de áudio é alterado através do `CafeAudioManager`.
- **`bus_name`**: O nome do bus que teve o volume alterado (e.g., "Master", "SFX", "Music").
- **`linear_volume`**: O novo volume em escala linear (0.0 a 1.0).

### `zone_event_triggered(zone_name: String, event_type: String, body: Node)`
Emitido quando um `AudioZone` dispara um evento. O `CafeAudioManager` retransmite o sinal do `AudioZone` para que possa ser acessado globalmente.
- **`zone_name`**: O nome da `AudioZone` que disparou o evento.
- **`event_type`**: O tipo de evento ("entered" ou "exited").
- **`body`**: O nó que entrou/saiu da zona.

## AudioZone (2D/3D) Signals

### `zone_event_triggered(zone_name: String, event_type: String, body: Node)`
Emitido diretamente pelo nó `AudioZone2D` ou `AudioZone3D` quando um corpo alvo entra ou sai da sua área de colisão.
- **`zone_name`**: O nome da zona, definido na propriedade `zone_name` do nó.
- **`event_type`**: O tipo de evento, que pode ser `"entered"` ou `"exited"`.
- **`body`**: O nó (`PhysicsBody` ou `Node`) que acionou o evento.

## AudioCafe (Base Class) Signals

### `config_updated`
Emitido por qualquer nó que herda de `AudioCafe` (incluindo a maioria dos nós de UI) quando o `AudioConfig` é recarregado. Isso permite que os nós atualizem suas configurações de SFX padrão.
