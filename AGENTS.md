# AGENTS.md — Constituição Técnica do App Flutter (`Avisa Mais` / `A+`)

---

## 1. Escopo e Regras Fundamentais

> **ESCOPO ESTRITO:** Este arquivo aplica-se **EXCLUSIVAMENTE** ao aplicativo frontend Flutter (`A+`).  
> Ele **não** se aplica ao repositório da API backend (`../avisa-mais-api`).  
> Nunca acesse, modifique ou crie arquivos no backend a partir de tarefas deste repositório e nunca duplique regras de segurança/autorização do servidor no cliente.

> **REGRA ZERO (INEGOCIÁVEL):** Nunca contorne travas de qualidade (`// ignore:`, `// ignore_for_file:`, remoção de testes, `dynamic` sem justificativa ou flexibilização dos limites objetivos de linhas) para "fazer passar". Sempre corrija a causa raiz ou extraia componentes/classes menores.

### Convenção de Status neste Documento
> **Conclusão arquitetural não significa conclusão funcional.** Toda regra neste documento deve ser interpretada segundo a classificação abaixo:

- **Arquitetura implementada:** estrutura **Feature-First + MVVM** (`lib/features/`, `lib/core/`, `lib/data/`, `lib/routes/`, `lib/widgets/`), Composition Root (`AppDependencies`), `ViewState<T>`, `SafeChangeNotifier`, `AppException`/`ErrorMessageMapper`/`ErrorFeedback`, `AppLogger`, `AppEnv` e `AppRouter`.
- **Guardrails implementados e testados:** regras estáticas em `analysis_options.yaml` e verificações arquiteturais em `test/architecture/guardrails_test.dart` (limites universais de 300/250 linhas, isolamento entre features, proibição de `lib/screens/` e `lib/viewmodels/`, DI explícita, armazenamento seguro e logging).
- **Funcionalidades implementadas (escopo local/UI):** telas e fluxos visuais de autenticação, ocorrências (feed, criação, histórico, detalhes), votação e comentários em memória, perfil e configurações, além do armazenamento seguro local de tokens via `SecureStorageService`.
- **Funcionalidades parcialmente implementadas:** acessibilidade (`tooltip` em `IconButton`s principais, ainda sem `Semantics`/`ExcludeSemantics`), padronização completa de formulários (`FocusNode`, `textInputAction`, `autofillHints`) e substituição contínua de estilos inline pelos tokens de `lib/core/theme/`.
- **Integrações externas e recursos pendentes:** cliente HTTP real para a `avisa-mais-api`, repositórios HTTP substituindo `InMemoryAuthRepository` e `InMemoryIssueRepository`, paginação remota, upload real de imagens, notificações push e módulo de denúncias.

---

## 2. Arquitetura Modular, Organização de Pastas e Nomenclatura

O app adota efetivamente **Feature-First + MVVM** com camadas bem definidas (**UI -> ViewModel -> Repository -> Service**) e **organização modular por tela**, garantindo baixo acoplamento, reutilização consciente, testabilidade e manutenção simples.

As antigas pastas `lib/screens/` e `lib/viewmodels/` foram eliminadas e sua recriação é bloqueada automaticamente por `test/architecture/guardrails_test.dart`.

### Estrutura Real do Projeto (`lib/`)
```text
lib/
├── main.dart                       # Bootstrap (binding, AppEnv.validate, AppDependencies.initialize, orientação, runApp)
├── core/                           # Infraestrutura global (ZERO lógica de feature)
│   ├── config/
│   │   └── app_env.dart            # Ambientes (development/staging/production) via --dart-define + validação
│   ├── di/
│   │   └── app_dependencies.dart   # Composition Root centralizado (sem framework de DI extra)
│   ├── errors/
│   │   ├── app_exception.dart      # Contrato de erro alinhado ao ApiErrorResponse da API
│   │   ├── error_message_mapper.dart # Tradução segura para mensagens amigáveis na UI
│   │   └── error_feedback.dart     # Exibição padronizada de erros (SnackBar)
│   ├── logging/
│   │   └── app_logger.dart         # Logging centralizado (dart:developer) com redação de segredos
│   ├── network/
│   │   └── api_endpoints.dart      # Rotas /api/v1/... centralizadas (zero URL mágica)
│   ├── state/
│   │   ├── view_state.dart         # Estados padronizados (initial, loading, success, error)
│   │   └── safe_change_notifier.dart # Proteção contra notifyListeners() após dispose()
│   └── theme/                      # Localização central e única do Design System
│       ├── app_colors.dart         # Paleta oficial de cores
│       ├── app_spacing.dart        # Tokens de espaçamento e raios de borda
│       ├── app_typography.dart     # Tokens tipográficos
│       └── app_theme.dart          # ThemeData Material 3 centralizado
├── data/                           # Camada de dados compartilhada e entidades de domínio/API
│   ├── models/                     # Modelos imutáveis únicos (*_model.dart) com fromJson / toJson / copyWith
│   ├── repositories/               # Interfaces + implementações (fonte única da verdade)
│   └── services/                   # SecureStorageService e futuros clientes HTTP/Upload
├── features/                       # Módulos organizados por funcionalidade (Feature-First MVVM)
│   ├── auth/                       # views/, viewmodels/, widgets/ (auth_scaffold, otp_code_input, social_auth_buttons + login/, register/)
│   ├── issues/                     # views/, viewmodels/, widgets/ (issue_card + feed/, create/, history/, detail/)
│   ├── profile/                    # views/ e widgets/profile/
│   └── settings/                   # views/ e widgets/settings/
├── routes/                         # AppRoutes + AppRouter + HomeScreen (shell de abas)
└── widgets/                        # Componentes visuais verdadeiramente globais (AppHeaderBar, AppBottomNavBar, AppPrimaryButton, etc.)
```

