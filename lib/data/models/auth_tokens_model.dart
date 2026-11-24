/// Credenciais de sessão armazenadas de forma segura no dispositivo.
class AuthTokensModel {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().toUtc().isAfter(expiresAt!.toUtc());
  }

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'accessToken': final String accessToken,
        'refreshToken': final String refreshToken,
      }
          when accessToken.isNotEmpty && refreshToken.isNotEmpty =>
        AuthTokensModel(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresAt: json['expiresAt'] is String
              ? DateTime.tryParse(json['expiresAt'] as String)
              : null,
        ),
      _ => throw const FormatException('Invalid AuthTokens JSON format.'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      if (expiresAt != null) 'expiresAt': expiresAt!.toUtc().toIso8601String(),
    };
  }

  /// Redige valores sensíveis para impedir vazamento acidental em logs.
  @override
  String toString() =>
      'AuthTokensModel(accessToken: [REDACTED], refreshToken: [REDACTED], expiresAt: $expiresAt)';
}
