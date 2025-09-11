# Tutorial: Criando Zonas de Áudio (Ambiente Dinâmico)

**Objetivo:** Aprender a usar o nó `AudioZone` para alterar a música ou o som ambiente com base na localização do jogador.

### Pré-requisitos

- Ter completado o Tutorial 03 e ter uma música de fundo padrão tocando.
- Ter uma chave de áudio para o som ambiente da nova zona (ex: uma chave `cave_ambiance` com sons de caverna).
- Uma cena de nível com um personagem de jogador que esteja no grupo `player` (ou em um grupo de sua escolha).

---

### Passo 1: Adicione a `AudioZone` à Cena

1.  Na cena do seu nível, adicione um nó `AudioZone2D` (ou `AudioZone3D`).
2.  Como filho da `AudioZone`, adicione um `CollisionShape2D` (ou `3D`).
3.  Ajuste a forma da colisão para cobrir a área que você quer que seja a sua zona especial (ex: a entrada de uma caverna).
4.  Selecione o nó `AudioZone` e, no **Inspector**, defina duas propriedades:
    - **Zone Name:** Dê um nome único e descritivo. Ex: `caverna_entrada`.
    - **Target Group:** Digite o nome do grupo do seu jogador. Ex: `player`. Isso garante que a zona só reagirá ao jogador, e não a outros corpos.

### Passo 2: Crie um Gerenciador de Ambiente

O `AudioZone` apenas emite um sinal; ele não toca sons. Precisamos de um script para ouvir esse sinal e reagir. É uma boa prática ter um único script gerenciando o ambiente do seu nível.

1.  Adicione um novo nó `Node` à sua cena de nível e nomeie-o como `AmbianceManager`.
2.  Adicione um novo script a ele com o seguinte conteúdo:

```gdscript
# AmbianceManager.gd
extends Node

# Guarda a chave da nossa música principal para podermos voltar a ela.
var default_music_key = "level1"

func _ready():
    # Conecta este script ao sinal global de eventos de zona
    CafeAudioManager.zone_event_triggered.connect(_on_zone_event)

func _on_zone_event(zone_name: String, event_type: String, body: Node):
    # O sinal nos diz o nome da zona, o tipo de evento e quem o acionou.
    # Como já filtramos pelo grupo no nó AudioZone, não precisamos verificar o 'body' aqui.

    if zone_name == "caverna_entrada":
        if event_type == "entered":
            # O jogador entrou na zona, toca a música da caverna
            print("Jogador entrou na caverna, tocando ambiente...")
            CafeAudioManager.play_music_requested.emit("cave_ambiance")
        elif event_type == "exited":
            # O jogador saiu da zona, volta para a música padrão
            print("Jogador saiu da caverna, voltando para música principal...")
            CafeAudioManager.play_music_requested.emit(default_music_key)
```

### Passo 3: Teste!

1.  Certifique-se de que sua música padrão está tocando no início do nível (conforme o Tutorial 03).
2.  Rode a cena e mova seu personagem para dentro da área definida pela `AudioZone`.
3.  Observe a música/ambiente mudar para o som da caverna.
4.  Mova o personagem para fora da área e observe a música retornar ao padrão.

**Parabéns!** Você criou um sistema de áudio ambiental dinâmico. Você pode adicionar quantas `AudioZone`s quiser à sua cena, cada uma com um `zone_name` diferente, e simplesmente adicionar mais lógica `elif zone_name == ...` ao seu `AmbianceManager` para lidar com cada uma.
