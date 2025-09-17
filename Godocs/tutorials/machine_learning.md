# Máquina de Estados Inteligente com Machine Learning (ONNX) no Godot

## Introdução

Este tutorial explora como criar um inimigo com uma Máquina de Estados (FSM) que toma decisões de forma inteligente, utilizando um modelo de Machine Learning (ML) treinado e exportado no formato ONNX. Em vez de regras codificadas manualmente, o inimigo usará um modelo para determinar seu próximo estado com base nas condições do jogo. É importante notar que, neste setup, o Python é utilizado apenas para o treinamento e exportação do modelo, não para sua execução direta no Godot.

## Pré-requisitos

*   Conhecimento básico de Godot Engine (GDScript, nós, cenas, GDShaders).
*   Familiaridade com o conceito de Máquinas de Estados.
*   Noções básicas de Machine Learning (treinamento de modelos, entradas, saídas).
*   Conhecimento de Python e bibliotecas de ML (TensorFlow, PyTorch, scikit-learn, NumPy) para a etapa de treinamento.
*   Noções de C++ para GDExtension (para implementação da ponte ONNX).

## Visão Geral da Arquitetura

A ideia central é que um modelo de ML, treinado externamente, será integrado ao Godot. Este modelo receberá informações do estado atual do jogo (entradas) e produzirá uma decisão (saída), que será usada para controlar as transições da FSM do inimigo. O formato ONNX (Open Neural Network Exchange) é ideal para isso, pois permite a interoperabilidade entre diferentes frameworks de ML e é otimizado para inferência.

### Fluxo da Arquitetura (Conceitual)

Para uma melhor compreensão visual, imagine o seguinte fluxo:

1.  **Treinamento (Python/PyTorch/TensorFlow/NumPy):** Dados do jogo são usados para treinar um modelo de ML.
2.  **Exportação (torch.onnx/tf2onnx):** O modelo treinado é salvo no formato ONNX.
3.  **Integração (C++/GDExtension/ONNX Runtime):** Uma GDExtension em C++ carrega o modelo ONNX e expõe uma interface para o Godot.
4.  **Coleta de Dados (GDScript):** O inimigo coleta informações do jogo (distância do jogador, saúde, etc.).
5.  **Inferência (GDScript -> GDExtension):** Os dados coletados são passados para a GDExtension, que executa a inferência no modelo ONNX.
6.  **Controle da FSM (GDScript):** A previsão do modelo (o próximo estado desejado) é usada para transicionar a Máquina de Estados do inimigo.
7.  **Feedback Visual (GDScript -> GDShaders):** Os estados ou resultados do modelo podem ser passados para GDShaders para criar efeitos visuais dinâmicos.

Este fluxo garante que o modelo de ML, embora treinado externamente, influencie diretamente o comportamento e a aparência do inimigo no jogo. Um diagrama visual (não incluído aqui) seria altamente recomendado para ilustrar essas etapas.

## Passo 1: Treinamento do Modelo de ML (Externo ao Godot)

Esta etapa é realizada fora do Godot, geralmente em Python.

### O que o Modelo Aprenderá?

O modelo de ML será treinado para prever o próximo estado desejado do inimigo com base em um conjunto de entradas.

**Exemplos de Entradas (Features):**
*   `distancia_do_jogador`: Distância euclidiana até o jogador.
*   `saude_inimigo`: Percentual de saúde restante do inimigo.
*   `saude_jogador`: Percentual de saúde restante do jogador.
*   `munição_inimigo`: Quantidade de munição disponível.
*   `visibilidade_jogador`: Booleano indicando se o jogador está visível.
*   `estado_atual`: O estado atual do inimigo (pode ser codificado numericamente).

**Exemplos de Saídas (Labels):**
O modelo deve prever um dos estados da FSM do inimigo.
*   `0`: IDLE
*   `1`: PATROL
*   `2`: CHASE
*   `3`: ATTACK
*   `4`: FLEE

### Ferramentas e Dados

Você pode usar frameworks como TensorFlow, PyTorch ou scikit-learn para treinar seu modelo. O NumPy é frequentemente utilizado para manipulação e preparação de dados. A parte mais desafiadora é a coleta de dados de treinamento. Isso pode ser feito por:
*   **Gravação de Jogadas:** Registrar as decisões de um jogador humano ou de uma IA baseada em regras.
*   **Simulação:** Executar simulações onde o inimigo experimenta diferentes cenários e as ações ótimas são registradas.
*   **Aprendizado por Reforço:** Treinar um agente para aprender a política de estados diretamente no ambiente do jogo (mais complexo).

