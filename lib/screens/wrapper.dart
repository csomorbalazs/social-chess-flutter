import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:socialchess/screens/authenticate/login_page.dart';
import 'package:socialchess/screens/gameplay/game_page.dart';
import 'package:socialchess/screens/splash_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<bool>(context);

    if (isLoggedIn == null) {
      return SplashScreen();
    } else if (!isLoggedIn) {
      return LoginPage();
    } else {
      return GamePage();
    }
  }
}
