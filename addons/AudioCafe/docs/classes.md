# Classes do Godot Engine 4.5: Organização por Tópicos

Este documento apresenta uma organização das principais classes do Godot Engine 4.5, agrupadas por seções e tópicos relevantes, em vez de uma lista alfabética. O objetivo é facilitar a compreensão da estrutura do motor e a localização de classes com base em sua funcionalidade. Classes de tipagem básica (como `Vector2`, `int`, `bool`) foram omitidas para focar nas classes de `Nodes` e `Resources` e em objetos de serviço importantes.

## Nós (Nodes)

Nós são os blocos de construção fundamentais de qualquer projeto Godot. Eles representam entidades na árvore de cena, cada um com uma função específica, propriedades e a capacidade de interagir com outros nós.

### Nós Base e Estrutura da Cena

Essas classes formam a espinha dorsal da árvore de cena, gerenciando a hierarquia, o processamento e a renderização fundamental.

*   **Node**: A classe mais fundamental na árvore de cena do Godot. Todos os outros nós herdam dela. Gerencia a hierarquia, processamento, sinais e grupos.
*   **Node2D**: Base para todos os nós 2D. Gerencia posição, rotação, escala e visibilidade em 2D.
*   **Node3D**: Base para todos os nós 3D. Gerencia posição, rotação, escala e visibilidade em 3D.
*   **CanvasItem**: Base para todos os nós que podem ser desenhados em um `CanvasLayer` (inclui `Node2D` e `Control`).
*   **CanvasLayer**: Um nó que renderiza seus filhos em uma camada separada, útil para UI ou elementos que devem estar acima/abaixo do resto da cena.
*   **CanvasModulate**: Modula a cor de todos os `CanvasItem`s abaixo dele na árvore.
*   **SubViewport**: Um nó que atua como uma janela de visualização separada, renderizando seus filhos para uma textura que pode ser usada em outro lugar.
*   **SubViewportContainer**: Um contêiner que exibe o conteúdo de um `SubViewport`.
*   **Viewport**: O nó que gerencia a renderização de uma cena. Cada `Window` tem um `Viewport` raiz.
*   **InstancePlaceholder**: Um nó que atua como um placeholder para uma cena instanciada, carregando-a sob demanda.
*   **MissingNode**: Um nó placeholder para nós que não puderam ser carregados (ex: script ausente).

### Nós 2D

Classes dedicadas à criação e manipulação de elementos em um ambiente 2D.

*   **Area2D**: Detecta sobreposições e colisões sem participar da simulação física.
*   **AnimatedSprite2D**: Exibe animações 2D baseadas em `SpriteFrames`.
*   **CollisionObject2D**: Base para objetos que interagem com o sistema de colisão 2D.
*   **CollisionPolygon2D**: Define uma forma de colisão 2D usando um polígono.
*   **CollisionShape2D**: Define uma forma de colisão 2D usando um `Shape2D`.
*   **LightOccluder2D**: Define uma forma que bloqueia a luz em 2D.
*   **Line2D**: Desenha uma linha 2D usando uma série de pontos.
*   **Marker2D**: Um nó auxiliar para marcar posições 2D.
*   **MeshInstance2D**: Exibe uma malha 2D.
*   **MultiMeshInstance2D**: Renderiza múltiplas instâncias de uma malha 2D de forma eficiente.
*   **Parallax2D**: Adiciona profundidade a planos de fundo com efeitos de paralaxe.
*   **ParallaxBackground**: Contêiner para camadas de paralaxe.
*   **ParallaxLayer**: Uma camada dentro de um `ParallaxBackground` com seu próprio fator de rolagem.
*   **Path2D**: Define um caminho 2D para nós seguirem.
*   **PathFollow2D**: Um nó que segue um `Path2D`.
*   **Polygon2D**: Desenha um polígono 2D.
*   **RayCast2D**: Realiza um raio de colisão 2D.
*   **RemoteTransform2D**: Transforma um nó remoto em 2D.
*   **ResourcePreloader**: Pré-carrega recursos para uso posterior.
*   **Skeleton2D**: Gerencia uma hierarquia de `Bone2D`s para deformação de malhas 2D.
*   **Sprite2D**: Exibe uma textura 2D.
*   **TileMap**: Um nó para criar mapas de tiles 2D.
*   **TileMapLayer**: Uma camada dentro de um `TileMap`.
*   **TouchScreenButton**: Um botão para entrada de toque.
*   **VisibleOnScreenEnabler2D**: Habilita/desabilita nós quando visíveis na tela 2D.
*   **VisibleOnScreenNotifier2D**: Notifica quando visível/invisível na tela 2D.
*   **World2D**: Contém informações de ambiente 2D para a cena.

### Nós 3D

Classes para construir e interagir com ambientes tridimensionais.

*   **Area3D**: Detecta sobreposições e colisões sem participar da simulação física.
*   **AnimatedSprite3D**: Exibe animações 3D baseadas em `SpriteFrames`.
*   **BoneAttachment3D**: Anexa um nó a um osso em um `Skeleton3D`.
*   **Camera3D**: Uma câmera 3D para renderizar a cena.
*   **CollisionObject3D**: Base para objetos que interagem com o sistema de colisão 3D.
*   **CollisionPolygon3D**: Define uma forma de colisão 3D usando um polígono.
*   **CollisionShape3D**: Define uma forma de colisão 3D usando um `Shape3D`.
*   **Decal**: Projeta uma textura em uma superfície 3D.
*   **FogVolume**: Define um volume de névoa 3D.
*   **GeometryInstance3D**: Base para nós que representam geometria 3D.
*   **GridMap**: Um nó para criar mapas de tiles 3D.
*   **ImporterMeshInstance3D**: Uma instância de malha importada.
*   **Label3D**: Exibe texto 3D.
*   **LightmapGI**: Iluminação global estática baseada em lightmaps.
*   **LightmapProbe**: Uma sonda para `LightmapGI`.
*   **Marker3D**: Um nó auxiliar para marcar posições 3D.
*   **MeshInstance3D**: Exibe uma malha 3D.
*   **MultiMeshInstance3D**: Renderiza múltiplas instâncias de uma malha 3D de forma eficiente.
*   **OccluderInstance3D**: Uma instância de oclusor 3D para culling.
*   **Path3D**: Define um caminho 3D para nós seguirem.
*   **PathFollow3D**: Um nó que segue um `Path3D`.
*   **ReflectionProbe**: Captura o ambiente para reflexões.
*   **RemoteTransform3D**: Transforma um nó remoto em 3D.
*   **RootMotionView**: Visualiza o movimento da raiz de uma animação.
*   **Skeleton3D**: Gerencia uma hierarquia de ossos para deformação de malhas 3D.
*   **SkeletonIK3D**: Resolve cinemática inversa para um `Skeleton3D`.
*   **Sprite3D**: Exibe uma textura 2D em 3D.
*   **SpriteBase3D**: Base para `Sprite3D` e `AnimatedSprite3D`.
*   **VisibleOnScreenEnabler3D**: Habilita/desabilita nós quando visíveis na tela 3D.
*   **VisibleOnScreenNotifier3D**: Notifica quando visível/invisível na tela 3D.
*   **VisualInstance3D**: Base para nós que podem ser renderizados em 3D.
*   **VoxelGI**: Iluminação global em tempo real baseada em voxels.
*   **World3D**: Contém informações de ambiente 3D para a cena.

### Nós de Interface de Usuário (UI)

Classes para construir interfaces de usuário interativas e responsivas.

