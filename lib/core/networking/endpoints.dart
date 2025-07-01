class Endpoints {
  static String get baseUrl => 'https://aura.laravel.cloud/api/';
  static String authAccount({required String provideName}) {
    return 'https://aura.laravel.cloud/$provideName/redirect';
  }

  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String deleteAccount = 'user';
  static const String updateProfile = 'user';
  static const String getProfile = 'user';
}
