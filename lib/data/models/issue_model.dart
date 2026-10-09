class IssueModel {
  final String id;
  final String title;
  final String location;
  final String status;
  final int upvotes;
  final int downvotes;
  final bool userUpvoted;
  final bool userDownvoted;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;

  const IssueModel({
    required this.id,
    required this.title,
    required this.location,
    required this.status,
    required this.upvotes,
    required this.downvotes,
    this.userUpvoted = false,
    this.userDownvoted = false,
    this.description,
    this.imageUrl,
    this.createdAt,
  });

  int get score => upvotes - downvotes;

  IssueModel copyWith({
    String? id,
    String? title,
    String? location,
    String? status,
    int? upvotes,
    int? downvotes,
    bool? userUpvoted,
    bool? userDownvoted,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return IssueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      status: status ?? this.status,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      userUpvoted: userUpvoted ?? this.userUpvoted,
      userDownvoted: userDownvoted ?? this.userDownvoted,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'title': String title,
        'location': String location,
        'status': String status,
        'upvotes': int upvotes,
        'downvotes': int downvotes,
      } =>
        IssueModel(
          id: id,
          title: title,
          location: location,
          status: status,
          upvotes: upvotes,
          downvotes: downvotes,
          userUpvoted: json['userUpvoted'] as bool? ?? false,
          userDownvoted: json['userDownvoted'] as bool? ?? false,
          description: json['description'] as String?,
          imageUrl: json['imageUrl'] as String?,
          createdAt: json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'] as String)
              : null,
        ),
      _ => throw const FormatException('Invalid Issue JSON format.'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'status': status,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'userUpvoted': userUpvoted,
      'userDownvoted': userDownvoted,
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
