import 'package:chess/chess.dart' as chess;

class PromotionRequiredException implements Exception {
  chess.Color color;

  PromotionRequiredException(this.color);
}
