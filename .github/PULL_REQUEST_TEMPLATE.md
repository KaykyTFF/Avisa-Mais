## Resumo da Mudança
<!-- Descreva o que foi alterado ou corrigido no aplicativo Flutter -->

## Tipo de Mudança
- [ ] `feat`: Nova tela ou funcionalidade
- [ ] `fix`: Correção de bug (inclui teste de regressão)
- [ ] `refactor`: Modularização / extração de widgets ou ViewModels
- [ ] `test`: Adição ou melhoria de testes
- [ ] `chore` / `docs`: Configuração, CI ou documentação

## Checklist de Qualidade (Obrigatório)
- [ ] Li e segui as regras do `AGENTS.md`
- [ ] Nenhum arquivo novo ultrapassa 300 linhas (UI) ou 250 linhas (lógica/dados)
- [ ] Nenhuma tela legada cresceu em relação ao teto do Ratchet
- [ ] Nenhuma tela importa clientes HTTP ou URLs hardcoded (usa `ViewModel` + `AppEnv` + `ApiEndpoints`)
- [ ] `.\scripts\check.ps1` passou 100% localmente (`flutter analyze --fatal-infos` + `flutter test`)