## Passo 2: Exportando para ONNX

Após treinar seu modelo, você precisará exportá-lo para o formato ONNX. ONNX é um formato aberto que permite a representação de modelos de ML, facilitando a portabilidade entre diferentes frameworks e plataformas.

### Exemplo (PyTorch):

```python
import torch
import torch.nn as nn

# Defina seu modelo (exemplo simples)
class SimpleNN(nn.Module):
    def __init__(self):
        super(SimpleNN, self).__init__()
        self.fc1 = nn.Linear(6, 16) # 6 entradas (features)
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(16, 5) # 5 saídas (estados)

    def forward(self, x):
        x = self.fc1(x)
        x = self.relu(x)
        x = self.fc2(x)
        return x

# Crie uma instância do modelo e carregue os pesos treinados
model = SimpleNN()
# model.load_state_dict(torch.load("caminho/para/seus_pesos.pth"))
model.eval()

# Crie uma entrada de exemplo com o tamanho esperado
dummy_input = torch.randn(1, 6) # Batch size 1, 6 features

# Exporte o modelo para ONNX
torch.onnx.export(model, dummy_input, "inimigo_fsm.onnx",
                  input_names=['input'],
                  output_names=['output'],
                  dynamic_axes={'input': {0: 'batch_size'},
                                'output': {0: 'batch_size'}})

print("Modelo exportado para inimigo_fsm.onnx")
```

### Exemplo (TensorFlow/Keras com `tf2onnx`):

```python
import tensorflow as tf
import tf2onnx

# Defina seu modelo (exemplo simples)
model = tf.keras.Sequential([
    tf.keras.layers.Dense(16, activation='relu', input_shape=(6,)), # 6 entradas
    tf.keras.layers.Dense(5, activation='softmax') # 5 saídas (estados)
])

# Carregue os pesos treinados
# model.load_weights("caminho/para/seus_pesos.h5")

# Crie uma entrada de exemplo com o tamanho esperado
spec = (tf.TensorSpec((None, 6), tf.float32, name="input"),) # None para batch_size dinâmico

# Exporte o modelo para ONNX
model_proto, _ = tf2onnx.convert.from_keras(model, input_signature=spec, opset=13, output_path="inimigo_fsm.onnx")

print("Modelo exportado para inimigo_fsm.onnx")
```

## Passo 3: Integrando ONNX no Godot (Via GDExtension/Plugin)

