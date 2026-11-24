import '../../core/errors/app_exception.dart';
import '../models/comment_model.dart';
import '../models/issue_model.dart';

/// Contrato do repositório de ocorrências, votos e comentários.
abstract interface class IssueRepository {
  List<IssueModel> getIssues({String query = ''});
  Future<List<IssueModel>> fetchIssues({String query = ''});
  IssueModel? getIssueById(String id);
  void addIssue(IssueModel issue);
  void toggleUpvote(String id);
  void toggleDownvote(String id);
  List<CommentModel> getComments(String issueId);
  void addComment(String issueId, CommentModel comment);
  int get totalCount;
}

/// Implementação local em memória de [IssueRepository].
class InMemoryIssueRepository implements IssueRepository {
  final List<IssueModel> _issues = [];
  final Map<String, List<CommentModel>> _comments = {};

  InMemoryIssueRepository({bool seedDefaults = true}) {
    if (seedDefaults) {
      _initDefaultIssues();
      _initDefaultComments();
    }
  }

  void _initDefaultIssues() {
    _issues.addAll(const [
      IssueModel(
        id: '1',
        title: 'Datashow quebrado',
        location: 'Sala de Aula 10/Setor Informática',
        status: 'Resolvido',
        description: 'Não está conectando a nenhum notebok',
        upvotes: 17,
        downvotes: 0,
      ),
      IssueModel(
        id: '2',
        title: 'Ar condicionado danificado',
        location: 'Sala de Aula 13/Setor Administrativo',
        status: 'Pendente',
        description:
            'Aparelho fazendo barulho muito alto e pingando água na primeira fileira de cadeiras.',
        upvotes: 7,
        downvotes: 0,
      ),
      IssueModel(
        id: '3',
        title: 'Chão sujo',
        location: 'Sala de Aula 20/Setor agropecuária',
        status: 'Pendente',
        description:
            'Resíduos de terra e poeira acumulados após a última aula prática.',
        upvotes: 0,
        downvotes: 13,
      ),
      IssueModel(
        id: '4',
        title: 'Lâmpada piscando',
        location: 'Laboratório 3/Setor Eletrotécnica',
        status: 'Pendente',
        description:
            'Lâmpada tubular na bancada central piscando continuamente, dificultando a visualização.',
        upvotes: 12,
        downvotes: 1,
      ),
      IssueModel(
        id: '5',
        title: 'Tomada sem energia',
        location: 'Biblioteca / Cabine 04',
        status: 'Resolvido',
        description: 'Tomada 110V não carrega os notebooks dos alunos.',
        upvotes: 5,
        downvotes: 0,
      ),
    ]);
  }

  void _initDefaultComments() {
    _comments['1'] = [
      CommentModel(
        id: 'c1',
        userName: 'Suporte TI IFPI',
        userRole: 'Equipe Técnica',
        content: 'Cabo HDMI substituído e projetor recalibrado com sucesso!',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isOfficial: true,
      ),
      CommentModel(
        id: 'c2',
        userName: 'Lucas Santos',
        userRole: 'Aluno - Informática',
        content:
            'Testei agora há pouco na aula do Prof. Marcos e funcionou perfeitamente.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    _comments['2'] = [
      CommentModel(
        id: 'c3',
        userName: 'Coordenação Administrativa',
        userRole: 'Gestão Predial',
        content:
            'A equipe de manutenção terceirizada virá amanhã pela manhã.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        isOfficial: true,
      ),
    ];
  }

  @override
  List<IssueModel> getIssues({String query = ''}) {
    if (query.trim().isEmpty) {
      return List.unmodifiable(_issues);
    }
    final q = query.toLowerCase().trim();
    return List.unmodifiable(
      _issues.where(
        (item) =>
            item.title.toLowerCase().contains(q) ||
            item.location.toLowerCase().contains(q) ||
            item.status.toLowerCase().contains(q),
      ),
    );
  }

  @override
  Future<List<IssueModel>> fetchIssues({String query = ''}) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return getIssues(query: query);
    } catch (error) {
      throw AppException.fromError(error);
    }
  }

  @override
  IssueModel? getIssueById(String id) {
    for (final issue in _issues) {
      if (issue.id == id) return issue;
    }
    return null;
  }

  @override
  void addIssue(IssueModel issue) {
    _issues.insert(0, issue);
  }

  @override
  void toggleUpvote(String id) {
    final index = _issues.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final item = _issues[index];
    if (item.userUpvoted) {
      _issues[index] = item.copyWith(
        upvotes: item.upvotes - 1,
        userUpvoted: false,
      );
      return;
    }

    _issues[index] = item.copyWith(
      upvotes: item.upvotes + 1,
      userUpvoted: true,
      downvotes: item.userDownvoted ? item.downvotes - 1 : item.downvotes,
      userDownvoted: false,
    );
  }

  @override
  void toggleDownvote(String id) {
    final index = _issues.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final item = _issues[index];
    if (item.userDownvoted) {
      _issues[index] = item.copyWith(
        downvotes: item.downvotes - 1,
        userDownvoted: false,
      );
      return;
    }

    _issues[index] = item.copyWith(
      downvotes: item.downvotes + 1,
      userDownvoted: true,
      upvotes: item.userUpvoted ? item.upvotes - 1 : item.upvotes,
      userUpvoted: false,
    );
  }

  @override
  List<CommentModel> getComments(String issueId) {
    return List.unmodifiable(_comments[issueId] ?? const <CommentModel>[]);
  }

  @override
  void addComment(String issueId, CommentModel comment) {
    _comments.putIfAbsent(issueId, () => []);
    _comments[issueId]!.add(comment);
  }

  @override
  int get totalCount => _issues.length;
}
