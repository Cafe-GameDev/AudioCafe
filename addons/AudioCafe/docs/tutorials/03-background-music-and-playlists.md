# Tutorial: Música de Fundo e Playlists

**Objetivo:** Aprender a tocar música de fundo em uma cena e como o AudioCafe facilita a criação de playlists dinâmicas.

### Pré-requisitos

- O plugin AudioCafe v1.0 instalado e ativado.
- Uma pasta no seu projeto contendo um ou mais arquivos de música (ex: `res://assets/music/level1/`).

---

### Passo 1: Organize seus Arquivos de Música

A força do AudioCafe está na organização por pastas. Para criar uma "playlist" para a primeira fase do seu jogo, simplesmente coloque todos os arquivos de música para essa fase na mesma subpasta.

Exemplo de estrutura:
```
res://assets/music/
└── level1/
    ├── song_a.ogg
    ├── song_b.ogg
    └── song_c.ogg
```

### Passo 2: Configure o Caminho no AudioPanel

1.  Abra o painel **"CafeEngine"** no editor Godot.
2.  Vá para a aba **"Paths"**.
3.  Clique em **"Add Music Path"** e adicione o caminho para a pasta que contém suas subpastas de música. No nosso exemplo, seria `res://assets/music`.

### Passo 3: Gere o Manifesto

1.  Clique no botão **"Generate Audio Manifest"**.
2.  Após a conclusão, vá para a aba **"Music List"**. Você verá uma nova chave chamada `level1`. O número entre colchetes `[3]` indica que o AudioCafe encontrou 3 faixas associadas a esta chave.

### Passo 4: Toque a Playlist via Código

Agora, para tocar sua playlist, você só precisa de uma linha de código.

1.  Crie uma cena para o seu nível (ex: `Level1.tscn`).
2.  Adicione um script ao nó raiz da cena.
3.  No método `_ready()`, adicione a seguinte linha:

```gdscript
# Level1.gd
extends Node2D

func _ready():
    # Emite um sinal para o manager global tocar a playlist "level1"
    CafeAudioManager.play_music_requested.emit("level1")
```

### Passo 5: Teste!

Rode a cena do seu nível. A música começará a tocar.

**O que acontece nos bastidores?**
- O `CafeAudioManager` recebeu a requisição para tocar a playlist `level1`.
- Ele olhou no `AudioManifest`, viu as 3 músicas associadas e escolheu uma **aleatoriamente** para tocar.
- Quando essa música terminar, o `CafeAudioManager` automaticamente escolherá outra música aleatória da mesma playlist `level1` e a tocará, criando uma trilha sonora que não se repete de forma previsível.

Você acabou de criar uma trilha sonora de fundo dinâmica com uma única linha de código.
