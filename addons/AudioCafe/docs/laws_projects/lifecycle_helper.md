# Lei do Componente de Ciclo de Vida de Áudio

**Status:** Proposta
**Documento:** `docs/laws_projects/lifecycle_helper.md`

---

### **Preâmbulo**

É um padrão de código comum precisar que um som comece a tocar quando um objeto entra em cena e pare quando ele sai. Atualmente, isso requer código boilerplate nos métodos `_ready()` e `_exit_tree()` do script do objeto. O plugin `Resonate` oferecia uma função `stop_on_exit` para mitigar isso. Esta lei propõe a criação de um componente de nó dedicado para gerenciar esses casos de uso de forma inteiramente visual, sem a necessidade de código.

---

### **Artigo I: O Nó `AudioLifecycleHelper`**

*   **Seção 1.1: Definição:** Será criado um novo tipo de nó, `AudioLifecycleHelper`, que herda de `Node`.
*   **Seção 1.2: Workflow:** O usuário adicionará este nó como filho de qualquer objeto cujo ciclo de vida deva controlar um som (ex: um inimigo, uma tocha, um item temporário).
*   **Seção 1.3: Propriedades Exportadas:** O nó `AudioLifecycleHelper` exporá as seguintes propriedades no `Inspector`:
    *   **Diretriz 1.3.1:** `play_on_ready`: `String` (Chave de SFX do `AudioManifest` a ser tocada quando o nó pai entra na árvore).
    *   **Diretriz 1.3.2:** `is_looping`: `bool` (Se o som deve tocar em loop).
    *   **Diretriz 1.3.3:** `stop_on_exit`: `bool` (Se `true`, o som será parado quando o nó pai sair da árvore).
    *   **Diretriz 1.3.4:** `fade_out_on_exit_seconds`: `float` (O tempo de fade-out a ser usado ao parar o som na saída).

---

### **Artigo II: Lógica de Implementação**

*   **Seção 2.1: Gerenciamento Interno:** Para gerenciar o som de forma isolada, o `AudioLifecycleHelper` não usará o pool global. Em seu método `_ready()`, ele criará uma instância de `AudioStreamPlayer` como seu próprio filho.
*   **Seção 2.2: Lógica `_ready()`:** Se `play_on_ready` não estiver vazio, o helper carregará o `AudioStream` correspondente à chave, o atribuirá ao seu player interno, definirá a propriedade de loop e o tocará.
*   **Seção 2.3: Lógica `_exit_tree()`:** Se `stop_on_exit` for `true`, o helper chamará `stop()` em seu player interno. A lógica de fade-out será implementada através de um `Tween`.

---

### **Conclusão**

A introdução do `AudioLifecycleHelper` elimina a necessidade de código repetitivo para um dos casos de uso mais comuns de áudio em jogos. Ele encapsula a lógica de forma limpa, mantém os scripts de gameplay livres de responsabilidades de áudio e reforça a filosofia do AudioCafe de prover soluções de workflow visuais e de arrastar e soltar.
