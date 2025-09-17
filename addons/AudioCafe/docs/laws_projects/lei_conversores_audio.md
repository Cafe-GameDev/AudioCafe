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
3.  **Salvamento:** O `AudioStreamRandomized` será salvo no mesmo diretório da `AudioStreamPlaylist` original, com o sufixo `_randomized.tres`.

---

### **Artigo II: Criação de AudioStreamInteractive**

1.  **Funcionalidade:** Um botão "Interactive" será adicionado à interface do `AudioPanel` para cada `AudioStreamPlaylist` listada. Ao ser ativado, este botão permitirá ao usuário selecionar múltiplas `AudioStreamPlaylist`s para criar um novo `AudioStreamInteractive`.
2.  **Seleção e Nome:** O usuário poderá selecionar múltiplas `AudioStreamPlaylist`s através de uma interface dedicada. Um `FileDialog` será apresentado para que o usuário escolha o nome do arquivo para o `AudioStreamInteractive`, que terá o sufixo `_interactive.tres`.
3.  **Estrutura:** Cada `AudioStreamPlaylist` selecionada se tornará um "clip" dentro do `AudioStreamInteractive`.
4.  **Preservação:** As `AudioStreamPlaylist`s originais não serão excluídas após a criação do `AudioStreamInteractive`.

---

### **Artigo III: Criação de AudioStreamSynchronized**

1.  **Funcionalidade:** Um botão "Synchronized" será adicionado à interface do `AudioPanel` para cada `AudioStreamPlaylist` listada. Ao ser ativado, este botão criará uma cópia da `AudioStreamPlaylist` existente, convertendo-a em um `AudioStreamSynchronized`.
2.  **Salvamento:** O `AudioStreamSynchronized` será salvo no mesmo diretório da `AudioStreamPlaylist` original, com o sufixo `_synchronized.tres`.
3.  **Preservação:** A `AudioStreamPlaylist` original não será excluída após a criação do `AudioStreamSynchronized`.

---

### **Conclusão**

A implementação desta lei proporcionará ao AudioCafe ferramentas robustas para a manipulação de recursos de áudio, permitindo a criação de experiências sonoras mais dinâmicas e complexas no Godot Engine.