# Sistema de Animação no Godot Engine (4.0 em diante)

Este documento detalha a evolução e as funcionalidades do sistema de animação no Godot Engine, começando pela versão 4.0 e progredindo até a 4.5. Abordaremos as principais classes, conceitos, tipos de faixas, animação 2D e 3D, e a criação de filmes, além de tutoriais e o pipeline de ativos.

## Introdução

O sistema de animação é um pilar fundamental para dar vida a jogos e aplicações interativas. O Godot Engine, desde a versão 4.0, tem recebido melhorias significativas em sua robustez, flexibilidade e ferramentas, oferecendo aos desenvolvedores um conjunto poderoso para criar movimentos complexos e expressivos.

## Visão Geral do Sistema de Animação no Godot 4.0

O Godot 4.0 trouxe uma revisão interna substancial para o sistema de animação, focando em desempenho, usabilidade e a capacidade de lidar com animações mais complexas. As principais melhorias e recursos introduzidos no Godot 4.0 incluem:

*   **Editor de Animação Aprimorado**: Suporte a trilhas de blend shape e um fluxo de trabalho de curva Bezier aprimorado, permitindo a seleção e edição de múltiplas curvas simultaneamente.
*   **Fluxo de Trabalho de Animação 3D Aprimorado**: Revisão interna das animações 3D para compressão e redução do uso de memória. Trilhas dedicadas de posição, rotação e escala substituíram as transformações unificadas, com controle sobre modos de rotação e ordem do eixo.
*   **Bibliotecas de Animação e Sistema de Retargeting**: Animações agora são armazenadas em Bibliotecas de Animação para fácil reutilização. Um novo sistema de retargeting permite mapear animações para diferentes ativos no momento da importação, facilitando a adaptação de animações existentes a modelos com proporções diferentes.
*   **Blending, Transições e Suporte a Animações Complexas**: O sistema de blending de animação foi reescrito, oferecendo mais controle e flexibilidade para configurar gráficos de animação avançados com sincronização, espaços de blend, transições de nós e crossfades de máquina de estados. Máquinas de estados de animação podem se teletransportar para qualquer estado.
*   **Novo Sistema de Animação Tween**: Uma API reescrita para animações tween, permitindo a composição de animações complexas com suporte a empilhamento, sobreposição e easing.

## Conceitos Fundamentais de Animação no Godot

No Godot, a animação é gerenciada principalmente através de:

*   **AnimationPlayer**: O nó principal para reproduzir e gerenciar recursos `Animation`.
*   **AnimationTree**: Um nó poderoso para misturar e controlar múltiplas animações, criando transições complexas e lógicas de estado.
*   **AnimationMixer**: Uma classe base para `AnimationPlayer` e `AnimationTree`, unificando funcionalidades.
*   **Animation**: O recurso que contém os dados da animação (keyframes, trilhas).

A animação no Godot Engine depende de keyframes. Um tutorial simples de animação envolve a criação de um nó `AnimationPlayer`, adição de uma animação, gerenciamento de bibliotecas de animação, adição de faixas e keyframes.

## Classes de Animação Detalhadas

### `AnimationMixer` (Classe Base)
`AnimationMixer` é a classe base para nós que reproduzem animações. Ela gerencia uma biblioteca de animações e fornece funcionalidades básicas para processar e reproduzir animações. `AnimationPlayer` e `AnimationTree` herdam de `AnimationMixer`.

### `AnimationPlayer` (Nó)
O `AnimationPlayer` é um nó que reproduz e gerencia animações. Ele permite criar animações baseadas em keyframes para propriedades de nós, chamadas de métodos, reprodução de áudio e muito mais. É ideal para animações diretas e sequenciais.

