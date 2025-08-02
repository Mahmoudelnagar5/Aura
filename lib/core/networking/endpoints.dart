class Endpoints {
  static String get baseUrl => 'https://aura.laravel.cloud/api/';
  static String authAccount({required String provideName}) {
    // يجب أن يكون المسار مطابق لمسار Laravel
    return 'https://aura.laravel.cloud/$provideName/redirect';
  }

  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String deleteAccount = 'user';
  static const String updateProfile = 'user';
  static const String emailVerify = 'email/verify';
  static const String emailResend = 'email/resend';
  static const String getProfile = 'user';
  static const String documents = 'documents';
}
