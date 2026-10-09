class CommentModel {
  final String id;
  final String userName;
  final String userRole;
  final String content;
  final DateTime createdAt;
  final bool isOfficial;

  const CommentModel({
    required this.id,
    required this.userName,
    this.userRole = 'Aluno',
    required this.content,
    required this.createdAt,
    this.isOfficial = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'userName': String userName,
        'content': String content,
      } =>
        CommentModel(
          id: id,
          userName: userName,
          userRole: json['userRole'] as String? ?? 'Aluno',
          content: content,
          createdAt: json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
              : DateTime.now(),
          isOfficial: json['isOfficial'] as bool? ?? false,
        ),
      _ => throw const FormatException('Invalid Comment JSON format.'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userRole': userRole,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isOfficial': isOfficial,
    };
  }
}
