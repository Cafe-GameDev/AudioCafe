# Constituição do Gerenciador Central

**Status:** Constitucional
**Documento:** `docs/laws_constitution/manager.md`

---

### **Artigo I: Princípio da Orquestração Global**

O `CafeAudioManager` deve existir como um **singleton global** que atua como o ponto central de orquestração para todas as operações de áudio em tempo de execução. Ele deve prover uma interface simplificada para as funcionalidades de áudio mais comuns.

### **Artigo II: Princípio da Otimização de Performance**

O Gerenciador Central deve ser responsável por otimizações de performance que não são triviais para o usuário final implementar, como o **pooling de recursos** (`AudioStreamPlayer`s) para a reprodução eficiente de SFX.

### **Artigo III: Princípio da Comunicação Centralizada**

O `CafeAudioManager` deve servir como o **hub central para a comunicação de eventos de áudio**, tanto recebendo requisições de reprodução quanto emitindo notificações sobre o estado do áudio no jogo.
