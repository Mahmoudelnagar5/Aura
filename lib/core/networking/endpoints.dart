import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  // static const String githubSignInUrl =
  //     'https://aura.laravel.cloud/github/redirect';
  static String authAccount({required String provideName}) {
    return 'https://aura.laravel.cloud/$provideName/redirect';
  }

  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';
}