### Organização Modular por Feature e por Tela (Padrão Oficial)
Cada funcionalidade vive em `lib/features/<nome_da_feature>/`, agrupando suas telas em `views/`, seus estados em `viewmodels/` e seus componentes auxiliares em `widgets/` — **com subpastas por tela para componentes exclusivos daquela tela**:

```text
lib/
└── features/
    └── issues/
        ├── views/
        │   ├── create_issue_screen.dart
        │   ├── history_screen.dart
        │   └── issue_detail_screen.dart
        ├── viewmodels/
        │   └── issue_viewmodel.dart
        └── widgets/
            ├── issue_card.dart              # Compartilhado dentro da feature `issues`
            ├── feed/                        # Exclusivos do feed principal
            │   └── issues_feed_view.dart
            ├── detail/                      # Exclusivos da tela de detalhes
            │   ├── issue_detail_header.dart
            │   ├── issue_detail_vote_bar.dart
            │   └── issue_comments_section.dart
            ├── history/                     # Exclusivos da tela de histórico
            │   ├── history_metrics_row.dart
            │   ├── history_filters.dart
            │   ├── history_issue_card.dart
            │   └── history_empty_state.dart
            └── create/                      # Exclusivos da tela de criação
                ├── issue_photo_picker.dart
                └── issue_sector_picker.dart
```

> **Diretriz de criação (não crie pastas vazias):** crie subpastas dentro de `lib/features/<feature>/` apenas conforme a necessidade real da funcionalidade.

#### Regras de Organização por Tela
1. **`views/` contém apenas as telas completas:** cada tela tem seu próprio arquivo em `views/`. A pasta `widgets/` contém apenas componentes auxiliares — nunca cópias de telas.
2. **Isolamento de componentes por tela:** widgets exclusivos de uma tela ficam em uma subpasta com o contexto daquela tela dentro de `widgets/` (ex.: `widgets/detail/`, `widgets/create/`, `widgets/history/`).
3. **Compartilhamento dentro da feature:** componentes usados por mais de uma tela da mesma funcionalidade ficam diretamente em `features/<feature>/widgets/` (ou subpasta `shared/` se o volume justificar).
4. **Sem mistura nem duplicação:** não misture na mesma pasta componentes sem relação apenas por pertencerem à mesma feature e nunca duplique um componente para evitar um `import`.
5. **Decisão arquitetural sobre `models/`, `repositories/` e `data/` (Sem Duplicidade de Camadas):**
   - **Entidades compartilhadas e modelos de domínio/API (`*_model.dart`):** permanecem centralizados em `lib/data/models/` (`IssueModel`, `UserModel`, `CommentModel`, `AuthTokensModel`), preservando a regra de modelo único verificada por `guardrails_test.dart`. Não reorganize ou mova os modelos existentes sem necessidade real.
   - **Modelos exclusivamente de apresentação:** tipos auxiliares restritos à camada visual de uma feature (ex.: filtros, ordenações como `HistoryFilter`/`HistorySort`, ou futuros view-data/UI states sem papel de entidade de domínio/API) podem viver dentro da própria feature (`lib/features/<feature>/`) quando houver justificativa clara, sem nunca duplicar entidades de `lib/data/models/`.
   - **Repositórios e serviços compartilhados:** permanecem centralizados em `lib/data/` (`repositories/`, `services/`) e compostos em `lib/core/di/app_dependencies.dart`, evitando criar uma segunda camada paralela de acesso a dados.

### Critérios Objetivos para Compartilhamento de Componentes

| Situação | Localização Obrigatória |
|---|---|
| Utilizado exclusivamente por uma única tela | `lib/features/<feature>/widgets/<tela>/` |
| Utilizado por várias telas da mesma funcionalidade | `lib/features/<feature>/widgets/` |
| Utilizado por funcionalidades independentes diferentes | `lib/widgets/` |
| Relacionado a tema, tokens visuais ou infraestrutura global | `lib/core/` |

- **Exemplo prático:** `issue_card.dart` pertence a `lib/features/issues/widgets/` e `auth_scaffold.dart` / `otp_code_input.dart` / `social_auth_buttons.dart` pertencem a `lib/features/auth/widgets/` — não à pasta global `lib/widgets/`.
- **Promoção consciente:** só mova um componente para `lib/widgets/` quando houver reutilização real entre **duas ou mais funcionalidades independentes**.

