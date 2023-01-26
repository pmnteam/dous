import 'package:flutter/material.dart';
//
import 'package:dous/pages/login_home.dart';
import 'package:dous/pages/create_user.dart';
import 'package:dous/pages/dous.dart';

class RouteHandler {
  static const loginPage = '/';
  static const createUser = '/create_user';
  static const doUs = '/doUs';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: ((context) => const Login()),
        );
      case doUs:
        return MaterialPageRoute(
          builder: ((context) => const DoUs()),
        );
      case createUser:
        return MaterialPageRoute(
          builder: ((context) => const CreateUserPage()),
        );
      default:
        throw const FormatException('Route not found!');
    }
  }
}
