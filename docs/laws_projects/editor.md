# Lei da Integração com o Editor (Editor Scripts v2.0)

**Status:** Proposta
**Documento:** `docs/leis/editor.md`

---

### **Preâmbulo**

A integração profunda e transparente com o editor Godot é um pilar fundamental do AudioCafe. Esta lei define os roles e responsabilidades da suíte de scripts de editor (`EditorPlugin`, `EditorExportPlugin`, etc.), garantindo que eles suportem a nova arquitetura v2.0, registrem todos os componentes corretamente e automatizem tarefas críticas como a geração do manifesto no momento da exportação.

---

### **Artigo I: O Plugin Principal (`editor_plugin.gd`)**

Este script é o ponto de entrada do AudioCafe no editor e orquestra toda a integração.

*   **Seção 1.1: Gerenciamento do Ciclo de Vida:** Suas responsabilidades essenciais são mantidas:
    1.  Adicionar o singleton `CafeAudioManager` ao `ProjectSettings` quando o plugin é ativado (`_enter_tree`).
    2.  Remover o singleton quando o plugin é desativado (`_exit_tree`).
    3.  Instanciar e gerenciar o `AudioPanel` no dock do editor.

*   **Seção 1.2: Registro de Tipos Customizados:** Esta função é expandida para refletir a nova arquitetura.
    *   **Diretriz 1.2.1 (Manutenção):** Continuará a registrar todos os nós `SFX*`, `AudioPosition` e `AudioZone` para que apareçam no diálogo "Add Node".
    *   **Diretriz 1.2.2 (Novos Tipos):** Registrará os novos nós definidos em nossa legislação, como o `AmbianceHandler`.
    *   **Diretriz 1.2.3 (Classes Base):** Fica estabelecido que classes base puras, como a `SFXControlBase` proposta na "Lei dos Controles", **não** serão registradas como um tipo customizado, pois servem apenas para herança de código e não para instanciação direta.

---

### **Artigo II: O Plugin de Exportação (`editor_export_plugin.gd`)**

Este script garante que os projetos dos usuários sempre funcionem corretamente após a exportação.

*   **Seção 2.1: Manutenção da Geração de Manifesto Pré-Exportação:** A funcionalidade de acionar o script de geração de manifesto através do hook `_export_begin` é crítica e será mantida. Isso garante que o `AudioManifest.tres` e as playlists geradas estejam sempre 100% sincronizados com os arquivos de áudio no momento de criar uma build do jogo.

*   **Seção 2.2: Adaptação ao Novo Processo:** O plugin de exportação não precisa de alterações em seu próprio código, mas ele agora acionará a nova versão do `generate_audio_manifest.gd`, que executa o processo de geração em duas fases (catálogo v1 + playlists v2).

---

### **Artigo III: O Gerador de Manifesto (`generate_audio_manifest.gd`)**

Este script de editor (`EditorScript`) contém a lógica central da organização de ativos.

*   **Seção 3.1: Implementação da Geração em Duas Fases:** Conforme a "Lei do Manifesto Extensível", este script será reescrito para:
    1.  Primeiro, gerar o `AudioManifest.tres` v1 com os UIDs.
    2.  Segundo, iterar sobre o manifesto recém-criado e gerar os recursos `AudioStreamPlaylist.tres` correspondentes no diretório `generated/`.

*   **Seção 3.2: Emissão de Sinais de Progresso:** O script deve emitir sinais `progress_updated` e `generation_finished` para que o `AudioPanel` possa exibir feedback visual em tempo real ao usuário durante o processo.

---

### **Artigo IV: Limpeza de Scripts de Editor Não Utilizados**

Para manter a base de código do plugin enxuta e focada, os scripts de editor que não possuem uma função clara na arquitetura v2.0 serão removidos.

*   **Diretriz 4.1.1:** Os arquivos `editor_file_system_plugin.gd`, `editor_import_plugin.gd`, `editor_inspector_plugin.gd`, e `editor_property.gd`, que atualmente estão vazios, serão **removidos do projeto**. Caso uma necessidade futura para eles surja, eles poderão ser recriados.

---

### **Conclusão**

A suíte de scripts de editor do AudioCafe v2.0 será mais focada e robusta. Ao refinar o plugin principal, adaptar o processo de exportação e limpar arquivos desnecessários, garantimos que a integração com o editor Godot seja estável, eficiente e alinhada com todas as novas funcionalidades do plugin.
