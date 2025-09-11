# Constituição da Configuração

**Status:** Constitucional
**Documento:** `docs/laws_constitution/config.md`

---

### **Artigo I: Princípio da Centralização**

Deve existir um único recurso (`Resource`) que sirva como a **única fonte da verdade** para todas as configurações globais e editáveis pelo usuário do AudioCafe. Este recurso é o `AudioConfig`.

### **Artigo II: Princípio da Editabilidade**

As configurações globais, como caminhos de busca de áudio, volumes de bus e comportamentos padrão, devem ser expostas de forma clara e acessível através de uma interface de usuário no editor, o `AudioPanel`.

### **Artigo III: Princípio da Reatividade**

O sistema de configuração deve ser reativo. Qualquer alteração no `AudioConfig` deve disparar um sinal (`config_changed`) que permita que outros componentes do plugin e do jogo se atualizem em tempo real, sem a necessidade de reiniciar o editor ou o jogo.
