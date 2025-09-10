# Lei da Central de Gerenciamento de Áudio (AudioPanel v2.0)

**Status:** Proposta
**Documento:** `docs/laws_projects/audiopanel.md`

---

### **Preâmbulo**

Com a evolução do AudioCafe para uma camada de workflow sobre os recursos nativos da Godot, o `AudioPanel` se torna uma **Central de Gerenciamento de Áudio** completa. Esta lei detalha sua nova interface, focada no gerenciamento de mapeamentos de caminho e na conversão de ativos de áudio.

---

### **Artigo I: Redesenho da Interface**

*   **Seção 1.1: Reestruturação das Abas:**
    *   **Aba "Config":** Esta aba será redesenhada para gerenciar os novos mapeamentos de caminho.
    *   **Aba "Audio Assets":** Esta se torna a aba principal para visualização e interação com os recursos de áudio gerados.

*   **Seção 1.2: Funcionalidades Principais:**
    *   **Diretriz 1.2.1:** O botão **"Generate Audio Assets"** continua sendo a ação principal para acionar o processo de geração.
    *   **Diretriz 1.2.2:** Botões para **"New Audio Playlist"** e **"New Interactive Audio"** serão mantidos para criação manual de recursos.

---

### **Artigo II: A Nova Aba "Config"**

Esta aba será dedicada ao gerenciamento dos mapeamentos de caminho definidos no `AudioConfig`.

*   **Seção 2.1: Interface de Mapeamento:**
    *   **Diretriz 2.1.1:** A aba exibirá uma lista dos `AudioPathMapping`s existentes.
    *   **Diretriz 2.1.2:** Para cada mapeamento na lista, haverá campos para editar:
        *   `Category Name`
        *   `Source Path` (com um botão "Browse...")
        *   `Target Path` (com um botão "Browse...")
    *   **Diretriz 2.1.3:** Um botão **"Add New Category"** permitirá ao usuário criar um novo `AudioPathMapping` vazio na lista.
    *   **Diretriz 2.1.4:** Cada entrada terá um botão **"Remove"** para excluir o mapeamento.

*   **Seção 2.2: Configurações Globais:** A aba também conterá os sliders de volume globais (Master, Music, SFX) e as configurações padrão para a geração de playlists (ex: `Default Loop`).

---

### **Artigo III: A Aba "Audio Assets"**

Esta aba permanece como a principal interface para interagir com os sons do projeto, com as seguintes funcionalidades mantidas:

*   **Seção 3.1: Visualização em Árvore:** Exibirá uma `Tree` com todas as chaves de áudio catalogadas no `AudioConfig`.
*   **Seção 3.2: Ações de Contexto:** O menu de contexto em cada item permitirá:
    *   Copiar a chave.
    *   Abrir o recurso no Inspector.
    *   Mostrar no FileSystem.
    *   **Converter** para `AudioStreamInteractive` ou `AudioStreamSynchronized`.

---

### **Conclusão**

O novo `AudioPanel` se alinha perfeitamente com a arquitetura flexível do `AudioConfig` v2.0. Ao fornecer uma interface clara para gerenciar mapeamentos de categorias, ele capacita os desenvolvedores a moldar o workflow de geração de áudio exatamente às necessidades de seus projetos, desde os mais simples aos mais complexos.