**Projeto de Lei: Lei da Estrutura do AudioManifest**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_audio_manifest_estrutura.md`

---

### **Preâmbulo**

Esta lei estabelece a reestruturação do `AudioManifest` para acomodar e categorizar de forma eficiente os novos tipos de recursos de áudio (`AudioStreamRandomized`, `AudioStreamInteractive`, `AudioStreamSynchronized`), além dos já existentes `AudioStreamPlaylist`. O objetivo é garantir que o `AudioManifest` sirva como um índice centralizado e organizado para todos os recursos de áudio gerados pelo plugin.

---

### **Artigo I: Categorização de Recursos de Áudio**

1.  **Dicionários Separados:** O `AudioManifest` será modificado para incluir dicionários separados para cada tipo de recurso de áudio, permitindo uma categorização clara e acesso facilitado:
    *   `music_playlists: Dictionary` (para `AudioStreamPlaylist` de música)
    *   `sfx_playlists: Dictionary` (para `AudioStreamPlaylist` de efeitos sonoros)
    *   `randomized_streams: Dictionary` (para `AudioStreamRandomized`)
    *   `interactive_streams: Dictionary` (para `AudioStreamInteractive`)
    *   `synchronized_streams: Dictionary` (para `AudioStreamSynchronized`)
2.  **Chaves e Valores:** Cada dicionário armazenará pares de chave-valor, onde a chave será o identificador único do recurso (ex: nome do arquivo sem sufixo) e o valor será o caminho `res://` para o arquivo `.tres` correspondente.

---

### **Artigo II: Atualização da Lógica de Geração**

1.  **GenerateAudioManifest:** O script `generate_audio_manifest.gd` será atualizado para popular corretamente os novos dicionários no `AudioManifest` durante o processo de geração, identificando o tipo de recurso e sua categoria (música ou SFX, quando aplicável).
2.  **Remoção de Playlists Convertidas:** Quando uma `AudioStreamPlaylist` for convertida para `AudioStreamRandomized`, a entrada correspondente em `music_playlists` ou `sfx_playlists` será removida, e a nova entrada será adicionada em `randomized_streams`.

---

### **Conclusão**

A implementação desta lei garantirá que o `AudioManifest` seja uma estrutura de dados robusta e bem organizada, essencial para o gerenciamento eficaz dos diversos recursos de áudio no AudioCafe.