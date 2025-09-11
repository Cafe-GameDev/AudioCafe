# Editor Panel (AudioPanel)

O AudioCafe vem com um painel integrado ao editor do Godot para facilitar a configuração e o gerenciamento do plugin. Para acessá-lo, procure pelo dock "CafeEngine" no lado direito do editor (por padrão).

O painel é dividido em várias abas para organizar as configurações.

## Botões Principais

- **`Generate Audio Manifest`**: O botão mais importante. Clicar aqui irá escanear os diretórios de áudio definidos na aba "Paths" e gerará (ou atualizará) o arquivo `AudioManifest.tres`. Uma barra de progresso mostrará o status da operação.
- **`Docs`**: Abre a documentação online do plugin no seu navegador.

## Aba "Paths"

Nesta aba, você define onde o AudioCafe deve procurar por seus arquivos de áudio.

- **`Music Paths`**: Adicione os diretórios que contêm suas músicas.
- **`SFX Paths`**: Adicione os diretórios que contêm seus efeitos sonoros.

Use o botão "Add..." para adicionar um novo caminho e o "X" para remover um existente. Os caminhos devem começar com `res://`.

## Aba "Keys"

Aqui você pode configurar os volumes globais e as chaves de SFX padrão para os controles de UI.

### Volume Settings

- **`Master Volume`**: Controla o volume do bus "Master".
- **`SFX Volume`**: Controla o volume do bus "SFX".
- **`Music Volume`**: Controla o volume do bus "Music".

Os sliders permitem um ajuste fácil, e o valor percentual é exibido ao lado.

### Default Keys

Esta seção permite definir as chaves de SFX padrão para vários eventos de UI. Por exemplo, se você definir `Default Click Key` como "ui_click", todo `SFXButton` em seu jogo tocará o som "ui_click" quando pressionado, a menos que você especifique uma chave diferente no próprio nó do botão.

## Abas "Music List" e "SFX List"

Estas abas são apenas para visualização. Elas listam todas as chaves de áudio que foram encontradas e registradas no `AudioManifest` após a geração.

- A lista mostra a **chave** do áudio (gerada a partir da estrutura de pastas).
- O número entre colchetes `[ ]` indica quantos arquivos de áudio diferentes estão associados a essa chave. Se o número for maior que 1, o `CafeAudioManager` tocará um deles aleatoriamente quando a chave for solicitada.

## Aba "Signals"

Esta aba fornece uma referência rápida aos principais `signals` disponíveis no plugin, divididos por componente (`CafeAudioManager`, `AudioPosition`, `AudioZone`), para que você possa consultá-los sem sair do editor.