*   **Control**: A classe base para todos os elementos de interface de usuário. Gerencia layout, eventos de entrada e desenho.
*   **AcceptDialog**: Uma caixa de diálogo simples com um botão "OK".
*   **AspectRatioContainer**: Um contêiner que mantém uma proporção específica para seus filhos.
*   **BaseButton**: Base para todos os tipos de botões.
*   **BoxContainer**: Base para `HBoxContainer` e `VBoxContainer`.
*   **Button**: Um botão clicável.
*   **CenterContainer**: Um contêiner que centraliza seus filhos.
*   **CheckBox**: Uma caixa de seleção.
*   **CheckButton**: Um botão que pode ser alternado (ligado/desligado).
*   **CodeEdit**: Um editor de código com realce de sintaxe.
*   **ColorPicker**: Um seletor de cores.
*   **ColorPickerButton**: Um botão que abre um seletor de cores.
*   **ColorRect**: Um retângulo preenchido com uma cor.
*   **ConfirmationDialog**: Uma caixa de diálogo com botões "OK" e "Cancelar".
*   **Container**: Base para todos os contêineres de UI.
*   **FileDialog**: Um diálogo para abrir/salvar arquivos.
*   **FlowContainer**: Base para `HFlowContainer` e `VFlowContainer`.
*   **FoldableContainer**: Um contêiner que pode ser dobrado/expandido.
*   **GridContainer**: Um contêiner que organiza seus filhos em uma grade.
*   **HBoxContainer**: Um contêiner que organiza seus filhos horizontalmente.
*   **HFlowContainer**: Um contêiner que organiza seus filhos horizontalmente e quebra a linha.
*   **HScrollBar**: Uma barra de rolagem horizontal.
*   **HSeparator**: Um separador horizontal.
*   **HSlider**: Um slider horizontal.
*   **HSplitContainer**: Um contêiner que divide o espaço horizontalmente.
*   **ItemList**: Uma lista de itens selecionáveis.
*   **Label**: Exibe texto.
*   **LineEdit**: Um campo de entrada de texto de linha única.
*   **LinkButton**: Um botão que se parece com um link.
*   **MarginContainer**: Um contêiner que adiciona margens aos seus filhos.
*   **MenuBar**: Uma barra de menu.
*   **MenuButton**: Um botão que abre um menu pop-up.
*   **NinePatchRect**: Um retângulo que pode ser redimensionado sem distorcer os cantos.
*   **OptionButton**: Um botão que exibe um menu de opções.
*   **Panel**: Um painel simples.
*   **PanelContainer**: Um contêiner com um painel de fundo.
*   **Popup**: Base para janelas pop-up.
*   **PopupMenu**: Um menu pop-up.
*   **PopupPanel**: Um painel pop-up.
*   **ProgressBar**: Uma barra de progresso.
*   **Range**: Base para nós com um valor mínimo, máximo e atual (ex: `ProgressBar`, `Slider`).
*   **ReferenceRect**: Um retângulo de referência para layout.
*   **RichTextLabel**: Exibe texto formatado com tags BBCode.
*   **ScrollBar**: Base para barras de rolagem.
*   **ScrollContainer**: Um contêiner que permite rolagem.
*   **Separator**: Base para separadores.
*   **SpinBox**: Um campo de entrada numérica com botões de girar.
*   **SplitContainer**: Base para contêineres de divisão.
*   **StatusIndicator**: Um indicador de status.
*   **TabBar**: Uma barra com abas.
*   **TabContainer**: Um contêiner com abas.
*   **TextEdit**: Um editor de texto multilinha.
*   **TextureButton**: Um botão que usa texturas para seus estados.
*   **TextureProgressBar**: Uma barra de progresso que usa texturas.
*   **TextureRect**: Exibe uma textura.
*   **Tree**: Uma visualização em árvore hierárquica.
*   **VBoxContainer**: Um contêiner que organiza seus filhos verticalmente.
*   **VFlowContainer**: Um contêiner que organiza seus filhos verticalmente e quebra a linha.
*   **VScrollBar**: Uma barra de rolagem vertical.
*   **VSeparator**: Um separador vertical.
*   **VSlider**: Um slider vertical.
*   **VSplitContainer**: Um contêiner que divide o espaço verticalmente.
*   **Window**: A janela principal ou uma sub-janela do aplicativo.

### Nós de Animação

Classes para criar, reproduzir e controlar animações complexas.

*   **AnimationMixer**: Classe base para nós que reproduzem animações, como `AnimationPlayer` e `AnimationTree`.
*   **AnimationPlayer**: Reproduz e gerencia recursos `Animation`.
*   **AnimationTree**: Uma ferramenta poderosa para misturar e controlar animações complexas.
*   **AnimatableBody2D**: Um corpo físico 2D que pode ser animado.
*   **AnimatableBody3D**: Um corpo físico 3D que pode ser animado.
*   **Bone2D**: Um osso em um `Skeleton2D`.
*   **BoneAttachment3D**: Anexa um nó a um osso em um `Skeleton3D`.
*   **BoneConstraint3D**: Restringe o movimento de um osso em 3D.
*   **LookAtModifier3D**: Modificador de osso 3D que faz um osso "olhar para" um alvo.
*   **ModifierBoneTarget3D**: Um alvo para modificadores de osso 3D.
*   **RetargetModifier3D**: Modificador de osso 3D para retargeting de animações.
*   **SkeletonModifier3D**: Base para modificadores de esqueleto 3D.
*   **SpringBoneSimulator3D**: Simula ossos de mola em 3D.
*   **ConvertTransformModifier3D**: Modificador de osso 3D para converter transformações.
*   **CopyTransformModifier3D**: Modificador de osso 3D para copiar transformações.

### Nós de Áudio e Vídeo

Classes para reprodução e controle de áudio e vídeo.

*   **AudioListener2D**: Um ouvinte de áudio 2D.
*   **AudioListener3D**: Um ouvinte de áudio 3D.
*   **AudioStreamPlayer**: Base para nós que reproduzem `AudioStream`.
*   **AudioStreamPlayer2D**: Reproduz `AudioStream` em 2D.
*   **AudioStreamPlayer3D**: Reproduz `AudioStream` em 3D.
*   **VideoStreamPlayer**: Reproduz um `VideoStream`.

### Nós de Física

Classes para simulação de física, detecção de colisão e interação de corpos.

*   **CharacterBody2D**: Um corpo físico 2D para personagens controlados.
*   **CharacterBody3D**: Um corpo físico 3D para personagens controlados.
*   **DampedSpringJoint2D**: Uma junta de mola amortecida 2D.
*   **Generic6DOFJoint3D**: Uma junta genérica de 6 graus de liberdade 3D.
*   **GrooveJoint2D**: Uma junta de ranhura 2D.
*   **HingeJoint3D**: Uma junta de dobradiça 3D.
*   **Joint2D**: Base para todas as juntas 2D.
*   **Joint3D**: Base para todas as juntas 3D.
*   **PhysicalBone2D**: Um osso físico 2D.
*   **PhysicalBone3D**: Um osso físico 3D.
*   **PhysicalBoneSimulator3D**: Simula ossos físicos em 3D.
*   **PhysicsBody2D**: Base para todos os corpos físicos 2D.
*   **PhysicsBody3D**: Base para todos os corpos físicos 3D.
*   **PinJoint2D**: Uma junta de pino 2D.
*   **PinJoint3D**: Uma junta de pino 3D.
*   **RigidBody2D**: Um corpo físico 2D rígido.
*   **RigidBody3D**: Um corpo físico 3D rígido.
*   **SliderJoint3D**: Uma junta deslizante 3D.
*   **SoftBody3D**: Simula corpos macios (roupas, tecidos).
*   **StaticBody2D**: Um corpo físico 2D que não se move.
*   **StaticBody3D**: Um corpo físico 3D que não se move.
*   **VehicleBody3D**: Um corpo físico 3D para veículos.
*   **VehicleWheel3D**: Uma roda para `VehicleBody3D`.
*   **WorldBoundaryShape2D**: Uma forma de limite de mundo 2D.
*   **WorldBoundaryShape3D**: Uma forma de limite de mundo 3D.
*   **ShapeCast2D**: Realiza um cast de forma 2D.
*   **ShapeCast3D**: Realiza um cast de forma 3D.

### Nós de Navegação

Classes para criar e gerenciar caminhos e agentes de navegação.

*   **NavigationAgent2D**: Um agente de navegação 2D.
*   **NavigationAgent3D**: Um agente de navegação 3D.
*   **NavigationLink2D**: Um link de navegação 2D.
*   **NavigationLink3D**: Um link de navegação 3D.
*   **NavigationObstacle2D**: Um obstáculo de navegação 2D.
*   **NavigationObstacle3D**: Um obstáculo de navegação 3D.
*   **NavigationRegion2D**: Uma região de navegação 2D.
*   **NavigationRegion3D**: Uma região de navegação 3D.

### Nós de Partículas

Classes para sistemas de partículas 2D e 3D, permitindo efeitos visuais dinâmicos.

*   **CPUParticles2D**: Sistema de partículas 2D processado na CPU.
*   **CPUParticles3D**: Sistema de partículas 3D processado na CPU.
*   **GPUParticles2D**: Sistema de partículas 2D processado na GPU.
*   **GPUParticles3D**: Sistema de partículas 3D processado na GPU.
*   **GPUParticlesAttractor3D**: Base para atratores de partículas 3D.
*   **GPUParticlesAttractorBox3D**: Atrator de partículas 3D em forma de caixa.
*   **GPUParticlesAttractorSphere3D**: Atrator de partículas 3D em forma de esfera.
*   **GPUParticlesAttractorVectorField3D**: Atrator de partículas 3D usando um campo vetorial.
*   **GPUParticlesCollision3D**: Base para colisores de partículas 3D.
*   **GPUParticlesCollisionBox3D**: Colisor de partículas 3D em forma de caixa.
*   **GPUParticlesCollisionHeightField3D**: Colisor de partículas 3D usando um campo de altura.
*   **GPUParticlesCollisionSDF3D**: Colisor de partículas 3D usando um campo de distância assinado.
*   **GPUParticlesCollisionSphere3D**: Colisor de partículas 3D em forma de esfera.

### Nós de Renderização e Iluminação

Classes para controlar a aparência visual da cena, incluindo luzes e efeitos de ambiente.

*   **BackBufferCopy**: Copia o conteúdo do buffer de tela para uma textura.
*   **DirectionalLight2D**: Uma luz direcional 2D.
*   **DirectionalLight3D**: Uma luz direcional 3D (simula o sol).
*   **Light2D**: Base para todas as luzes 2D.
*   **Light3D**: Base para todas as luzes 3D.
*   **OmniLight3D**: Uma luz omnidirecional 3D (ponto de luz).
*   **PointLight2D**: Uma luz pontual 2D.
*   **SpotLight3D**: Uma luz spot 3D (cone de luz).
*   **WorldEnvironment**: Configurações de ambiente global para a cena.
*   **ShaderGlobalsOverride**: Permite sobrescrever globais de shader.

### Nós de XR (Realidade Estendida)

Classes para desenvolver aplicações de Realidade Virtual (VR) e Realidade Aumentada (AR).

