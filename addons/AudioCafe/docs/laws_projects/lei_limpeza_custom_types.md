@ -0,0 +1,25 @@
---
**Projeto de Lei: Lei da Limpeza de Custom Types**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_limpeza_custom_types.md`

---

### **Preâmbulo**

Esta lei visa otimizar o `EditorPlugin` do AudioCafe, removendo o registro de tipos personalizados (`custom_types`) que não serão mais utilizados na nova arquitetura do plugin. Ao focar exclusivamente na automação de workflow no editor, a necessidade de expor nodes de runtime customizados é eliminada, simplificando o código e reduzindo a superfície de ataque.

---

### **Artigo I: Modificação das Funções de Registro**

1.  **Esvaziamento de `_register_custom_types()`:** A função `_register_custom_types()` no `editor_plugin.gd` será modificada para não conter mais nenhuma chamada `add_custom_type()`.
2.  **Esvaziamento de `_unregister_custom_types()`:** A função `_unregister_custom_types()` no `editor_plugin.gd` será modificada para não conter mais nenhuma chamada `remove_custom_type()`.
3.  **Estado Final:** Ambas as funções ficarão vazias, contendo apenas a palavra-chave `pass`.

---

### **Conclusão**

A implementação desta lei garantirá um `EditorPlugin` mais enxuto e focado, alinhado com o novo propósito do AudioCafe como uma ferramenta de automação de editor, sem a responsabilidade de gerenciar nodes de runtime customizados.