### Leis de Isolamento, Modularidade e Injeção de Dependências
1. **View / Screen burra (apenas UI):** renderiza estado vindo do `ViewModel` e dispara intenções do usuário. **Proibido** colocar regras de negócio em widgets ou chamar HTTP, `dart:io`, `package:http`, `dio` ou `data/services/` diretamente em telas/widgets.
2. **Baixo acoplamento entre features (Implementado e verificado em `guardrails_test.dart`):** uma feature (`lib/features/<A>/`) **nunca** deve importar arquivos internos de outra feature (`lib/features/<B>/`) nem criar dependências circulares. Compartilhamento entre features ocorre via `lib/data/`, `lib/core/`, `lib/routes/` ou `lib/widgets/`.
3. **Injeção explícita de dependências (Implementado):**
   - Todo `ViewModel` recebe seus `Repositories` explicitamente pelo construtor (`required`).
   - **Proibido** instanciar repositórios concretos dentro de ViewModels ou manter singletons ocultos (`static final _instance`) em ViewModels.
   - A composição é centralizada em `lib/core/di/app_dependencies.dart` (`AppDependencies`), preservando substituição fácil por mocks/fakes em testes.
   - Não introduza frameworks externos de DI sem necessidade real comprovada.
4. **ViewModel sem dependência de UI:** estende `SafeChangeNotifier`, expõe `ViewState<T>` e **nunca** guarda `BuildContext` ou exibe `SnackBar`/`Dialog`.
5. **Repository atrás de interface:** define contrato abstrato (`AuthRepository`, `IssueRepository`), traduz respostas/falhas de `Services` para modelos de `lib/data/models/` e `AppException`.
6. **Modelo único e tema centralizado:** entidades de domínio/API vivem exclusivamente em `lib/data/models/` e toda infraestrutura de tema vive exclusivamente em `lib/core/theme/` (proibido recriar `lib/theme/` ou `lib/models/`).

### Convenções de Nomenclatura, Imports e Documentação
- **Arquivos e pastas:** `snake_case` descritivo refletindo o papel (`issue_detail_screen.dart`, `issue_detail_header.dart`, `secure_storage_service.dart`, `auth_viewmodel.dart`).
- **Classes, enums e typedefs:** `UpperCamelCase` refletindo o papel (`AuthViewModel`, `IssueRepository`, `AppException`, `IssueCard`).
- **Métodos, variáveis e parâmetros:** `lowerCamelCase`; membros privados com prefixo `_`; constantes descritivas sem abreviações obscuras.
- **Organização de imports:** agrupe em 3 blocos separados por linha em branco: (1) `dart:*`, (2) `package:*`, (3) imports relativos do projeto.
- **Sem dependências circulares e sem código duplicado:** `core/` nunca depende de `features/` ou `routes/` (exceto o Composition Root em `core/di/app_dependencies.dart` que compõe os ViewModels); extraia lógica ou widgets repetidos respeitando a tabela de compartilhamento acima.
- **Documentação técnica:** atualize `AGENTS.md` e `README.md` quando houver mudanças arquiteturais relevantes e registre decisões técnicas de impacto. Evite comentários redundantes que apenas repetem o óbvio; documente *porquês*, contratos e restrições.

---

## 3. Limites Objetivos de Código e Qualidade

Todo código em `lib/` é verificado universalmente (sem exceções) por `analysis_options.yaml` e `test/architecture/guardrails_test.dart`:

| Regra | Limite / Status |
|---|---|
| Linhas efetivas por arquivo de UI em `lib/` (`views/`, `widgets/`, `routes/home_screen.dart`) | **Máx. 300 linhas** (universal, sem exceções) |
| Linhas efetivas por arquivo de lógica (`core/`, `data/`, `features/*/viewmodels/`, `routes/` exceto shell) | **Máx. 250 linhas** (universal, sem exceções) |
| Recriação das pastas removidas `lib/screens/` e `lib/viewmodels/` | **Proibida** (`guardrails_test.dart`; usar `lib/features/`) |
| Uso de `print()` ou `debugPrint()` direto em `lib/` | **Proibido** (`avoid_print` + `guardrails_test.dart`; use `AppLogger`) |
| `// ignore:` em regras críticas de análise | **Proibido** |
| Singletons ocultos (`_instance`) em ViewModels | **Proibido** |
| Credenciais sensíveis em `SharedPreferences` | **Proibido** |
| URL `http://` ou `https://` hardcoded em telas/widgets | **Proibido** (use `AppEnv` + `ApiEndpoints`) |
| Telas/widgets importando `data/services/`, `dart:io`, `http` ou `dio` | **Proibido** |
| Importação direta entre features distintas (`features/<A>` -> `features/<B>`) | **Proibido** (`guardrails_test.dart`) |
| Modelos duplicados fora de `lib/data/models/` | **Proibido** |
| Pasta duplicada `lib/theme/` | **Proibida** (use `lib/core/theme/`) |
| Tipos implícitos perigosos | `strict-casts` e `strict-raw-types` ativos |

