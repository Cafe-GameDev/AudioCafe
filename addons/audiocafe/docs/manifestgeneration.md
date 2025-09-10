# Geração do AudioManifest

O processo de geração do `AudioManifest` é o que torna o sistema do AudioCafe robusto. Ele escaneia seus diretórios de áudio e cria o catálogo de `keys` e `UIDs` que o `CafeAudioManager` usará.

## Como as Chaves São Geradas

A chave de um arquivo de áudio é determinada por sua **estrutura de diretórios** relativa ao caminho base que você definiu na aba "Paths" do AudioPanel.

**Regra:** O nome da chave é o caminho do subdiretório, com as barras (`/`) substituídas por underscores (`_`).

**Exemplo:**

Suponha que você configurou um `SFX Path` como `res://assets/sfx/`.
Sua estrutura de pastas é a seguinte:

```
res://assets/sfx/
├── interface/
│   ├── click/
│   │   ├── click_01.ogg
│   │   └── click_02.ogg
│   └── back.ogg
└── player/
    ├── jump.ogg
    └── land.ogg
```

Quando você gerar o manifesto, as seguintes chaves serão criadas:

- **`interface_click`**: Apontará para os UIDs de `click_01.ogg` e `click_02.ogg`.
- **`interface`**: Apontará para o UID de `back.ogg`.
- **`player`**: Apontará para os UIDs de `jump.ogg` e `land.ogg`.

Se um arquivo estiver diretamente no diretório raiz (como `back.ogg` dentro de `interface/`), a chave será o nome do diretório pai. Se não houver uma estrutura de subdiretorios significativa, o nome do arquivo (sem extensão) será usado como chave.

## Métodos de Geração

Existem duas maneiras de gerar o manifesto:

### 1. Geração Manual (Recomendado durante o desenvolvimento)

- **Onde**: No painel do AudioCafe, clique no botão **`Generate Audio Manifest`**.
- **Quando**: Faça isso sempre que adicionar, remover ou reorganizar seus arquivos de áudio para garantir que o manifesto esteja atualizado. As abas "Music List" e "SFX List" serão atualizadas para refletir as novas chaves.

### 2. Geração Automática (Essencial para builds)

O AudioCafe inclui um `EditorExportPlugin` que aciona a geração do manifesto automaticamente antes de exportar seu projeto.

- **Onde**: O processo é automático. Apenas exporte seu jogo normalmente (`Project > Export...`).
- **Por que**: Isso garante que a versão do seu jogo que vai para os jogadores sempre tenha o `AudioManifest` mais recente, prevenindo problemas de "áudio faltando" na build final. Você verá mensagens no console do Godot indicando que o script de pré-exportação foi executado.
