**Projeto de Lei: Lei da Desvinculação de Componentes de Runtime**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_desvinculacao_componentes_runtime.md`

---

### **Preâmbulo**

Esta lei visa eliminar todas as referências e dependências dos componentes de runtime do AudioCafe que serão descontinuados. O objetivo é garantir que o código remanescente esteja livre de menções a sistemas como `CafeAudioManager`, `AudioPosition` e `AudioZone`, consolidando a transição para um plugin focado exclusivamente em automação de editor.

---

### **Artigo I: Remoção de Autoload e Referências**

1.  **Remoção do Autoload `CafeAudioManager`:** O instanciamento do autoload `CafeAudioManager` no `editor_plugin.gd` será removido. Isso inclui a remoção das constantes `AUTOLOAD_NAME` e `AUTOLOAD_PATH`, e a lógica de `add_autoload_singleton`/`remove_autoload_singleton` nas funções `_enter_tree()` e `_exit_tree()`.
2.  **Remoção de Menções em Scripts:** Toda e qualquer menção ou dependência de `CafeAudioManager`, `AudioPosition` e `AudioZone` em outros scripts que permanecerão no projeto (ex: `scripts/audio_panel.gd`) será removida ou comentada, conforme a necessidade de cada script.

---

### **Conclusão**

A implementação desta lei garantirá a independência do AudioCafe de seus antigos componentes de runtime, permitindo que o plugin opere de forma limpa e focada em seu novo propósito.