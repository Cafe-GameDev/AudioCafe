# Lei do Gerenciador Central (CafeAudioManager v2.0)

**Status:** Proposta
**Documento:** `docs/leis/manager.md`

---

### **Preâmbulo**

O `CafeAudioManager` é o coração operacional do AudioCafe. Com a nova arquitetura v2.0, seu papel evolui de um implementador de lógica para um **despachante inteligente e orquestrador de recursos**. Esta lei define suas novas responsabilidades, focando na integração com os recursos nativos, na manutenção de suas funcionalidades de otimização e na garantia de retrocompatibilidade.

---

### **Artigo I: Gerenciamento de Música (Foco em `AudioStreamPlaylist`)**

*   **Seção 1.1: Lógica de Reprodução Refatorada:** O `CafeAudioManager` irá delegar a lógica de playlist para a engine.
    *   **Diretriz 1.1.1 (Acesso de Camada Dupla):** Ao receber o sinal `play_music_requested(playlist_key)`, o manager implementará a lógica de acesso de duas camadas:
        1.  **Prioridade v2:** Tentará carregar o recurso `AudioStreamPlaylist` de `res://.../generated/playlists/{playlist_key}.tres`. Se bem-sucedido, este stream será atribuído ao player de música.
        2.  **Fallback v1:** Se o recurso `.tres` não existir, ele reverterá para a lógica v1, buscando a `playlist_key` no `AudioManifest.tres` e tocando um UID aleatório do array.
    *   **Diretriz 1.1.2 (Delegação Nativa):** Uma vez que um `AudioStreamPlaylist` é carregado no player, o `CafeAudioManager` não interfere mais na seleção da próxima faixa. O próprio recurso nativo da Godot gerenciará a transição (seja aleatória ou sequencial), e o sinal `finished` do player simplesmente acionará o comportamento de loop da playlist, se ativado.

*   **Seção 1.2: Remoção de Lógica Redundante:**
    *   As funções internas como `_select_and_play_random_playlist()` e as variáveis que armazenavam as chaves de playlists serão removidas do script `cafe_audio_manager.gd`. Isso resultará em um código mais limpo, mais leve e mais fácil de manter.

---

### **Artigo II: Gerenciamento de SFX com Acesso Indexado**

*   **Seção 2.1: Manutenção do Pooling de SFX:** O sistema de pooling de `AudioStreamPlayer`s para SFX é uma otimização de performance valiosa e será mantido e revisado para garantir eficiência.

*   **Seção 2.2: Implementação do Acesso por Índice:** A lógica que responde ao sinal `play_sfx_requested` será aprimorada.
    *   **Diretriz 2.2.1:** A função irá honrar o novo parâmetro `index: int`.
    *   **Diretriz 2.2.2:** Se `index` for o padrão (`-1`), o comportamento aleatório (`pick_random()`) será usado, como na v1.
    *   **Diretriz 2.2.3:** Se `index` for um número não negativo, o manager tentará acessar o UID naquele índice específico dentro do array de UIDs da chave correspondente no `AudioManifest.tres`. A implementação deve incluir verificações de limites (`if index >= 0 and index < sfx_uids.size()`) para evitar erros.

---

### **Artigo III: Integração com o Ecossistema do Plugin**

*   **Seção 3.1: Gerenciamento de Configuração em Tempo Real:** O manager continuará conectado ao sinal `audio_config_updated`. Ao receber o sinal, ele aplicará imediatamente os novos valores de `master_volume`, `sfx_volume` e `music_volume` aos buses de áudio correspondentes.

*   **Seção 3.2: Hub de `AudioZone`:** A funcionalidade do manager de se registrar para escutar todos os eventos de `AudioZone` e retransmiti-los globalmente será mantida. Ele continua a ser o hub central para a lógica de áudio ambiental.

---

### **Conclusão**

O `CafeAudioManager` v2.0 se torna mais um "condutor" do que um "músico". Ele delega a execução complexa para os componentes nativos da Godot, que são mais eficientes, e se concentra em suas tarefas de mais alto nível: orquestrar os pedidos, gerenciar os recursos de forma inteligente (com retrocompatibilidade), otimizar a performance (pooling) e centralizar a comunicação do ecossistema AudioCafe. O resultado é um gerenciador mais leve, mais poderoso e mais alinhado com a filosofia da Godot.
