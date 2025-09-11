# Lei da Unificação do AudioPosition

**Status:** Proposta
**Documento:** `docs/laws_projects/unified_audioposition.md`

---

### **Preâmbulo**

Atualmente, o AudioCafe exige que o usuário escolha entre `AudioPosition2D` e `AudioPosition3D`, o que adiciona uma pequena carga cognitiva e é um ponto de erro potencial (usar o nó errado para a dimensão da cena). O plugin `Resonate` possuía uma detecção automática de espaço, uma melhoria de qualidade de vida que o AudioCafe pode adotar para tornar seu uso mais fluido e inteligente.

---

### **Artigo I: Unificação dos Nós**

*   **Seção 1.1: Novo Nó `AudioPosition`:** Fica proposta a criação de um único nó `AudioPosition` que substituirá os atuais `AudioPosition2D` e `AudioPosition3D`.
*   **Seção 1.2: Depreciação:** Os nós `AudioPosition2D` e `AudioPosition3D` serão marcados como depreciados e, eventualmente, removidos em uma futura versão `MAJOR`.

---

### **Artigo II: Lógica de Detecção de Espaço**

*   **Seção 2.1: Arquitetura Interna:** O novo nó `AudioPosition` não herdará diretamente de nenhum `AudioStreamPlayer`. Ele atuará como um **nó proxy**.
*   **Seção 2.2: Lógica em `_ready()`:**
    *   **Diretriz 2.2.1:** No seu método `_ready()`, o `AudioPosition` irá inspecionar seu nó pai com `get_parent()`.
    *   **Diretriz 2.2.2:** Se o pai for um `Node3D` (ou herdar dele), o `AudioPosition` instanciará um `AudioStreamPlayer3D` como seu filho interno e o armazenará em uma variável (ex: `_internal_player`).
    *   **Diretriz 2.2.3:** Se o pai for um `Node2D` (ou herdar dele), ele instanciará um `AudioStreamPlayer2D` como filho.
    *   **Diretriz 2.2.4:** Se o pai não for nem 2D nem 3D, ele emitirá um `push_warning` e usará um `AudioStreamPlayer` padrão (não posicional).

---

### **Artigo III: API e Compatibilidade**

*   **Seção 3.1: Interface Consistente:** A API pública do `AudioPosition` será mantida. Métodos como `set_state()`, `play_secondary_sound()` e o futuro `travel()` continuarão a existir.
*   **Seção 3.2: Delegação de Chamadas:** O nó `AudioPosition` simplesmente delegará as chamadas para seu `_internal_player`. Por exemplo, a chamada `AudioPosition.play()` internamente chamará `_internal_player.play()`.

---

### **Conclusão**

Esta unificação simplifica a experiência do usuário, alinhando-se à filosofia do AudioCafe de ser uma ferramenta intuitiva que "simplesmente funciona". Ao remover uma escolha desnecessária, reduzimos a chance de erro e tornamos o plugin mais elegante e fácil de usar, sem sacrificar nenhuma funcionalidade.
