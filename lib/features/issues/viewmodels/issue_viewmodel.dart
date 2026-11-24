import '../../../core/errors/app_exception.dart';
import '../../../core/state/safe_change_notifier.dart';
import '../../../core/state/view_state.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/models/issue_model.dart';
import '../../../data/repositories/issue_repository.dart';

/// ViewModel de ocorrências com injeção explícita de [IssueRepository]
/// e estados padronizados (`initial`, `loading`, `success`, `error`).
class IssueViewModel extends SafeChangeNotifier {
  final IssueRepository _repository;
  String _searchQuery = '';
  ViewState<List<IssueModel>> _state;

  IssueViewModel({required IssueRepository repository})
      : _repository = repository,
        _state = ViewState<List<IssueModel>>.initial(
          data: repository.getIssues(),
        );

  ViewState<List<IssueModel>> get state => _state;
  String get searchQuery => _searchQuery;
  bool get isLoading => _state.isLoading;
  AppException? get error => _state.error;
  String? get errorMessage => _state.errorMessage;
  int get totalCount => _repository.totalCount;

  List<IssueModel> get issues => _repository.getIssues(query: _searchQuery);

  IssueModel? getIssue(String id) => _repository.getIssueById(id);

  List<CommentModel> getComments(String issueId) =>
      _repository.getComments(issueId);

  void search(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _emit(ViewState<List<IssueModel>>.success(issues));
  }

  void addIssue(IssueModel issue) {
    _repository.addIssue(issue);
    _emit(ViewState<List<IssueModel>>.success(issues));
  }

  void toggleUpvote(String id) {
    _repository.toggleUpvote(id);
    _emit(ViewState<List<IssueModel>>.success(issues));
  }

  void toggleDownvote(String id) {
    _repository.toggleDownvote(id);
    _emit(ViewState<List<IssueModel>>.success(issues));
  }

  void addComment(
    String issueId,
    String content, {
    String userName = 'Kayky Rocha',
    String userRole = 'Aluno',
  }) {
    if (content.trim().isEmpty) return;

    final comment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: userName,
      userRole: userRole,
      content: content.trim(),
      createdAt: DateTime.now(),
    );

    _repository.addComment(issueId, comment);
    _emit(ViewState<List<IssueModel>>.success(issues));
  }

  Future<void> refresh() async {
    if (_state.isLoading) return;

    _emit(ViewState<List<IssueModel>>.loading(data: issues));
    try {
      final fetched = await _repository.fetchIssues(query: _searchQuery);
      _emit(ViewState<List<IssueModel>>.success(fetched));
    } catch (error) {
      final appError = AppException.fromError(error);
      _emit(ViewState<List<IssueModel>>.error(appError, data: issues));
    }
  }

  void clearError() {
    if (!_state.hasError) return;
    _emit(ViewState<List<IssueModel>>.initial(data: issues));
  }

  void _emit(ViewState<List<IssueModel>> nextState) {
    if (isDisposed) return;
    _state = nextState;
    safeNotifyListeners();
  }
}
