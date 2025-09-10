# Lei da Configuração Central (AudioConfig v2.0)

**Status:** Proposta
**Documento:** `docs/laws_projects/audioconfig.md`

---

### **Preâmbulo**

O `AudioConfig` é a espinha dorsal das configurações do plugin. Esta lei refina suas responsabilidades para suportar um sistema de mapeamento de caminhos flexível, permitindo que os usuários organizem seus projetos de áudio de forma simples ou categorizada.

---

### **Artigo I: O Mapeamento de Caminhos de Áudio**

O núcleo da configuração de geração de ativos será um array de mapeamentos.

*   **Seção 1.1: A Propriedade Principal:**
    *   **Diretriz 1.1.1:** O `AudioConfig` conterá uma propriedade principal: `@export var path_mappings: Array[AudioPathMapping]`. Esta propriedade substitui as antigas listas `sfx_paths`, `music_paths` e o `generated_assets_path` singular.

*   **Seção 1.2: O Recurso `AudioPathMapping`:**
    *   **Diretriz 1.2.1:** Será criado um novo tipo de `Resource` chamado `AudioPathMapping`.
    *   **Diretriz 1.2.2:** Cada `AudioPathMapping` conterá três propriedades:
        1.  `@export var category_name: String`: Um nome para o mapeamento (ex: "Player", "UI", "Default").
        2.  `@export var source_path: String`: O diretório de origem onde os arquivos de áudio brutos estão localizados (ex: `res://assets/player/`).
        3.  `@export var target_path: String`: O diretório de destino onde os recursos `AudioStreamPlaylist` gerados serão salvos (ex: `res://audio/generated/player/`).

---

### **Artigo II: Outras Propriedades de Configuração**

As seguintes propriedades serão mantidas para controle global:

*   **Seção 2.1: Volumes Globais (`master_volume`, `sfx_volume`, `music_volume`):** Para controle de volume no editor.
*   **Seção 2.2: Configurações Padrão de Geração:** Propriedades como `@export var default_playlist_loop: bool` para definir os padrões dos recursos `AudioStreamPlaylist` gerados.

---

### **Artigo III: Catálogo de Ativos Gerados**

Para permitir que o plugin descubra os recursos gerados, o `AudioConfig` atuará como um registrador.

*   **Seção 3.1: Catálogo de Playlists:**
    *   **Diretriz 3.1.1:** Manterá a propriedade `@export var generated_playlists: Dictionary`.
    *   **Diretriz 3.1.2:** Esta propriedade será populada programaticamente pelo script de geração, mapeando a **chave da playlist** (ex: `player_footsteps`) para o **caminho do recurso** (`res://audio/generated/player/footsteps.tres`).

---

### **Conclusão**

Esta nova estrutura para o `AudioConfig` oferece uma base muito mais flexível e poderosa. Ela permite que os usuários organizem seus projetos da maneira que melhor lhes convier, desde uma estrutura de pastas simples até uma arquitetura de categorias complexa, solidificando o papel do AudioCafe como uma ferramenta de workflow adaptável.