# Controles de UI com SFX Integrado

O AudioCafe fornece uma coleção de nós de `Control` que estendem os nós de UI padrão do Godot. A principal vantagem é que eles vêm com a capacidade de tocar efeitos sonoros (SFX) automaticamente em resposta a eventos comuns da interface do usuário, como cliques, hovers e mudanças de valor.

## Como Funciona

Cada nó `SFX*` (e.g., `SFXButton`, `SFXSlider`) possui propriedades exportadas no `Inspector` onde você pode especificar a **chave de SFX** a ser tocada para cada evento relevante.

- Se você fornecer uma chave, esse som específico será tocado.
- Se você deixar o campo da chave em branco, o nó usará a **chave padrão** definida no seu recurso `AudioConfig`. Isso permite que você defina um som de "clique" padrão para todo o seu projeto e o substitua apenas quando necessário.

Todos esses nós herdam da classe base `AudioCafe`, então eles se conectam automaticamente ao `CafeAudioManager` para solicitar a reprodução de sons.

## Nós Disponíveis

Aqui está uma lista dos nós de controle disponíveis e os eventos para os quais você pode configurar um SFX:

| Nó                      | Evento(s) com SFX                               | Chave Padrão (de `AudioConfig`) |
|-------------------------|-------------------------------------------------|---------------------------------|
| `SFXButton`             | `pressed`, `mouse_entered`                      | `default_click_key`, `default_hover_key` |
| `SFXCheckButton`        | `toggled`, `mouse_entered`                      | `default_toggle_key`, `default_hover_key` |
| `SFXLinkButton`         | `pressed`, `mouse_entered`                      | `default_click_key`, `default_hover_key` |
| `SFXMenuButton`         | `pressed`, `mouse_entered`                      | `default_click_key`, `default_hover_key` |
| `SFXOptionButton`       | `item_selected`, `mouse_entered`                | `default_select_key`, `default_hover_key` |
| `SFXColorPickerButton`  | `pressed`, `mouse_entered`                      | `default_click_key`, `default_hover_key` |
| `SFXSlider`             | `value_changed`, `mouse_entered`                | `default_slider_key`, `default_hover_key` |
| `SFXSpinBox`            | `value_changed`, `mouse_entered`                | `default_slider_key`, `default_hover_key` |
| `SFXProgressBar`        | `value_changed`                                 | `default_slider_key` |
| `SFXTextureProgressBar` | `value_changed`                                 | `default_slider_key` |
| `SFXItemList`           | `item_selected`, `mouse_entered`                | `default_select_key`, `default_hover_key` |
| `SFXTree`               | `item_selected`, `item_collapsed`, `mouse_entered` | `default_select_key`, `default_toggle_key`, `default_hover_key` |
| `SFXTabContainer`       | `tab_changed`, `mouse_entered`                  | `default_select_key`, `default_hover_key` |
| `SFXLineEdit`           | `text_submitted`, `mouse_entered`               | `default_text_input_key`, `default_hover_key` |
| `SFXTextEdit`           | `focus_entered`, `mouse_entered`                | `default_focus_key`, `default_hover_key` |
| `SFXScrollContainer`    | `scrolled`, `mouse_entered`                     | `default_scroll_key`, `default_hover_key` |
| `SFXPopupMenu`          | `id_pressed`, `mouse_entered`                   | `default_select_key`, `default_hover_key` |
| `SFXWindow`             | `close_requested`, `mouse_entered`              | `default_close_key`, `default_hover_key` |
| `SFXAcceptDialog`       | `confirmed`, `mouse_entered`                    | `default_confirm_key`, `default_hover_key` |
| `SFXConfirmationDialog` | `confirmed`, `mouse_entered`                    | `default_confirm_key`, `default_hover_key` |
| `SFXFileDialog`         | `dir_selected`, `file_selected`, `confirmed`    | `default_select_key`, `default_confirm_key` |
| `SFXColorPicker`        | `color_changed`, `mouse_entered`                | `default_slider_key`, `default_hover_key` |

## Como Usar

1.  Ao adicionar um nó de UI à sua cena, escolha a versão `SFX*` em vez da padrão (e.g., escolha `SFXButton` em vez de `Button`).
2.  No `Inspector`, localize o grupo "SFX Settings".
3.  Digite a chave de SFX desejada nos campos correspondentes (e.g., `click_sfx_key`).
4.  É isso! O som tocará automaticamente quando o evento ocorrer no jogo.
