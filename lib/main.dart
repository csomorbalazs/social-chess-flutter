import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chess/chess.dart' as chess;
import 'package:flushbar/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chessboard/chessboard.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Chess',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(118, 150, 86, 1),
          accentColor: Color.fromRGBO(238, 238, 210, 1),
          backgroundColor: Colors.white),
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Flushbar topFlushbar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Chess',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print('AppBar IconButton pressed');
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
            child: Chessboard(
              size: MediaQuery.of(context).size.shortestSide * 0.9,
              whiteColor: Theme.of(context).accentColor,
              blackColor: Theme.of(context).primaryColor,
              onMove: (chess.Move move) {
                print(
                    "${move.fromAlgebraic} ${move.toAlgebraic} ${move.promotion}");
              },
              onCheck: (chess.Color colorInCheck) {
                topFlushbar?.dismiss();
                topFlushbar = createTopFlushbar(FontAwesomeIcons.check,
                    "CHECK!", "Outstanding move!", Colors.blue[300]);
                topFlushbar.show(context);
              },
              onDraw: () {
                topFlushbar?.dismiss();
                topFlushbar = createTopFlushbar(
                    FontAwesomeIcons.solidFlag,
                    "DRAW!",
                    "This game is a draw. Well played!",
                    Theme.of(context).primaryColor);
                topFlushbar.show(context);
              },
              onCheckmate: (chess.Color winnerColor) {
                topFlushbar?.dismiss();
                topFlushbar = createTopFlushbar(
                    FontAwesomeIcons.trophy,
                    "CHECKMATE!",
                    "You won this game. Well played!",
                    Colors.amber);
                topFlushbar.show(context);
              },
            ),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.5))
            ])),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 25,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        unselectedFontSize: 18,
        selectedFontSize: 18,
        onTap: (selected) {},
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            title: Text(
              'GAMES',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.play_arrow,
            ),
            title: Text(
              'NEXT',
            ),
          ),
        ],
      ),
    );
  }

  Flushbar createTopFlushbar(
      IconData icon, String title, String message, Color backgroundColor,
      [Duration duration]) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      titleText: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: FaIcon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
      shouldIconPulse: false,
      backgroundColor: backgroundColor,
      duration: duration,
      animationDuration: Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.bounceIn,
      reverseAnimationCurve: Curves.linear,
    );
  }
}
