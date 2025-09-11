# Lei da Integração de UI (Nós de Controle SFX)

**Status:** Proposta
**Documento:** `docs/leis/controls.md`

---

### **Preâmbulo**

Os nós de `Control` com SFX integrado (a família `SFX*`) são uma das funcionalidades mais aclamadas do AudioCafe, eliminando a necessidade de código boilerplate para a sonorização de interfaces de usuário. Esta lei reafirma a importância fundamental desses nós, garante sua continuidade na arquitetura v2.0 e estabelece um padrão para sua implementação interna, visando a manutenibilidade e a consistência.

---

### **Artigo I: Manutenção da Funcionalidade Principal**

*   **Seção 1.1: Continuidade do Comportamento:** A funcionalidade central dos nós `SFX*` (ex: `SFXButton`, `SFXSlider`) permanecerá inalterada. Eles continuarão a:
    1.  Herdar do seu nó de `Control` correspondente da Godot.
    2.  Conectar-se aos seus sinais relevantes (`pressed`, `toggled`, `value_changed`, etc.) em seu `_ready()`.
    3.  Emitir o sinal `play_sfx_requested` do `CafeAudioManager` em resposta a esses eventos.

*   **Seção 1.2: Preservação do Sistema de Chaves (Padrão com Override):** O sistema onde cada nó expõe uma ou mais propriedades de chave de SFX (ex: `click_sfx_key`) que, se deixadas em branco, utilizam um valor padrão do `AudioConfig` (ex: `default_click_key`) é a essência desta funcionalidade e será integralmente mantido.

---

### **Artigo II: Integração com a Arquitetura v2.0**

*   **Seção 2.1: Compatibilidade com Sinais v2.0:** A implementação atual dos nós `SFX*` já é compatível com a "Lei dos Sinais". Ao emitir `play_sfx_requested`, eles não fornecerão o novo parâmetro `index`, que por sua vez terá o valor padrão de `-1` no `CafeAudioManager`, ativando o comportamento de reprodução aleatória já esperado. Nenhuma alteração funcional é necessária nos scripts dos nós de controle para esta integração.

*   **Seção 2.2: Conexão com `AudioConfig`:** A lógica existente, onde cada nó se conecta ao sinal `audio_config_updated` para recarregar as chaves padrão em tempo real, continua sendo um requisito essencial e será mantida.

---

### **Artigo III: Refatoração para Manutenibilidade (Classe Base)**

Apesar de a funcionalidade externa não mudar, a implementação interna pode ser significativamente aprimorada para reduzir a duplicação de código e facilitar a manutenção futura.

*   **Seção 3.1: Mandato de Criação de uma Classe Base:**
    *   **Diretriz 3.1.1:** Será criada uma nova classe base, `SFXControlBase.gd`. Esta classe não precisará ser registrada como um tipo customizado, servindo apenas como um script para herança.
    *   **Diretriz 3.1.2:** Esta classe base conterá toda a lógica compartilhada, incluindo:
        *   A conexão inicial com o `CafeAudioManager`.
        *   A função `_on_audio_config_updated(config: AudioConfig)` que carrega as chaves padrão.
        *   Funções auxiliares para tocar os sons (ex: `_play_sfx(key)`).
    *   **Diretriz 3.1.3:** Todos os scripts dos nós `SFX*` (ex: `sfx_button.gd`) serão modificados para herdar de `SFXControlBase` (`extends SFXControlBase`) em vez de herdar diretamente do nó Godot. O script do nó Godot base será movido para a classe `SFXControlBase`. Isso irá simplificar drasticamente o código de cada nó individual, que passará a ter apenas a lógica específica de conexão de seus próprios sinais.

---

### **Conclusão**

Esta lei solidifica o papel dos nós de Controle SFX como um pilar do workflow do AudioCafe. Ela garante que a experiência do usuário final permaneça simples e poderosa, ao mesmo tempo em que impõe um refatoramento interno crucial que melhorará a qualidade do código, a consistência e a facilidade de adicionar novos nós de controle no futuro.
