**Projeto de Lei: Lei do Gerador de Manifest**

**Status:** Proposta
**Documento:** `docs/laws_projects/lei_gerador_manifest.md`

---

### **Preâmbulo**

Esta lei estabelece a refatoração do script `generate_audio_manifest.gd` para centralizar as definições de caminhos de salvamento no `AudioConfig`. O objetivo é tornar a configuração dos diretórios de saída mais flexível e acessível, evitando a duplicação de lógica e facilitando a manutenção.

---

### **Artigo I: Centralização de Caminhos no AudioConfig**

1.  **Remoção de Variáveis Locais:** As variáveis `base_dist_path`, `playlist_dist_save_path`, `random_dist_save_path`, `sync_dist_save_path` e `interactive_dist_save_path` serão removidas do script `generate_audio_manifest.gd`.
2.  **Novas Propriedades no AudioConfig:** As definições desses caminhos serão movidas para o `AudioConfig` como novas propriedades exportadas, permitindo que sejam configuradas diretamente no recurso `.tres`.
3.  **Acesso via AudioConfig:** O script `generate_audio_manifest.gd` passará a acessar esses caminhos diretamente através da instância de `AudioConfig` que lhe é fornecida.

---

### **Conclusão**

A implementação desta lei garantirá uma arquitetura mais limpa e configurável para o processo de geração do manifest, alinhando-se aos princípios de um plugin robusto e de fácil manutenção.