*   **OpenXRCompositionLayer**: Base para camadas de composição OpenXR.
*   **OpenXRCompositionLayerCylinder**: Camada de composição OpenXR cilíndrica.
*   **OpenXRCompositionLayerEquirect**: Camada de composição OpenXR equiretangular.
*   **OpenXRCompositionLayerQuad**: Camada de composição OpenXR quad.
*   **OpenXRHand**: Representa uma mão OpenXR.
*   **OpenXRRenderModel**: Um modelo de renderização OpenXR.
*   **OpenXRRenderModelManager**: Gerencia modelos de renderização OpenXR.
*   **OpenXRVisibilityMask**: Máscara de visibilidade OpenXR.
*   **XRAnchor3D**: Uma âncora XR em 3D.
*   **XRBodyModifier3D**: Modificador de corpo XR em 3D.
*   **XRCamera3D**: Uma câmera XR em 3D.
*   **XRController3D**: Um controlador XR em 3D.
*   **XRFaceModifier3D**: Modificador de rosto XR em 3D.
*   **XRHandModifier3D**: Modificador de mão XR em 3D.
*   **XRNode3D**: Base para nós XR em 3D.
*   **XROrigin3D**: A origem do espaço XR em 3D.
*   **OpenXRBindingModifierEditor**: Editor de modificador de binding OpenXR.
*   **OpenXRInteractionProfileEditor**: Editor de perfil de interação OpenXR.
*   **OpenXRInteractionProfileEditorBase**: Base do editor de perfil de interação OpenXR.

### Nós de CSG (Constructive Solid Geometry)

Classes para criar geometria 3D de forma procedural através de operações booleanas.

*   **CSGBox3D**: Uma primitiva CSG de caixa.
*   **CSGCombiner3D**: Combina múltiplas primitivas CSG.
*   **CSGCylinder3D**: Uma primitiva CSG de cilindro.
*   **CSGMesh3D**: Uma primitiva CSG baseada em malha.
*   **CSGPolygon3D**: Uma primitiva CSG de polígono.
*   **CSGPrimitive3D**: Base para todas as primitivas CSG.
*   **CSGShape3D**: Base para todas as formas CSG.
*   **CSGSphere3D**: Uma primitiva CSG de esfera.
*   **CSGTorus3D**: Uma primitiva CSG de toro.

### Nós de Edição (Editor-only Nodes)

Nós que são usados exclusivamente dentro do editor Godot para auxiliar no desenvolvimento.

*   **EditorCommandPalette**: Paleta de comandos do editor.
*   **EditorFileDialog**: Diálogo de arquivo do editor.
*   **EditorFileSystem**: O sistema de arquivos do editor.
*   **EditorInspector**: O inspetor do editor.
*   **EditorProperty**: Um editor de propriedade no inspetor.
*   **EditorResourcePicker**: Seletor de recursos do editor.
*   **EditorScriptPicker**: Seletor de script do editor.
*   **EditorSpinSlider**: Um slider com um campo de entrada numérica.
*   **EditorToaster**: Exibe mensagens temporárias no editor.
*   **FileSystemDock**: O dock do sistema de arquivos do editor.
*   **GraphEdit**: Um editor de grafo visual.
*   **GraphElement**: Base para elementos em um `GraphEdit`.
*   **GraphFrame**: Um frame para agrupar nós em um `GraphEdit`.
*   **GraphNode**: Um nó dentro de um `GraphEdit`.
*   **ScriptCreateDialog**: Diálogo para criar scripts.
*   **ScriptEditor**: O editor de script.
*   **ScriptEditorBase**: Base para o editor de script.

## Recursos (Resources)

Recursos são blocos de dados que podem ser salvos e carregados independentemente dos nós. Eles representam ativos como texturas, materiais, scripts, animações e configurações.

### Recursos Base e Utilitários

Classes fundamentais para o gerenciamento de recursos e dados.

*   **Resource**: A classe base para todos os recursos. Recursos são blocos de dados que podem ser salvos e carregados.
*   **PackedScene**: Um recurso que contém uma cena inteira, permitindo que ela seja instanciada.
*   **RefCounted**: Base para objetos que são contados por referência. Muitos recursos herdam disso.
*   **ConfigFile**: Um arquivo de configuração para armazenar dados chave-valor.
*   **Image**: Um recurso que armazena dados de imagem.
*   **MissingResource**: Um recurso placeholder para recursos que não puderam ser carregados.
*   **PackedDataContainer**: Um contêiner de dados empacotados.
*   **PackedDataContainerRef**: Referência a um contêiner de dados empacotados.
*   **Shortcut**: Um atalho de teclado ou entrada.
*   **Translation**: Um recurso de tradução.
*   **TranslationDomain**: Um domínio de tradução.
*   **X509Certificate**: Um certificado X.509.

### Recursos de Animação

Recursos que definem e controlam o comportamento de animações.

*   **Animation**: Contém os dados de uma única animação (keyframes, trilhas).
*   **AnimatedTexture**: Uma textura que exibe uma sequência de frames.
*   **AnimationLibrary**: Uma coleção de recursos `Animation`.
*   **AnimationNode**: Base para nós usados em um `AnimationTree`.
*   **AnimationNodeAdd2**: Adiciona duas animações.
*   **AnimationNodeAdd3**: Adiciona três animações.
*   **AnimationNodeAnimation**: Reproduz uma animação específica.
*   **AnimationNodeBlend2**: Mistura duas animações.
*   **AnimationNodeBlend3**: Mistura três animações.
*   **AnimationNodeBlendSpace1D**: Espaço de mistura 1D para animações.
*   **AnimationNodeBlendSpace2D**: Espaço de mistura 2D para animações.
*   **AnimationNodeBlendTree**: Uma árvore de mistura de animações.
*   **AnimationNodeExtension**: Extensão para `AnimationNode`.
*   **AnimationNodeOneShot**: Reproduz uma animação uma vez.
*   **AnimationNodeOutput**: O nó de saída de um `AnimationTree`.
*   **AnimationNodeStateMachine**: Uma máquina de estados para animações.
*   **AnimationNodeStateMachinePlayback**: Controla a reprodução de um `AnimationNodeStateMachine`.
*   **AnimationNodeStateMachineTransition**: Uma transição entre estados em um `AnimationNodeStateMachine`.
*   **AnimationNodeSub2**: Subtrai duas animações.
*   **AnimationNodeSync**: Sincroniza animações.
*   **AnimationNodeTimeScale**: Escala o tempo de uma animação.
*   **AnimationNodeTimeSeek**: Busca um ponto específico no tempo de uma animação.
*   **AnimationNodeTransition**: Transição entre animações.
*   **AnimationRootNode**: O nó raiz de um `AnimationTree`.
*   **BoneMap**: Mapeia ossos.
*   **Curve**: Um recurso que define uma curva.
*   **Curve2D**: Um recurso que define uma curva 2D.
*   **Curve3D**: Um recurso que define uma curva 3D.
*   **CurveTexture**: Uma textura gerada a partir de uma curva.
*   **CurveXYZTexture**: Uma textura XYZ gerada a partir de uma curva.
*   **SpriteFrames**: Contém os frames e animações para `AnimatedSprite2D`.
*   **SkeletonModification2D**: Base para modificações de esqueleto 2D.
*   **SkeletonModification2DCCDIK**: Modificação de esqueleto 2D CCDIK.
*   **SkeletonModification2DFABRIK**: Modificação de esqueleto 2D FABRIK.
*   **SkeletonModification2DJiggle**: Modificação de esqueleto 2D Jiggle.
*   **SkeletonModification2DLookAt**: Modificação de esqueleto 2D LookAt.
*   **SkeletonModification2DPhysicalBones**: Modificação de esqueleto 2D de ossos físicos.
*   **SkeletonModification2DStackHolder**: Holder de stack de modificação de esqueleto 2D.
*   **SkeletonModification2DTwoBoneIK**: Modificação de esqueleto 2D TwoBoneIK.
*   **SkeletonModificationStack2D**: Stack de modificação de esqueleto 2D.
*   **SkeletonProfile**: Um perfil de esqueleto.
*   **SkeletonProfileHumanoid**: Um perfil de esqueleto humanoide.
*   **Skin**: Um recurso de skin.

### Recursos de Áudio e Vídeo

Recursos que representam streams de áudio, efeitos e configurações de barramento.