### Definição Objetiva de Linha Efetiva (idêntica ao `guardrails_test.dart`)
Considera-se **linha efetiva** toda linha que, após `trim()`, **não** esteja vazia e **não** inicie com `//`, `/*`, `*` ou `*/`. Imports, declarações, código e chaves de fechamento **são contabilizados**.  
> Não divida arquivos artificialmente apenas para cumprir o limite: priorize coesão real, legibilidade e extração de widgets/classes com responsabilidade única.

---

## 4. UI, Design System, Responsividade e Acessibilidade

### Design System e Critérios de Componentização Consciente
- Centralize tokens visuais exclusivamente em `lib/core/theme/` (`AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppTheme`) e componentes globais em `lib/widgets/`.
- Evite repetir `Color(0xFF...)` ou estilos inline quando já existir token em `AppColors` / `AppTypography` *(padronização contínua dos estilos inline ainda presentes em algumas telas)*.
- **Quando extrair um componente (sem exageros):** extraia um **`StatelessWidget` dedicado** (preferencialmente `const`) quando o trecho:
  - possui responsabilidade visual ou comportamental própria (ex.: card, cabeçalho, filtro, bottom sheet, formulário);
  - tem complexidade suficiente para prejudicar a legibilidade do `build()` (ex.: acima de ~60–80 linhas);
  - é reutilizado ou possui potencial real de reutilização;
  - pode ser testado ou mantido de maneira independente;
  - melhora efetivamente a clareza e a organização do módulo.
- **Quando NÃO extrair:** não transforme trechos triviais de interface em arquivos separados nem crie abstrações artificiais apenas para reduzir linhas. Os limites universais de 300/250 linhas continuam obrigatórios e devem ser atendidos por coesão real.

### Responsividade e Adaptação de Interfaces
*(Obrigatório em toda nova tela e nas evoluções das telas existentes)*
- Projete layouts funcionais tanto para smartphones compactos (ex.: 320–360dp de largura) quanto para telas grandes (ex.: >= 412dp / tablets), preservando a identidade visual.
- Adapte componentes ao espaço disponível com `LayoutBuilder`, `Expanded`, `Flexible`, `ConstrainedBox` (ex.: `maxWidth` em formulários) e `Wrap` quando necessário.
- **Prevenção de overflow horizontal e vertical:** nunca confie em larguras/alturas fixas rígidas para textos dinâmicos; use `Expanded`/`Flexible` em `Row`, `softWrap: true` e `TextOverflow.ellipsis` quando apropriado.
- **Teclado virtual e rolagem:** toda tela com campos de texto ou conteúdo extenso deve usar `SingleChildScrollView` (ou `ListView`) com `SafeArea` e tratamento adequado de `viewInsets`, impedindo sobreposição ou `RenderFlex overflow` quando o teclado abrir.
- **Textos dinâmicos e fontes ampliadas:** evite containers de altura fixa contendo textos que possam quebrar em mais linhas com `textScaler` elevado; use `minHeight` (`ConstrainedBox`) em vez de `height` rígida sempre que possível.
- **Dimensões fixas conscientes:** restrinja tamanhos fixos a ícones, avatares, espaçadores e alvos mínimos de toque.

### Acessibilidade
*(Parcialmente adotado em `tooltip` de `IconButton`s principais; `Semantics`/`ExcludeSemantics`, auditoria sistemática de contraste e testes com ampliação de fonte seguem como **Requisito arquitetural futuro** obrigatório para novas telas e refatorações)*
- Utilize `Semantics` (e `ExcludeSemantics` em elementos puramente decorativos) para manter uma hierarquia semântica clara para leitores de tela (TalkBack / VoiceOver).
- Todo `IconButton`, botão apenas com ícone e imagem informativa deve possuir `tooltip` ou `semanticLabel` descritivo.
- Garanta contraste adequado entre texto/ícone e fundo (padrão WCAG AA) ao escolher combinações de cores do Design System.
- **Nunca dependa exclusivamente de cor** para transmitir estado ou alerta: combine cor com rótulo textual e/ou ícone (ex.: badges de status `Pendente`, `Em andamento`, `Resolvido`, mensagens de erro).
- Garanta **áreas de toque mínimas de `48x48` dp** em elementos interativos (`IconButton`, links clicáveis, checkboxes, botões de voto).
- Teste compatibilidade com ampliação de fonte do sistema, prevenindo cortes, truncamentos críticos e sobreposições.

---

## 5. Gerenciamento de Estado e Ciclo de Vida

1. **Estados assíncronos padronizados (`ViewState<T>`, Implementado):**
   - Operações assíncronas nos ViewModels devem transitar explicitamente entre `ViewStatus.initial`, `ViewStatus.loading`, `ViewStatus.success` e `ViewStatus.error`.
   - Proteja operações concorrentes duplicadas (`if (_state.isLoading) return;`) quando aplicável.
   - Em qualquer falha, o estado **deve** sair de `loading` para `error` (a interface nunca pode ficar presa em carregamento).
   - Mantenha estados independentes por feature/ViewModel (não force um estado global monolítico).
2. **Proteção pós-descarte (`SafeChangeNotifier`, Implementado):**
   - ViewModels estendem `SafeChangeNotifier` e notificam via `safeNotifyListeners()`, impedindo chamadas a `notifyListeners()` após `dispose()`.
