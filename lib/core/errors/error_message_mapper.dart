import 'app_exception.dart';

/// Converte [AppException] em mensagens amigáveis para exibição na interface.
///
/// Garante que stack traces, erros técnicos internos ou informações sensíveis
/// nunca sejam expostos diretamente ao usuário final.
abstract final class ErrorMessageMapper {
  static String toUserMessage(AppException exception) {
    if (exception.isValidationError && exception.details.isNotEmpty) {
      return exception.details.first;
    }

    return switch (exception.code) {
      'NETWORK_ERROR' =>
        'Sem conexão com o servidor. Verifique sua internet e tente novamente.',
      'REQUEST_TIMEOUT' =>
        'A operação demorou mais que o esperado. Tente novamente em instantes.',
      'SESSION_EXPIRED' => 'Sua sessão expirou. Faça login novamente.',
      'INVALID_CREDENTIALS' => 'E-mail ou senha inválidos.',
      'UNAUTHORIZED' => 'Autenticação necessária. Faça login para continuar.',
      'FORBIDDEN' || 'INSUFFICIENT_PERMISSIONS' =>
        'Você não tem permissão para realizar esta ação.',
      'RESOURCE_NOT_FOUND' || 'NOT_FOUND' =>
        'O conteúdo solicitado não foi encontrado.',
      'RESOURCE_CONFLICT' || 'CONFLICT' =>
        'Já existe um registro com os dados informados.',
      'TOO_MANY_REQUESTS' =>
        'Muitas tentativas seguidas. Aguarde alguns instantes e tente novamente.',
      'SECURE_STORAGE_ERROR' =>
        'Não foi possível acessar as credenciais seguras do dispositivo.',
      'VALIDATION_ERROR' || 'BAD_REQUEST' =>
        'Verifique os dados informados e tente novamente.',
      'DEPENDENCY_UNAVAILABLE' || 'SERVICE_UNAVAILABLE' =>
        'O serviço está temporariamente indisponível. Tente novamente em breve.',
      _ => _fallbackByStatusCode(exception.statusCode),
    };
  }

  static String _fallbackByStatusCode(int statusCode) {
    if (statusCode == 401) {
      return 'Sua sessão não é válida. Faça login novamente.';
    }
    if (statusCode == 403) {
      return 'Você não tem permissão para realizar esta ação.';
    }
    if (statusCode == 404) {
      return 'O conteúdo solicitado não foi encontrado.';
    }
    if (statusCode == 409) {
      return 'Já existe um registro com os dados informados.';
    }
    if (statusCode == 429) {
      return 'Muitas tentativas seguidas. Aguarde alguns instantes e tente novamente.';
    }
    if (statusCode >= 500) {
      return 'Ocorreu um erro inesperado no servidor. Tente novamente mais tarde.';
    }
    return 'Não foi possível concluir a operação. Tente novamente.';
  }
}
