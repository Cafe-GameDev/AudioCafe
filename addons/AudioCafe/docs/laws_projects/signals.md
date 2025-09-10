# Lei da Comunicação por Sinais (Signals API v2.0)

**Status:** Proposta
**Documento:** `docs/leis/signals.md`

---

### **Preâmbulo**

Uma arquitetura de software robusta e desacoplada depende de uma interface de comunicação clara e bem definida. Esta lei estabelece a API de Sinais oficial para o AudioCafe v2.0. O objetivo é refinar, modernizar e documentar os canais de comunicação entre os componentes do plugin e entre o plugin e o código do jogo do usuário, garantindo consistência e previsibilidade.

---

### **Artigo I: Sinais do `CafeAudioManager` (O Hub Global)**

O `CafeAudioManager` serve como o principal ponto de comunicação global. Seus sinais são divididos em duas categorias: Requisições (sinais que o usuário emite) e Notificações (sinais aos quais o usuário se conecta).

*   **Seção 1.1: Sinais de Requisição (API de Entrada)**
    *   **`play_sfx_requested(sfx_key: String, bus: String, node: Node, index: int = -1)`**
        *   **Status:** MANTIDO E ESTENDIDO.
        *   **Descrição:** O principal método para tocar SFX. A adição do parâmetro `index` (conforme a Lei do Manifesto) permite a seleção de um som específico dentro de uma chave, com `-1` mantendo o comportamento aleatório padrão.
    *   **`play_music_requested(playlist_key: String, fade_time: float = -1.0)`**
        *   **Status:** MANTIDO COM PROPÓSITO ALTERADO.
        *   **Descrição:** Solicita a reprodução de uma playlist de música. Na v2.0, `playlist_key` corresponde a um recurso `AudioStreamPlaylist` gerado. O `fade_time` opcional permite sobrepor o tempo de fade padrão do recurso.
    *   **`stop_music_requested(fade_out_time: float = -1.0)`**
        *   **Status:** NOVO.
        *   **Descrição:** Um sinal explícito e mais claro para parar a música atual, com um tempo de fade out opcional. Substitui a necessidade de uma função `stop_music()` direta, mantendo o padrão de comunicação por sinais.

*   **Seção 1.2: Sinais de Notificação (API de Saída)**
    *   **`music_track_changed(playlist_key: String, new_stream: AudioStream)`**
        *   **Status:** MANTIDO E APRIMORADO.
        *   **Descrição:** Emitido quando uma nova faixa de uma playlist começa a tocar. Agora também fornece uma referência direta ao `AudioStream` da faixa atual, permitindo lógicas mais avançadas (ex: exibir o nome do artista/faixa na UI).
    *   **`volume_changed(bus_name: String, linear_volume: float)`**
        *   **Status:** MANTIDO.
        *   **Descrição:** Essencial para a UI (ex: sliders de volume) reagir a mudanças de volume feitas programaticamente ou por outros componentes.
    *   **`zone_event_triggered(zone_name: String, event_type: String, body: Node)`**
        *   **Status:** MANTIDO.
        *   **Descrição:** O papel do `CafeAudioManager` como um retransmissor global para eventos de `AudioZone` continua sendo uma funcionalidade de alto valor para centralizar a lógica de áudio ambiental.
    *   **`audio_config_updated(config: AudioConfig)`**
        *   **Status:** MANTIDO.
        *   **Descrição:** Essencial para que os componentes internos (especialmente os `SFX* Nodes`) saibam quando recarregar as configurações, como as chaves de SFX padrão.

---

### **Artigo II: Sinais de Componentes Específicos**

*   **Seção 2.1: `AudioPosition` (2D/3D)**
    *   **Status:** REVISADO.
    *   **Descrição:** Com a lógica de estado sendo transferida para o `AudioStreamInteractive` nativo, o `AudioPosition` não precisa mais emitir sinais relacionados a estados. Sua API principal se torna baseada em métodos (`travel()`). Sinais customizados para este nó são considerados desnecessários na nova arquitetura, a fim de evitar redundância com os sinais que o próprio `AudioStreamInteractive` pode vir a ter no futuro.

*   **Seção 2.2: `AudioZone` (2D/3D)**
    *   **Status:** MANTIDO.
    *   **Descrição:** O sinal `zone_event_triggered(zone_name: String, event_type: String, body: Node)` emitido por cada instância de `AudioZone` é perfeitamente adequado e genérico. Ele será mantido sem alterações.

*   **Seção 2.3: `AudioConfig` (Recurso)**
    *   **Status:** MANTIDO.
    *   **Descrição:** O sinal `config_changed` é o gatilho fundamental para a reatividade de todo o plugin e permanece inalterado.

---

### **Conclusão**

A API de Sinais do AudioCafe v2.0 será mais limpa, mais explícita e totalmente alinhada com a nova arquitetura focada em recursos nativos. Mantemos os sinais de notificação que provaram seu valor, estendemos as requisições para adicionar poder (seleção por índice) e eliminamos a redundância, resultando em uma API pública mais estável e fácil de usar para o desenvolvedor.
