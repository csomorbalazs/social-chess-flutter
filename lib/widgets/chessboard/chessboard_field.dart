import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chess/chess.dart' as chess;

import 'chesspiece.dart';
import 'promotion_exception.dart';

class ChessboardField extends StatefulWidget {
  final Color color;
  final double size;
  final String fieldName;
  final chess.Piece piece;
  final bool highlighted;
  final bool selected;
  final bool draggable;
  final void Function(String field) onDragStart;
  final void Function() onDragEnd;
  final void Function(Map move) onMove;

  ChessboardField(
      {this.color,
      this.size,
      this.fieldName,
      this.piece,
      this.highlighted,
      this.selected,
      this.draggable,
      this.onDragStart,
      this.onMove,
      this.onDragEnd});

  @override
  _ChessboardFieldState createState() => _ChessboardFieldState();
}

class _ChessboardFieldState extends State<ChessboardField> {
  _ChessboardFieldState();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ChessboardFieldBackground(
            color: widget.color,
            highlighted: widget.highlighted,
            selected: widget.selected,
            size: widget.size,
          ),
          widget.piece != null ? _chesspieceDraggable() : Container(),
          widget.highlighted ? _dragTarget(context) : Container()
        ],
      ),
    );
  }

  void _onTap() {
    if (widget.piece != null && !widget.draggable && !widget.highlighted)
      return;

    if (widget.piece != null && !widget.selected && !widget.highlighted) {
      widget.onDragStart(widget.fieldName);
    } else if (widget.highlighted) {
      Map move = {'to': widget.fieldName};

      _makeMove(move, context);

      widget.onDragEnd();
    } else {
      widget.onDragEnd();
    }
  }

  Widget _chesspieceDraggable() {
    return Draggable<String>(
      maxSimultaneousDrags: widget.draggable ? 1 : 0,
      data: widget.fieldName,
      onDragStarted: () {
        widget.onDragStart(widget.fieldName);
      },
      onDraggableCanceled: (_, __) {
        widget.onDragEnd();
      },
      onDragCompleted: () {
        widget.onDragEnd();
      },
      child: _chesspieceWidget(),
      childWhenDragging: Container(),
      feedback: Transform.scale(
        scale: 1.3,
        child: _chesspieceWidget(),
      ),
    );
  }

  DragTarget<String> _dragTarget(BuildContext context) {
    return DragTarget<String>(onAccept: (String from) {
      Map move = {'from': from, 'to': widget.fieldName};

      _makeMove(move, context);
    }, onWillAccept: (String from) {
      return widget.highlighted;
    }, builder: (context, accept, deny) {
      return Container(
        color: Colors.transparent,
        width: widget.size,
        height: widget.size,
      );
    });
  }

  void _makeMove(Map move, BuildContext context) {
    try {
      widget.onMove(move);
    } on PromotionRequiredException catch (e) {
      _promotionDialog(context, e.color).then((String promoteTo) {
        move['promotion'] = promoteTo;
        widget.onMove(move);
      });
    }
  }

  Widget _chesspieceWidget() {
    assert(widget.piece != null);
    return Chesspiece(
      color: widget.piece.color,
      type: widget.piece.type,
      size: widget.size,
    );
  }

  Future<String> _promotionDialog(
      BuildContext context, chess.Color pieceColor) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Choose promotion'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _chesspieceInkwell(context, pieceColor, chess.PieceType.QUEEN),
              _chesspieceInkwell(context, pieceColor, chess.PieceType.ROOK),
              _chesspieceInkwell(context, pieceColor, chess.PieceType.BISHOP),
              _chesspieceInkwell(context, pieceColor, chess.PieceType.KNIGHT),
            ],
          ),
        );
      },
    ).then((value) {
      return value;
    });
  }

  InkWell _chesspieceInkwell(
      BuildContext context, chess.Color pieceColor, chess.PieceType type) {
    return InkWell(
      child: Chesspiece(color: pieceColor, type: type),
      onTap: () {
        Navigator.of(context).pop(type.toString());
      },
    );
  }
}

class ChessboardFieldBackground extends StatelessWidget {
  final double size;
  final Color color;
  final bool highlighted;
  final bool selected;

  const ChessboardFieldBackground(
      {this.size, this.color, this.highlighted, this.selected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildBackground(),
        _buildHighlight(),
      ],
    );
  }

  Container _buildBackground() {
    return Container(
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: selected
            ? Color.alphaBlend(Color.fromRGBO(246, 246, 130, 0.8), this.color)
            : this.color,
      ),
    );
  }

  Container _buildHighlight() {
    return highlighted
        ? Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(10, 10, 10, 0.3), shape: BoxShape.circle),
            height: size * 0.6,
            width: size * 0.6,
          )
        : Container();
  }
}
