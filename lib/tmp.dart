import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chess/chess.dart' as chess;

import 'widgets/chessboard/chessboard.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Chess',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(118, 150, 86, 1),
          accentColor: Color.fromRGBO(238, 238, 210, 1),
          backgroundColor: Colors.white),
      home: GamePage(),
    );
  }
}

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 10,
                            color: Random().nextBool()
                                ? Colors.red
                                : Colors.green)),
                    child: Chessboard(
                      size: MediaQuery.of(context).size.shortestSide * 0.6,
                      enableMoves: false,
                      onMove: (chess.Move move) {
                        print(
                            "${move.fromAlgebraic} ${move.toAlgebraic} ${move.promotion}");
                      },
                      onGiveCheck: (chess.Color colorInCheck) {
                        print("$colorInCheck is in check");
                      },
                      onReceiveCheck: (colorInCheck) {},
                      onDraw: () {
                        print("draw");
                      },
                      onCheckmate: (chess.Color winnerColor) {
                        print("$winnerColor won the game");
                      },
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
