# Lei da Integração com Máquinas de Estado (v2.0)

**Status:** Proposta
**Documento:** `docs/leis/statemachine.md`

---

### **Preâmbulo**

O nó `AudioPosition` é o principal componente do AudioCafe para áudio diegético e reativo a estados de jogo. Com a substituição da lógica de dicionário pelo `AudioStreamInteractive` nativo, o método de integração com máquinas de estado (`State Machines`) muda fundamentalmente. Esta lei estabelece o novo fluxo de trabalho e o padrão de implementação recomendado para conectar a lógica de estado do jogo ao `AudioPosition` v2.0.

---

### **Artigo I: O Workflow Baseado em `AudioStreamInteractive`**

A responsabilidade pela "lógica" do áudio (qual som tocar e quando) é transferida do código para um recurso visual, desacoplando o trabalho do programador do trabalho do designer de som.

*   **Seção 1.1: Design do Áudio no Editor:** O fluxo de trabalho começa no editor da Godot, não no código.
    1.  **Criação do Recurso:** O usuário primeiro cria um recurso `AudioStreamInteractive` (seja pelo `AudioPanel` ou pelo menu do FileSystem).
    2.  **Design Visual:** Dentro do editor de áudio interativo, o usuário irá adicionar seus clipes de áudio (ex: `walk_loop.ogg`, `jump.ogg`) e definir as transições nomeadas entre eles. Por exemplo, uma transição chamada `"jump"` que leva do clipe de caminhada para o clipe de pulo, e uma transição `"land"` que leva de um clipe de "caindo no ar" para o som de aterrissagem.
    3.  **Associação:** O usuário arrasta este recurso `AudioStreamInteractive` para a propriedade `interactive_stream` do nó `AudioPosition` na cena do personagem.

---

### **Artigo II: Implementação no Código da Máquina de Estado**

O código da máquina de estado se torna mais simples e mais declarativo. Ele não se preocupa mais com *qual* som tocar, apenas com *qual evento de jogo* aconteceu.

*   **Seção 2.1: O Método `travel()` como Interface Principal:** A interação primária do código com o `AudioPosition` será através da chamada de um único método: `audio_position.travel("nome_da_transicao")`. O nome da transição deve corresponder exatamente ao nome definido no editor do `AudioStreamInteractive`.

*   **Seção 2.2: Exemplo de Implementação:**
    ```gdscript
    # player.gd (Exemplo v2.0)
    extends CharacterBody2D

    @onready var audio_position: AudioPosition2D = $AudioPosition2D

    var current_state: State = State.IDLE

    func change_state(new_state: State):
        # Lógica para quando o estado antigo termina
        match current_state:
            State.FALL:
                if new_state == State.IDLE or new_state == State.WALK:
                    # Aciona a transição "land" definida no AudioStreamInteractive
                    audio_position.travel("land")

        # Lógica para quando o novo estado começa
        match new_state:
            State.WALK:
                audio_position.travel("walk")
            State.JUMP:
                audio_position.travel("jump")
            State.IDLE:
                # Exemplo: se o som de walk estiver tocando, podemos ter uma 
                # transição para um estado de silêncio ou fade-out.
                audio_position.travel("stop_walking")

        current_state = new_state
    ```

*   **Seção 2.3: Vantagens da Nova Abordagem:**
    *   **Desacoplamento:** O programador só precisa saber os nomes dos eventos (`"jump"`, `"land"`). O designer de som pode alterar os sons, os tempos de fade e a lógica de transição no recurso `AudioStreamInteractive` sem nunca tocar no código.
    *   **Poder Nativo:** Permite o uso de todas as funcionalidades avançadas do `AudioStreamInteractive`, como transições baseadas em batida (BPM), múltiplos pontos de entrada e saída, e crossfades complexos, tudo gerenciado pela engine.

---

### **Artigo III: Gerenciamento de Sons Não-Estatais**

*   **Seção 3.1: Manutenção do `play_secondary_sound()`:** Para sons que podem ocorrer a qualquer momento e não fazem parte da máquina de estados principal (ex: receber dano, coletar um item), o método `audio_position.play_secondary_sound("sfx_key")` continua sendo a abordagem correta. Ele toca um som "por cima" do áudio interativo principal sem interrompê-lo.

---

### **Artigo IV: Garantia de Retrocompatibilidade (v1)**

*   **Seção 4.1: Preservação do Sistema de Dicionário:** Para garantir que projetos existentes não quebrem, o nó `AudioPosition` **manterá** a propriedade `@export var state_audio: Dictionary` e o método `set_state(state_key: String)` da v1.

*   **Seção 4.2: Lógica de Execução Dupla:**
    *   O novo sistema (`interactive_stream` e `travel()`) é o método preferencial.
    *   O método `set_state()` da v1 continuará a funcionar como antes, usando o `AudioManifest`.
    *   Se um desenvolvedor tentar usar ambos os sistemas no mesmo nó `AudioPosition` (ex: atribuir um `interactive_stream` e também chamar `set_state()`), o nó dará prioridade ao novo sistema e emitirá um `push_warning` no console, recomendando a migração completa para o `AudioStreamInteractive` para evitar comportamentos conflitantes.

---

### **Conclusão**

Esta lei estabelece um padrão de integração moderno e robusto para o `AudioPosition`. Ao adotar o `AudioStreamInteractive` como peça central, o AudioCafe v2.0 promove um fluxo de trabalho mais limpo, mais poderoso e mais colaborativo entre programadores e designers de som, permitindo a criação de experiências de áudio dinâmicas com maior facilidade e flexibilidade.
