import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:socialchess/screens/wrapper.dart';
import 'package:socialchess/services/auth.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>.value(
      initialData: null,
      value: AuthService().isLoggedIn,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social Chess',
        theme: ThemeData(
            primaryColor: Color.fromRGBO(118, 150, 86, 1),
            accentColor: Color.fromRGBO(238, 238, 210, 1),
            backgroundColor: Colors.white),
        home: Wrapper(),
      ),
    );
  }
}
