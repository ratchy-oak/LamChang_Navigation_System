import 'package:application/pages/login_page.dart';
import 'package:application/pages/register_page.dart';

class AppRoutes {
  static final pages = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
  };

  static const login = '/';
  static const register = '/register';
}
