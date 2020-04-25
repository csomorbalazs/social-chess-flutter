import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chess/chess.dart' as chess;
import 'package:flushbar/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:socialchess/widgets/chessboard/chessboard.dart';
import 'package:socialchess/models/game_dto.dart';
import 'package:socialchess/services/api.dart';
import 'package:socialchess/models/next_button_state.dart';

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
  static const String PLAYER_ID = 'player2';

  Future<GameDto> _game;

  NextButtonState _nextButtonState = NextButtonState.disabled;
  Flushbar _topFlushbar;

  @override
  void initState() {
    _game = Api.getRandomGame(PLAYER_ID);

    super.initState();
  }

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
        child: FutureBuilder<GameDto>(
            future: _game,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return _buildChessboard(
                    context, snapshot.data.id, snapshot.data.fen);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                );
              }
            }),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildChessboard(BuildContext context, String gameId, String fen) {
    return Container(
      child: Chessboard(
        size: MediaQuery.of(context).size.shortestSide * 0.9,
        whiteColor: Theme.of(context).accentColor,
        blackColor: Theme.of(context).primaryColor,
        initialFEN: fen,
        disableMovesAfterMove: true,
        onMove: (chess.Move move) {
          print("${move.fromAlgebraic} ${move.toAlgebraic} ${move.promotion}");

          setState(() {
            _nextButtonState = NextButtonState.loading;
          });

          Api.makeMove(gameId, PLAYER_ID, move).then((result) => {
                setState(() {
                  _nextButtonState = result
                      ? NextButtonState.enabled
                      : NextButtonState.disabled;
                })
              });
        },
        onCheck: (chess.Color colorInCheck) {
          _topFlushbar?.dismiss();
          _topFlushbar = createTopFlushbar(FontAwesomeIcons.check, "CHECK!",
              "Outstanding move!", Colors.blue[300]);
          _topFlushbar.show(context);
        },
        onDraw: () {
          _topFlushbar?.dismiss();
          _topFlushbar = createTopFlushbar(
              FontAwesomeIcons.solidFlag,
              "DRAW!",
              "This game is a draw. Well played!",
              Theme.of(context).primaryColor);
          _topFlushbar.show(context);
        },
        onCheckmate: (chess.Color winnerColor) {
          _topFlushbar?.dismiss();
          _topFlushbar = createTopFlushbar(FontAwesomeIcons.trophy,
              "CHECKMATE!", "You won this game. Well played!", Colors.amber);
          _topFlushbar.show(context);
        },
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            spreadRadius: 0,
            blurRadius: 10,
            color: Colors.black.withOpacity(0.5))
      ]),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      iconSize: 25,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      unselectedFontSize: 18,
      selectedFontSize: 18,
      onTap: (selected) {
        switch (selected) {
          case 0:
            break;
          case 1:
            if (_nextButtonState != NextButtonState.enabled) return;

            setState(() {
              _nextButtonState = NextButtonState.disabled;
              _game = Api.getRandomGame(PLAYER_ID);
            });
            break;
        }
      },
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
          icon: AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            reverseDuration: Duration(milliseconds: 10),
            child: _buildNextIcon(),
          ),
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            reverseDuration: Duration(milliseconds: 10),
            child: _buildNextTitle(),
          ),
        ),
      ],
    );
  }

  Widget _buildNextIcon() {
    return Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      key: _nextButtonState != NextButtonState.loading
          ? Key('enabled')
          : Key('loading'),
      child: _nextButtonState != NextButtonState.loading
          ? Icon(
              Icons.play_arrow,
              size: 25,
              color: _nextButtonState == NextButtonState.enabled
                  ? Colors.white
                  : Colors.white30,
            )
          : Padding(
              padding: const EdgeInsets.all(3),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white30),
                strokeWidth: 3,
              ),
            ),
    );
  }

  Widget _buildNextTitle() {
    return Text(
      'NEXT',
      key: _nextButtonState == NextButtonState.enabled
          ? Key('enabled')
          : Key('disabled'),
      style: TextStyle(
        color: _nextButtonState == NextButtonState.enabled
            ? Colors.white
            : Colors.white30,
      ),
    );
  }
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
