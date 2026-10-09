class UserModel {
  final String id;
  final String name;
  final String email;
  final String matricula;
  final String campus;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.matricula,
    required this.campus,
    this.avatarUrl,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? matricula,
    String? campus,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      matricula: matricula ?? this.matricula,
      campus: campus ?? this.campus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'email': String email,
        'matricula': String matricula,
        'campus': String campus,
      } =>
        UserModel(
          id: id,
          name: name,
          email: email,
          matricula: matricula,
          campus: campus,
          avatarUrl: json['avatarUrl'] as String?,
        ),
      _ => throw const FormatException('Invalid User JSON format.'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'matricula': matricula,
      'campus': campus,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }
}
