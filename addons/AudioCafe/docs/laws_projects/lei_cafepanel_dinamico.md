**Projeto de Lei: Lei do CafePanel Dinâmico**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_cafepanel_dinamico.md`

---

### **Preâmbulo**

Esta lei estabelece a transição do `CafePanel` de uma cena (`.tscn`) para uma criação inteiramente dinâmica em tempo de execução pelo `EditorPlugin`. O objetivo é simplificar a manutenção, remover dependências de arquivos de cena para um componente sem lógica própria e garantir que ele funcione como um hub genérico para outros painéis de plugins, mantendo a capacidade de verificar se já existe uma instância no editor.

---

### **Artigo I: Criação Dinâmica do CafePanel**

1.  **Substituição da Cena por Código:** A função `_create_plugin_panel()` no `editor_plugin.gd` será modificada para criar o `CafePanel` (um `ScrollContainer` com um `VBoxContainer` interno) inteiramente via código, em vez de carregar e instanciar `cafe_panel.tscn`.
2.  **Propriedades de Layout:** O `ScrollContainer` e o `VBoxContainer` criados dinamicamente terão suas propriedades de layout (como `name`, `h_scroll_mode`, `anchors_and_offsets_preset`, `follow_focus`, `layout_mode`, `h_size_flags`, `v_size_flags`) definidas para replicar o comportamento e a aparência da cena original.
3.  **Verificação de Existência:** A lógica existente para verificar se um `CafePanel` (`"CafeEngine"`) já está presente no editor será mantida e respeitada, garantindo que apenas uma instância seja criada.

---

### **Artigo II: Exclusão de Arquivos Obsoletos**

1.  **Remoção de Cena e Script:** Após a implementação e verificação bem-sucedida da criação dinâmica, os arquivos `cafe_panel.tscn` e `scripts/cafe_panel.gd` (juntamente com seus arquivos `.uid` correspondentes) serão excluídos do projeto.

---

### **Conclusão**

A implementação desta lei garantirá um `CafePanel` mais leve, flexível e independente de arquivos de cena, alinhado com a filosofia de automação de workflow do novo AudioCafe.