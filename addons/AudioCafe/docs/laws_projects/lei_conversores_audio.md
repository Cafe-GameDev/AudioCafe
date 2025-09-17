**Projeto de Lei: Lei dos Conversores de Áudio**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_conversores_audio.md`

---

### **Preâmbulo**

Esta lei estabelece a introdução de funcionalidades de conversão e criação de diferentes tipos de recursos de áudio (`AudioStreamRandomized`, `AudioStreamInteractive`, `AudioStreamSynchronized`) a partir de `AudioStreamPlaylist`s existentes no AudioCafe. O objetivo é oferecer maior flexibilidade na gestão de áudios, permitindo que o usuário adapte o comportamento de reprodução conforme a necessidade do projeto.

---

### **Artigo I: Conversão para AudioStreamRandomized**

1.  **Funcionalidade:** Um botão "Randomized" será adicionado à interface do `AudioPanel` para cada `AudioStreamPlaylist` listada. Ao ser ativado, este botão converterá a `AudioStreamPlaylist` correspondente em um `AudioStreamRandomized`.
2.  **Comportamento:** A conversão de `AudioStreamPlaylist` para `AudioStreamRandomized` será uma substituição. A `AudioStreamPlaylist` original será removida do `AudioManifest` e o `AudioStreamRandomized` resultante será adicionado em seu lugar, na categoria apropriada.
3.  **Salvamento:** O `AudioStreamRandomized` será salvo no caminho definido em `AudioConfig.randomized_save_path`, com o sufixo `_randomized.tres`.

---

### **Artigo II: Criação de AudioStreamInteractive**

1.  **Funcionalidade:** Um botão "Interactive" será adicionado à interface do `AudioPanel` para cada `AudioStreamPlaylist` listada. Ao ser ativado, este botão permitirá ao usuário selecionar múltiplas `AudioStreamPlaylist`s para criar um novo `AudioStreamInteractive`.
2.  **Seleção e Nome:** O usuário poderá selecionar múltiplas `AudioStreamPlaylist`s através de uma interface dedicada. Um `FileDialog` será apresentado para que o usuário escolha o nome do arquivo para o `AudioStreamInteractive`, que será salvo no caminho definido em `AudioConfig.interactive_save_path` e terá o sufixo `_interactive.tres`.
3.  **Estrutura:** Cada `AudioStreamPlaylist` selecionada se tornará um "clip" dentro do `AudioStreamInteractive`.
4.  **Preservação:** As `AudioStreamPlaylist`s originais não serão excluídas após a criação do `AudioStreamInteractive`.

---

### **Artigo III: Criação de AudioStreamSynchronized**

1.  **Funcionalidade:** Um botão "Synchronized" será adicionado à interface do `AudioPanel` para cada `AudioStreamPlaylist` listada. Ao ser ativado, este botão criará uma cópia da `AudioStreamPlaylist` existente, convertendo-a em um `AudioStreamSynchronized`.
2.  **Salvamento:** O `AudioStreamSynchronized` será salvo no caminho definido em `AudioConfig.synchronized_save_path`, com o sufixo `_synchronized.tres`.
3.  **Preservação:** A `AudioStreamPlaylist` original não será excluída após a criação do `AudioStreamSynchronized`.

---

### **Conclusão**

A implementação desta lei proporcionará ao AudioCafe ferramentas robustas para a manipulação de recursos de áudio, permitindo a criação de experiências sonoras mais dinâmicas e complexas no Godot Engine.

---

### **Artigo IV: Artigo Técnico: Implementação**

1.  **Criação de AudioStreamRandomized (Exemplo em GDScript):**
    ```gdscript
    # Supondo que AudioStreamRandomized seja uma nova classe Resource
    # e que AudioStreamPlaylist tenha um método para obter seus streams.
    func convert_to_randomized(playlist_resource_path: String, audio_config: AudioConfig) -> String:
        var playlist = load(playlist_resource_path)
        if not playlist or not playlist is AudioStreamPlaylist:
            push_error("Recurso de playlist inválido: " + playlist_resource_path)
            return ""

        var randomized_stream = AudioStreamRandomized.new()
        for stream in playlist.get_streams(): # get_streams() é um método hipotético
            randomized_stream.add_stream(stream) # add_stream() é um método hipotético

        var file_name = playlist_resource_path.get_file().get_basename()
        var new_path = audio_config.randomized_save_path.path_join(file_name + "_randomized.tres")

        var error = ResourceSaver.save(randomized_stream, new_path)
        if error != OK:
            push_error("Falha ao salvar AudioStreamRandomized: %s" % error)
            return ""
        return new_path
    ```

2.  **Criação de AudioStreamInteractive (Exemplo em GDScript):**
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

3.  **Criação de AudioStreamSynchronized (Exemplo em GDScript):**
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