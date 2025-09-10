# AudioConfig

O `AudioConfig` é um recurso (`Resource`) que centraliza todas as configurações do plugin AudioCafe. Ele é o "cérebro" das configurações, armazenando os caminhos para seus arquivos de áudio, as chaves de SFX padrão para os controles de UI e os volumes globais.

O arquivo de configuração padrão está localizado em `res://addons/AudioCafe/resources/audio_config.tres`.

## Acesso e Modificação

A maneira mais fácil de modificar o `AudioConfig` é através do **AudioPanel** no editor do Godot. Todas as alterações feitas no painel são salvas diretamente neste recurso.

## Propriedades

### Paths de Áudio

- **`sfx_paths: Array[String]`**: Uma lista de diretórios que contêm seus efeitos sonoros. O `AudioManifest` será gerado a partir dos arquivos encontrados nestes caminhos.
- **`music_paths: Array[String]`**: Uma lista de diretórios que contêm suas músicas.

### Chaves de SFX Padrão (`default_*_key`)

Estas propriedades definem as chaves de SFX que os [nós de Controle](./Controls.md) usarão por padrão se você não especificar uma chave customizada neles.

- **`default_click_key`**: Para eventos de clique (`SFXButton`).
- **`default_hover_key`**: Para eventos de mouse hover.
- **`default_slider_key`**: Para mudança de valor em sliders (`SFXSlider`, `SFXSpinBox`).
- **`default_confirm_key`**: Para confirmação em diálogos (`SFXConfirmationDialog`).
- **`default_cancel_key`**: Para cancelamento ou fechamento.
- **`default_toggle_key`**: Para botões de alternância (`SFXCheckButton`).
- **`default_select_key`**: Para seleção em listas (`SFXOptionButton`, `SFXItemList`).
- **`default_text_input_key`**: Para submissão de texto (`SFXLineEdit`).
- **`default_scroll_key`**: Para eventos de rolagem (`SFXScrollContainer`).
- **`default_focus_key`**: Quando um controle de texto ganha foco (`SFXTextEdit`).
- **`default_error_key`**: Para indicar um erro.
- **`default_warning_key`**: Para indicar um aviso.
- **`default_success_key`**: Para indicar sucesso.
- **`default_open_key`**: Para abrir janelas ou menus.
- **`default_close_key`**: Para fechar janelas ou menus (`SFXWindow`).

### Configurações de Volume

- **`master_volume: float`**: O volume principal do jogo (bus "Master").
- **`sfx_volume: float`**: O volume para o bus "SFX".
- **`music_volume: float`**: O volume para o bus "Music".

Todos os volumes são salvos em uma escala linear de `0.0` a `1.0`.

### `config_changed` (Signal)

O recurso `AudioConfig` emite o signal `config_changed` sempre que uma de suas propriedades é modificada e salva. O `CafeAudioManager` escuta este signal para recarregar as configurações e notificar outros componentes do plugin através do seu próprio signal `audio_config_updated`.
