# Constituição da API de Sinais

**Status:** Constitucional
**Documento:** `docs/laws_constitution/signals.md`

---

### **Artigo I: Princípio da Comunicação Desacoplada**

A comunicação entre os componentes do plugin e o código do usuário deve ser feita, preferencialmente, através de um **conjunto bem definido de sinais globais**. Isso garante um baixo acoplamento e facilita a manutenção e a extensão do sistema.

### **Artigo II: Princípio da Clareza da API**

Os sinais devem ter nomes claros e descritivos, e seus parâmetros devem ser bem definidos. A API de sinais deve ser intuitiva e fácil de usar para o desenvolvedor.

### **Artigo III: Princípio da Estabilidade da API**

Uma vez que um sinal é definido como parte da API pública, sua assinatura (nome e parâmetros) deve ser considerada estável. Qualquer alteração que quebre a compatibilidade de um sinal público deve ser tratada como uma **quebra de compatibilidade maior** e seguir as regras de versionamento estabelecidas na Constituição do Versionamento.
