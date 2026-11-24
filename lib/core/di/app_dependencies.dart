import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/issue_repository.dart';
import '../../data/services/secure_storage_service.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';
import '../../features/issues/viewmodels/issue_viewmodel.dart';

/// Composition Root centralizado do aplicativo Avisa Mais (A+ IFPI).
///
/// Concentra a criação e injeção explícita de Services, Repositories e
/// ViewModels sem introduzir frameworks de DI desnecessários.
class AppDependencies {
  final SecureStorageService secureStorage;
  final AuthRepository authRepository;
  final IssueRepository issueRepository;
  final AuthViewModel authViewModel;
  final IssueViewModel issueViewModel;

  AppDependencies._({
    required this.secureStorage,
    required this.authRepository,
    required this.issueRepository,
    required this.authViewModel,
    required this.issueViewModel,
  });

  /// Cria um grafo isolado de dependências (ideal para bootstrap e testes).
  factory AppDependencies.create({
    SecureStorageService? secureStorage,
    AuthRepository? authRepository,
    IssueRepository? issueRepository,
  }) {
    final resolvedStorage = secureStorage ?? FlutterSecureStorageService();
    final resolvedAuthRepo = authRepository ??
        InMemoryAuthRepository(secureStorage: resolvedStorage);
    final resolvedIssueRepo = issueRepository ?? InMemoryIssueRepository();

    return AppDependencies._(
      secureStorage: resolvedStorage,
      authRepository: resolvedAuthRepo,
      issueRepository: resolvedIssueRepo,
      authViewModel: AuthViewModel(repository: resolvedAuthRepo),
      issueViewModel: IssueViewModel(repository: resolvedIssueRepo),
    );
  }

  static AppDependencies? _instance;

  /// Instância ativa da composição da aplicação.
  static AppDependencies get instance {
    return _instance ??= AppDependencies.create();
  }

  /// Inicializa a composição no bootstrap (`main.dart`) ou em testes.
  static void initialize([AppDependencies? dependencies]) {
    _instance = dependencies ?? AppDependencies.create();
  }

  /// Limpa a instância ativa entre testes para evitar vazamento de estado.
  static void resetForTesting() {
    _instance?.authViewModel.dispose();
    _instance?.issueViewModel.dispose();
    _instance = null;
  }
}
