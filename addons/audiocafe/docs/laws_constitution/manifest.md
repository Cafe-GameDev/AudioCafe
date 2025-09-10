# Constituição do Manifesto

**Status:** Constitucional
**Documento:** `docs/laws_constitution/manifest.md`

---

### **Artigo I: Princípio da Abstração**

O sistema de Manifesto deve servir como a camada de abstração que **desacopla a lógica do jogo da estrutura física dos arquivos**. O código do jogo deve referenciar ativos de áudio através de chaves de texto amigáveis, nunca através de caminhos de arquivo diretos (`res://...`).

### **Artigo II: Princípio da Geração Automática**

As chaves de áudio devem ser, por padrão, **geradas automaticamente** a partir da estrutura de diretórios do projeto. Este princípio garante um fluxo de trabalho rápido onde a organização de pastas se traduz diretamente na organização do áudio no jogo.

### **Artigo III: Princípio da Otimização para Build**

O Manifesto deve, em sua forma final, mapear as chaves de texto para uma forma de referência de recurso que seja **robusta e otimizada para builds exportadas** (como os UIDs do Godot), garantindo que nenhuma referência de áudio seja perdida quando o jogo é compilado.
