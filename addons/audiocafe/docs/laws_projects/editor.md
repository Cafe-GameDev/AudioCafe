# Lei da Integração com o Editor (Editor Scripts v2.0)

**Status:** Proposta
**Documento:** `docs/laws_projects/editor.md`

---

### **Preâmbulo**

A integração profunda e transparente com o editor Godot é um pilar fundamental do AudioCafe. Esta lei define os roles e responsabilidades da suíte de scripts de editor, garantindo que eles suportem a nova arquitetura v2.0 e automatizem tarefas críticas.

---

### **Artigo I: O Plugin Principal (`editor_plugin.gd`)**

Este script é o ponto de entrada do AudioCafe no editor.

*   **Seção 1.1: Gerenciamento do Ciclo de Vida:**
    1.  Instanciar e gerenciar o `AudioPanel` no dock do editor quando o plugin é ativado (`_enter_tree`).
    2.  Remover o painel quando o plugin é desativado (`_exit_tree`).

*   **Seção 1.2: Remoção de Lógica Obsoleta:**
    *   **Diretriz 1.2.1:** A lógica para adicionar/remover o autoload `CafeAudioManager` será completamente removida.
    *   **Diretriz 1.2.2:** A lógica para registrar os tipos customizados (`AudioPosition`, `AudioZone`, `SFX*` nodes) será removida.

---

### **Artigo II: O Plugin de Exportação (`editor_export_plugin.gd`)**

Este script garante que os projetos dos usuários sempre funcionem corretamente após a exportação.

*   **Seção 2.1: Manutenção da Geração Pré-Exportação:** A funcionalidade de acionar o script de geração de assets através do hook `_export_begin` é crítica e será mantida. Isso garante que todos os `AudioStreamPlaylist.tres` estejam sempre 100% sincronizados com os arquivos de áudio no momento de criar uma build do jogo.

---

### **Artigo III: O Gerador de Ativos (`generate_assets.gd`)**

Este script de editor (`EditorScript`) contém a lógica central da organização de ativos.

*   **Seção 3.1: Implementação da Nova Geração:** Conforme a "Lei da Geração de Ativos de Playlist", este script será reescrito para gerar os recursos `AudioStreamPlaylist.tres` diretamente no diretório de ativos gerados, e registrar seus caminhos no `AudioConfig`.

*   **Seção 3.2: Emissão de Sinais de Progresso:** O script deve emitir sinais `progress_updated` e `generation_finished` para que o `AudioPanel` possa exibir feedback visual em tempo real ao usuário.

---

### **Conclusão**

A suíte de scripts de editor do AudioCafe v2.0 será mais focada e robusta. Ao simplificar o plugin principal e focar no processo de geração, garantimos que a integração com o editor Godot seja estável, eficiente e alinhada com as novas funcionalidades do plugin.
