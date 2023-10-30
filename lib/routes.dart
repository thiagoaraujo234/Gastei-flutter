import 'package:gastei/views/cadastro.dart';
import 'package:gastei/views/home_screen.dart';
import 'package:gastei/views/login.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String perfil = '/perfil';

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case cadastro:
        return MaterialPageRoute(builder: (_) => CadastroPage());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }

  static String initialRoute = home;
}