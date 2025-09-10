# Lei dos Manipuladores de Áudio (Audio Handlers)

**Status:** Proposta
**Documento:** `docs/leis/handlers.md`

---

### **Preâmbulo**

Para promover uma arquitetura de áudio limpa, escalável e organizada, e para evitar a sobrecarga de lógica de áudio em scripts de jogadores ou de níveis, esta lei estabelece um novo tipo de componente no ecossistema AudioCafe: o **Audio Handler**. Handlers são nós especializados e autocontidos, projetados para gerenciar cenários de áudio complexos e específicos de uma cena.

---

### **Artigo I: Definição e Propósito do `AudioHandler`**

*   **Seção 1.1: O que é um `AudioHandler`?:** Um `AudioHandler` é um `Node`-based script/scene projetado para gerenciar um domínio de áudio específico dentro de uma cena (e.g., `LevelAmbianceHandler`, `PlayerFootstepsHandler`, `BossMusicHandler`). Ele atua como um "diretor de áudio local".

*   **Seção 1.2: Problemas que Resolve:**
    1.  **Separação de Responsabilidades:** Remove a lógica de áudio complexa de outros scripts, mantendo o código limpo e focado.
    2.  **Reutilização:** Um `Handler` bem projetado (como um `FootstepHandler`) pode ser facilmente reutilizado em diferentes personagens ou projetos.
    3.  **Organização:** Permite que a árvore de cena reflita a estrutura da lógica de áudio, facilitando a depuração e o entendimento.

---

### **Artigo II: Implementação de Referência - O `AmbianceHandler`**

Para solidificar o conceito, o AudioCafe v2.0 irá incluir um `Handler` pronto para uso, focado no caso de uso mais comum: áudio ambiental baseado em zonas.

*   **Seção 2.1: Funcionalidade do `AmbianceHandler`:**
    *   Será um nó (`AmbianceHandler.tscn`) que o usuário pode adicionar à sua cena de nível.
    *   Ele se conectará automaticamente ao sinal `CafeAudioManager.zone_event_triggered`.
    *   Sua principal propriedade será um dicionário exportado: `@export var zone_playlist_map: Dictionary[String, AudioStreamPlaylist]`. Este dicionário mapeia o `zone_name` de um `AudioZone` para um recurso `AudioStreamPlaylist` que deve tocar quando o jogador entrar naquela zona.

*   **Seção 2.2: Lógica de Operação:**
    *   O `AmbianceHandler` manterá um pool interno de `AudioStreamPlayer`s para tocar múltiplos sons ambientes simultaneamente (ex: som de floresta e som de rio próximo).
    *   Quando o sinal `zone_event_triggered` for recebido, o handler verificará se o `zone_name` do evento existe em seu `zone_playlist_map`.
    *   Se existir, ele pegará um player de seu pool e começará a tocar a `AudioStreamPlaylist` associada, com um fade-in suave.
    *   Ao sair da zona, o som correspondente sofrerá um fade-out e o player será liberado.
    *   O handler terá uma lógica para gerenciar prioridades ou crossfades ao se mover entre zonas adjacentes.

---

### **Artigo III: Diretrizes para Handlers Futuros**

*   **Seção 3.1: Padrão de Design:** Handlers futuros, sejam eles parte do plugin ou criados por usuários, devem seguir o padrão de serem nós autocontidos que escutam sinais globais (do `CafeAudioManager`) e/ou sinais locais para executar uma lógica de áudio específica e encapsulada.

*   **Seção 3.2: Exemplos para Ilustrar o Conceito:**
    *   **`FootstepHandler`:** Poderia ter um dicionário mapeando tipos de `PhysicsMaterial` para chaves de SFX de passos. Ele obteria o material do chão abaixo do jogador a cada passo e tocaria o som correspondente.
    *   **`MusicStateHandler`:** Gerenciaria a trilha sonora de um nível. Poderia expor funções como `set_music_state("COMBAT")` ou `set_music_state("EXPLORATION")`, que por sua vez chamariam a função `travel()` em um recurso `AudioStreamInteractive` central para aquele nível.

---

### **Conclusão**

A introdução do conceito de `AudioHandler` e a provisão de uma implementação de referência (`AmbianceHandler`) adicionam uma camada crucial de organização e escalabilidade ao AudioCafe. Este padrão capacita os desenvolvedores a construir sistemas de áudio complexos de forma modular e limpa, reforçando a posição do AudioCafe como um framework de áudio completo.
