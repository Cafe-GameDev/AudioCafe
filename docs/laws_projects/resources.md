# Lei dos Recursos de Dados

**Status:** Proposta
**Documento:** `docs/laws_projects/resources.md`

---

### **Preâmbulo**

Para garantir a clareza, a consistência e a manutenibilidade da arquitetura de dados do AudioCafe, esta lei estabelece e define todos os tipos de `Resource` customizados utilizados pelo plugin, bem como a forma como os recursos nativos da Godot são empregados.

---

### **Artigo I: `AudioConfig.tres`**

*   **Classe:** `AudioConfig` (herda de `Resource`)
*   **Propósito:** Atuar como a **única fonte da verdade** para todas as configurações globais do plugin que são gerenciadas pelo usuário e pelo sistema.
*   **Propriedades Chave:**
    *   `sfx_paths`, `music_paths`: Caminhos de busca para a geração de ativos.
    *   `default_*_key`: Chaves de SFX padrão para os nós de UI.
    *   `master_volume`, `sfx_volume`, `music_volume`: Volumes globais dos buses.
    *   `generated_assets_path`: Caminho de destino para os recursos gerados.
    *   `generated_playlists`: Dicionário que cataloga todas as `AudioStreamPlaylist`s geradas pelo plugin, mapeando sua chave ao seu caminho de arquivo.
*   **Ciclo de Vida:** É um recurso singleton, normalmente existindo apenas uma instância em `res://addons/AudioCafe/resources/audio_config.tres`. É modificado pelo usuário através do `AudioPanel` e programaticamente pelo gerador de manifesto.

---

### **Artigo II: `AudioManifest.tres`**

*   **Classe:** `AudioManifest` (herda de `Resource`)
*   **Propósito:** Servir como a **camada de compatibilidade com a v1**. Ele desacopla o código do sistema de arquivos, mapeando chaves de texto para os UIDs dos arquivos de áudio.
*   **Propriedades Chave:**
    *   `music_data`: Dicionário `[String: PackedStringArray]` mapeando chaves de música para UIDs.
    *   `sfx_data`: Dicionário `[String: PackedStringArray]` mapeando chaves de SFX para UIDs.
*   **Ciclo de Vida:** É um recurso inteiramente gerenciado pelo plugin. Ele é sobrescrito toda vez que o processo de geração é executado. Os usuários não devem editá-lo manualmente.

---

### **Artigo III: `AudioMaterialMap.tres`**

*   **Classe:** `AudioMaterialMap` (herda de `Resource`)
*   **Propósito:** Criar uma ponte entre o sistema de física e o sistema de áudio, permitindo sons de impacto baseados na superfície.
*   **Propriedades Chave:**
    *   `material_map`: Dicionário `[PhysicsMaterial: String]` que mapeia um recurso `PhysicsMaterial` a uma `sfx_key` do `AudioManifest`.
*   **Ciclo de Vida:** É um recurso criado e configurado manualmente pelo usuário para definir o comportamento sonoro das superfícies em seu jogo. Ele é então atribuído a um `Handler` (como o `FootstepHandler`) para ser usado.

---

### **Artigo IV: Recursos Nativos Empregados**

*   **`AudioStreamPlaylist`:**
    *   **Propósito:** É o principal bloco de construção da v2.0 para agrupar múltiplos sons. Usado para playlists de música e para coleções de SFX com variações.
    *   **Ciclo de Vida:** O AudioCafe **gera automaticamente** estes recursos a partir da estrutura de pastas do usuário. Eles também podem ser criados manualmente pelo usuário através do `AudioPanel`. Servem como base para as ferramentas de conversão para outros tipos de `AudioStream`.

*   **`AudioStreamInteractive` e `AudioStreamSynchronized`:**
    *   **Propósito:** Recursos nativos da Godot para áudio complexo, dinâmico e em camadas.
    *   **Ciclo de Vida:** O AudioCafe não os gera diretamente, mas os posiciona como o **próximo passo** no workflow. Os usuários podem criá-los manualmente ou usar as ferramentas de conversão do `AudioPanel` para gerá-los a partir de uma `AudioStreamPlaylist`.
