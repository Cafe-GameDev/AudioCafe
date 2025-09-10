# Lei da Documentação Pública (v2.0)

**Status:** Proposta
**Documento:** `docs/laws_projects/documentation.md`

---

### **Preâmbulo**

Toda refatoração de software deve ser acompanhada por uma atualização proporcional em sua documentação. Com as mudanças arquiteturais significativas no AudioCafe v2.0, a documentação existente se tornou obsoleta. Esta lei estabelece o plano para uma revisão completa e a criação de novos materiais, garantindo que a documentação pública seja precisa, clara e capacite os usuários a utilizarem todo o potencial do novo sistema.

---

### **Artigo I: Revisão e Atualização dos Documentos Existentes**

Fica mandatória a revisão e reescrita de todos os arquivos `.md` na pasta `docs/` para refletir a nova arquitetura e filosofia do v2.0.

*   **Seção 1.1: `index.md` (Página Inicial):** A seção "Funcionalidades Principais" será atualizada para destacar o novo foco do AudioCafe como uma camada de workflow e gerenciamento sobre os recursos nativos da Godot.

*   **Seção 1.2: `AudioConfig.md`:** Será reescrito para detalhar as novas propriedades, como `generated_assets_path` e o catálogo `generated_playlists`.

*   **Seção 1.3: `AudioPanel.md`:** Será atualizado com novas screenshots e descrições que reflitam a interface redesenhada, incluindo a nova aba "Audio Assets" e as ferramentas de conversão.

*   **Seção 1.4: `ManifestGeneration.md`:** Será reescrito para explicar o novo processo de geração de `AudioStreamPlaylist` e o papel do `AudioManifest` como camada de compatibilidade opcional.

---

### **Artigo II: Criação de Novos Documentos Essenciais**

*   **Seção 2.1: Guia de Migração:**
    *   **Diretriz 2.1.1:** Fica mandatória a criação de um novo arquivo: `docs/MigrationFromV1.md`.
    *   **Diretriz 2.1.2:** Este guia deverá fornecer um passo a passo claro sobre como um usuário da v1 pode atualizar seu projeto para a v2.0, focando em como substituir a lógica de `CafeAudioManager` pelo uso direto dos `AudioStreamPlayer`s com os novos recursos gerados.

*   **Seção 2.2: Novos Tutoriais:**
    *   **Diretriz 2.2.1:** Novos tutoriais serão criados em `docs/tutorials/` para cobrir o novo workflow:
        1.  `01-generating-playlists.md`: Como organizar pastas e gerar `AudioStreamPlaylist`s.
        2.  `02-interactive-music.md`: Como usar a ferramenta de conversão para criar um `AudioStreamInteractive` para música de combate/exploração.
        3.  `03-layered-music.md`: Como usar a ferramenta de conversão para criar um `AudioStreamSynchronized` para música em camadas.

---

### **Conclusão**

A documentação é um produto, não uma reflexão tardia. Ao executar o plano desta lei, garantimos que a documentação do AudioCafe v2.0 será um recurso de alta qualidade, capacitando os usuários a aproveitarem ao máximo a nova arquitetura e garantindo uma transição suave para a base de usuários existente.
