# Lei da Documentação Pública (v2.0)

**Status:** Proposta
**Documento:** `docs/leis/documentation.md`

---

### **Preâmbulo**

Toda refatoração de software deve ser acompanhada por uma atualização proporcional em sua documentação. Com as mudanças arquiteturais significativas no AudioCafe v2.0, a documentação existente se tornou obsoleta. Esta lei estabelece o plano para uma revisão completa e a criação de novos materiais, garantindo que a documentação pública seja precisa, clara e capacite os usuários a utilizarem todo o potencial do novo sistema.

---

### **Artigo I: Revisão e Atualização dos Documentos Existentes**

Fica mandatória a revisão e reescrita de todos os arquivos `.md` na pasta `docs/` para refletir a nova arquitetura e filosofia do v2.0.

*   **Seção 1.1: `index.md` (Página Inicial):** A seção "Funcionalidades Principais" será atualizada para destacar o novo foco do AudioCafe como uma camada de workflow e gerenciamento sobre os recursos nativos da Godot.

*   **Seção 1.2: `AudioManager.md`:** Será reescrito para explicar o novo papel do manager como um "orquestrador". A explicação da lógica de playlist customizada será removida e substituída pela explicação do novo sistema de acesso de camada dupla (v2 com fallback para v1).

*   **Seção 1.3: `AudioPosition.md`:** Será completamente reescrito. O foco será 100% no novo workflow: associar um recurso `AudioStreamInteractive` à propriedade `interactive_stream` e controlá-lo via código com o método `travel()`.

*   **Seção 1.4: `AudioManifest.md` e `ManifestGeneration.md`:** Ambos os documentos serão fundidos ou atualizados para explicar o novo sistema de geração em duas fases: a criação do catálogo de UIDs (v1) e a geração paralela dos recursos `AudioStreamPlaylist` (`.tres`).

*   **Seção 1.5: `AudioPanel.md`:** Será atualizado com novas screenshots e descrições que reflitam a interface redesenhada, incluindo as novas abas "Config" e "Audio Assets" e os botões de criação de recursos.

*   **Seção 1.6: `Controls.md`:** O conteúdo principal será mantido, pois a funcionalidade do usuário não muda. Será adicionada uma nota sobre o refatoramento interno para uma classe base, destacando a melhoria na manutenibilidade.

*   **Seção 1.7: `Signals.md`:** A lista de sinais será atualizada para corresponder exatamente ao definido na "Lei dos Sinais", com os novos parâmetros e sinais, e a remoção dos obsoletos.

*   **Seção 1.8: `StateMachineIntegration.md`:** Este guia será completamente reescrito para seguir a nova "Lei da Integração com Máquinas de Estado", demonstrando o uso do método `travel()`.

*   **Seção 1.9: `AdvancedUsage.md`:** Será revisado para atualizar exemplos, como o uso do novo `AmbianceHandler` como a prática recomendada para áudio ambiental.

---

### **Artigo II: Criação de Novos Documentos Essenciais**

*   **Seção 2.1: Guia de Migração:**
    *   **Diretriz 2.1.1:** Fica mandatória a criação de um novo arquivo: `docs/MigrationFromV1.md`.
    *   **Diretriz 2.1.2:** Este guia deverá fornecer um passo a passo claro e com exemplos de código sobre como um usuário da v1 pode atualizar seu projeto para a v2.0, com foco na conversão da lógica de `AudioPosition` para o novo sistema `AudioStreamInteractive`.

*   **Seção 2.2: Documentação dos Handlers:**
    *   **Diretriz 2.2.1:** Fica mandatória a criação de um novo arquivo: `docs/Handlers.md`.
    *   **Diretriz 2.2.2:** Este documento explicará o conceito de `Handlers` como um padrão de design e incluirá um tutorial detalhado sobre como usar o novo `AmbianceHandler`.

---

### **Artigo III: Limpeza da Documentação**

*   **Seção 3.1:** Após a conclusão da fase legislativa, o arquivo `docs/leis/exemplo.md` será removido para manter a pasta de documentação final limpa e focada no conteúdo relevante para o usuário.

---

### **Conclusão**

A documentação é um produto, não uma reflexão tardia. Ao executar o plano desta lei, garantimos que a documentação do AudioCafe v2.0 será um recurso de alta qualidade, capacitando os usuários a aproveitarem ao máximo a nova arquitetura e garantindo uma transição suave para a base de usuários existente.
