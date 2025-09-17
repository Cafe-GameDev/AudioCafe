**Projeto de Lei: Lei do Conversor de AudioStreamSynchronized**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_conversor_synchronized.md`

---

### **Preâmbulo**

Esta lei estabelece a funcionalidade de criação de um `AudioStreamSynchronized` a partir de uma `AudioStreamPlaylist` existente. O objetivo é permitir a reprodução de áudios de forma sincronizada com outros elementos do jogo, garantindo que o áudio comece e termine em momentos específicos, ideal para trilhas sonoras que precisam se alinhar a eventos visuais ou de gameplay.

---

### **Artigo I: Criação de AudioStreamSynchronized**

1.  **Funcionalidade:** Um botão "Synchronized" será adicionado à interface do `AudioPanel` para cada `AudioStreamPlaylist` listada. Ao ser ativado, este botão criará uma cópia da `AudioStreamPlaylist` existente, convertendo-a em um `AudioStreamSynchronized`.
2.  **Salvamento:** O `AudioStreamSynchronized` será salvo no caminho definido em `AudioConfig.synchronized_save_path`, com o sufixo `_synchronized.tres`.
3.  **Preservação:** A `AudioStreamPlaylist` original não será excluída após a criação do `AudioStreamSynchronized`.

---

### **Artigo II: Artigo Técnico: Implementação**

1.  **Criação de AudioStreamSynchronized (Exemplo em GDScript):**
    ```gdscript
    # Supondo que AudioStreamSynchronized seja uma nova classe Resource
    func create_synchronized(playlist_resource_path: String, audio_config: AudioConfig) -> String:
        var playlist = load(playlist_resource_path)
        if not playlist or not playlist is AudioStreamPlaylist:
            push_error("Recurso de playlist inválido: " + playlist_resource_path)
            return ""

        var synchronized_stream = AudioStreamSynchronized.new()
        synchronized_stream.set_playlist(playlist) # set_playlist() é um método hipotético

        var file_name = playlist_resource_path.get_file().get_basename()
        var new_path = audio_config.synchronized_save_path.path_join(file_name + "_synchronized.tres")

        var error = ResourceSaver.save(synchronized_stream, new_path)
        if error != OK:
            push_error("Falha ao salvar AudioStreamSynchronized: %s" % error)
            return ""
        return new_path
    ```