3. **Ciclo de vida seguro em `StatefulWidget`:**
   - Todo `TextEditingController`, `FocusNode`, `ScrollController` e `StreamSubscription` **deve** ser descartado em `dispose()`.
   - Após qualquer `await` em `State`, verifique `if (!mounted) return;` antes de usar `context` ou `setState`.

---

## 6. Navegação e Formulários

### Navegação e Gerenciamento de Rotas (`Navigator 1.0`, Implementado)
- A solução oficial do projeto é **`Navigator 1.0`** centralizado em `lib/routes/app_routes.dart` (`AppRoutes`), `lib/routes/app_router.dart` (`AppRouter.onGenerateRoute`) e `lib/routes/home_screen.dart` (shell de abas), configurado em `lib/main.dart`. Não substitua por `go_router` ou outra biblioteca sem justificativa técnica comprovada.
- **Centralização e uso obrigatório de rotas nomeadas (Implementado):** todo nome de rota é declarado em `AppRoutes` e toda navegação entre telas utiliza `Navigator.of(context).pushNamed(...)` / `pushReplacementNamed(...)` / `pushNamedAndRemoveUntil(...)`. Não existe mais nenhum `MaterialPageRoute` direto fora de `AppRouter._buildRoute` *(única transição customizada fora do router: `PageRouteBuilder` com `FadeTransition` na saída de `SplashScreen` para `LoginScreen` dentro de `features/auth`)*. É proibido espalhar strings literais de rotas pelo projeto.
- **Isolamento de navegação entre features (Obrigatório):** uma feature (`lib/features/<A>/`) **nunca** deve importar telas ou widgets internos de outra feature (`lib/features/<B>/`) para realizar navegação. Toda transição entre features deve utilizar o sistema centralizado de rotas (`AppRoutes` + `AppRouter`) com argumentos tipados.
- **Parâmetros tipados e validação (Implementado em `AppRouter`):** rotas parametrizadas recebem classes de argumentos tipadas (`IssueDetailRouteArgs`, `RegisterVerifyRouteArgs`) validadas no `AppRouter`. Parâmetros ausentes ou inválidos redirecionam para fallback seguro (`_InvalidRouteScreen` ou `RegisterScreen`) sem lançar exceções não tratadas.
- **Prevenção de duplicação e botão voltar:** use `pushNamedAndRemoveUntil` ao trocar de contexto raiz (ex.: login -> home, logout -> login) e `pushReplacementNamed` ao substituir etapas equivalentes, evitando telas duplicadas na pilha e mantendo comportamento consistente do botão voltar (`PopScope` no `HomeScreen`).
- **Separação de responsabilidades:** regras de negócio ficam nos ViewModels/Repositories; a navegação pertence exclusivamente à camada de apresentação/roteamento.

### Padronização de Formulários
*(Obrigatório para novos formulários; adoção progressiva de `FocusNode`, `textInputAction` e `autofillHints` nos formulários existentes)*
- Use `Form` + `GlobalKey<FormState>` com validadores consistentes, exibindo mensagens de erro próximas aos respectivos campos.
- Identifique claramente campos obrigatórios na interface (rótulo/validação coerente).
- **Prevenção de submissão duplicada:** desabilite o botão de envio (`onPressed: isLoading ? null : _submit`) e bloqueie reentrada durante carregamento.
- **Feedback visual:** exiba indicador de carregamento no botão de ação (`AppPrimaryButton(isLoading: ...)`) durante operações assíncronas.
- **Preservação de dados em falhas recuperáveis:** nunca limpe os `TextEditingController`s quando uma submissão falhar por rede, timeout ou erro de validação; preserve o que o usuário digitou para correção/reintento.
- **Teclado e foco:** configure `keyboardType`, `textInputAction` (`next` / `done`) e `autofillHints` adequados; descarte obrigatoriamente todos os `TextEditingController`s e `FocusNode`s em `dispose()`.
- **Separação de validação:** validação visual/sintática (campo vazio, formato de e-mail, confirmação de senha) fica no formulário; regras de negócio e validações definitivas (unicidade, autenticação, RBAC) ficam no ViewModel/Repository/Backend.

---

## 7. Integração com API, Segurança e Tratamento de Erros

### Fluxo Padronizado de Erros (`Service -> Repository -> ViewModel -> View`)
*(Infraestrutura de erro implementada em `AppException`, `ErrorMessageMapper`, `ErrorFeedback`, `SecureStorageService` e ViewModels; os repositórios ativos ainda são em memória — `InMemoryAuthRepository` e `InMemoryIssueRepository` — e a camada HTTP real segue **pendente**)*
1. **Service:** detecta falhas de comunicação, timeout ou armazenamento seguro e lança `AppException`.
2. **Repository:** converte erros HTTP pelo parser único `AppException.fromApiJson(...)` — respeitando o contrato `ApiErrorResponse` (`statusCode`, `code`, `message`, `details`, `requestId`) — e falhas inesperadas por `AppException.fromError(...)`. Não duplique parsers de erro.
3. **ViewModel:** captura a exceção, transita para `ViewState.error(appException)` e expõe `error` / `errorMessage`.
4. **View:** exibe exclusivamente `error.userMessage` (traduzido por `ErrorMessageMapper` / exibido via `ErrorFeedback.showSnackBar`). **Nunca** exiba stack traces, exceções cruas, detalhes internos ou dados sensíveis na UI.

