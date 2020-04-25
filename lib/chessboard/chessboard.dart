import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

import 'chessboard_field.dart';
import 'promotion_exception.dart';

class Chessboard extends StatefulWidget {
  final double size;
  final Color whiteColor;
  final Color blackColor;
  final String initialFEN;
  final bool enableMoves;
  final bool disableMovesAfterMove;
  final chess.Color userSideColor;
  final Function(chess.Move move) onMove;
  final Function(chess.Color colorInCheck) onCheck;
  final Function() onDraw;

  final Function(chess.Color winnerColor) onCheckmate;

  Chessboard(
      {this.size = 200,
      this.whiteColor = Colors.white,
      this.blackColor = Colors.black54,
      this.initialFEN =
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      this.enableMoves = true,
      this.disableMovesAfterMove = false,
      this.userSideColor,
      @required this.onMove,
      @required this.onCheck,
      @required this.onDraw,
      @required this.onCheckmate});

  @override
  _ChessboardState createState() => _ChessboardState();
}

class _ChessboardState extends State<Chessboard> {
  chess.Chess game;
  chess.Color userSideColor;
  bool movesDisabled = false;
  List<String> highlightedFields = [];
  String selectedField;

  @override
  void initState() {
    game = chess.Chess.fromFEN(widget.initialFEN);
    if (game.in_check) widget.onCheck(game.turn);
    userSideColor = widget.userSideColor ?? game.turn;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        // Background of chess table to fill gaps between fields
        _background(),
        Table(
            defaultColumnWidth: FixedColumnWidth(widget.size * 0.125),
            children: _generateChessboardFields())
      ]),
    );
  }

  Container _background() {
    return Container(
      decoration: BoxDecoration(
          color: widget.whiteColor, borderRadius: BorderRadius.circular(6)),
      width: widget.size,
      height: widget.size,
    );
  }

  _generateChessboardFields() {
    List<TableRow> chessboardRows = [];

    for (int i = 0; i < 8; i++) {
      List<ChessboardField> chessboardFields = [];

      for (int j = 0; j < 8; j++) {
        String fieldName = _fieldIndexToString(j, i);
        chess.Piece piece = game.get(fieldName);

        chessboardFields.add(ChessboardField(
          color: (i + j).isOdd ? widget.whiteColor : widget.blackColor,
          size: widget.size / 8,
          fieldName: fieldName,
          piece: piece,
          highlighted: highlightedFields.contains(fieldName),
          selected: selectedField == fieldName,
          draggable:
              widget.enableMoves && !movesDisabled && game.turn == piece?.color,
          onDragStart: _onDragStart,
          onMove: _onMove,
          onDragEnd: _onDragEnd,
        ));
      }

      chessboardRows.add(TableRow(children: chessboardFields));
    }

    if (userSideColor == chess.Color.WHITE) {
      chessboardRows = chessboardRows.reversed.toList();
    }

    return chessboardRows;
  }

  String _fieldIndexToString(int j, int i) {
    return String.fromCharCode('a'.codeUnitAt(0) + j) + (i + 1).toString();
  }

  void _onDragStart(String field) {
    setState(() {
      _clearHighlights();
      _highlightMovesFrom(field);
    });
  }

  void _onDragEnd() {
    setState(() {
      _clearHighlights();
    });
  }

  void _onMove(Map move) {
    setState(() {
      _move(move);
    });
  }

  void _clearHighlights() {
    selectedField = null;
    highlightedFields.clear();
  }

  void _highlightMovesFrom(String field) {
    selectedField = field;

    List moves = game.moves({'asObjects': true});

    for (chess.Move move in moves) {
      if (move.fromAlgebraic == field) {
        highlightedFields.add(move.toAlgebraic);
      }
    }
  }

  void _move(Map move) {
    if (move['from'] == null) {
      move['from'] = selectedField;
    }

    chess.Piece pieceToMove = game.get(move['from']);

    if (move['promotion'] == null && _promotionRequired(move, pieceToMove)) {
      throw PromotionRequiredException(pieceToMove.color);
    }

    bool moveSuccessful = game.move(move);

    if (moveSuccessful) {
      if (widget.disableMovesAfterMove) this.movesDisabled = true;

      widget.onMove(game.history.last.move);

      if (game.in_check && !game.in_checkmate) {
        widget.onCheck(game.turn);
      }

      if (game.in_draw) {
        widget.onDraw();
        movesDisabled = true;
      }

      if (game.in_checkmate) {
        widget.onCheckmate(game.turn == chess.Color.WHITE
            ? chess.Color.BLACK
            : chess.Color.WHITE);
        movesDisabled = true;
      }
    }
  }

  bool _promotionRequired(Map move, chess.Piece chesspiece) =>
      chesspiece.type == chess.PieceType.PAWN &&
      ((move['to'][1] == '8') || (move['to'][1] == '1'));
}
