/// Rotas versionadas da `avisa-mais-api` (`/api/v1/...`).
///
/// Todas as chamadas HTTP do aplicativo devem referenciar estas constantes
/// em vez de concatenar strings manualmente em telas ou repositórios.
abstract final class ApiEndpoints {
  static const String apiPrefix = '/api/v1';

  // Health
  static const String healthLive = '$apiPrefix/health/live';
  static const String healthReady = '$apiPrefix/health/ready';

  // Auth
  static const String authRegister = '$apiPrefix/auth/register';
  static const String authVerifyOtp = '$apiPrefix/auth/otp/verify';
  static const String authResendOtp = '$apiPrefix/auth/otp/resend';
  static const String authLogin = '$apiPrefix/auth/login';
  static const String authRefresh = '$apiPrefix/auth/refresh';
  static const String authLogout = '$apiPrefix/auth/logout';
  static const String authForgotPassword = '$apiPrefix/auth/password/forgot';
  static const String authResetPassword = '$apiPrefix/auth/password/reset';

  // Users
  static const String currentUser = '$apiPrefix/users/me';

  // Campuses & Sectors
  static const String campuses = '$apiPrefix/campuses';
  static String campusSectors(String campusId) =>
      '$apiPrefix/campuses/$campusId/sectors';

  // Issues, Votes & Comments
  static const String issues = '$apiPrefix/issues';
  static String issueById(String issueId) => '$apiPrefix/issues/$issueId';
  static String issueStatus(String issueId) =>
      '$apiPrefix/issues/$issueId/status';
  static String issueVotes(String issueId) =>
      '$apiPrefix/issues/$issueId/votes';
  static String issueComments(String issueId) =>
      '$apiPrefix/issues/$issueId/comments';
}
