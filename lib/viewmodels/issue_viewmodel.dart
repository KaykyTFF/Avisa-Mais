import 'package:flutter/foundation.dart';
import '../data/models/comment_model.dart';
import '../data/models/issue_model.dart';
import '../data/repositories/issue_repository.dart';

class IssueViewModel extends ChangeNotifier {
  static final IssueViewModel _instance = IssueViewModel._internal();
  factory IssueViewModel({IssueRepository? repository}) {
    if (repository != null) {
      _instance._repository = repository;
    }
    return _instance;
  }

  IssueViewModel._internal() : _repository = IssueRepository();

  IssueRepository _repository;
  String _searchQuery = '';
  bool _isLoading = false;

  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  int get totalCount => _repository.totalCount;

  List<IssueModel> get issues => _repository.getIssues(query: _searchQuery);

  IssueModel? getIssue(String id) => _repository.getIssueById(id);

  List<CommentModel> getComments(String issueId) =>
      _repository.getComments(issueId);

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addIssue(IssueModel issue) {
    _repository.addIssue(issue);
    notifyListeners();
  }

  void toggleUpvote(String id) {
    _repository.toggleUpvote(id);
    notifyListeners();
  }

  void toggleDownvote(String id) {
    _repository.toggleDownvote(id);
    notifyListeners();
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
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoading = false;
    notifyListeners();
  }
}
