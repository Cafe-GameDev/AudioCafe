# Constituição do Estilo de Código

**Status:** Constitucional
**Documento:** `docs/laws_constitution/styleguide.md`

---

### **Preâmbulo**

Um estilo de código consistente é fundamental para a legibilidade, manutenibilidade e colaboração em qualquer projeto de software. Esta lei estabelece as diretrizes de estilo de código para todo o desenvolvimento do AudioCafe.

### **Artigo I: Princípios Gerais**

1.  **Clareza e Legibilidade:** O código deve ser fácil de ler e entender por qualquer desenvolvedor familiarizado com GDScript.
2.  **Consistência:** Manter o estilo consistente em todo o projeto, mesmo que isso signifique adaptar-se a um estilo existente em um arquivo específico.
3.  **Simplicidade:** Preferir soluções simples e diretas em vez de complexas e excessivamente inteligentes.

### **Artigo II: Convenções de Nomenclatura**

1.  **Classes:** `PascalCase` (ex: `MyCustomNode`, `PlayerController`).
2.  **Funções/Métodos:** `snake_case` (ex: `_ready`, `process_input`, `calculate_damage`).
3.  **Variáveis:** `snake_case` (ex: `player_speed`, `current_health`).
4.  **Constantes:** `SCREAMING_SNAKE_CASE` (ex: `MAX_SPEED`, `JUMP_VELOCITY`).
5.  **Variáveis Membro Privadas:** Prefixo `_` (underscore) para indicar que a variável é de uso interno da classe (ex: `_current_state`, `_target_position`).

### **Artigo III: Formatação**

1.  **Indentação:** Usar **4 espaços** para indentação. Não usar tabs.
2.  **Quebra de Linha:** Limitar linhas a aproximadamente 100-120 caracteres para melhorar a legibilidade.
3.  **Espaços:**
    *   Usar espaços ao redor de operadores (ex: `a = b + c`).
    *   Usar espaços após vírgulas em listas e argumentos (ex: `func my_func(arg1, arg2):`).
    *   Não usar espaços imediatamente dentro de parênteses, colchetes ou chaves (ex: `my_array[index]`, `my_dict["key"]`).

### **Artigo IV: Comentários**

1.  **Propósito:** Comentar *por que* algo é feito, não *o que* é feito. O código deve ser autoexplicativo sempre que possível.
2.  **Moderação:** Usar comentários com moderação. Código limpo e bem nomeado é preferível a comentários excessivos.

### **Artigo V: Tipagem**

1.  **Uso de Tipos:** Recomendar o uso de tipagem estática para variáveis, argumentos de função e retornos de função sempre que possível. Isso melhora a clareza, a detecção de erros e o autocompletar do editor.
