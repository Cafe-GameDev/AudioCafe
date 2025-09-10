# Lei dos Materiais de Áudio

**Status:** Proposta
**Documento:** `docs/laws_projects/materials.md`

---

### **Preâmbulo**

Para criar ambientes sonoros críveis e reativos, os sons de impacto, como os passos de um personagem, devem corresponder à superfície em que ocorrem. Esta lei estabelece um sistema robusto e flexível para mapear materiais físicos a sons específicos, começando com o caso de uso de passos (`footsteps`).

---

### **Artigo I: Componentes do Sistema**

*   **Seção 1.1: `PhysicsMaterial` (Recurso Nativo):**
    *   **Diretriz 1.1.1:** A base do sistema será o recurso `PhysicsMaterial` nativo da Godot. Os desenvolvedores criarão diferentes materiais (ex: `wood.tres`, `metal.tres`, `grass.tres`) e os aplicarão à propriedade `physics_material_override` dos nós de colisão do cenário.

*   **Seção 1.2: `AudioMaterialMap` (Novo Recurso):**
    *   **Diretriz 1.2.1:** Será criado um novo tipo de `Resource` chamado `AudioMaterialMap`.
    *   **Diretriz 1.2.2:** Este recurso conterá uma única propriedade exportada: `@export var material_map: Dictionary[PhysicsMaterial, String]`. Este dicionário mapeia um recurso `PhysicsMaterial` a uma `sfx_key` do `AudioManifest`.
    *   **Exemplo de Mapeamento:** `[ wood.tres ]: "footsteps_wood"`, `[ grass.tres ]: "footsteps_grass"`.

*   **Seção 1.3: `FootstepHandler` (Novo Nó de Handler):**
    *   **Diretriz 1.3.1:** Será criado um novo nó `FootstepHandler`, seguindo o padrão definido na "Lei dos Manipuladores de Áudio".
    *   **Diretriz 1.3.2:** O desenvolvedor adicionará este nó como filho de seu personagem. O handler terá uma propriedade exportada para receber o recurso `AudioMaterialMap`.

---

### **Artigo II: Lógica de Execução**

*   **Seção 2.1: Gatilho por Animação:**
    *   **Diretriz 2.1.1:** A `AnimationPlayer` do personagem, em vez de tocar um som diretamente, usará uma "Call Method Track" para chamar uma função no `FootstepHandler`, como `play_footstep()`, no exato frame em que o pé toca o chão.

*   **Seção 2.2: Lógica do `FootstepHandler`:**
    *   **Diretriz 2.2.1:** Ao receber a chamada `play_footstep()`, o handler realizará um `raycast` curto para baixo a partir da posição do personagem.
    *   **Diretriz 2.2.2:** Do corpo com o qual o raio colidiu, ele obterá o `PhysicsMaterial`.
    *   **Diretriz 2.2.3:** O handler procurará este `PhysicsMaterial` em seu `AudioMaterialMap`.
    *   **Diretriz 2.2.4:** Se uma `sfx_key` correspondente for encontrada, ele emitirá o sinal `CafeAudioManager.play_sfx_requested` com essa chave (ex: `footsteps_wood`).
    *   **Diretriz 2.2.5:** Se nenhum material for encontrado ou se o material não estiver no mapa, o handler poderá tocar uma chave de passo padrão, também configurável no `Inspector`.

---

### **Conclusão**

Este sistema cria uma ponte elegante entre o mundo físico do jogo (através de `PhysicsMaterial`) и o sistema de áudio do AudioCafe. Ele fornece uma solução escalável e reutilizável para um dos problemas mais comuns no design de som de jogos, mantendo a lógica de áudio encapsulada e o workflow do desenvolvedor limpo e organizado.
