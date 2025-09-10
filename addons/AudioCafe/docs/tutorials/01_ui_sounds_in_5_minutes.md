# Tutorial: Sons de UI em 5 Minutos

Este tutorial irá guiá-lo para ter sons de interface de usuário (UI) funcionando em seu projeto usando o AudioCafe em menos de 5 minutos.

### Pré-requisitos

- O plugin AudioCafe v1.0 instalado e ativado.
- Uma pasta no seu projeto contendo alguns arquivos de som para cliques e hovers (ex: `res://assets/audio/ui/`).

---

### Passo 1: Configure o Caminho dos SFX

1.  No editor Godot, encontre o dock **"CafeEngine"** no lado direito e clique nele.
2.  Dentro do painel "AudioCafe", vá para a aba **"Paths"**.
3.  Na seção "SFX Paths", clique no botão **"Add SFX Path"**.
4.  Na nova linha que aparecer, digite o caminho para a pasta que contém seus sons de UI. Por exemplo: `res://assets/audio/ui`.

    *(O painel irá salvar automaticamente.)*

### Passo 2: Gere o Manifesto

1.  Ainda no painel AudioCafe, clique no botão principal **"Generate Audio Manifest"**.
2.  Aguarde a barra de progresso terminar. Uma mensagem de sucesso aparecerá.

    *O que aconteceu? O AudioCafe escaneou sua pasta, encontrou os sons e os registrou com chaves de acesso fáceis.*

### Passo 3: Verifique as Chaves Padrão

1.  Vá para a aba **"Keys"**.
2.  Encontre os campos `Default Click Key` e `Default Hover Key`.
3.  Certifique-se de que eles correspondem às chaves geradas para seus sons. Por exemplo, se você tem um som em `.../ui/click.ogg`, a chave será `click`. Se estiver em `.../ui/button/click.ogg`, a chave será `button_click`.
4.  Ajuste os valores se necessário.

### Passo 4: Adicione um Botão com SFX

1.  Crie uma nova cena com um nó `Control` como raiz.
2.  Clique em "Add Child Node" (ou `Ctrl+A`).
3.  Em vez de procurar por `Button`, procure por **`SFXButton`** e adicione-o à cena.
4.  Ajuste o texto e o tamanho do botão como faria com um botão normal.

### Passo 5: Teste!

Rode a cena (`F6`). Passe o mouse sobre o botão e clique nele. Você ouvirá os sons de hover e clique que você configurou!

**É isso!** Você não precisou escrever uma única linha de código. O `SFXButton` automaticamente usou as chaves padrão do `AudioConfig` para tocar os sons corretos.

Para usar um som customizado em um botão específico, basta selecionar o `SFXButton` e, no Inspector, preencher as propriedades `Click Sfx Key` ou `Hover Sfx Key`.
