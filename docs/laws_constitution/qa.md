# Constituição da Garantia de Qualidade

**Status:** Constitucional
**Documento:** `docs/laws_constitution/qa.md`

---

### **Preâmbulo**

A estabilidade e a confiabilidade são pilares da qualidade de software. Esta lei estabelece os requisitos mínimos de teste e garantia de qualidade para todo o desenvolvimento do AudioCafe.

### **Artigo I: Requisito de Teste**

Nenhuma nova funcionalidade ou refatoração significativa será considerada completa sem um **Plano de Teste** correspondente.

### **Artigo II: Formato do Plano de Teste**

Um plano de teste pode assumir uma das seguintes formas, em ordem de preferência:

1.  **Cena de Teste Automatizado:** Uma cena autocontida no diretório `/tests` do projeto que executa a funcionalidade e usa asserções (`assert`) para validar o resultado. Este é o padrão ouro.

2.  **Cena de Teste Manual:** Uma cena de exemplo que permite a um testador humano interagir com a nova funcionalidade de forma isolada para verificar seu comportamento.

3.  **Procedimento de Teste Manual:** Um documento de texto ou markdown que descreve, passo a passo, como testar manualmente a nova funcionalidade e quais são os resultados esperados.

### **Artigo III: Teste de Regressão**

Antes de qualquer novo lançamento (`PATCH`, `MINOR` ou `MAJOR`), um esforço de teste de regressão deve ser realizado para garantir que as novas alterações não quebraram funcionalidades existentes. Isso envolve a execução de todos os planos de teste previamente estabelecidos.
