**Projeto de Lei: Lei da Interface do AudioPanel**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_audio_panel_ui.md`

---

### **Preâmbulo**

Esta lei define as modificações necessárias na interface do `AudioPanel` para integrar as novas funcionalidades de conversão e gerenciamento de `AudioStreamRandomized`, `AudioStreamInteractive` e `AudioStreamSynchronized`. O objetivo é proporcionar uma experiência de usuário intuitiva e eficiente para a manipulação desses novos tipos de recursos de áudio.

---

### **Artigo I: Exibição e Interação com Recursos de Áudio**

1.  **Aba "Playlists" Centralizada:** A aba "Playlists" do `AudioPanel` será o ponto central para a exibição e interação com todos os tipos de recursos de áudio gerados: `AudioStreamPlaylist`, `AudioStreamRandomized`, `AudioStreamInteractive` e `AudioStreamSynchronized`.
2.  **Identificação Visual:** Cada entrada na lista de recursos de áudio deverá ter um indicador visual claro (ex: ícone, cor, label) que permita ao usuário identificar rapidamente o tipo de recurso (Playlist, Randomized, Interactive, Synchronized).
3.  **Botões de Conversão:** Para cada `AudioStreamPlaylist` listada, serão adicionados botões para as ações de conversão:
    *   **Botão "Randomized":** Um botão de toggle que, quando ativado, converterá a `AudioStreamPlaylist` em um `AudioStreamRandomized` e atualizará a exibição. Quando desativado, reverterá para `AudioStreamPlaylist` (se aplicável e com confirmação).
    *   **Botão "Interactive":** Um botão que, ao ser pressionado, iniciará o processo de criação de um `AudioStreamInteractive`, permitindo a seleção de múltiplas `AudioStreamPlaylist`s e a definição do nome do arquivo de saída.
    *   **Botão "Synchronized":** Um botão que, ao ser pressionado, criará uma cópia da `AudioStreamPlaylist` como um `AudioStreamSynchronized`.

---

### **Artigo II: Gerenciamento de Recursos Interactive**

1.  **Seleção Múltipla:** A interface para a criação de `AudioStreamInteractive` permitirá a seleção de múltiplas `AudioStreamPlaylist`s de forma clara e organizada.
2.  **Nome do Arquivo:** Um `FileDialog` será utilizado para que o usuário possa definir o nome do arquivo para o `AudioStreamInteractive`, garantindo que o sufixo `_interactive.tres` seja automaticamente adicionado.

---

### **Conclusão**

A implementação desta lei garantirá que o `AudioPanel` seja uma ferramenta completa e fácil de usar para a gestão de todos os tipos de recursos de áudio, otimizando o workflow do desenvolvedor no Godot Engine.