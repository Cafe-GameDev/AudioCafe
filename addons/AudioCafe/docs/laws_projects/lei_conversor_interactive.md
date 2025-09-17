**Projeto de Lei: Lei do Conversor de AudioStreamInteractive**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_conversor_interactive.md`

---

### **Preâmbulo**

Esta lei estabelece a funcionalidade de criação de um `AudioStreamInteractive` a partir da seleção de múltiplas `AudioStreamPlaylist`s. O objetivo é permitir a composição de áudios complexos e interativos, onde diferentes segmentos de áudio (clips) podem ser reproduzidos em sequência ou com base em eventos, proporcionando uma experiência sonora dinâmica.

---

### **Artigo I: Criação de AudioStreamInteractive**

1.  **Funcionalidade:** Um botão "Interactive" será adicionado à interface do `AudioPanel` para cada `AudioStreamPlaylist` listada. Ao ser ativado, este botão permitirá ao usuário selecionar múltiplas `AudioStreamPlaylist`s para criar um novo `AudioStreamInteractive`.
2.  **Seleção e Nome:** O usuário poderá selecionar múltiplas `AudioStreamPlaylist`s através de uma interface dedicada. Um `FileDialog` será apresentado para que o usuário escolha o nome do arquivo para o `AudioStreamInteractive`, que será salvo no caminho definido em `AudioConfig.interactive_save_path` e terá o sufixo `_interactive.tres`.
3.  **Estrutura:** Cada `AudioStreamPlaylist` selecionada se tornará um "clip" dentro do `AudioStreamInteractive`.
4.  **Preservação:** As `AudioStreamPlaylist`s originais não serão excluídas após a criação do `AudioStreamInteractive`.

---

### **Artigo II: Artigo Técnico: Implementação**

1.  **Criação de AudioStreamInteractive (Exemplo em GDScript):**
    ```gdscript
    # Supondo que AudioStreamInteractive seja uma nova classe Resource
    # e que ela tenha um método para adicionar clips.
    func create_interactive(playlist_resource_paths: Array[String], interactive_name: String, audio_config: AudioConfig) -> String:
        var interactive_stream = AudioStreamInteractive.new()

        for path in playlist_resource_paths:
            var playlist = load(path)
            if not playlist or not playlist is AudioStreamPlaylist:
                push_error("Recurso de playlist inválido: " + path)
                return ""
            interactive_stream.add_clip(playlist) # add_clip() é um método hipotético

        var new_path = audio_config.interactive_save_path.path_join(interactive_name + "_interactive.tres")

        var error = ResourceSaver.save(interactive_stream, new_path)
        if error != OK:
            push_error("Falha ao salvar AudioStreamInteractive: %s" % error)
            return ""
        return new_path
    ```