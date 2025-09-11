# Recursos do AudioCafe

O AudioCafe utiliza os `Resources` nativos da Godot para armazenar de forma eficiente tanto a configuração do plugin quanto o catálogo de seus arquivos de áudio. Embora você possa interagir com eles, a maior parte da configuração é feita de forma mais fácil através do [AudioPanel](./audiopanel.md).

## `AudioConfig.tres`

- **Propósito:** Este é o coração das suas configurações. É um arquivo de recurso que armazena tudo o que você configura no `AudioPanel`.
- **Localização:** `res://addons/AudioCafe/resources/audio_config.tres`
- **O que ele contém:**
    - Os caminhos para suas pastas de música e SFX.
    - Todas as chaves de SFX padrão para os [Controles de UI](./controls.md).
    - Os níveis de volume para os buses Master, Music e SFX.
- **Como editar:** A maneira recomendada é usar o `AudioPanel`. As alterações são salvas automaticamente neste arquivo.

## `AudioManifest.tres`

- **Propósito:** Este recurso é um catálogo gerado de todos os seus arquivos de áudio. Sua principal função é otimizar o acesso aos sons em builds exportadas, onde os caminhos de arquivo não são mais facilmente acessíveis.
- **Localização:** `res://addons/AudioCafe/resources/audio_manifest.tres`
- **O que ele contém:**
    - Um mapeamento de `chaves` de áudio (geradas a partir de sua estrutura de pastas) para os `UIDs` (Identificadores Únicos) internos que a Godot usa para cada arquivo de som.
- **Como editar:** **Você nunca deve editar este arquivo manualmente.** Ele é inteiramente gerenciado pelo AudioCafe. Clique no botão **`Generate Audio Manifest`** no `AudioPanel` para criá-lo ou atualizá-lo sempre que você adicionar ou alterar seus arquivos de áudio.
