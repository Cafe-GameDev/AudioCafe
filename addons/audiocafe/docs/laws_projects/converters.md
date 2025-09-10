# Lei das Ferramentas de Conversão de Áudio

**Status:** Proposta
**Documento:** `docs/laws_projects/converters.md`

---

### **Preâmbulo**

Para preencher a lacuna entre a simples organização de áudio em playlists e a criação de experiências de áudio complexas e dinâmicas, esta lei estabelece a criação de **Ferramentas de Conversão** integradas ao `AudioPanel`. O objetivo é capacitar os usuários a usar os `AudioStreamPlaylist`s gerados como um ponto de partida para a criação de recursos de áudio mais avançados.

---

### **Artigo I: Conversor para `AudioStreamInteractive`**

*   **Seção 1.1: Funcionalidade:** O `AudioPanel` fornecerá uma ação (ex: via menu de contexto na aba "Audio Assets") para converter um recurso `AudioStreamPlaylist` selecionado em um novo `AudioStreamInteractive`.

*   **Seção 1.2: Processo de Conversão:**
    1.  Ao ser acionada, a ferramenta criará um novo objeto `AudioStreamInteractive` em memória.
    2.  Ela irá iterar por todos os `AudioStream`s contidos na `AudioStreamPlaylist` de origem.
    3.  Para cada `AudioStream`, um novo "clipe" será adicionado ao `AudioStreamInteractive`.
    4.  A ferramenta criará uma estrutura de estados básica e funcional, como um estado de "entrada" que leva ao primeiro clipe, para que o recurso funcione imediatamente.
    5.  Finalmente, um `FileDialog` será exibido, solicitando que o usuário escolha um local e nome para salvar o novo recurso `AudioStreamInteractive` (`.tres`).

*   **Seção 1.3: Propósito:** Esta ferramenta não visa criar uma máquina de estados de áudio final, mas sim **acelerar o setup inicial**. Ela elimina o trabalho tedioso de arrastar e soltar manualmente dezenas de clipes, permitindo que o designer de som se concentre diretamente na criação da lógica de transições.

---

### **Artigo II: Conversor para `AudioStreamSynchronized`**

*   **Seção 2.1: Funcionalidade:** O `AudioPanel` fornecerá uma ação similar para converter uma `AudioStreamPlaylist` em um novo `AudioStreamSynchronized`.

*   **Seção 2.2: Processo de Conversão:**
    1.  Criará um novo objeto `AudioStreamSynchronized` em memória.
    2.  Iterará por todos os `AudioStream`s da playlist de origem e os adicionará ao recurso sincronizado.
    3.  Solicitará ao usuário que salve o novo recurso `.tres`.

*   **Seção 2.3: Propósito:** Ideal para o workflow de música em camadas (layered music), onde um grupo de arquivos em uma pasta (ex: `level1_drums.ogg`, `level1_bass.ogg`, `level1_melody.ogg`) é primeiro agrupado em uma playlist e depois convertido em um único stream sincronizado com um clique.

---

### **Conclusão**

As Ferramentas de Conversão são um pilar da estratégia do AudioCafe v2.0. Elas reforçam a utilidade do processo de geração de playlists, transformando-o em um passo intermediário poderoso que alimenta os fluxos de trabalho de áudio mais complexos da Godot, solidificando o papel do AudioCafe como uma camada de produtividade indispensável.
