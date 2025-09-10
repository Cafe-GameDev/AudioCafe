# AudioCafe: Sistema de Áudio para Godot Engine

Bem-vindo à documentação do **AudioCafe**, um sistema de gerenciamento de áudio robusto e flexível projetado para a Godot Engine. Este plugin visa simplificar a implementação de áudio em seus jogos, oferecendo ferramentas para música de fundo, efeitos sonoros (SFX) aleatórios, áudio posicional e integração completa com o editor.

## Funcionalidades Principais

O AudioCafe oferece um conjunto abrangente de recursos para atender às suas necessidades de áudio:

*   **`CafeAudioManager`**: Um `singleton` central para controlar toda a reprodução de áudio, incluindo música, SFX e volumes.
*   **`AudioPosition` (2D/3D)**: `Nodes` especializados para reprodução de áudio posicional, ideal para sons de personagens, objetos e ambientes.
*   **`AudioZone` (2D/3D)**: `Nodes` de área que disparam eventos de áudio com base na entrada e saída de `bodies`, perfeito para áudio ambiental ou gatilhos sonoros.
*   **Controles de UI com SFX Integrado**: Uma coleção de `nodes` de `Control` que estendem os `nodes` de UI padrão do Godot, adicionando a capacidade de reproduzir SFX automaticamente em eventos como cliques, `hovers` e mudanças de valor.
*   **`AudioConfig`**: Um `resource` centralizado para configurar `paths` de áudio, `keys` padrão de SFX e volumes globais.
*   **`AudioManifest`**: Um sistema de `manifest` que otimiza o carregamento de áudio para `builds` exportadas, mapeando `keys` de áudio para `UIDs` de `resources`.
*   **Ferramentas de Editor**: Um `panel` de editor intuitivo para configurar o plugin, gerenciar `paths` de áudio e gerar o `AudioManifest`.

## Como Começar

Para começar a usar o AudioCafe em seu projeto Godot, siga estes passos:

1.  **Instalação**: Copie a pasta `addons/AudioCafe` para a pasta `addons` do seu projeto Godot.
2.  **Ativar Plugin**: No Godot Editor, vá em `Project` -> `Project Settings` -> `Plugins` e ative o plugin "AudioCafe".
3.  **Configuração Inicial**: Um `autoload` `CafeAudioManager` será adicionado automaticamente ao seu projeto. Você pode acessar as configurações do plugin através do `panel` "CafeEngine" na `dock` lateral do editor.

Para detalhes sobre a configuração e uso de cada componente, navegue pelas seções desta documentação.

## Estrutura da Documentação

Esta documentação está organizada nas seguintes seções, cada uma focando em um aspecto específico do plugin AudioCafe:

*   **`CafeAudioManager`**: Detalhes sobre o `singleton` principal de gerenciamento de áudio.
*   **`AudioPosition`**: Uso e configuração de áudio posicional 2D e 3D.
*   **`AudioZone`**: Implementação de zonas de áudio para gatilhos baseados em área.
*   **Controles de UI com SFX**: Como usar os `nodes` de `Control` com SFX integrado.
*   **`Signals`**: Uma lista completa de todos os `signals` emitidos pelos componentes do AudioCafe.
*   **`Editor Panel`**: Guia de uso do `panel` do editor para configuração e gerenciamento.
*   **`AudioConfig`**: Explicação do `resource` de configuração central.
*   **Geração do `AudioManifest`**: Como o `manifest` é gerado e sua importância.
*   **`AudioManifest`**: Detalhes sobre a estrutura e o propósito do `resource` `AudioManifest`.
*   **Plugin do Editor**: Informações técnicas sobre a integração do plugin com o Godot Editor.

Esperamos que esta documentação seja útil para você criar experiências de áudio imersivas em seus jogos Godot!