### `AnimationTree` (Nó)
O `AnimationTree` é uma ferramenta poderosa para misturar e controlar animações complexas. Ele permite criar gráficos de estado, transições suaves entre animações, e controlar parâmetros de animação em tempo real através de nós como `AnimationNodeBlendSpace1D`, `AnimationNodeStateMachine`, entre outros. É essencial para personagens com múltiplos estados de animação (andar, correr, pular, atacar).

### `Animation` (Recurso)
A classe `Animation` é um recurso que contém dados de animação, como faixas e seus keyframes. Ela pode ser usada para armazenar dados de animação para reprodução por um `AnimationPlayer` ou `AnimationTree`.

## Tipos de Faixas de Animação

As faixas de animação definem quais propriedades ou ações serão animadas. Os tipos de faixas incluem:

*   **Property Track (Faixa de Propriedade):** Anima propriedades de nós.
*   **Position 3D / Rotation 3D / Scale 3D Track (Faixa de Posição 3D / Rotação 3D / Escala 3D):** Anima transformações 3D.
*   **Blend Shape Track (Faixa de Blend Shape):** Anima blend shapes em meshes.
*   **Call Method Track (Faixa de Chamada de Método):** Chama métodos em nós em pontos específicos da animação.
*   **Bezier Curve Track (Faixa de Curva de Bezier):** Permite animação usando curvas de Bezier.
*   **Audio Playback Track (Faixa de Reprodução de Áudio):** Reproduz áudio durante a animação.
*   **Animation Playback Track (Faixa de Reprodução de Animação):** Controla a reprodução de outras animações.

## Animação 2D e 3D

### Animação de Sprite 2D
A animação de sprites 2D pode ser feita usando:
*   Imagens individuais com `AnimatedSprite2D`.
*   Folhas de sprite com `AnimatedSprite2D`.
*   Folhas de sprite com `AnimationPlayer`.

### Animação Cutout
Um tipo de animação que envolve a manipulação de partes de um sprite.

### Esqueletos 2D
Esqueletos 2D são usados para deformar polígonos 2D. O processo envolve a criação de polígonos, a criação do esqueleto e a deformação dos polígonos com os ossos.

### Controle de Animação a partir de Código
É possível controlar animações e árvores de animação via código, permitindo interatividade e lógica complexa.

## Linha do Tempo de Mudanças na Animação (Godot 4.0 - 4.5)

### Godot 4.0 (Lançamento: 1 de Março de 2023)

Conforme detalhado na seção anterior, o Godot 4.0 trouxe uma reestruturação fundamental do sistema de animação, focando em estabilidade, desempenho e flexibilidade para animações 2D e 3D. As principais adições foram o editor aprimorado, o novo sistema de retargeting, o sistema de blending reescrito e o novo sistema Tween.

### Godot 4.1 (Lançamento: 6 de Julho de 2023)

O Godot 4.1 focou em estabilidade, desempenho e polimento geral do motor. Embora não tenha introduzido grandes novos recursos de animação, houve melhorias na confiabilidade e correções de bugs que beneficiaram o sistema de animação como um todo.

### Godot 4.2 (Lançamento: 30 de Novembro de 2023)

O Godot 4.2 continuou a refinar o sistema de animação com melhorias significativas:

*   **Retrabalho Interno de `AnimationPlayer` e `AnimationTree`**: Unificação de partes de sua implementação sob o novo nó `AnimationMixer`, resolvendo problemas e discrepâncias entre os dois. Introdução da opção de mistura determinística.
*   **"Onion Skinning" de Volta**: O recurso de "onion skinning" foi reintroduzido no editor de animação, permitindo visualizar quadros anteriores e futuros como uma sobreposição semi-transparente.

### Godot 4.3 (Lançamento: 15 de Agosto de 2024)

O Godot 4.3 trouxe novos recursos e melhorias para o sistema de animação:

*   **Novo nó SkeletonModifier3D**: Facilita a movimentação de ossos via script.
*   **Novas opções de importação de animação esquelética**: Retargeting de animações mais fácil, especialmente para o formato .fbx.
*   **Manipulação de keyframes ativada**: Selecionar, copiar, colar e duplicar keyframes.

