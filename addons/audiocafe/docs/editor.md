# Guia dos Plugins de Editor (v1.0)

**Documento:** `docs/Editor.md`

---

### **Preâmbulo**

Além do `AudioPanel`, que possui sua própria página de documentação, o AudioCafe utiliza uma série de scripts de plugin para se integrar profundamente ao editor Godot. Estes scripts trabalham nos bastidores para automatizar processos, registrar componentes e garantir uma experiência de usuário fluida. Este documento detalha a função de cada um desses scripts na versão 1.0.

---

### **`EditorPlugin` (`editor_plugin.gd`)**

Este é o script mais importante, o ponto de entrada que orquestra a presença do AudioCafe no editor.

*   **Propósito:** Atuar como o orquestrador principal da integração do plugin com a interface do Godot.
*   **Funcionalidades Principais:**
    1.  **Gerenciamento do Autoload:** Ao ser ativado (`_enter_tree`), o script verifica se o singleton `CafeAudioManager` já está no `ProjectSettings`. Se não estiver, ele o adiciona. Ao ser desativado (`_exit_tree`), ele o remove de forma limpa. Isso garante que o manager esteja sempre acessível globalmente sem que o usuário precise configurar nada manualmente.
    2.  **Criação da Interface:** O script é responsável por encontrar ou criar o dock "CafeEngine" na interface do Godot e por carregar a cena do `AudioPanel` (`audio_panel.tscn`) dentro dele.
    3.  **Registro de Tipos Customizados:** Através da função `add_custom_type()`, este script registra todos os nós do AudioCafe (a família `SFX*`, `AudioPosition2D/3D`, `AudioZone2D/3D`, etc.). É por causa deste registro que eles aparecem no diálogo "Add Node" (Ctrl+A) e podem ser instanciados na cena como se fossem nós nativos da engine.

---

### **`EditorExportPlugin` (`editor_export_plugin.gd`)**

Este script atua como uma garantia de qualidade e segurança para o seu jogo final.

*   **Propósito:** Garantir que a build final do seu jogo sempre contenha um `AudioManifest` atualizado.
*   **Funcionalidade:** Ele utiliza o método `_export_begin`, que é um "hook" do Godot executado momentos antes de o processo de exportação começar. Dentro deste método, o script carrega e executa o `generate_audio_manifest.gd`.
*   **Benefício para o Usuário:** Esta automação previne o erro humano mais comum: adicionar ou alterar arquivos de áudio e esquecer de clicar em "Generate Audio Manifest" antes de exportar. Com este plugin, o manifesto está sempre sincronizado, garantindo que nenhum áudio falte no jogo publicado.

---

### **`EditorInspectorPlugin` (`editor_inspector_plugin.gd`)**

*   **Propósito na v1.0:** Na versão 1.0 do AudioCafe, este script é um **placeholder** e não contém lógica ativa.
*   **Potencial Futuro:** Um `EditorInspectorPlugin` é usado na API do Godot para modificar como as propriedades de um nó ou recurso são exibidas no painel "Inspector". No futuro, ele poderia ser usado para criar interfaces mais ricas para configurar os nós do AudioCafe, como exibir listas de chaves de áudio disponíveis diretamente no Inspector de um nó `AudioPosition`.

---

### **`EditorImportPlugin` (`editor_import_plugin.gd`)**

*   **Propósito na v1.0:** Na versão 1.0 do AudioCafe, este script é um **placeholder** e não contém lógica ativa.
*   **Potencial Futuro:** Um `EditorImportPlugin` permite executar código customizado quando um tipo específico de arquivo é importado para o projeto. Poderíamos usá-lo no futuro para, por exemplo, ler metadados de um arquivo `.wav` no momento da importação e pré-configurar algum recurso com base nesses dados.

---

### **Outros Plugins de Editor**

Os seguintes scripts também fazem parte da estrutura do plugin, mas estão vazios na v1.0, servindo como placeholders para expansões futuras:

*   **`editor_file_system_plugin.gd`:** Poderia ser usado para reagir a mudanças no sistema de arquivos, como mover ou renomear um arquivo de áudio.
*   **`editor_property.gd`:** Usado em conjunto com o `EditorInspectorPlugin` para definir a aparência de uma única propriedade customizada.
*   **`editor_resource_preview_generator.gd`:** Poderia gerar thumbnails customizadas para nossos recursos (ex: mostrar uma onda sonora para um `AudioStreamPlaylist`).
*   **`editor_script.gd`:** A classe base para scripts que podem ser executados de dentro do editor.
