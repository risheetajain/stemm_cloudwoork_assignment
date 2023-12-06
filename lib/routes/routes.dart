import 'package:flutter/material.dart';
import 'package:stemm_cloudwoork_assignment/routes/routes_constant.dart';
import 'package:stemm_cloudwoork_assignment/screens/home_page.dart';
import 'package:stemm_cloudwoork_assignment/screens/spalsh.dart';

import '../screens/login.dart';

class RoutersPath {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments != null ? settings.arguments as Map : {};

    switch (settings.name) {
      case RoutesConstant.loginScreen:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const LoginScreen(
            isLogin: true,
          );
        });
      case "/":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const SplashScreen();
        });
      case RoutesConstant.signUpScreen:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const LoginScreen(
            isLogin: false,
          );
        });
      case RoutesConstant.homeScreen:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const MyHomePage();
        });
      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const SplashScreen();
        });
    }
  }
}