*   **AudioBusLayout**: Define o layout dos barramentos de áudio.
*   **AudioEffect**: Base para todos os efeitos de áudio.
*   **AudioEffectAmplify**: Efeito de amplificação de áudio.
*   **AudioEffectBandLimitFilter**: Filtro de limite de banda de áudio.
*   **AudioEffectBandPassFilter**: Filtro passa-banda de áudio.
*   **AudioEffectCapture**: Captura áudio.
*   **AudioEffectChorus**: Efeito de chorus de áudio.
*   **AudioEffectCompressor**: Efeito de compressor de áudio.
*   **AudioEffectDelay**: Efeito de delay de áudio.
*   **AudioEffectDistortion**: Efeito de distorção de áudio.
*   **AudioEffectEQ**: Base para equalizadores de áudio.
*   **AudioEffectEQ10**: Equalizador de 10 bandas.
*   **AudioEffectEQ21**: Equalizador de 21 bandas.
*   **AudioEffectEQ6**: Equalizador de 6 bandas.
*   **AudioEffectFilter**: Base para filtros de áudio.
*   **AudioEffectHardLimiter**: Limitador de áudio rígido.
*   **AudioEffectHighPassFilter**: Filtro passa-altas de áudio.
*   **AudioEffectHighShelfFilter**: Filtro high-shelf de áudio.
*   **AudioEffectLimiter**: Efeito de limitador de áudio.
*   **AudioEffectLowPassFilter**: Filtro passa-baixas de áudio.
*   **AudioEffectLowShelfFilter**: Filtro low-shelf de áudio.
*   **AudioEffectNotchFilter**: Filtro notch de áudio.
*   **AudioEffectPanner**: Efeito de panner de áudio.
*   **AudioEffectPhaser**: Efeito de phaser de áudio.
*   **AudioEffectPitchShift**: Efeito de pitch shift de áudio.
*   **AudioEffectRecord**: Grava áudio.
*   **AudioEffectReverb**: Efeito de reverb de áudio.
*   **AudioEffectSpectrumAnalyzer**: Analisador de espectro de áudio.
*   **AudioEffectStereoEnhance**: Efeito de aprimoramento estéreo de áudio.
*   **AudioStream**: Base para todos os streams de áudio.
*   **AudioStreamGenerator**: Gera áudio programaticamente.
*   **AudioStreamInteractive**: Stream de áudio interativo.
*   **AudioStreamMicrophone**: Stream de áudio do microfone.
*   **AudioStreamMP3**: Stream de áudio MP3.
*   **AudioStreamOggVorbis**: Stream de áudio Ogg Vorbis.
*   **AudioStreamPlaylist**: Stream de áudio de playlist.
*   **AudioStreamPolyphonic**: Stream de áudio polifônico.
*   **AudioStreamRandomizer**: Stream de áudio aleatório.
*   **AudioStreamSynchronized**: Stream de áudio sincronizado.
*   **AudioStreamWAV**: Stream de áudio WAV.
*   **OggPacketSequence**: Sequência de pacotes Ogg.
*   **VideoStream**: Base para streams de vídeo.
*   **VideoStreamTheora**: Stream de vídeo Theora.

### Recursos de Material e Shader

Recursos que definem como os objetos são renderizados, incluindo suas cores, texturas e efeitos visuais.

*   **BaseMaterial3D**: Base para materiais 3D.
*   **CanvasItemMaterial**: Material para `CanvasItem`s.
*   **FogMaterial**: Material para `FogVolume`.
*   **Material**: Base para todos os materiais.
*   **ORMMaterial3D**: Material 3D com oclusão, rugosidade e metálico.
*   **PanoramaSkyMaterial**: Material para céu panorâmico.
*   **ParticleProcessMaterial**: Material para processamento de partículas.
*   **PhysicalSkyMaterial**: Material para céu físico.
*   **PlaceholderMaterial**: Material de placeholder.
*   **ProceduralSkyMaterial**: Material para céu procedural.
*   **Shader**: Um recurso que contém código de shader.
*   **ShaderInclude**: Inclui outro shader.
*   **ShaderMaterial**: Um material que usa um `Shader`.
*   **StandardMaterial3D**: Material 3D padrão.
*   **VisualShader**: Um shader visual.
*   **VisualShaderNode**: Base para nós em um `VisualShader`.
*   **VisualShaderNodeBillboard**: Nó de shader visual para billboard.
*   **VisualShaderNodeBooleanConstant**: Constante booleana em shader visual.
*   **VisualShaderNodeBooleanParameter**: Parâmetro booleano em shader visual.
*   **VisualShaderNodeClamp**: Nó de shader visual para clamp.
*   **VisualShaderNodeColorConstant**: Constante de cor em shader visual.
*   **VisualShaderNodeColorFunc**: Função de cor em shader visual.
*   **VisualShaderNodeColorOp**: Operação de cor em shader visual.
*   **VisualShaderNodeColorParameter**: Parâmetro de cor em shader visual.
*   **VisualShaderNodeComment**: Comentário em shader visual.
*   **VisualShaderNodeCompare**: Comparação em shader visual.
*   **VisualShaderNodeConstant**: Constante em shader visual.
*   **VisualShaderNodeCubemap**: Cubemap em shader visual.
*   **VisualShaderNodeCubemapParameter**: Parâmetro de cubemap em shader visual.
*   **VisualShaderNodeCurveTexture**: Textura de curva em shader visual.
*   **VisualShaderNodeCurveXYZTexture**: Textura XYZ de curva em shader visual.
*   **VisualShaderNodeCustom**: Nó customizado em shader visual.
*   **VisualShaderNodeDerivativeFunc**: Função derivada em shader visual.
*   **VisualShaderNodeDeterminant**: Determinante em shader visual.
*   **VisualShaderNodeDistanceFade**: Fade por distância em shader visual.
*   **VisualShaderNodeDotProduct**: Produto escalar em shader visual.
*   **VisualShaderNodeExpression**: Expressão em shader visual.
*   **VisualShaderNodeFaceForward**: Face forward em shader visual.
*   **VisualShaderNodeFloatConstant**: Constante float em shader visual.
*   **VisualShaderNodeFloatFunc**: Função float em shader visual.
*   **VisualShaderNodeFloatOp**: Operação float em shader visual.
*   **VisualShaderNodeFloatParameter**: Parâmetro float em shader visual.
*   **VisualShaderNodeFrame**: Frame em shader visual.
*   **VisualShaderNodeFresnel**: Fresnel em shader visual.
*   **VisualShaderNodeGlobalExpression**: Expressão global em shader visual.
*   **VisualShaderNodeGroupBase**: Base para grupo em shader visual.
*   **VisualShaderNodeIf**: If em shader visual.
*   **VisualShaderNodeInput**: Entrada em shader visual.
*   **VisualShaderNodeIntConstant**: Constante int em shader visual.
*   **VisualShaderNodeIntFunc**: Função int em shader visual.
*   **VisualShaderNodeIntOp**: Operação int em shader visual.
*   **VisualShaderNodeIntParameter**: Parâmetro int em shader visual.
*   **VisualShaderNodeIs**: Is em shader visual.
*   **VisualShaderNodeLinearSceneDepth**: Profundidade linear da cena em shader visual.
*   **VisualShaderNodeMix**: Mix em shader visual.
*   **VisualShaderNodeMultiplyAdd**: Multiplicar e adicionar em shader visual.
*   **VisualShaderNodeOuterProduct**: Produto externo em shader visual.
*   **VisualShaderNodeOutput**: Saída em shader visual.
*   **VisualShaderNodeParameter**: Parâmetro em shader visual.
*   **VisualShaderNodeParameterRef**: Referência de parâmetro em shader visual.
*   **VisualShaderNodeParticleAccelerator**: Acelerador de partículas em shader visual.
*   **VisualShaderNodeParticleBoxEmitter**: Emissor de caixa de partículas em shader visual.
    *   **VisualShaderNodeParticleConeVelocity**: Velocidade de cone de partículas em shader visual.
    *   **VisualShaderNodeParticleEmit**: Emitir partículas em shader visual.
    *   **VisualShaderNodeParticleEmitter**: Emissor de partículas em shader visual.
    *   **VisualShaderNodeParticleMeshEmitter**: Emissor de malha de partículas em shader visual.
    *   **VisualShaderNodeParticleMultiplyByAxisAngle**: Multiplicar por eixo-ângulo de partículas em shader visual.
    *   **VisualShaderNodeParticleOutput**: Saída de partículas em shader visual.
    *   **VisualShaderNodeParticleRandomness**: Aleatoriedade de partículas em shader visual.
    *   **VisualShaderNodeParticleRingEmitter**: Emissor de anel de partículas em shader visual.
    *   **VisualShaderNodeParticleSphereEmitter**: Emissor de esfera de partículas em shader visual.
    *   **VisualShaderNodeProximityFade**: Fade por proximidade em shader visual.
    *   **VisualShaderNodeRandomRange**: Range aleatório em shader visual.
    *   **VisualShaderNodeRemap**: Remap em shader visual.
    *   **VisualShaderNodeReroute**: Reroute em shader visual.
    *   **VisualShaderNodeResizableBase**: Base redimensionável em shader visual.
    *   **VisualShaderNodeRotationByAxis**: Rotação por eixo em shader visual.
    *   **VisualShaderNodeSample3D**: Amostra 3D em shader visual.
    *   **VisualShaderNodeScreenNormalWorldSpace**: Normal de tela em espaço de mundo em shader visual.
    *   **VisualShaderNodeScreenUVToSDF**: UV de tela para SDF em shader visual.
    *   **VisualShaderNodeSDFRaymarch**: Raymarch SDF em shader visual.
    *   **VisualShaderNodeSDFToScreenUV**: SDF para UV de tela em shader visual.
    *   **VisualShaderNodeSmoothStep**: Smooth step em shader visual.
    *   **VisualShaderNodeStep**: Step em shader visual.
    *   **VisualShaderNodeSwitch**: Switch em shader visual.
    *   **VisualShaderNodeTexture**: Textura em shader visual.
    *   **VisualShaderNodeTexture2DArray**: Array de textura 2D em shader visual.
    *   **VisualShaderNodeTexture2DArrayParameter**: Parâmetro de array de textura 2D em shader visual.
    *   **VisualShaderNodeTexture2DParameter**: Parâmetro de textura 2D em shader visual.
    *   **VisualShaderNodeTexture3D**: Textura 3D em shader visual.
    *   **VisualShaderNodeTexture3DParameter**: Parâmetro de textura 3D em shader visual.
    *   **VisualShaderNodeTextureParameter**: Parâmetro de textura em shader visual.
    *   **VisualShaderNodeTextureParameterTriplanar**: Parâmetro de textura triplanar em shader visual.
    *   **VisualShaderNodeTextureSDF**: Textura SDF em shader visual.
    *   **VisualShaderNodeTextureSDFNormal**: Normal de textura SDF em shader visual.
    *   **VisualShaderNodeTransformCompose**: Compor transformação em shader visual.
    *   **VisualShaderNodeTransformConstant**: Constante de transformação em shader visual.
    *   **VisualShaderNodeTransformDecompose**: Decompor transformação em shader visual.
    *   **VisualShaderNodeTransformFunc**: Função de transformação em shader visual.
    *   **VisualShaderNodeTransformOp**: Operação de transformação em shader visual.
    *   **VisualShaderNodeTransformParameter**: Parâmetro de transformação em shader visual.
    *   **VisualShaderNodeTransformVecMult**: Multiplicação de vetor por transformação em shader visual.
    *   **VisualShaderNodeUIntConstant**: Constante UInt em shader visual.
    *   **VisualShaderNodeUIntFunc**: Função UInt em shader visual.
    *   **VisualShaderNodeUIntOp**: Operação UInt em shader visual.
    *   **VisualShaderNodeUIntParameter**: Parâmetro UInt em shader visual.
    *   **VisualShaderNodeUVFunc**: Função UV em shader visual.
    *   **VisualShaderNodeUVPolarCoord**: Coordenada polar UV em shader visual.
    *   **VisualShaderNodeVarying**: Varying em shader visual.
    *   **VisualShaderNodeVaryingGetter**: Getter de varying em shader visual.
    *   **VisualShaderNodeVaryingSetter**: Setter de varying em shader visual.
    *   **VisualShaderNodeVec2Constant**: Constante Vec2 em shader visual.
    *   **VisualShaderNodeVec2Parameter**: Parâmetro Vec2 em shader visual.
    *   **VisualShaderNodeVec3Constant**: Constante Vec3 em shader visual.
    *   **VisualShaderNodeVec3Parameter**: Parâmetro Vec3 em shader visual.
    *   **VisualShaderNodeVec4Constant**: Constante Vec4 em shader visual.
    *   **VisualShaderNodeVec4Parameter**: Parâmetro Vec4 em shader visual.
    *   **VisualShaderNodeVectorBase**: Base de vetor em shader visual.
    *   **VisualShaderNodeVectorCompose**: Compor vetor em shader visual.
    *   **VisualShaderNodeVectorDecompose**: Decompor vetor em shader visual.
    *   **VisualShaderNodeVectorDistance**: Distância de vetor em shader visual.
    *   **VisualShaderNodeVectorFunc**: Função de vetor em shader visual.
    *   **VisualShaderNodeVectorLen**: Comprimento de vetor em shader visual.
    *   **VisualShaderNodeVectorOp**: Operação de vetor em shader visual.
    *   **VisualShaderNodeVectorRefract**: Refração de vetor em shader visual.
    *   **VisualShaderNodeWorldPositionFromDepth**: Posição de mundo a partir da profundidade em shader visual.

