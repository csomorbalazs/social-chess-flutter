import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:socialchess/services/auth.dart';
import 'package:socialchess/utils/platform_svg.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService _auth = AuthService();
  bool _enableButtons = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PlatformSvg.asset(
              'assets/chesspieces/w_p.svg',
              height: 200,
            ),
            Text(
              'Social Chess',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 220,
              child: GoogleSignInButton(
                darkMode: true,
                borderRadius: 10,
                onPressed: _enableButtons
                    ? () {
                        _auth.signInWithGoogle();
                        setState(() {
                          _enableButtons = false;
                        });
                      }
                    : null,
              ),
            ),
            Container(
              width: 220,
              child: OutlineButton(
                onPressed: _enableButtons
                    ? () {
                        _auth.signInAnon();
                        setState(() {
                          _enableButtons = false;
                        });
                      }
                    : null,
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white),
                highlightedBorderColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Play as guest',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