### Segurança e Armazenamento de Autenticação (Implementado na camada Service/Repository)
1. Credenciais de sessão (`AuthTokensModel`: `accessToken`, `refreshToken`, `expiresAt`) devem ser manipuladas exclusivamente via `SecureStorageService` (`FlutterSecureStorageService` com `flutter_secure_storage`).
2. **Nunca** armazene JWT, senhas ou credenciais em `SharedPreferences`, arquivos comuns ou logs. `AuthTokensModel.toString()` mantém os tokens sempre redigidos (`[REDACTED]`).
3. `logout()` e tratamento de sessão expirada (`handleSessionExpired()` / resposta `401`) devem remover imediatamente as credenciais do armazenamento seguro.
4. Falhas de leitura, gravação, exclusão ou payload corrompido no armazenamento seguro devem ser convertidas em `AppException.storage()`.
5. **Autorização é responsabilidade do backend:** nunca implemente no cliente regras de permissão que substituam validações RBAC da `avisa-mais-api`.

---

## 8. Performance e Otimização

- **Listas extensas:** utilize sempre `ListView.builder` / `ListView.separated` / `SliverList` (construção sob demanda) em vez de `Column` com listas dinâmicas grandes.
- **Paginação (Requisito arquitetural futuro para integração HTTP):** quando a API suportar paginação (`page`, `limit`, `meta`), carregue páginas sob demanda sem buscar coleções inteiras de uma vez.
- **Zero I/O em `build()`:** nunca dispare requisições HTTP, leitura de storage ou inicializações pesadas dentro de `build()`. Acione carregamentos em `initState`, eventos do usuário ou inicialização explícita do ViewModel.
- **Prevenção de chamadas duplicadas:** evite re-disparar requisições em rebuilds; proteja métodos assíncronos no ViewModel contra concorrência duplicada (`if (_state.isLoading) return;`).
- **Reconstruções enxutas:** prefira widgets `const`, limite o escopo de `ListenableBuilder` apenas à subárvore que depende do estado alterado e evite `setState` amplos sem necessidade.
- **Imagens e recursos:** redimensione/comprima imagens antes de upload quando implementado, use `cacheWidth`/`cacheHeight` ou cache apropriado quando houver carregamento remoto de fotos, e evite pré-carregar recursos não utilizados.
- **Cache consciente:** não introduza bibliotecas ou camadas complexas de cache sem necessidade real comprovada.
- **Memória:** descarte controllers, listeners, timers e subscriptions em `dispose()` para evitar vazamentos.

---

## 9. Logs e Diagnóstico

- **Mecanismo centralizado (Implementado):** utilize exclusivamente `AppLogger` (`lib/core/logging/app_logger.dart`, baseado em `dart:developer` sem dependências externas).
- **Proibição total de `print()` e `debugPrint()` direto:** qualquer uso em `lib/` é bloqueado pelo analyzer e pelo `guardrails_test.dart`.
- **Redação obrigatória de segredos:** jamais registre senhas, tokens JWT, headers `Authorization`, códigos OTP ou dados pessoais sensíveis. `AppLogger.sanitize(...)` aplica redação automática como camada adicional de defesa.
- **Desenvolvimento vs. Produção:** `AppLogger` emite `debug` e `info` apenas em desenvolvimento/profile e restringe produção (`kReleaseMode`) a `warning` e `error` sem stack trace bruto.
- **Sobriedade nos logs:** registre apenas falhas relevantes para diagnóstico (erros inesperados, rotas inválidas, falhas de storage/rede); evite poluir logs com cada interação trivial.
- **Proibido exibir stack traces ao usuário:** diagnóstico fica no `AppLogger`; a UI recebe apenas `AppException.userMessage`.
- Não adicione pacotes externos de logging sem justificativa técnica real.

---

## 10. Dependências e Configuração de Ambientes

### Gerenciamento de Dependências (`pubspec.yaml`)
- **Dependências atuais de runtime:** `flutter`, `cupertino_icons`, `flutter_secure_storage`.
- Antes de adicionar qualquer pacote, verifique se o próprio Flutter/Dart ou o projeto já atendem à necessidade.
- Toda nova dependência exige justificativa técnica clara, avaliação de manutenção ativa, compatibilidade com o SDK (`sdk: ^3.13.2`) e ausência de sobreposição com pacotes existentes.
- Não atualize dependências sem relação direta com a tarefa; quando atualizar, preserve compatibilidade e documente o motivo no PR/relatório.

