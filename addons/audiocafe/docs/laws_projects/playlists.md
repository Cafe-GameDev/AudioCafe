# Lei da Geração de Ativos de Playlist

**Status:** Proposta
**Documento:** `docs/laws_projects/playlists.md`

---

### **Preâmbulo**

Para alavancar os recursos nativos do Godot 4.3+ e fornecer um workflow moderno, esta lei estabelece um processo de **geração automática de recursos `AudioStreamPlaylist`**. Este processo funciona em paralelo com a geração do manifesto v1, transformando a estrutura de pastas do projeto em ativos de playlist prontos para uso.

---

### **Artigo I: Processo de Geração Aditivo**

*   **Seção 1.1: Workflow Paralelo:** A geração de playlists é um processo aditivo que ocorre durante a execução do script `generate_audio_manifest.gd`, imediatamente após a conclusão da geração do `AudioManifest.tres` v1. Este processo não altera nem substitui o manifesto v1, garantindo total retrocompatibilidade.

---

### **Artigo II: Lógica de Geração Programática**

*   **Seção 2.1: Fonte de Dados:** O processo utilizará o `AudioManifest.tres` recém-gerado como sua fonte da verdade, iterando sobre suas chaves de música e SFX.

*   **Seção 2.2: Passos da Geração:** Para cada chave no manifesto (ex: `sfx_ui_click`):
    1.  Um novo objeto `AudioStreamPlaylist` será criado em memória.
    2.  Para cada UID no array de UIDs da chave, o `AudioStream` correspondente será carregado.
    3.  Cada `AudioStream` carregado será adicionado à lista de streams da nova playlist.
    4.  As propriedades padrão da playlist (loop, shuffle, fade time) serão definidas com base nos valores do `AudioConfig`.
    5.  O recurso final será salvo em um subdiretório específico, usando o nome da chave como nome do arquivo.
    6.  Após salvar, o script registrará o caminho do novo recurso no dicionário `generated_playlists` do `AudioConfig` e salvará o `AudioConfig`.

---

### **Artigo III: Configuração**

*   **Seção 3.1: Referência ao `AudioConfig`:** O caminho de destino para os ativos gerados (`generated_assets_path`) e as configurações padrão para as novas playlists (`default_playlist_loop`, `default_playlist_shuffle`, `default_playlist_fade_time`) são definidos no recurso `AudioConfig`, conforme a "Lei da Configuração Central".

---

### **Conclusão**

A geração automática de `AudioStreamPlaylist`s é um pilar do workflow do AudioCafe v2.0. Ela fornece ao desenvolvedor blocos de construção de áudio nativos e organizados, prontos para serem usados diretamente ou convertidos em sistemas mais complexos, acelerando drasticamente o processo de sound design.
