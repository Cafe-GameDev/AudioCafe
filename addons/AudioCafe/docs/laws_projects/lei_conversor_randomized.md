**Projeto de Lei: Lei do Conversor de AudioStreamRandomized**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_conversor_randomized.md`

---

### **Preâmbulo**

Esta lei estabelece a funcionalidade de conversão de uma `AudioStreamPlaylist` existente em um `AudioStreamRandomized`. O objetivo é permitir que o usuário alterne o comportamento de reprodução de uma sequência linear para uma seleção aleatória de streams de áudio, otimizando o uso para efeitos sonoros ou músicas com variações.

---

### **Artigo I: Conversão para AudioStreamRandomized**

1.  **Funcionalidade:** Um botão "Randomized" será adicionado à interface do `AudioPanel` para cada `AudioStreamPlaylist` listada. Ao ser ativado, este botão converterá a `AudioStreamPlaylist` correspondente em um `AudioStreamRandomized`.
2.  **Comportamento:** A conversão de `AudioStreamPlaylist` para `AudioStreamRandomized` será uma substituição. A `AudioStreamPlaylist` original será removida do `AudioManifest` e o `AudioStreamRandomized` resultante será adicionado em seu lugar, na categoria apropriada.
3.  **Salvamento:** O `AudioStreamRandomized` será salvo no caminho definido em `AudioConfig.randomized_save_path`, com o sufixo `_randomized.tres`.

---

### **Artigo II: Artigo Técnico: Implementação**

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