### Recursos de Malha (Mesh)

Recursos que definem a geometria 3D de objetos.

*   **ArrayMesh**: Uma malha que armazena seus dados em arrays.
*   **BoxMesh**: Uma malha de caixa.
*   **CapsuleMesh**: Uma malha de cápsula.
*   **CylinderMesh**: Uma malha de cilindro.
*   **ImmediateMesh**: Uma malha que pode ser construída e desenhada imediatamente.
*   **ImporterMesh**: Uma malha importada.
*   **Mesh**: Base para todos os recursos de malha.
*   **MeshLibrary**: Uma coleção de malhas para `GridMap`.
*   **PlaceholderMesh**: Malha de placeholder.
*   **PlaneMesh**: Uma malha de plano.
*   **PointMesh**: Uma malha de ponto.
*   **PrimitiveMesh**: Base para malhas primitivas.
*   **PrismMesh**: Uma malha de prisma.
*   **QuadMesh**: Uma malha de quad.
*   **RibbonTrailMesh**: Uma malha de trilha de fita.
*   **SphereMesh**: Uma malha de esfera.
*   **TextMesh**: Uma malha de texto.
*   **TorusMesh**: Uma malha de toro.
*   **TubeTrailMesh**: Uma malha de trilha de tubo.

### Recursos de Forma (Shape) e Oclusão

Recursos que definem formas para colisão, detecção e oclusão.

*   **BoxOccluder3D**: Um oclusor 3D em forma de caixa.
*   **BoxShape3D**: Uma forma de caixa 3D.
*   **CapsuleShape2D**: Uma forma de cápsula 2D.
*   **CapsuleShape3D**: Uma forma de cápsula 3D.
*   **CircleShape2D**: Uma forma de círculo 2D.
*   **ConcavePolygonShape2D**: Uma forma de polígono côncavo 2D.
*   **ConcavePolygonShape3D**: Uma forma de polígono côncavo 3D.
*   **ConvexPolygonShape2D**: Uma forma de polígono convexo 2D.
*   **ConvexPolygonShape3D**: Uma forma de polígono convexo 3D.
*   **HeightMapShape3D**: Uma forma de mapa de altura 3D.
*   **Occluder3D**: Base para recursos de oclusor 3D.
*   **OccluderPolygon2D**: Um oclusor 2D em forma de polígono.
*   **PolygonOccluder3D**: Um oclusor 3D em forma de polígono.
*   **QuadOccluder3D**: Um oclusor 3D em forma de quad.
*   **RectangleShape2D**: Uma forma de retângulo 2D.
*   **SegmentShape2D**: Uma forma de segmento 2D.
*   **SeparationRayShape2D**: Uma forma de raio de separação 2D.
*   **SeparationRayShape3D**: Uma forma de raio de separação 3D.
*   **Shape2D**: Base para todas as formas 2D.
*   **Shape3D**: Base para todas as formas 3D.
*   **SphereOccluder3D**: Um oclusor 3D em forma de esfera.
*   **SphereShape3D**: Uma forma de esfera 3D.
*   **WorldBoundaryShape2D**: Uma forma de limite de mundo 2D.
*   **WorldBoundaryShape3D**: Uma forma de limite de mundo 3D.

### Recursos de Textura

Recursos que armazenam dados de imagem para renderização.

*   **AtlasTexture**: Uma textura que representa uma região de uma textura maior.
*   **CompressedCubemap**: Um cubemap comprimido.
*   **CompressedCubemapArray**: Um array de cubemaps comprimidos.
*   **CompressedTexture2D**: Uma textura 2D comprimida.
*   **CompressedTexture2DArray**: Um array de texturas 2D comprimidas.
*   **CompressedTexture3D**: Uma textura 3D comprimida.
*   **CompressedTextureLayered**: Uma textura em camadas comprimida.
*   **Cubemap**: Um cubemap.
*   **CubemapArray**: Um array de cubemaps.
*   **DPITexture**: Uma textura com informações de DPI.
*   **ExternalTexture**: Uma textura externa.
*   **GradientTexture1D**: Uma textura de gradiente 1D.
*   **GradientTexture2D**: Uma textura de gradiente 2D.
*   **ImageTexture**: Uma textura baseada em `Image`.
*   **ImageTexture3D**: Uma textura 3D baseada em `Image`.
*   **ImageTextureLayered**: Uma textura em camadas baseada em `Image`.
*   **MeshTexture**: Uma textura baseada em malha.
*   **NoiseTexture2D**: Uma textura de ruído 2D.
*   **NoiseTexture3D**: Uma textura de ruído 3D.
*   **PlaceholderCubemap**: Cubemap de placeholder.
*   **PlaceholderCubemapArray**: Array de cubemaps de placeholder.
*   **PlaceholderTexture2D**: Textura 2D de placeholder.
*   **PlaceholderTexture2DArray**: Array de texturas 2D de placeholder.
*   **PlaceholderTexture3D**: Textura 3D de placeholder.
*   **PlaceholderTextureLayered**: Textura em camadas de placeholder.
*   **PortableCompressedTexture2D**: Uma textura 2D comprimida portátil.
*   **Texture**: Base para todos os recursos de textura.
*   **Texture2D**: Uma textura 2D.
*   **Texture2DArray**: Um array de texturas 2D.
*   **Texture2DArrayRD**: Array de texturas 2D para `RenderingDevice`.
*   **Texture2DRD**: Textura 2D para `RenderingDevice`.
*   **Texture3D**: Uma textura 3D.
*   **Texture3DRD**: Textura 3D para `RenderingDevice`.
*   **TextureCubemapArrayRD**: Array de cubemaps para `RenderingDevice`.
    *   **TextureCubemapRD**: Cubemap para `RenderingDevice`.
    *   **TextureLayered**: Uma textura em camadas.
    *   **TextureLayeredRD**: Textura em camadas para `RenderingDevice`.
    *   **ViewportTexture**: Uma textura que contém o conteúdo de um `Viewport`.

### Recursos de Script

Recursos que representam código executável no Godot.

*   **CSharpScript**: Um recurso de script C#.
*   **GDExtension**: Um recurso que representa uma extensão GDExtension.
*   **GDScript**: Um recurso de script GDScript.
*   **Script**: Base para todos os recursos de script.
*   **ScriptExtension**: Extensão para `Script`.

