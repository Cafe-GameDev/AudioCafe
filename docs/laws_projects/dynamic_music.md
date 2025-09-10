# Lei da Música Dinâmica

**Status:** Proposta
**Documento:** `docs/laws_projects/dynamic_music.md`

---

### **Preâmbulo**

O plugin `Resonate` era reconhecido por seu poderoso sistema de música em camadas (`stems`), uma funcionalidade que o AudioCafe v1 não possuía. Com a introdução dos nós `AudioStreamInteractive` e `AudioStreamSynchronized` no Godot 4.3, a engine agora fornece as ferramentas para criar tais sistemas, mas sua configuração manual é complexa e trabalhosa. Esta lei propõe a criação de um sistema de alto nível dentro do AudioCafe para abstrair e acelerar drasticamente a criação de música dinâmica e adaptativa, trazendo a principal força do `Resonate` para o workflow do AudioCafe.

---

### **Artigo I: O Recurso `MusicTrack`**

*   **Seção 1.1: Definição:** Será criado um novo tipo de `Resource` chamado `MusicTrack.tres`.
*   **Seção 1.2: Estrutura:** Este recurso terá uma interface de configuração customizada no `Inspector` e conterá:
    *   **Diretriz 1.2.1:** Uma lista de **Stems**, onde cada entrada é uma `String` correspondente a uma chave de áudio do `AudioManifest` (ex: `level1_drums`, `level1_bass`).
    *   **Diretriz 1.2.2:** Um dicionário de **Estados de Intensidade**, onde a chave é o nome do estado (ex: `"Combat"`, `"Stealth"`) e o valor é um `Array` contendo os nomes dos `stems` que devem estar ativos naquele estado.

---

### **Artigo II: Workflow no `AudioPanel`**

*   **Seção 2.1: Criação Simplificada:** O `AudioPanel` terá um novo botão, "Create New Music Track", para gerar e salvar um novo `MusicTrack.tres`.
*   **Seção 2.2: Geração de Ativo Interativo:** Uma nova ação no painel, "Generate Interactive Music from Track", irá ler um `MusicTrack.tres` e gerar programaticamente um recurso `AudioStreamInteractive` complexo, com todos os estados e transições de crossfade pré-configurados, salvando-o no diretório de ativos gerados.

---

### **Artigo III: Nova API no `CafeAudioManager`**

Para controlar a música dinâmica, a API do `CafeAudioManager` será expandida com funções diretas e sinais correspondentes.

*   **Seção 3.1: Funções:**
    *   **Diretriz 3.1.1:** `play_music_track(track_key: String)`: Carrega e inicia a reprodução do `AudioStreamInteractive` gerado associado à `track_key`.
    *   **Diretriz 3.1.2:** `set_music_state(state_name: String)`: Aciona a transição para o estado de intensidade correspondente (ex: `"Combat"`) no `AudioStreamInteractive` que está tocando, resultando em um crossfade suave entre os `stems`.

*   **Seção 3.2: Sinais:**
    *   **Diretriz 3.2.1:** `music_state_changed(track_key: String, new_state: String)`: Emitido quando uma transição de estado é concluída.

---

### **Conclusão**

Este sistema absorve a funcionalidade mais poderosa do `Resonate` e a implementa através da filosofia de workflow do AudioCafe. Ele capacita os desenvolvedores a criar trilhas sonoras ricas e adaptativas com uma fração do esforço que seria necessário para configurar as ferramentas nativas manualmente, solidificando o AudioCafe como a camada de gerenciamento de áudio essencial para Godot.