### Configuração de Ambientes (`AppEnv`, Implementado)
- Os valores abaixo são **exemplos ilustrativos** de uso do `--dart-define` (não representam URLs fixas ou universais obrigatórias — informe o endereço real correspondente ao ambiente no build/execução):
  - **Desenvolvimento local:** `--dart-define=APP_ENV=development --dart-define=API_BASE_URL=http://10.0.2.2:3000` (emulador Android) ou `--dart-define=API_BASE_URL=http://localhost:3000` (Web/Desktop local; valor padrão do `AppEnv`).
  - **Homologação (`staging`):** `--dart-define=APP_ENV=staging --dart-define=API_BASE_URL=https://<host-de-staging>` (substitua pelo host real de homologação).
  - **Produção (`production`):** `--dart-define=APP_ENV=production --dart-define=API_BASE_URL=https://<host-de-producao>` (substitua pelo host real de produção; `HTTPS` obrigatório).
- **Validação obrigatória (`AppEnv.validate()`, Implementado):** executada no bootstrap (`main.dart`) e na construção de URIs; exige URL HTTP/HTTPS válida com host não vazio, **obriga HTTPS em `production`** e exige `REQUEST_TIMEOUT_SECONDS > 0`.
- **Zero segredos versionados e zero URL fora de `AppEnv` / `ApiEndpoints`:** nunca versione chaves privadas ou senhas no repositório e nunca escreva URLs da API fora de `AppEnv` + `ApiEndpoints`.

---

## 11. Regras Específicas das Funcionalidades do Avisa Mais

> As diretrizes abaixo refletem estritamente o estado real do código e o caminho planejado para integração com a `avisa-mais-api`, **sem inventar endpoints ou contratos**.

1. **Autenticação e gerenciamento de sessão** *(Modularizado em `lib/features/auth/` com `AuthViewModel`, `InMemoryAuthRepository`, `SecureStorageService` e `AuthTokensModel`; **integração HTTP com `/api/v1/auth/*` pendente**)*:
   - Fluxos existentes (simulados localmente na UI): Login, Cadastro, Verificação OTP (4 dígitos) e Recuperação de Senha.
   - Armazene tokens exclusivamente via `SecureStorageService`; limpe credenciais imediatamente em `logout()` ou sessão expirada (`401` / `handleSessionExpired()`).
   - Nunca exponha se um e-mail existe ou não em mensagens de erro caso a API retorne mensagem genérica.
2. **Ocorrências** *(Modularizado em `lib/features/issues/` + shell `lib/routes/home_screen.dart` com `IssuesFeedView`, `CreateIssueScreen`, `HistoryScreen`, `IssueDetailScreen`, `IssueViewModel`, `InMemoryIssueRepository` e `IssueModel`; **integração HTTP com `/api/v1/issues` e paginação pendentes**)*:
   - Atualizações de lista e criação passam pelo `IssueViewModel` (`ViewState<List<IssueModel>>`), mantendo estados independentes de erro/carregamento e busca reativa.
   - Ao integrar a API, substitua as listas locais (`kDefaultCampusSectors` em `issue_sector_picker.dart` e `kDefaultCampiList` em `settings_dialogs.dart`) pelo catálogo dinâmico retornado pelo servidor.
3. **Votações** *(Upvote/downvote mutuamente exclusivos implementados em memória no `InMemoryIssueRepository` / `IssueViewModel`; **sincronização HTTP com `/api/v1/issues/:id/votes` pendente**)*:
   - Evite cliques duplicados simultâneos durante sincronização; em caso de falha de rede na API, reverta qualquer estado otimista e exiba feedback amigável via `ErrorFeedback`.
   - A unicidade de voto por usuário e o cálculo definitivo pertencem ao backend.
4. **Comentários** *(Listagem e criação implementadas em memória em `IssueDetailScreen`, `IssueCommentsSection`, `IssueViewModel` e `CommentModel`; **integração HTTP com `/api/v1/issues/:id/comments` pendente**)*:
   - Ignore comentários em branco e preserve o texto no campo caso o envio falhe.
   - A flag `isOfficial` exibida na UI deve ser tratada como dado somente-leitura vindo do servidor (nunca definida pelo cliente com base em regras locais).
5. **Perfis de usuários** *(Modularizado em `lib/features/profile/` e `lib/features/settings/` com `UserModel` e `AuthViewModel.updateProfile` em memória; **integração HTTP com `/api/v1/users/me` pendente**)*:
   - Atualizações de perfil devem refletir no `AuthViewModel` de forma consistente entre telas sem criar cópias divergentes de estado.
6. **Notificações** *(Apenas toggles locais de preferência na UI de `SettingsScreen`; **sem serviço de push ou backend de notificações implementado**)*:
   - **(Requisito arquitetural futuro):** quando notificações reais forem adicionadas, encapsule permissões/tokens push em um `Service` dedicado em `lib/data/services/` e nunca trate falhas de permissão como erro fatal do app.
7. **Imagens e uploads** *(UI de seleção simulada em `IssuePhotoPicker` / `ProfileModals` com flag booleana e `imageUrl` opcional nos models; **sem pacote de seleção de mídia nem upload real implementados**)*:
   - **(Requisito arquitetural futuro):** ao implementar upload real, valide tamanho/formato antes do envio, isole o upload em um `Service` dedicado, exiba progresso/erro recuperável sem perder os campos preenchidos e nunca confie apenas na validação do cliente.