### Recursos de Entrada (InputEvent)

Recursos que descrevem eventos de entrada do usuário.

*   **InputEvent**: Base para todos os eventos de entrada.
*   **InputEventAction**: Um evento de entrada de ação.
*   **InputEventFromWindow**: Um evento de entrada de uma janela.
*   **InputEventGesture**: Um evento de entrada de gesto.
*   **InputEventJoypadButton**: Um evento de entrada de botão de joypad.
*   **InputEventJoypadMotion**: Um evento de entrada de movimento de joypad.
*   **InputEventKey**: Um evento de entrada de tecla.
*   **InputEventMagnifyGesture**: Um evento de entrada de gesto de magnificar.
*   **InputEventMIDI**: Um evento de entrada MIDI.
*   **InputEventMouse**: Base para eventos de entrada de mouse.
*   **InputEventMouseButton**: Um evento de entrada de botão de mouse.
*   **InputEventMouseMotion**: Um evento de entrada de movimento de mouse.
*   **InputEventPanGesture**: Um evento de entrada de gesto de pan.
*   **InputEventScreenDrag**: Um evento de entrada de arrastar tela.
*   **InputEventScreenTouch**: Um evento de entrada de toque de tela.
*   **InputEventShortcut**: Um evento de entrada de atalho.
*   **InputEventWithModifiers**: Um evento de entrada com modificadores (Shift, Ctrl, etc.).

### Recursos de Navegação

Recursos que definem dados para o sistema de navegação.

*   **NavigationMesh**: Uma malha de navegação.
*   **NavigationMeshSourceGeometryData2D**: Dados de geometria de origem para malha de navegação 2D.
*   **NavigationMeshSourceGeometryData3D**: Dados de geometria de origem para malha de navegação 3D.
*   **NavigationPolygon**: Um polígono de navegação.
*   **TileMapPattern**: Um padrão de tilemap.
*   **TileSet**: Um conjunto de tiles para `TileMap`.
*   **TileSetAtlasSource**: Uma fonte de atlas para `TileSet`.
*   **TileSetScenesCollectionSource**: Uma fonte de coleção de cenas para `TileSet`.
*   **TileSetSource**: Base para fontes de `TileSet`.

### Recursos de Física

Recursos que definem propriedades físicas de materiais.

*   **PhysicsMaterial**: Um material físico.

### Recursos de UI e Fonte

Recursos para estilização de UI e gerenciamento de fontes.

*   **ButtonGroup**: Um grupo de botões.
*   **CodeHighlighter**: Realçador de código.
*   **ColorPalette**: Uma paleta de cores.
*   **EditorSettings**: Configurações do editor.
*   **EditorSyntaxHighlighter**: Realçador de sintaxe do editor.
*   **Font**: Base para todos os recursos de fonte.
*   **FontFile**: Um arquivo de fonte.
*   **FontVariation**: Uma variação de fonte.
*   **Gradient**: Um recurso que define um gradiente.
*   **LabelSettings**: Configurações para `Label`.
*   **StyleBox**: Base para caixas de estilo.
*   **StyleBoxEmpty**: Uma caixa de estilo vazia.
*   **StyleBoxFlat**: Uma caixa de estilo plana.
    *   **StyleBoxLine**: Uma caixa de estilo de linha.
    *   **StyleBoxTexture**: Uma caixa de estilo de textura.
    *   **SystemFont**: Uma fonte do sistema.
    *   **SyntaxHighlighter**: Realçador de sintaxe.
    *   **Theme**: Um recurso de tema.

### Recursos de XR

Recursos para configurar e interagir com dispositivos e ações de Realidade Estendida.

*   **OpenXRAction**: Uma ação OpenXR.
*   **OpenXRActionBindingModifier**: Modificador de binding de ação OpenXR.
*   **OpenXRActionMap**: Um mapa de ações OpenXR.
*   **OpenXRActionSet**: Um conjunto de ações OpenXR.
*   **OpenXRAnalogThresholdModifier**: Modificador de limiar analógico OpenXR.
*   **OpenXRBindingModifier**: Modificador de binding OpenXR.
*   **OpenXRDpadBindingModifier**: Modificador de binding de D-pad OpenXR.
*   **OpenXRHapticBase**: Base háptica OpenXR.
*   **OpenXRHapticVibration**: Vibração háptica OpenXR.
*   **OpenXRInteractionProfile**: Um perfil de interação OpenXR.
*   **OpenXRIPBinding**: Um binding de perfil de interação OpenXR.
*   **OpenXRInteractionProfileMetadata**: Metadados de perfil de interação OpenXR.
*   **XRPose**: Uma pose XR.

### Recursos de GLTF

Recursos relacionados à importação e manipulação de modelos no formato GLTF.

*   **GLTFAccessor**: Acessor GLTF.
*   **GLTFAnimation**: Animação GLTF.
*   **GLTFBufferView**: Buffer view GLTF.
*   **GLTFCamera**: Câmera GLTF.
*   **GLTFDocument**: Documento GLTF.
*   **GLTFDocumentExtension**: Extensão de documento GLTF.
*   **GLTFDocumentExtensionConvertImporterMesh**: Extensão de documento GLTF para converter malha importada.
*   **GLTFLight**: Luz GLTF.
*   **GLTFMesh**: Malha GLTF.
*   **GLTFNode**: Nó GLTF.
*   **GLTFObjectModelProperty**: Propriedade de modelo de objeto GLTF.
*   **GLTFPhysicsBody**: Corpo físico GLTF.
*   **GLTFPhysicsShape**: Forma física GLTF.
*   **GLTFSkeleton**: Esqueleto GLTF.
*   **GLTFSkin**: Skin GLTF.
*   **GLTFSpecGloss**: Specular/Glossiness GLTF.
*   **GLTFState**: Estado GLTF.
*   **GLTFTexture**: Textura GLTF.
*   **GLTFTextureSampler**: Sampler de textura GLTF.

### Outros Recursos

Uma variedade de outros recursos que não se encaixam nas categorias anteriores.

*   **CameraAttributes**: Atributos de câmera.
*   **CameraAttributesPhysical**: Atributos físicos de câmera.
*   **CameraAttributesPractical**: Atributos práticos de câmera.
*   **CameraTexture**: Textura de câmera.
*   **Compositor**: Um compositor.
*   **CompositorEffect**: Efeito de compositor.
*   **CryptoKey**: Uma chave criptográfica.
*   **Environment**: Configurações de ambiente.
*   **FastNoiseLite**: Gerador de ruído FastNoiseLite.
*   **FBXDocument**: Documento FBX.
*   **FBXState**: Estado FBX.
*   **FoldableGroup**: Um grupo dobrável.
*   **LightmapGIData**: Dados de GI de lightmap.
*   **Noise**: Base para recursos de ruído.
*   **OptimizedTranslation**: Tradução otimizada.
*   **PolygonPathFinder**: Um localizador de caminho de polígono.
*   **RDShaderFile**: Um arquivo de shader para `RenderingDevice`.
*   **RDShaderSPIRV**: Shader SPIR-V para `RenderingDevice`.
*   **SceneReplicationConfig**: Configuração de replicação de cena.
*   **ShaderGlobalsOverride**: Override de globais de shader.
*   **ShaderIncludeDB**: Banco de dados de includes de shader.
*   **TileData**: Dados de tile.
*   **VoxelGIData**: Dados de GI de voxel.

## Objetos de Serviço e Utilitários (Other Objects)

Essas classes representam singletons globais e objetos de utilidade de baixo nível que fornecem funcionalidades essenciais para o motor, mas não são nós na árvore de cena nem recursos salváveis diretamente.

### Servidores (Servers)

Singletons que gerenciam sistemas de baixo nível do motor.

*   **AudioServer**: Gerencia o processamento de áudio de baixo nível.
*   **DisplayServer**: Gerencia janelas e monitores.
*   **NavigationServer2D**: Gerencia a navegação 2D.
*   **NavigationServer3D**: Gerencia a navegação 3D.
*   **PhysicsServer2D**: Gerencia a simulação física 2D de baixo nível.
*   **PhysicsServer3D**: Gerencia a simulação física 3D de baixo nível.
*   **RenderingServer**: Gerencia a renderização de baixo nível.
*   **TextServer**: Gerencia o layout e renderização de texto avançado.
*   **TranslationServer**: Gerencia a internacionalização.
*   **XRServer**: Gerencia dispositivos XR.

### Gerenciadores de Sistema e Projeto

Singletons que fornecem acesso a informações do sistema operacional, configurações do projeto e controle do motor.

*   **Engine**: Gerencia parâmetros de execução do motor.
*   **Input**: Gerencia todos os eventos de entrada.
*   **InputMap**: Define o mapeamento de ações de entrada.
*   **OS**: Fornece acesso a funcionalidades do sistema operacional.
*   **Performance**: Monitora estatísticas de desempenho.
*   **ProjectSettings**: Gerencia as configurações do projeto.
*   **Time**: Fornece funcionalidades relacionadas à medida de tempo.
*   **SceneTree**: A árvore de cena.

### Ferramentas de Geometria e Dados

Classes utilitárias para manipulação de geometria e dados.

