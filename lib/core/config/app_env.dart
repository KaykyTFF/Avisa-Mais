/// Ambientes suportados pelo aplicativo Avisa Mais (A+ IFPI).
enum AppEnvironment { development, staging, production }

/// Configuração de ambiente do aplicativo Avisa Mais (A+ IFPI).
///
/// Os valores são fornecidos em tempo de build/execução via `--dart-define`:
/// ```bash
/// flutter run --dart-define=APP_ENV=development --dart-define=API_BASE_URL=http://10.0.2.2:3000
/// flutter run --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=https://staging-api.avisamais.ifpi.edu.br
/// flutter run --dart-define=APP_ENV=production --dart-define=API_BASE_URL=https://api.avisamais.ifpi.edu.br
/// ```
abstract final class AppEnv {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const int requestTimeoutSeconds = int.fromEnvironment(
    'REQUEST_TIMEOUT_SECONDS',
    defaultValue: 15,
  );

  static AppEnvironment get environment => parseEnvironment(appEnv);
  static bool get isDevelopment => environment == AppEnvironment.development;
  static bool get isStaging => environment == AppEnvironment.staging;
  static bool get isProduction => environment == AppEnvironment.production;

  static Duration get requestTimeout =>
      const Duration(seconds: requestTimeoutSeconds);

  /// Converte a string de ambiente com fallback seguro para `development`.
  static AppEnvironment parseEnvironment(String rawEnv) {
    return switch (rawEnv.trim().toLowerCase()) {
      'production' || 'prod' => AppEnvironment.production,
      'staging' || 'homolog' || 'homologacao' => AppEnvironment.staging,
      _ => AppEnvironment.development,
    };
  }

  /// Normaliza a base removendo barras finais duplicadas.
  static String normalizeBaseUrl(String rawUrl) {
    return rawUrl.trim().replaceAll(RegExp(r'/+$'), '');
  }

  /// Valida as configurações obrigatórias de ambiente.
  ///
  /// Lança [StateError] em caso de URL ausente/inválida, protocolo inseguro em
  /// produção ou timeout não positivo.
  static void validate({
    String? envOverride,
    String? baseUrlOverride,
    int? timeoutSecondsOverride,
  }) {
    final resolvedEnv = parseEnvironment(envOverride ?? appEnv);
    final rawBaseUrl = normalizeBaseUrl(baseUrlOverride ?? apiBaseUrl);
    final timeout = timeoutSecondsOverride ?? requestTimeoutSeconds;

    if (rawBaseUrl.isEmpty) {
      throw StateError('API_BASE_URL must not be empty.');
    }

    final uri = Uri.tryParse(rawBaseUrl);
    final validScheme = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;

    if (!validScheme) {
      throw StateError('API_BASE_URL must be a valid HTTP/HTTPS URL.');
    }

    if (resolvedEnv == AppEnvironment.production && uri.scheme != 'https') {
      throw StateError('API_BASE_URL must use HTTPS in production.');
    }

    if (timeout <= 0) {
      throw StateError('REQUEST_TIMEOUT_SECONDS must be greater than zero.');
    }
  }

  /// Constrói a URI completa combinando `apiBaseUrl` com um caminho versionado.
  static Uri buildUri(
    String path, {
    String? baseUrlOverride,
    Map<String, String>? queryParameters,
  }) {
    final base = normalizeBaseUrl(baseUrlOverride ?? apiBaseUrl);
    validate(
      envOverride: baseUrlOverride != null ? 'development' : null,
      baseUrlOverride: base,
    );
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$base$normalizedPath');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: queryParameters);
  }
}
