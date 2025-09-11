# Lei do Manifesto de Compatibilidade (v1.0)

**Status:** Proposta
**Documento:** `docs/laws_projects/manifest.md`

---

### **Preâmbulo**

Para evoluir as capacidades do AudioCafe em alinhamento com o Godot 4.3+ sem invalidar projetos existentes, esta lei estabelece o papel do `AudioManifest.tres` como um **mecanismo de compatibilidade**. O objetivo é garantir que a lógica de áudio da v1 continue funcionando perfeitamente, enquanto o novo workflow de geração de ativos (`AudioStreamPlaylist`) se torna o padrão recomendado.

---

### **Artigo I: Manutenção e Propósito do Manifesto v1**

*   **Seção 1.1: Preservação Integral:** Fica estabelecido que a estrutura e o processo de geração do arquivo `res://addons/AudioCafe/resources/audio_manifest.tres` serão integralmente preservados. Ele continuará a mapear chaves de texto para arrays de UIDs de áudio.

*   **Seção 1.2: Função de Compatibilidade:** A principal função deste manifesto na v2.0 é garantir que toda a lógica de jogo existente que depende de acesso direto a UIDs (como chamadas a `play_secondary_sound` ou scripts legados) continue funcionando sem qualquer modificação.

---

### **Artigo II: Coexistência com Ativos Gerados**

*   **Seção 2.1: Processos Paralelos:** O `AudioManifest.tres` é o primeiro artefato gerado pelo script `generate_audio_manifest.gd`. Ele serve como fonte de dados para o processo subsequente de geração de playlists, conforme definido na "Lei da Geração de Ativos de Playlist".

*   **Seção 2.2: Lógica de Acesso de Camada Dupla:** O `CafeAudioManager` implementará um sistema de acesso transparente para garantir a coexistência dos dois sistemas.
    *   **Diretriz 2.2.1 (Prioridade v2):** Ao receber um pedido de áudio (ex: `play_music_requested("level_theme")`), o gerenciador primeiro tentará carregar o recurso `AudioStreamPlaylist` correspondente do diretório de ativos gerados. Se encontrado, este será o recurso utilizado.
    *   **Diretriz 2.2.2 (Fallback v1):** Se o recurso de playlist não for encontrado, o gerenciador reverterá para a lógica v1, procurando a chave no `AudioManifest.tres` e tocando um UID aleatório do array.

---

### **Conclusão**

Esta lei formaliza um plano de evolução robusto e seguro. Ao definir o `AudioManifest.tres` como uma camada de compatibilidade e priorizar o uso dos novos `AudioStreamPlaylist`s, introduzimos um workflow moderno e poderoso que alavanca os recursos nativos da Godot, ao mesmo tempo que garantimos estabilidade total para projetos existentes. Esta abordagem permite uma transição suave e opcional para os novos sistemas.