*   **Geometry2D**: Funções utilitárias para operações geométricas 2D.
*   **Geometry3D**: Funções utilitárias para operações geométricas 3D.
*   **MeshDataTool**: Ferramenta para manipular dados de malha.
*   **SurfaceTool**: Ferramenta para construir malhas.
*   **TriangleMesh**: Uma malha de triângulos.
*   **ClassDB**: Banco de dados de classes.
*   **Expression**: Expressão.
*   **HashingContext**: Contexto de hashing.
*   **HMACContext**: Contexto HMAC.
*   **JSON**: Ferramentas para JSON.
*   **Marshalls**: Funções de transformação e codificação de dados.
*   **RegEx**: Expressões regulares.
*   **RegExMatch**: Resultado de uma correspondência de expressão regular.
*   **ResourceLoader**: Carrega recursos.
*   **ResourceSaver**: Salva recursos.
*   **ResourceUID**: UID de recurso.
*   **XMLParser**: Parser XML.
*   **ZIPPacker**: Empacotador ZIP.
*   **ZIPReader**: Leitor ZIP.

### Ferramentas de Rede e Comunicação

Classes para gerenciar conexões de rede e comunicação.

*   **DTLSServer**: Servidor DTLS.
*   **ENetConnection**: Conexão ENet.
*   **ENetMultiplayerPeer**: Peer multiplayer ENet.
*   **ENetPacketPeer**: Peer de pacote ENet.
*   **HTTPClient**: Cliente HTTP.
*   **IP**: IP.
*   **MultiplayerAPI**: API multiplayer.
*   **MultiplayerAPIExtension**: Extensão da API multiplayer.
*   **MultiplayerPeer**: Peer multiplayer.
*   **MultiplayerPeerExtension**: Extensão de peer multiplayer.
*   **OfflineMultiplayerPeer**: Peer multiplayer offline.
*   **PacketPeer**: Peer de pacote.
*   **PacketPeerDTLS**: Peer de pacote DTLS.
*   **PacketPeerExtension**: Extensão de peer de pacote.
*   **PacketPeerStream**: Peer de pacote de stream.
*   **PacketPeerUDP**: Peer de pacote UDP.
*   **SceneMultiplayer**: Multiplayer de cena.
*   **StreamPeer**: Peer de stream.
*   **StreamPeerBuffer**: Peer de stream de buffer.
*   **StreamPeerExtension**: Extensão de peer de stream.
*   **StreamPeerGZIP**: Peer de stream GZIP.
*   **StreamPeerTCP**: Peer de stream TCP.
*   **StreamPeerTLS**: Peer de stream TLS.
*   **TCPServer**: Servidor TCP.
*   **TLSOptions**: Opções TLS.
*   **UDPServer**: Servidor UDP.
*   **UPNP**: UPNP.
*   **UPNPDevice**: Dispositivo UPNP.
*   **WebRTCDataChannel**: Canal de dados WebRTC.
*   **WebRTCDataChannelExtension**: Extensão de canal de dados WebRTC.
*   **WebRTCMultiplayerPeer**: Peer multiplayer WebRTC.
*   **WebRTCPeerConnection**: Conexão de peer WebRTC.
*   **WebRTCPeerConnectionExtension**: Extensão de conexão de peer WebRTC.
*   **WebSocketMultiplayerPeer**: Peer multiplayer WebSocket.
*   **WebSocketPeer**: Peer WebSocket.

### Ferramentas de Editor (Editor-only Objects)

Objetos que fornecem funcionalidades específicas para o ambiente de desenvolvimento do Godot.

*   **EditorContextMenuPlugin**: Plugin de menu de contexto do editor.
*   **EditorDebuggerPlugin**: Plugin de depurador do editor.
*   **EditorDebuggerSession**: Sessão de depurador do editor.
*   **EditorExportPlatform**: Base para plataformas de exportação do editor.
*   **EditorExportPlatformAndroid**: Plataforma de exportação Android.
*   **EditorExportPlatformAppleEmbedded**: Plataforma de exportação Apple embarcada.
*   **EditorExportPlatformExtension**: Extensão de plataforma de exportação.
*   **EditorExportPlatformIOS**: Plataforma de exportação iOS.
*   **EditorExportPlatformLinuxBSD**: Plataforma de exportação Linux/BSD.
*   **EditorExportPlatformMacOS**: Plataforma de exportação macOS.
*   **EditorExportPlatformPC**: Plataforma de exportação PC.
*   **EditorExportPlatformVisionOS**: Plataforma de exportação visionOS.
*   **EditorExportPlatformWeb**: Plataforma de exportação Web.
*   **EditorExportPlatformWindows**: Plataforma de exportação Windows.
*   **EditorExportPlugin**: Plugin de exportação do editor.
*   **EditorExportPreset**: Preset de exportação do editor.
*   **EditorFeatureProfile**: Perfil de recurso do editor.
*   **EditorFileSystemDirectory**: Diretório do sistema de arquivos do editor.
*   **EditorFileSystemImportFormatSupportQuery**: Query de suporte a formato de importação do sistema de arquivos do editor.
*   **EditorImportPlugin**: Plugin de importação do editor.
*   **EditorInspectorPlugin**: Plugin de inspetor do editor.
*   **EditorInterface**: Interface do editor.
*   **EditorNode3DGizmo**: Gizmo 3D do editor.
*   **EditorNode3DGizmoPlugin**: Plugin de gizmo 3D do editor.
*   **EditorPaths**: Caminhos do editor.
*   **EditorPlugin**: Plugin do editor.
*   **EditorResourceConversionPlugin**: Plugin de conversão de recursos do editor.
*   **EditorResourcePreviewGenerator**: Gerador de preview de recursos do editor.
*   **EditorResourceTooltipPlugin**: Plugin de tooltip de recursos do editor.
*   **EditorSceneFormatImporter**: Base para importadores de formato de cena do editor.
*   **EditorSceneFormatImporterBlend**: Importador de formato de cena Blend.
*   **EditorSceneFormatImporterFBX2GLTF**: Importador de formato de cena FBX para GLTF.
*   **EditorSceneFormatImporterGLTF**: Importador de formato de cena GLTF.
*   **EditorSceneFormatImporterUFBX**: Importador de formato de cena UFBX.
*   **EditorScenePostImport**: Pós-importação de cena do editor.
*   **EditorScenePostImportPlugin**: Plugin de pós-importação de cena do editor.
*   **EditorScript**: Script do editor.
*   **EditorSelection**: Seleção do editor.
*   **EditorSyntaxHighlighter**: Realçador de sintaxe do editor.
*   **EditorTranslationParserPlugin**: Plugin de parser de tradução do editor.
*   **EditorUndoRedoManager**: Gerenciador de desfazer/refazer do editor.
*   **EditorVCSInterface**: Interface VCS do editor.

### Outros Objetos Utilitários

Classes diversas que fornecem funcionalidades específicas ou de baixo nível.

