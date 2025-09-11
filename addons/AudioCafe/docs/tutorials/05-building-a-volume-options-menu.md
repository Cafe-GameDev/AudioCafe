# Tutorial: Construindo um Menu de Opções de Volume

**Objetivo:** Aprender a criar um menu de configurações de áudio funcional de forma extremamente rápida usando o `SFXVolumeSlider`.

### Pré-requisitos

- O plugin AudioCafe v1.0 instalado e ativado.
- Uma cena de UI para seu menu de opções.

---

### O Problema: Controle de Volume Manual

Normalmente, para criar um slider de volume em Godot, você precisaria:
1.  Adicionar um `HSlider`.
2.  Conectar seu sinal `value_changed` a um script.
3.  No script, obter o índice do bus de áudio (ex: "Master").
4.  Converter o valor linear do slider (0 a 100) para decibéis.
5.  Definir o volume do bus com `AudioServer.set_bus_volume_db()`.
6.  Fazer isso para cada bus (Master, Music, SFX).

O AudioCafe simplifica isso para um único passo de configuração.

### Passo 1: Adicione os Sliders de Volume do AudioCafe

1.  Abra sua cena de menu de opções.
2.  Adicione três nós do tipo **`SFXVolumeSlider`**. Nomeie-os para sua própria organização (ex: `MasterSlider`, `MusicSlider`, `SFXSlider`).
3.  Adicione `Label`s ao lado deles, se desejar.

### Passo 2: Configure o Bus de Áudio de Cada Slider

Esta é a única etapa de configuração necessária.

1.  Selecione o primeiro `SFXVolumeSlider` (ex: `MasterSlider`).
2.  No painel **Inspector**, encontre a propriedade **`Audio Bus Name`**.
3.  Digite `Master`.

4.  Selecione o segundo `SFXVolumeSlider` (ex: `MusicSlider`).
5.  No `Audio Bus Name`, digite `Music`.

6.  Selecione o terceiro `SFXVolumeSlider` (ex: `SFXSlider`).
7.  No `Audio Bus Name`, digite `SFX`.

### Passo 3: Teste!

Rode seu jogo, abra o menu de opções e interaja com os sliders. Eles já estão funcionando!

- Eles começarão no valor de volume que você definiu no `AudioPanel`.
- Mover o slider irá alterar o volume do bus correspondente em tempo real.
- Eles até mesmo tocarão um som de "slider" padrão ao serem movidos (que você pode customizar no `AudioConfig` ou no próprio nó).

**É isso!** Você criou um menu de opções de áudio totalmente funcional sem escrever nenhuma linha de código. O `SFXVolumeSlider` encapsula toda a lógica de conversão de decibéis e comunicação com o `AudioServer` para você.
