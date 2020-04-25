import 'package:flutter/widgets.dart';
import 'package:socialchess/utils/platform_svg.dart';
import 'package:chess/chess.dart' as chess;

class Chesspiece extends StatelessWidget {
  final chess.Color color;
  final chess.PieceType type;
  final double size;

  const Chesspiece({this.color, this.type, this.size});

  @override
  Widget build(BuildContext context) {
    return PlatformSvg.asset(
      'assets/chesspieces/' + color.toString() + '_' + type.name + '.svg',
      width: size,
      height: size,
    );
  }
}