### Godot 4.4 (Lançamento: 15 de Agosto de 2024)

O Godot 4.4 focou em melhorias de qualidade de vida e otimizações, incluindo:

*   **LookAtModifier3D**: Para animação procedural de modelos 3D.
*   **SpringBoneSimulator3D**: Para física de jiggle.
*   **Marcadores de animação**: Adição de marcadores para melhor controle e sincronização.

### Godot 4.5 (Lançamento: 15 de Agosto de 2024)

O Godot 4.5 trouxe atualizações de qualidade de vida para o Animation Player:

*   **Atualizações de qualidade de vida do Animation Player**: Seleção e dimensionamento de pontos do editor Bézier, auto-tangenciamento de novos pontos, classificação alfabética de animações e filtragem por nome.
*   **Vincular ossos a outros ossos com BoneConstraint3D**: Com BoneConstraint3D e os novos AimModifier3D, CopyTransformModifier3D e ConvertTransformModifier3D, agora é possível vincular ossos a outros ossos, permitindo movimentos e poses mais naturais.

## Classes de Animação Avançadas

### `AnimationMixer`

`AnimationMixer` é a classe base para `AnimationPlayer` e `AnimationTree`. Ela unifica funcionalidades e comportamentos, proporcionando uma base consistente para o gerenciamento de animações.

### `AnimationPlayer`

O `AnimationPlayer` é o nó mais comum para reproduzir animações. Ele contém um conjunto de recursos `Animation` e permite controlar a reprodução, velocidade, loop e transições básicas. É ideal para animações diretas e sequenciais.

### `AnimationTree`

O `AnimationTree` é uma ferramenta poderosa para misturar e controlar animações complexas. Ele permite criar gráficos de estado, transições suaves entre animações, e controlar parâmetros de animação em tempo real através de nós como `AnimationNodeBlendSpace1D`, `AnimationNodeStateMachine`, entre outros. É essencial para personagens com múltiplos estados de animação (andar, correr, pular, atacar).

### `Animation`

O recurso `Animation` armazena os dados de uma única animação, incluindo trilhas para diferentes propriedades (posição, rotação, escala, blend shapes, etc.) e seus respectivos keyframes. Ele é o "conteúdo" que o `AnimationPlayer` ou `AnimationTree` reproduzem.

## Tutoriais e Fluxos de Trabalho de Animação

O Godot oferece diversos tutoriais para explorar as capacidades de animação:

*   **Introdução à Animação**: Conceitos básicos e como começar a animar no Godot.
*   **Animação de Sprites 2D**: Criação de animações para personagens e objetos 2D usando `SpriteFrames` e `AnimationPlayer`.
*   **Tipos de Trilhas de Animação**: Detalhes sobre os diferentes tipos de trilhas disponíveis no recurso `Animation` (propriedade, método, áudio, etc.).
*   **Esqueletos 2D**: Como usar esqueletos e IK (Inverse Kinematics) para animar personagens 2D de forma mais flexível.
*   **Criando Filmes**: Utilizando o Godot para renderizar sequências de animação em alta qualidade, como para cutscenes ou trailers.
*   **Pipeline de Ativos**: Informações sobre como importar e configurar ativos com animações de ferramentas externas.

## Conclusão

O sistema de animação do Godot Engine, desde a versão 4.0, tem evoluído continuamente para oferecer uma plataforma robusta e flexível para desenvolvedores. Com melhorias no editor, suporte a retargeting, sistemas de blending avançados e ferramentas como `AnimationTree` e o novo sistema Tween, o Godot capacita os criadores a desenvolver experiências visuais ricas e dinâmicas. A linha do tempo de mudanças demonstra um compromisso contínuo com a melhoria do desempenho, usabilidade e recursos, tornando o Godot 4.x uma excelente escolha para projetos que exigem animações sofisticadas.