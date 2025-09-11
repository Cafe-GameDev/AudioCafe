# CafeAudioManager

O `CafeAudioManager` é o coração do plugin AudioCafe. Ele é um `singleton` (autoload) que gerencia toda a reprodução de áudio, volumes e a comunicação entre os diferentes componentes de áudio do seu jogo.

## Acesso

Por ser um `singleton`, você pode acessar o `CafeAudioManager` de qualquer script no seu projeto sem precisar de uma referência direta.

```gdscript
func _ready():
    # Toca um SFX
    CafeAudioManager.play_sfx_requested.emit("player_jump")

    # Toca uma música
    CafeAudioManager.play_music_requested.emit("level_1_theme")
```

## Funcionalidades Principais

### Gerenciamento de SFX e Música

O `CafeAudioManager` é responsável por carregar e tocar os sons definidos no seu `AudioManifest`.

- **`play_sfx_requested` (Signal)**: Emita este signal para tocar um efeito sonoro. O `CafeAudioManager` encontrará um `AudioStreamPlayer` disponível em seu pool interno e tocará o som.
- **`play_music_requested` (Signal)**: Emita este signal para tocar uma faixa de música. O `CafeAudioManager` gerencia um `AudioStreamPlayer` dedicado para a música, garantindo transições suaves e controle de playlist.

### Gerenciamento de Volume e Buses

O `CafeAudioManager` cria e gerencia os buses de áudio "Music" e "SFX" automaticamente.

- **`apply_volume_to_bus(bus_name: String, linear_volume: float)`**: Esta função permite que você altere o volume de qualquer bus de áudio ("Master", "Music", "SFX", etc.) em uma escala linear (de 0.0 a 1.0), que é mais intuitiva do que decibéis.
- **`volume_changed` (Signal)**: É emitido sempre que um volume é alterado através da função `apply_volume_to_bus`, permitindo que elementos da UI (como sliders de volume) reajam à mudança.

### Playlists de Música

Quando o jogo começa, ou quando uma música termina, o `CafeAudioManager` seleciona aleatoriamente uma nova "playlist" (uma chave de música do `AudioManifest`) e toca uma faixa aleatória dela. Isso cria uma trilha sonora dinâmica sem esforço.

- **`stop_music()`**: Para a reprodução da música atual.
- **`_on_music_finished()`**: Conectado ao signal `finished` do player de música, esta função interna aciona a seleção da próxima faixa.

### Integração com AudioZone

O `CafeAudioManager` se conecta automaticamente aos signals emitidos por qualquer `AudioZone` na cena, retransmitindo-os globalmente. Isso permite que você crie sistemas centralizados que reagem a eventos de zona, como alterar a música ambiente quando o jogador entra em uma caverna.

## Estrutura Interna

- **Pool de SFX Players**: Para evitar a criação e destruição constante de nós, o `CafeAudioManager` mantém um pool de `AudioStreamPlayer`s. Quando um SFX é solicitado, ele usa um player inativo. Após a reprodução, o player é liberado e fica disponível novamente. 
    - **Configurando o Tamanho do Pool:** O tamanho do pool pode ser configurado na propriedade `_sfx_player_count` no nó `CafeAudioManager` na cena `cafe_audio_manager.tscn`. O valor padrão é 15. Um número maior permite mais sons simultâneos ao custo de um pouco mais de memória, enquanto um número menor pode economizar memória mas arrisca que alguns sons não sejam tocados se muitos forem disparados ao mesmo tempo.

- **Player de Música Dedicado**: Um `AudioStreamPlayer` separado é usado exclusivamente para a música, permitindo um controle mais preciso sobre a trilha sonora.
