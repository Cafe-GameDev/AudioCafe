# Lei da Configuração Central (AudioConfig v2.0)

**Status:** Proposta
**Documento:** `docs/leis/audioconfig.md`

---

### **Preâmbulo**

O `AudioConfig` é a espinha dorsal das configurações do plugin. Esta lei visa refinar e focar suas responsabilidades, adicionando novos controles e um catálogo para os ativos gerados que suportem a arquitetura v2.0, solidificando seu papel como o único ponto da verdade para as configurações do AudioCafe.

---

### **Artigo I: Propriedades de Configuração do Usuário**

As seguintes propriedades são configuráveis pelo usuário através do `AudioPanel` e serão mantidas:

*   **Seção 1.1: Caminhos de Busca (`sfx_paths`, `music_paths`):** A base para o processo de geração do manifesto e das playlists.
*   **Seção 1.2: Chaves de UI Padrão (`default_*_key`):** O sistema de fallback para os `SFX* Nodes`.
*   **Seção 1.3: Volumes Globais (`master_volume`, `sfx_volume`, `music_volume`):** O método principal para o controle de volume global.
*   **Seção 1.4: Configurações de Geração:** Novas propriedades para controlar o processo de geração de playlists.
    *   **Diretriz 1.4.1:** `@export var generated_assets_path: String` para definir onde os `.tres` das playlists são salvos.
    *   **Diretriz 1.4.2:** Propriedades como `@export var default_playlist_loop: bool` para definir os padrões dos recursos gerados.

---

### **Artigo II: Catálogo de Ativos Gerados**

Para permitir que o plugin descubra os recursos de playlist gerados dinamicamente, o `AudioConfig` atuará como um registrador.

*   **Seção 2.1: Catálogo de Playlists:**
    *   **Diretriz 2.1.1:** Será adicionada a propriedade `@export var generated_playlists: Dictionary`.
    *   **Diretriz 2.1.2:** Esta propriedade **não será editável pelo usuário** no `AudioPanel`. Ela será populada programaticamente pelo script `generate_audio_manifest.gd`.
    *   **Diretriz 2.1.3:** A estrutura do dicionário será `[String: String]`, mapeando a **chave da playlist** (ex: `sfx_ui_click`) para o **caminho do recurso** (`res://.../sfx_ui_click.tres`).

---

### **Artigo III: Propriedades de Dados do Manifesto (Compatibilidade v1)**

*   **Seção 3.1: Manutenção de `music_data` e `sfx_data`:** As propriedades `@export var music_data: Dictionary` e `@export var sfx_data: Dictionary` serão **mantidas** no script `audio_config.gd`. Embora não sejam diretamente usadas pela lógica principal da v2, elas são essenciais para o funcionamento do `AudioManifest.tres` da v1, que herda deste script. Removê-las quebraria a compatibilidade. Elas não serão visíveis ou editáveis no `AudioPanel`.

---

### **Conclusão**

O `AudioConfig` v2.0 se torna um recurso mais completo. Ele não apenas guarda as configurações do usuário, mas também serve como um catálogo essencial que permite ao ecossistema do plugin (especialmente o `AudioPanel`) descobrir e interagir com os ativos de áudio que são gerados dinamicamente.
