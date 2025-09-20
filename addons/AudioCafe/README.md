# AudioCafe: Acelerador de Fluxo de Trabalho de Áudio para Godot Engine

## Visão Geral

O AudioCafe é um plugin revolucionário para o Godot Engine, projetado para otimizar e acelerar drasticamente o fluxo de trabalho de gerenciamento de áudio em seus projetos. Com um foco inabalável na Experiência do Usuário (UX), o AudioCafe transforma a maneira como você lida com recursos de áudio, desde a organização até a integração em tempo de execução.

Esqueça a tediosa tarefa de criar manualmente `AudioStreamPlaylist`, `AudioStreamRandomizer` ou `AudioStreamSynchronized` para cada som ou música em seu jogo. O AudioCafe atua como um **Acelerador de Fluxo**, automatizando a geração desses recursos a partir de seus arquivos de áudio brutos (`.ogg`, `.wav`), e os organiza em um `AudioManifest` centralizado.

O ponto forte do plugin é o seu **AudioPanel**, uma interface intuitiva e poderosa diretamente no editor do Godot. Através dele, você configura seus caminhos de assets, define onde os recursos gerados devem ser salvos e, com um único clique, gera um manifesto de áudio completo e pronto para uso.

## Principais Funcionalidades

*   **Geração Automatizada de Recursos**: Crie `AudioStreamPlaylist`, `AudioStreamRandomizer` e `AudioStreamSynchronized` a partir de seus arquivos de áudio de forma inteligente e automática.
*   **AudioManifest Centralizado**: Um único recurso (`audio_manifest.tres`) que atua como um catálogo, mapeando chaves de áudio para os recursos gerados, facilitando o acesso em tempo de execução.
*   **Interface Intuitiva (AudioPanel)**: Configure facilmente caminhos de assets e de distribuição, visualize os recursos gerados e acione a geração do manifesto diretamente no editor.
*   **Suporte a AudioStreamInteractive**: Embora não os gere, o AudioCafe coleta referências a `AudioStreamInteractive` criados manualmente, integrando-os ao seu manifesto.
*   **Otimização para Exportação**: Garante que todos os recursos de áudio gerados sejam incluídos corretamente nas suas builds exportadas.
*   **Foco em UX**: Projetado para ser simples, eficiente e agradável de usar, liberando você para focar na criatividade.

## Por Que Usar o AudioCafe?

*   **Economia de Tempo**: Automatize tarefas repetitivas e demoradas de configuração de áudio.
*   **Organização Impecável**: Mantenha seus recursos de áudio organizados e facilmente acessíveis através de um manifesto central.
*   **Flexibilidade**: Suporte a diversos tipos de `AudioStream` para atender a diferentes necessidades de áudio (música, SFX aleatórios, áudio sincronizado).
*   **Integração Perfeita**: Funciona nativamente dentro do Godot Engine, complementando seu fluxo de trabalho existente.
*   **Base para Sistemas Robustos**: O manifesto gerado serve como a espinha dorsal para construir sistemas de áudio complexos e dinâmicos em seu jogo.

Com o AudioCafe, você não apenas gerencia áudio; você acelera a criação de experiências sonoras imersivas e dinâmicas em seus jogos Godot.