*   **AStar2D**: Algoritmo A* para caminhos 2D.
*   **AStar3D**: Algoritmo A* para caminhos 3D.
*   **AStarGrid2D**: Algoritmo A* para grade 2D.
*   **AudioEffectInstance**: Instância de efeito de áudio.
*   **AudioEffectSpectrumAnalyzerInstance**: Instância de analisador de espectro de áudio.
*   **AudioSample**: Amostra de áudio.
*   **AudioSamplePlayback**: Reprodução de amostra de áudio.
*   **AudioStreamGeneratorPlayback**: Reprodução de gerador de stream de áudio.
*   **AudioStreamPlayback**: Base para reprodução de stream de áudio.
*   **AudioStreamPlaybackInteractive**: Reprodução de stream de áudio interativo.
*   **AudioStreamPlaybackOggVorbis**: Reprodução de stream de áudio Ogg Vorbis.
*   **AudioStreamPlaybackPlaylist**: Reprodução de stream de áudio de playlist.
*   **AudioStreamPlaybackPolyphonic**: Reprodução de stream de áudio polifônico.
*   **AudioStreamPlaybackResampled**: Reprodução de stream de áudio reamostrado.
*   **AudioStreamPlaybackSynchronized**: Reprodução de stream de áudio sincronizado.
*   **CallbackTweener**: Tweener de callback.
*   **CameraFeed**: Feed de câmera.
*   **CameraServer**: Servidor de câmera.
*   **CharFXTransform**: Transformação de efeito de caractere.
*   **EngineDebugger**: Depurador do motor.
*   **EngineProfiler**: Profiler do motor.
*   **EncodedObjectAsID**: Objeto codificado como ID.
*   **FramebufferCacheRD**: Cache de framebuffer para `RenderingDevice`.
*   **GDExtensionManager**: Gerenciador de GDExtension.
*   **ImageFormatLoader**: Carregador de formato de imagem.
*   **ImageFormatLoaderExtension**: Extensão de carregador de formato de imagem.
*   **JavaClass**: Classe Java.
*   **JavaClassWrapper**: Wrapper de classe Java.
*   **JavaObject**: Objeto Java.
*   **JavaScriptBridge**: Ponte JavaScript.
*   **JavaScriptObject**: Objeto JavaScript.
*   **JNISingleton**: Singleton JNI.
*   **KinematicCollision2D**: Colisão cinemática 2D.
*   **KinematicCollision3D**: Colisão cinemática 3D.
*   **Lightmapper**: Mapeador de luz.
*   **LightmapperRD**: Mapeador de luz para `RenderingDevice`.
*   **Logger**: Logger.
*   **MainLoop**: Loop principal.
*   **MeshConvexDecompositionSettings**: Configurações de decomposição convexa de malha.
*   **MobileVRInterface**: Interface VR móvel.
*   **MovieWriter**: Gravador de vídeo.
*   **MultiplayerSpawner**: Spawner multiplayer.
*   **MultiplayerSynchronizer**: Sincronizador multiplayer.
*   **Mutex**: Mutex.
*   **NativeMenu**: Menu nativo.
*   **NavigationMeshGenerator**: Gerador de malha de navegação.
*   **NavigationPathQueryParameters2D**: Parâmetros de query de caminho de navegação 2D.
*   **NavigationPathQueryParameters3D**: Parâmetros de query de caminho de navegação 3D.
*   **NavigationPathQueryResult2D**: Resultado de query de caminho de navegação 2D.
*   **NavigationPathQueryResult3D**: Resultado de query de caminho de navegação 3D.
*   **Node3DGizmo**: Gizmo 3D.
*   **OggPacketSequencePlayback**: Reprodução de sequência de pacotes Ogg.
*   **OpenXRAPIExtension**: Extensão da API OpenXR.
*   **OpenXRExtensionWrapper**: Wrapper de extensão OpenXR.
*   **OpenXRExtensionWrapperExtension**: Extensão de wrapper de extensão OpenXR.
*   **OpenXRFutureExtension**: Extensão futura OpenXR.
*   **OpenXRFutureResult**: Resultado futuro OpenXR.
*   **OpenXRInterface**: Interface OpenXR.
*   **OpenXRRenderModelExtension**: Extensão de modelo de renderização OpenXR.
*   **PCKPacker**: Empacotador de PCK.
*   **PhysicsDirectBodyState2D**: Estado direto do corpo físico 2D.
*   **PhysicsDirectBodyState2DExtension**: Extensão de estado direto do corpo físico 2D.
*   **PhysicsDirectBodyState3D**: Estado direto do corpo físico 3D.
*   **PhysicsDirectBodyState3DExtension**: Extensão de estado direto do corpo físico 3D.
*   **PhysicsDirectSpaceState2D**: Estado direto do espaço físico 2D.
*   **PhysicsDirectSpaceState2DExtension**: Extensão de estado direto do espaço físico 2D.
*   **PhysicsDirectSpaceState3D**: Estado direto do espaço físico 3D.
*   **PhysicsDirectSpaceState3DExtension**: Extensão de estado direto do espaço físico 3D.
*   **PhysicsPointQueryParameters2D**: Parâmetros de query de ponto físico 2D.
*   **PhysicsPointQueryParameters3D**: Parâmetros de query de ponto físico 3D.
*   **PhysicsRayQueryParameters2D**: Parâmetros de query de raio físico 2D.
*   **PhysicsRayQueryParameters3D**: Parâmetros de query de raio físico 3D.
*   **PhysicsServer2DExtension**: Extensão do servidor físico 2D.
*   **PhysicsServer2DManager**: Gerenciador do servidor físico 2D.
*   **PhysicsServer3DExtension**: Extensão do servidor físico 3D.
*   **PhysicsServer3DManager**: Gerenciador do servidor físico 3D.
*   **PhysicsServer3DRenderingServerHandler**: Handler do servidor físico 3D para o servidor de renderização.
*   **PhysicsShapeQueryParameters2D**: Parâmetros de query de forma física 2D.
*   **PhysicsShapeQueryParameters3D**: Parâmetros de query de forma física 3D.
*   **PhysicsTestMotionParameters2D**: Parâmetros de teste de movimento físico 2D.
*   **PhysicsTestMotionParameters3D**: Parâmetros de teste de movimento físico 3D.
*   **PhysicsTestMotionResult2D**: Resultado de teste de movimento físico 2D.
*   **PhysicsTestMotionResult3D**: Resultado de teste de movimento físico 3D.
*   **PropertyTweener**: Tweener de propriedade.
*   **RandomNumberGenerator**: Gerador de número aleatório.
*   **RDAttachmentFormat**: Formato de anexo para `RenderingDevice`.
*   **RDFramebufferPass**: Passagem de framebuffer para `RenderingDevice`.
*   **RDPipelineColorBlendState**: Estado de blend de cor de pipeline para `RenderingDevice`.
*   **RDPipelineColorBlendStateAttachment**: Anexo de estado de blend de cor de pipeline para `RenderingDevice`.
*   **RDPipelineDepthStencilState**: Estado de profundidade/stencil de pipeline para `RenderingDevice`.
*   **RDPipelineMultisampleState**: Estado multisample de pipeline para `RenderingDevice`.
*   **RDPipelineRasterizationState**: Estado de rasterização de pipeline para `RenderingDevice`.
*   **RDPipelineSpecializationConstant**: Constante de especialização de pipeline para `RenderingDevice`.
*   **RDSamplerState**: Estado de sampler para `RenderingDevice`.
*   **RDShaderSource**: Fonte de shader para `RenderingDevice`.
*   **RDShaderSPIRV**: Shader SPIR-V para `RenderingDevice`.
*   **RDTextureFormat**: Formato de textura para `RenderingDevice`.
*   **RDTextureView**: View de textura para `RenderingDevice`.
*   **RDUniform**: Uniform para `RenderingDevice`.
*   **RDVertexAttribute**: Atributo de vértice para `RenderingDevice`.
*   **RenderData**: Dados de renderização.
*   **RenderDataExtension**: Extensão de dados de renderização.
*   **RenderDataRD**: Dados de renderização para `RenderingDevice`.
*   **RenderingDevice**: Interface de baixo nível para a GPU.
*   **RenderSceneBuffers**: Buffers de cena de renderização.
*   **RenderSceneBuffersConfiguration**: Configuração de buffers de cena de renderização.
*   **RenderSceneBuffersExtension**: Extensão de buffers de cena de renderização.
*   **RenderSceneBuffersRD**: Buffers de cena de renderização para `RenderingDevice`.
*   **RenderSceneData**: Dados de cena de renderização.
*   **RenderSceneDataExtension**: Extensão de dados de cena de renderização.
*   **RenderSceneDataRD**: Dados de cena de renderização para `RenderingDevice`.
*   **ResourceFormatLoader**: Carregador de formato de recurso.
*   **ResourceFormatSaver**: Salva formato de recurso.
*   **ResourceImporter**: Importador de recurso.
*   **ResourceImporterBitMap**: Importador de bitmap.
*   **ResourceImporterBMFont**: Importador de BMFont.
*   **ResourceImporterCSVTranslation**: Importador de tradução CSV.
*   **ResourceImporterDynamicFont**: Importador de fonte dinâmica.
*   **ResourceImporterImage**: Importador de imagem.
*   **ResourceImporterImageFont**: Importador de fonte de imagem.
*   **ResourceImporterLayeredTexture**: Importador de textura em camadas.
*   **ResourceImporterMP3**: Importador de MP3.
*   **ResourceImporterOBJ**: Importador de OBJ.
*   **ResourceImporterOggVorbis**: Importador de Ogg Vorbis.
*   **ResourceImporterScene**: Importador de cena.
*   **ResourceImporterShaderFile**: Importador de arquivo de shader.
*   **ResourceImporterSVG**: Importador de SVG.
*   **ResourceImporterTexture**: Importador de textura.
*   **ResourceImporterTextureAtlas**: Importador de atlas de textura.
    *   **ResourceImporterWAV**: Importador de WAV.
    *   **SceneState**: Estado de cena.
    *   **SceneTreeTimer**: Timer da árvore de cena.
    *   **ScriptBacktrace**: Backtrace de script.
    *   **ScriptLanguage**: Linguagem de script.
    *   **ScriptLanguageExtension**: Extensão de linguagem de script.
    *   **Semaphore**: Semáforo.
    *   **SkinReference**: Referência de skin.
    *   **SubtweenTweener**: Tweener de subtween.
    *   **TextLine**: Linha de texto.
    *   **TextParagraph**: Parágrafo de texto.
    *   **TextServerAdvanced**: Servidor de texto avançado.
    *   **TextServerDummy**: Servidor de texto dummy.
    *   **TextServerExtension**: Extensão do servidor de texto.
    *   **TextServerFallback**: Servidor de texto fallback.
    *   **TextServerManager**: Gerenciador do servidor de texto.
    *   **ThemeDB**: Banco de dados de temas.
    *   **Thread**: Thread.
    *   **TileData**: Dados de tile.
    *   **Tween**: Gerenciador de interpolação.
    *   **Tweener**: Base para tweeners.
    *   **UndoRedo**: Gerenciador de desfazer/refazer.
    *   **UniformSetCacheRD**: Cache de conjunto de uniformes para `RenderingDevice`.
    *   **WeakRef**: Referência fraca.
    *   **WorkerThreadPool**: Pool de threads de trabalho.
    *   **WebXRInterface**: Interface WebXR.
    *   **XRBodyTracker**: Rastreador de corpo XR.
    *   **XRControllerTracker**: Rastreador de controlador XR.
    *   **XRFaceTracker**: Rastreador de rosto XR.
    *   **XRHandTracker**: Rastreador de mão XR.
    *   **XRInterface**: Interface XR.
    *   **XRInterfaceExtension**: Extensão de interface XR.
    *   **XRPositionalTracker**: Rastreador posicional XR.
    *   **XRTracker**: Rastreador XR.
    *   **XRVRS**: VRS XR.
