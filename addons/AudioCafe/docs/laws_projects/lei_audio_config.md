**Projeto de Lei: Lei das Novas Propriedades do AudioConfig**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_audio_config.md`

---

### **Preâmbulo**

Esta lei estabelece a adição de novas propriedades ao recurso `AudioConfig` para suportar as funcionalidades de criação e gerenciamento de `AudioStreamInteractive` e para centralizar as definições de caminhos de salvamento para todos os tipos de recursos de áudio. O objetivo é permitir que o usuário configure o comportamento padrão para a criação desses novos tipos de recursos, otimizando o fluxo de trabalho e garantindo a flexibilidade na definição dos diretórios de saída.

---

### **Artigo I: Propriedades para Caminhos de Salvamento**

1.  **`playlist_save_path`:** Uma nova propriedade `String` será adicionada ao `AudioConfig` para definir o caminho padrão onde os recursos `AudioStreamPlaylist` serão salvos. O valor padrão será `res://dist/playlist/`.
2.  **`randomized_save_path`:** Uma nova propriedade `String` será adicionada ao `AudioConfig` para definir o caminho padrão onde os recursos `AudioStreamRandomized` serão salvos. O valor padrão será `res://dist/randomized/`.
3.  **`interactive_save_path`:** Uma nova propriedade `String` será adicionada ao `AudioConfig` para definir o caminho padrão onde os recursos `AudioStreamInteractive` serão salvos. O valor padrão será `res://dist/interactive/`.
4.  **`synchronized_save_path`:** Uma nova propriedade `String` será adicionada ao `AudioConfig` para definir o caminho padrão onde os recursos `AudioStreamSynchronized` serão salvos. O valor padrão será `res://dist/synchronized/`.

---

### **Conclusão**

A implementação desta lei garantirá que o `AudioConfig` seja um recurso centralizado para todas as configurações do AudioCafe, incluindo as novas funcionalidades de áudio interativo e a gestão de caminhos de salvamento.