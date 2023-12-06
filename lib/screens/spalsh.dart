import 'package:flutter/material.dart';
import 'package:stemm_cloudwoork_assignment/api/shared_preferences.dart';
import 'package:stemm_cloudwoork_assignment/routes/routes_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SharedPref.getLoginStatus().then((value) {
      if (value) {
        Navigator.of(context).pushReplacementNamed(RoutesConstant.homeScreen);
      } else {
        Navigator.of(context).pushReplacementNamed(RoutesConstant.signUpScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: FlutterLogo());
  }
}
