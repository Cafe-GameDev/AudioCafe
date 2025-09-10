# Tutorial: Sons Contínuos e Sincronia com Animações

**Objetivo:** Aprender técnicas mais avançadas para o áudio de personagem, como sons em loop (passos) e sons sincronizados com animações (ataques).

### Pré-requisitos

- Ter completado o Tutorial 02 (`02-basic-character-audio.md`).
- Ter um som de passos em loop (ex: `footsteps.ogg`).
- Ter um som de ataque (ex: `sword_swoosh.ogg`).
- Ter uma animação de ataque em um nó `AnimationPlayer`.

---

### Parte 1: Sons Contínuos (Passos em Loop)

O som de pulo é um evento único, mas os passos precisam tocar continuamente enquanto o personagem anda e parar quando ele para.

#### Passo 1.1: Prepare o Som

1.  Encontre seu arquivo de som de passos (ex: `footsteps.ogg`) no `FileSystem`.
2.  Clique duas vezes nele e vá para a aba **Import**.
3.  Certifique-se de que a opção **Loop** está marcada. Clique em **Reimport**.

#### Passo 1.2: Configure o `AudioPosition`

1.  Selecione seu nó `AudioPosition2D`.
2.  No **Inspector**, na propriedade `State Audio`, adicione uma nova entrada:
    - **Key:** `walk`
    - **Value:** `player_footsteps` (ou a chave do seu som de passos).

#### Passo 1.3: Atualize a Máquina de Estado

Vamos modificar o script do personagem do tutorial anterior para lidar com o início e o fim do som de passos.

```gdscript
# player.gd (continuação)

# ... (código anterior: _physics_process, _determine_state) ...

func _change_state(new_state: State):
    # Lógica para quando o estado antigo termina
    if current_state == State.FALL and (new_state == State.IDLE or new_state == State.WALK):
        audio_position.set_state("land")
    
    # --- LÓGICA ADICIONADA ---
    # Se paramos de andar, pare o som de passos
    if current_state == State.WALK and new_state != State.WALK:
        audio_position.stop()
    # ------------------------

    current_state = new_state
    
    # Lógica para quando o novo estado começa
    match current_state:
        State.JUMP:
            audio_position.set_state("jump")
        # --- LÓGICA ADICIONADA ---
        State.WALK:
            # Só toque o som de passos se ele já não estiver tocando
            if not audio_position.playing:
                audio_position.set_state("walk")
        # ------------------------
```

Agora, o som de passos começará quando o personagem andar e parará quando ele ficar ocioso.

---

### Parte 2: Sincronia com Animações (Ataque)

Queremos que o som de um golpe de espada toque no momento exato do visual da animação.

#### Passo 2.1: Prepare o `AudioPosition`

No `Inspector` do `AudioPosition`, adicione mais uma entrada ao `State Audio`:
- **Key:** `attack`
- **Value:** `sfx_sword_swoosh`

#### Passo 2.2: Configure a `AnimationPlayer`

1.  Abra sua animação de ataque no painel de Animação.
2.  Clique em **"Add Track"** e escolha **"Call Method Track"**.
3.  Selecione o nó que tem o script do seu personagem (o nó raiz `CharacterBody2D`).
4.  Na linha do tempo da nova trilha, mova o cursor para o frame exato onde o golpe da espada acontece visualmente.
5.  Clique com o botão direito na trilha e selecione **"Insert Key"**.
6.  Uma janela se abrirá. No campo "Method Name", digite o nome de uma função que vamos criar. Ex: `_on_attack_animation_hit`.

#### Passo 2.3: Crie a Função no Script

No script do seu personagem, adicione a função que você acabou de nomear no `AnimationPlayer`.

```gdscript
# player.gd (continuação)

# Esta função será chamada pela AnimationPlayer
func _on_attack_animation_hit():
    # Usamos play_secondary_sound para não interromper o som de passos, se estiver tocando
    audio_position.play_secondary_sound("attack")
```

**Pronto!** Agora, quando você tocar a animação de ataque, a `AnimationPlayer` irá chamar a função no momento exato, que por sua vez pede ao `AudioPosition` para tocar o som de ataque. Isso garante uma sincronia perfeita entre áudio e visual.