O Godot não possui suporte nativo para carregar e executar modelos ONNX diretamente. Para isso, você **precisará obrigatoriamente** de uma **GDExtension** (ou um módulo customizado) que utilize uma biblioteca como o [ONNX Runtime](https://onnxruntime.ai/). A GDExtension permite estender o motor com código de alto desempenho (C++ ou Rust) e é a ponte necessária entre o Godot e bibliotecas externas como o ONNX Runtime.

Embora Rust possa ser usado para implementar a GDExtension, C++ é frequentemente preferido devido à maior quantidade de exemplos e documentação oficial para integração com o ONNX Runtime.

### Como a GDExtension/Plugin Funcionaria (Conceitual)

Você precisaria desenvolver uma GDExtension em C++ que:
1.  **Carregue o Modelo ONNX:** Exponha um método para carregar um arquivo `.onnx` para a memória, utilizando as APIs do ONNX Runtime.
2.  **Execute a Inferência:** Exponha um método que receba um array de floats (as entradas do modelo), execute a inferência usando o ONNX Runtime e retorne um array de floats (as saídas do modelo).
3.  **Integração com GDScript:** Os métodos expostos pela GDExtension podem ser chamados diretamente do GDScript, permitindo que a lógica do jogo interaja com o modelo de ML.

**Exemplo de Interface GDScript (como você usaria a GDExtension):**

Imagine que sua GDExtension cria um nó chamado `ONNXPredictor`.

**Exemplo de Interface GDScript (como você usaria a GDExtension):**

Imagine que sua GDExtension cria um nó chamado `ONNXPredictor`.

```gdscript
extends Node

var onnx_predictor: ONNXPredictor

func _ready():
    onnx_predictor = ONNXPredictor.new()
    add_child(onnx_predictor)
    var load_success = onnx_predictor.load_model("res://modelos/inimigo_fsm.onnx")
    if not load_success:
        print("Erro ao carregar o modelo ONNX!")

func predict_state(inputs: PackedFloat32Array) -> int:
    var outputs: PackedFloat32Array = onnx_predictor.predict(inputs)
    var predicted_state_index = 0
    var max_probability = -1.0
    for i in range(outputs.size()):
        if outputs[i] > max_probability:
            max_probability = outputs[i]
            predicted_state_index = i
    return predicted_state_index
```

**Nota:** A criação da GDExtension em si é um tópico avançado e fora do escopo deste tutorial. Você precisaria de conhecimento de C++ e da API GDExtension do Godot, além da biblioteca ONNX Runtime.

## Passo 4: Estruturando a Máquina de Estados no Godot

Vamos definir os estados do nosso inimigo e como ele coletará as entradas para o modelo de ML.

### Enumeração de Estados

```gdscript
extends CharacterBody3D

enum EstadoInimigo {
    IDLE,
    PATROL,
    CHASE,
    ATTACK,
    FLEE
}

var estado_atual: EstadoInimigo = EstadoInimigo.IDLE
var onnx_predictor: ONNXPredictor
var jogador: Node3D

func _ready():
    onnx_predictor = ONNXPredictor.new()
    add_child(onnx_predictor)
    var load_success = onnx_predictor.load_model("res://modelos/inimigo_fsm.onnx")
    if not load_success:
        print("Erro ao carregar o modelo ONNX!")
        set_process(false)

    jogador = get_tree().get_first_node_in_group("jogador")
    if not is_instance_valid(jogador):
        print("Jogador não encontrado!")
        set_process(false)
```

## Passo 5: Implementação no Godot (GDScript)

Agora, vamos integrar a lógica de coleta de dados, inferência do modelo e transição de estados.

```gdscript
# Continuação do script do inimigo (ex: Inimigo.gd)

func _physics_process(delta):
    if not is_instance_valid(jogador) or not is_instance_valid(onnx_predictor):
        return

    var inputs: PackedFloat32Array = _coletar_entradas_para_ml()

    var proximo_estado_index: int = _prever_proximo_estado(inputs)
    var proximo_estado: EstadoInimigo = EstadoInimigo.values()[proximo_estado_index]

    _transicionar_estado(proximo_estado)

    _executar_logica_estado(delta)

func _coletar_entradas_para_ml() -> PackedFloat32Array:
    var inputs_array: PackedFloat32Array
    
    var distancia_do_jogador = global_position.distance_to(jogador.global_position)
    var saude_inimigo = 1.0
    var saude_jogador = 1.0
    var municao_inimigo = 100.0
    var visibilidade_jogador = 1.0
    var estado_atual_codificado = float(estado_atual)

    inputs_array.append(distancia_do_jogador)
    inputs_array.append(saude_inimigo)
    inputs_array.append(saude_jogador)
    inputs_array.append(municao_inimigo)
    inputs_array.append(visibilidade_jogador)
    inputs_array.append(estado_atual_codificado)
    
    return inputs_array

func _prever_proximo_estado(inputs: PackedFloat32Array) -> int:
    var outputs: PackedFloat32Array = onnx_predictor.predict(inputs)
    var predicted_state_index = 0
    var max_probability = -1.0
    for i in range(outputs.size()):
        if outputs[i] > max_probability:
            max_probability = outputs[i]
            predicted_state_index = i
    return predicted_state_index

func _transicionar_estado(novo_estado: EstadoInimigo):
    if estado_atual == novo_estado:
        return

    estado_atual = novo_estado

func _executar_logica_estado(delta: float):
    match estado_atual:
        EstadoInimigo.IDLE:
            pass
        EstadoInimigo.PATROL:
            pass
        EstadoInimigo.CHASE:
            pass
        EstadoInimigo.ATTACK:
            pass
        EstadoInimigo.FLEE:
            pass

## Passo 6: Utilizando Resultados de ML em GDShaders

Os resultados da inferência do modelo de Machine Learning (obtidos via GDExtension e GDScript) podem ser usados para controlar dinamicamente propriedades visuais e efeitos em GDShaders. Isso permite criar comportamentos visuais que reagem de forma inteligente às decisões do modelo.

### Conceito

A ideia é passar os resultados do modelo (por exemplo, o estado previsto, uma probabilidade, ou um valor contínuo) do GDScript para um shader como `uniforms`. O shader, então, usa esses `uniforms` para modificar a renderização do material ou do objeto.

### Exemplo: Mudança de Cor Baseada no Estado do Inimigo

Vamos supor que queremos que o inimigo mude de cor dependendo do seu estado atual (IDLE, CHASE, ATTACK, FLEE).

1.  **Definir um `uniform` no Shader:**
    Crie um shader (por exemplo, `inimigo_shader.gdshader`) e adicione um `uniform` para receber o estado.

    ```gdshader
shader_type spatial;
uniform int enemy_state : hint_range(0, 4) = 0;
uniform vec4 idle_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 chase_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform vec4 attack_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 flee_color : source_color = vec4(0.0, 0.0, 1.0, 1.0);

void fragment() {
    vec4 final_color = idle_color;
    if (enemy_state == 1) { // PATROL (usando idle_color como base)
        final_color = idle_color;
    } else if (enemy_state == 2) { // CHASE
        final_color = chase_color;
    } else if (enemy_state == 3) { // ATTACK
        final_color = attack_color;
    } else if (enemy_state == 4) { // FLEE
        final_color = flee_color;
    }
    ALBEDO = final_color.rgb;
}
    ```

2.  **Atualizar o `uniform` via GDScript:**
    No script do inimigo, após prever o próximo estado, atualize o `uniform` do material.

    ```gdscript
# Continuação do script do inimigo (ex: Inimigo.gd)

func _transicionar_estado(novo_estado: EstadoInimigo):
    if estado_atual == novo_estado:
        return

    estado_atual = novo_estado
    _atualizar_shader_estado_inimigo()

func _atualizar_shader_estado_inimigo():
    if get_node("MeshInstance3D").get_surface_override_material(0) is ShaderMaterial:
        var material: ShaderMaterial = get_node("MeshInstance3D").get_surface_override_material(0)
        material.set_shader_parameter("enemy_state", estado_atual)

func _executar_logica_estado(delta: float):
    match estado_atual:
        EstadoInimigo.IDLE:
            pass
        EstadoInimigo.PATROL:
            pass
        EstadoInimigo.CHASE:
            pass
        EstadoInimigo.ATTACK:
            pass
        EstadoInimigo.FLEE:
            pass
    ```

    *   **Nota:** Certifique-se de que o `MeshInstance3D` do seu inimigo esteja usando um `ShaderMaterial` com o `inimigo_shader.gdshader` atribuído.

### Outras Aplicações com GDShaders

*   **Efeitos de Dano/Buff:** Um modelo pode prever a intensidade de um efeito de dano ou buff, e esse valor pode ser passado para um shader para controlar a saturação, brilho ou um efeito de "outline".
*   **Deformação Procedural:** Resultados de ML podem influenciar parâmetros de deformação em shaders, como a intensidade de um efeito de "jiggle" ou a forma de um "blob" inimigo.
*   **Feedback Visual de Comportamento:** O shader pode exibir visualmente o "humor" ou a "confiança" de um inimigo, com base em uma saída contínua do modelo de ML.

A combinação de Machine Learning com GDShaders abre um vasto leque de possibilidades para criar experiências visuais dinâmicas e responsivas, onde a aparência dos objetos no jogo é diretamente influenciada por decisões inteligentes baseadas em dados.

## Considerações Finais

*   **Desempenho:** A inferência de modelos de ML pode ser custosa. Modelos ONNX são otimizados para isso, mas o tamanho e a complexidade do seu modelo, bem como a frequência das previsões, impactarão o desempenho. Considere executar a inferência em um `WorkerThreadPool` se necessário.
*   **Depuração:** Depurar modelos de ML e sua integração pode ser desafiador. Use `print` statements para inspecionar as entradas e saídas do modelo.
*   **Iteração:** O processo de treinamento do modelo, exportação e integração no Godot é iterativo. Comece com um modelo simples e adicione complexidade gradualmente.
*   **GDExtension:** Lembre-se que a GDExtension para ONNX Runtime é a peça mais complexa e crucial para esta abordagem. Sem ela, a integração direta de ONNX no Godot não é possível.
*   **Expansões Futuras:** Qualquer expansão futura que envolva aprendizado online ou reforço diretamente dentro do Godot ainda exigirá uma ponte nativa (C++/Rust via GDExtension) para garantir um desempenho aceitável.

Este tutorial fornece uma base para você começar a explorar a integração de Machine Learning com ONNX para criar inimigos mais inteligentes no Godot.