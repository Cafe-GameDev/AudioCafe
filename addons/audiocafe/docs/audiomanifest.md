# AudioManifest

O `AudioManifest` é um recurso (`AudioManifest.tres`) que atua como um catálogo central de todos os seus arquivos de áudio. Ele é gerado pelo **AudioPanel** e é fundamental para o funcionamento otimizado do AudioCafe, especialmente em builds exportadas.

## O Problema que Ele Resolve

Em tempo de desenvolvimento, o Godot pode facilmente encontrar arquivos usando seus caminhos (`res://...`). No entanto, em um jogo exportado, os arquivos são empacotados e o escaneamento de diretórios se torna ineficiente ou impossível.

O `AudioManifest` resolve isso mapeando `keys` de áudio amigáveis (como "ui_click") para os `UIDs` (Identificadores Únicos) internos que o Godot usa para referenciar recursos. Em tempo de execução, o `CafeAudioManager` usa este manifesto para carregar sons de forma rápida e eficiente, sem precisar saber os caminhos dos arquivos.

## Estrutura do Manifesto

O `AudioManifest.tres` contém dois dicionários principais:

- **`music_data: Dictionary`**:
    - **Chave**: Uma `String` representando uma categoria de música (e.g., "level_1_theme", "boss_battle").
    - **Valor**: Um `PackedStringArray` contendo os `UIDs` de todos os arquivos de música nessa categoria.

- **`sfx_data: Dictionary`**:
    - **Chave**: Uma `String` representando uma categoria de SFX (e.g., "ui_click", "player_jump").
    - **Valor**: Um `PackedStringArray` contendo os `UIDs` de todos os arquivos de SFX nessa categoria.

**Exemplo de conteúdo (simplificado):**
```gdscript
# audio_manifest.tres (representação)
music_data = {
    "main_theme": ["uid://..._music1", "uid://..._music2"]
}
sfx_data = {
    "ui_click": ["uid://..._click1", "uid://..._click2", "uid://..._click3"],
    "player_jump": ["uid://..._jump1"]
}
```

## Benefícios

- **Otimização de Build**: Garante que o áudio funcione corretamente e de forma eficiente em jogos exportados.
- **Gerenciamento por Chaves**: Permite que você organize e chame seus áudios por nomes lógicos em vez de caminhos de arquivo, facilitando a manutenção.
- **Aleatoriedade**: Se uma chave no manifesto aponta para múltiplos UIDs (como "ui_click" no exemplo acima), o `CafeAudioManager` escolherá um deles aleatoriamente toda vez que o som for solicitado. Isso permite criar variações sonoras facilmente, simplesmente colocando vários arquivos de som na mesma subpasta.
