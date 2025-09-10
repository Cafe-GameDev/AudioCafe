# Lei da Central de Gerenciamento de Áudio (AudioPanel v2.0)

**Status:** Proposta
**Documento:** `docs/leis/audiopanel.md`

---

### **Preâmbulo**

Com a evolução do AudioCafe para uma camada de workflow sobre os recursos nativos da Godot, o `AudioPanel` transcende sua função original de um simples configurador. Esta lei estabelece o redesenho do `AudioPanel` para se tornar uma **Central de Gerenciamento de Áudio** completa, uma interface de alto nível que não apenas configura o plugin, mas também acelera a criação e o gerenciamento dos recursos `AudioStreamPlaylist` e `AudioStreamInteractive`.

---

### **Artigo I: Redesenho da Interface e Funcionalidades Principais**

*   **Seção 1.1: Foco na Criação e Gerenciamento de Ativos:** O painel deve capacitar o usuário a criar e gerenciar os novos recursos de áudio com o mínimo de atrito.
    *   **Diretriz 1.1.1:** O botão **"Generate Audio Manifest"** será mantido como a ação principal para sincronizar o projeto, acionando tanto a geração do manifesto v1 quanto a geração dos recursos de playlist v2.
    *   **Diretriz 1.1.2:** O painel incluirá um botão **"New Audio Playlist"** para criar manualmente um novo recurso `AudioStreamPlaylist` (`.tres`).
    *   **Diretriz 1.1.3:** Da mesma forma, um botão **"New Interactive Audio"** será adicionado para criar um novo recurso `AudioStreamInteractive`.
    *   **Diretriz 1.1.4:** O painel proverá **ferramentas de conversão**, acessíveis através da aba "Audio Assets", para transformar `AudioStreamPlaylist`s gerados em recursos `AudioStreamInteractive` ou `AudioStreamSynchronized`, conforme a "Lei das Ferramentas de Conversão de Áudio".

*   **Seção 1.2: Reestruturação das Abas:** A organização do painel será simplificada e tornada mais intuitiva.
    *   **Aba "Config":** As abas "Paths" e "Keys" serão fundidas em uma única aba "Config". Esta aba conterá as configurações globais: os caminhos de busca de áudio (`music_paths`, `sfx_paths`), os volumes globais e todas as chaves de SFX padrão para os nós de UI.
    *   **Aba "Audio Assets":** As abas "Music List" e "SFX List" serão substituídas por uma nova e poderosa aba chamada "Audio Assets".

---

### **Artigo II: A Nova Aba "Audio Assets"**

Esta aba será a principal interface para interagir com todos os sons do projeto.

*   **Seção 2.1: Visualização em Árvore Unificada:** A aba exibirá uma `Tree` que lista todas as chaves de áudio catalogadas. A lista será populada lendo as chaves do `AudioManifest.tres` (para SFX simples) e do dicionário `generated_playlists` no `AudioConfig.tres` (para os recursos de playlist). A estrutura em árvore permitirá agrupar os ativos por tipo.

*   **Seção 2.2: Identificação Visual:** Cada item na árvore terá um ícone para identificar rapidamente seu tipo:
    *   **SFX Simples:** Um ícone de "nota musical".
    *   **AudioStreamPlaylist:** Um ícone de "lista de reprodução".
    *   **AudioStreamInteractive:** Um ícone de "grafo" ou "nós conectados".

*   **Seção 2.3: Ações de Contexto:** Um menu de contexto (clique direito) ou botões ao lado de cada item na lista fornecerão ações rápidas:
    *   **"Copy Key":** Copia o nome da chave (ex: `sfx_ui_click`) para a área de transferência.
    *   **"Open Resource":** (Para Playlists e Interactive) Abre o arquivo `.tres` correspondente diretamente no Inspector do Godot.
    *   **"Show in FileSystem":** Revela o arquivo de áudio (`.ogg`) ou o recurso (`.tres`) no painel `FileSystem` do Godot.
    *   **"Convert to Interactive Audio":** (Apenas para Playlists) Aciona a ferramenta de conversão para `AudioStreamInteractive`.
    *   **"Convert to Synchronized Audio":** (Apenas para Playlists) Aciona a ferramenta de conversão para `AudioStreamSynchronized`.

---

### **Artigo III: Melhorias no Processo de Geração**

*   **Seção 3.1: Feedback Visual Aprimorado:** Ao clicar em "Generate Audio Manifest", a barra de progresso e o rótulo de status fornecerão feedback claro sobre as fases do processo: "Fase 1: Escaneando arquivos...", "Fase 2: Gerando playlists...".

*   **Seção 3.2: Recarregamento Automático:** Após a conclusão bem-sucedida da geração, a árvore na aba "Audio Assets" será automaticamente recarregada para refletir todas as novas chaves e recursos criados.

---

### **Conclusão**

O novo `AudioPanel` será o pilar da experiência do AudioCafe v2.0. Ele evolui de um painel de configurações para uma ferramenta de produtividade completa, capacitando os desenvolvedores a gerenciar, criar e utilizar os recursos de áudio nativos da Godot com uma velocidade e facilidade sem precedentes. Esta central de gerenciamento é o que solidificará a proposta de valor do AudioCafe como a camada de workflow essencial para o áudio no Godot.
