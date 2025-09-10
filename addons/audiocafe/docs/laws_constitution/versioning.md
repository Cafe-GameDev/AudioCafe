# Constituição do Versionamento

**Status:** Constitucional
**Documento:** `docs/laws_constitution/versioning.md`

---

### **Artigo I: Adoção do Versionamento Semântico (SemVer)**

O AudioCafe adota e seguirá estritamente o padrão de Versionamento Semântico 2.0.0. O formato da versão será `MAJOR.MINOR.PATCH`.

### **Artigo II: Definição das Versões**

1.  **`PATCH` (ex: 1.0.0 -> 1.0.1):** Reservado exclusivamente para correções de bugs que são retrocompatíveis. Não deve introduzir nenhuma nova funcionalidade ou alteração de API.

2.  **`MINOR` (ex: 1.0.0 -> 1.1.0):** Usado para a adição de novas funcionalidades que são retrocompatíveis. Pode incluir novos nós, novos sinais ou novas funções, mas não pode quebrar o código de usuários que utilizam a versão anterior do mesmo ramo `MAJOR`.

3.  **`MAJOR` (ex: 1.0.0 -> 2.0.0):** Reservado para qualquer alteração que **quebre a compatibilidade** com a versão anterior. A transição do workflow da v1.0 para a v2.0 é o exemplo canônico de uma mudança que exige uma nova versão `MAJOR`.

### **Artigo III: Inviolabilidade**

Nenhuma alteração que quebre a compatibilidade será introduzida em uma versão `MINOR` ou `PATCH`. Esta regra é inviolável e serve para garantir a confiança e a estabilidade para os usuários do plugin.