8. **Denúncias (moderação de conteúdo)** *(**Não implementado** no código atual; sem telas, modelos ou endpoints definidos)*:
   - **(Requisito arquitetural futuro):** não invente contratos ou endpoints para denúncias; quando a funcionalidade for especificada na `avisa-mais-api`, siga integralmente o Playbook da Seção 13 (model, endpoint em `ApiEndpoints`, repository, ViewModel, UI modular e testes).

---

## 12. Pirâmide de Testes e Prevenção de Regressões

| Camada | Localização / Status | O que valida |
|---|---|---|
| **1. Testes Unitários** | `test/unit/` *(Implementado)* | `AppEnv`, `AppLogger`, `AppException`/`ErrorMessageMapper`, `SecureStorageService`, serialização JSON dos models e ViewModels com repositórios simulados (`initial`, `loading`, `success`, `error`, concorrência e `dispose()`) |
| **2. Testes Arquiteturais (Guardrails)** | `test/architecture/` *(Implementado)* | Limites universais de linhas (`<= 300` UI / `<= 250` lógica sem exceções), proibição de `lib/screens/` e `lib/viewmodels/`, isolamento entre features, centralização em `lib/core/theme/`, `AppLogger`, `AppRouter`, proibição de singletons em ViewModels, proibição de `print()`/`debugPrint()`, isolamento de camadas, proibição de credenciais em `SharedPreferences` e zero model duplicado |
| **3. Testes de Widgets e Rotas** | `test/unit/routes/`, `test/widget_test.dart` *(Implementado)* | Renderização de telas/componentes, validação de rotas e parâmetros em `AppRouter`, exibição segura de erros (`ErrorFeedback`) e smoke tests básicos |
| **4. Testes de Integração** | `integration_test/` *(Pendente — ainda não implementado)* | Fluxos integrados rodando em dispositivo/emulador ou exercitando repositórios HTTP reais com o cliente de rede quando a integração com a API existir |
| **5. Testes Ponta a Ponta (E2E)** | *(Pendente — ainda não implementado)* | Validação completa de ponta a ponta com o aplicativo conectado a uma instância real da `avisa-mais-api` em ambiente de teste/staging |

> **Referência histórica da última execução conhecida (`2026-11-24`):** `flutter analyze --fatal-infos --fatal-warnings` (0 issues), `flutter test test/architecture/` (`13/13`), `flutter test` (`48/48`) e `.\scripts\check.ps1` (exit code `0`). Estes resultados refletem apenas a última verificação executada nessa data e **não** representam garantia permanente; qualquer mudança exige nova execução completa.

### Regra de Ouro para Bugs (Anti-Regressão)
Ao corrigir qualquer bug visual, de estado, roteamento ou serialização:
1. Primeiro escreva um teste unitário ou de widget que **reproduz o bug e falha**.
2. Aplique a correção mínima e limpa.
3. Execute o portão de qualidade completo para garantir que nada regrediu.

---

## 13. Playbook de Desenvolvimento e Evolução

1. Crie/atualize o model imutável em `lib/data/models/` (com `fromJson`, `toJson`, `copyWith` e testes unitários).
2. Adicione os endpoints em `lib/core/network/api_endpoints.dart` e implemente/atualize o `Service` e o `Repository` (interface + implementação) em `lib/data/`.
3. Crie ou evolua o `ViewModel` em `lib/features/<feature>/viewmodels/` estendendo `SafeChangeNotifier`, com injeção explícita no construtor e `ViewState<T>`, registrando na composição em `lib/core/di/app_dependencies.dart`.
4. Registre novas rotas em `lib/routes/app_routes.dart` e `lib/routes/app_router.dart` com argumentos tipados e validação.
5. Construa a UI em `lib/features/<feature>/views/` e `lib/features/<feature>/widgets/` (subpasta `widgets/<tela>/` para componentes exclusivos de uma tela e `widgets/` para componentes compartilhados da feature), respeitando desde a criação os limites universais (**<= 300 linhas** para UI, **<= 250 linhas** para lógica), tokens de `lib/core/theme/`, responsividade e acessibilidade (`Semantics`). Só promova um componente para `lib/widgets/` quando houver reuso real entre funcionalidades independentes.
6. Escreva testes unitários com repositórios simulados (`test/unit/`) e testes de widget/rotas.
7. Execute o portão completo de qualidade antes de commitar.

---

## 14. Definição de Pronto (DoD) e Fluxo Git

- Toda alteração deve preservar integralmente todos os guardrails arquiteturais ativos em `test/architecture/guardrails_test.dart` (limites universais de linhas, isolamento entre features, proibição de pastas antigas, DI explícita, segurança e logs).
- Commits seguem **Conventional Commits** (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`).
- Alterações em `pubspec.yaml` devem ser tecnicamente justificadas.
- **Obrigatório antes de finalizar qualquer tarefa ou abrir PR:**
  ```powershell
  .\scripts\check.ps1
  ```
  (Executa: `flutter analyze --fatal-infos --fatal-warnings`, `flutter test test/architecture/` e `flutter test`.)
