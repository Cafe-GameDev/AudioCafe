# Lei da Oclusão de Áudio

**Status:** Proposta
**Documento:** `docs/laws_projects/occlusion.md`

---

### **Preâmbulo**

Para aumentar o realismo e a imersão, o AudioCafe implementará um sistema de oclusão de áudio, permitindo que os sons sejam abafados de forma realista por obstáculos no ambiente, como paredes e outros elementos de geometria.

---

### **Artigo I: Componentes do Sistema**

*   **Seção 1.1: `AudioOccluder3D` (Nó):**
    *   **Diretriz 1.1.1:** Será criado um novo tipo de nó, `AudioOccluder3D`, que herda de `Area3D`.
    *   **Diretriz 1.1.2:** Os desenvolvedores adicionarão este nó como filho de qualquer `CollisionShape` que deva obstruir o som.
    *   **Diretriz 1.1.3:** O `AudioOccluder3D` terá uma propriedade exportada: `@export_range(0.0, 1.0) var occlusion_factor: float = 0.5`. Este valor representa a "densidade" do material para o som (0.0 para nenhuma oclusão, 1.0 para oclusão máxima).

*   **Seção 1.2: `AudioListener3D` (Nó):**
    *   **Diretriz 1.2.1:** Será criado um novo nó `AudioListener3D` que atuará como os "ouvidos" do jogador. Em um cenário típico, este nó será filho do nó de Câmera principal.
    *   **Diretriz 1.2.2:** O sistema de oclusão usará a posição global deste nó como o destino para todos os cálculos de oclusão. Se nenhum `AudioListener3D` estiver presente na cena, a câmera atual será usada como fallback.

---

### **Artigo II: Lógica de Oclusão**

*   **Seção 2.1: Detecção por Raycast:**
    *   **Diretriz 2.1.1:** O `CafeAudioManager` manterá uma lista de todos os `AudioPosition3D`s que estão tocando na cena.
    *   **Diretriz 2.1.2:** Periodicamente (em um intervalo configurável para otimização), para cada som ativo, o sistema realizará um `raycast` do `global_position` do som até o `global_position` do `AudioListener3D`.

*   **Seção 2.2: Aplicação do Efeito:**
    *   **Diretriz 2.2.1:** Se o raio for interceptado por um corpo de física que tenha um `AudioOccluder3D` como filho, o som será considerado "ocluído".
    *   **Diretriz 2.2.2:** Para cada som ocluído, o sistema aplicará um efeito de **Low-Pass Filter** ao bus de áudio em que o som está tocando. A propriedade `cutoff_hz` do filtro será ajustada com base no `occlusion_factor` do objeto oclusor.
    *   **Diretriz 2.2.3:** Se múltiplos objetos ocluírem o som, o maior `occlusion_factor` será usado.

*   **Seção 2.3: Otimização:**
    *   **Diretriz 2.3.1:** O sistema de oclusão será desativado por padrão e poderá ser ativado no `AudioConfig`.
    *   **Diretriz 2.3.2:** A frequência da verificação de oclusão (o `raycast`) será configurável (ex: a cada 0.1 segundos) para balancear entre precisão e performance.

---

### **Conclusão**

Este sistema fornecerá uma solução de oclusão de áudio integrada e de fácil configuração, diretamente alinhada com a filosofia de workflow do AudioCafe, permitindo que os desenvolvedores adicionem uma camada significativa de profundidade e realismo ao áudio de seus jogos com pouco esforço.
