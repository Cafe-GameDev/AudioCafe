# Constituição dos Recursos de Dados

**Status:** Constitucional
**Documento:** `docs/laws_constitution/resources.md`

---

### **Preâmbulo**

Os recursos (`Resource`) são a espinha dorsal da persistência de dados e da configuração no Godot. Esta lei estabelece os princípios fundamentais que governam a criação e o uso de recursos de dados dentro do ecossistema AudioCafe.

---

### **Artigo I: Princípio da Configuração Centralizada e Editável**

Deve existir um recurso primário, singleton, que sirva como a única fonte da verdade para todas as configurações **editáveis pelo usuário** (ex: `AudioConfig`). Este recurso deve ser projetado para ser modificado de forma segura, preferencialmente através de uma interface de usuário dedicada como o `AudioPanel`.

---

### **Artigo II: Princípio da Abstração de Ativos Gerados**

Deve existir um ou mais recursos que sirvam como uma camada de abstração sobre os ativos brutos do projeto (ex: `AudioManifest`). Estes recursos devem ser **gerados e gerenciados programaticamente** pelo plugin. Eles não devem ser editados manualmente pelo usuário, pois seu propósito é otimizar o acesso e garantir a estabilidade em builds exportadas.

---

### **Artigo III: Princípio da Extensibilidade**

A arquitetura de recursos deve ser extensível, permitindo a criação de novos tipos de `Resource` para suportar novas funcionalidades (ex: `AudioMaterialMap`). Cada novo tipo de recurso deve ter um propósito claro e bem definido, aderindo aos princípios de configuração ou abstração.
