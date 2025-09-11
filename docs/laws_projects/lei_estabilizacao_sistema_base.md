---
**Projeto de Lei: Lei da Estabilização do Sistema Base**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_estabilizacao_sistema_base.md`

---

### **Preâmbulo**

Esta lei define a etapa final da fase de limpeza e preparação do AudioCafe. O objetivo é garantir que os componentes essenciais que permanecerão no plugin (configuração, painel do editor e o script de geração de manifest) estejam funcionando perfeitamente e de forma isolada, servindo como uma base sólida para a implementação do novo workflow de automação.

---

### **Artigo I: Verificação e Estabilização dos Componentes Remanescentes**

1.  **Funcionamento do `AudioConfig`:** Será verificado e garantido que o recurso `AudioConfig` (`scripts/audio_config.gd`) esteja livre de erros e funcionando conforme o esperado, especialmente no que diz respeito à manipulação de caminhos, volumes e chaves padrão.
2.  **Funcionamento do `AudioPanel`:** Será verificado e garantido que o `AudioPanel` (`scenes/audio_panel.tscn`) esteja sendo carregado e exibido corretamente no editor, e que sua interface esteja funcional após as remoções de dependências.
3.  **Funcionamento do `generate_audio_manifest.gd`:** Será verificado e garantido que o script `generate_audio_manifest.gd` (que será o último a ser excluído) esteja funcionando corretamente em seu estado atual, pois sua lógica será reaproveitada para os novos scripts de geração.

---

### **Conclusão**

A implementação desta lei marcará o fim da fase de limpeza, deixando o AudioCafe com uma base de código enxuta, estável e pronta para a construção do novo workflow de automação de editor.
