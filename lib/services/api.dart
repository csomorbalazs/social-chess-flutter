import 'package:chess/chess.dart' as chess;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:socialchess/models/game_dto.dart';

class Api {
  static const String API_BASE_URL = 'social-chess.herokuapp.com';

  static Future<GameDto> getRandomGame(String playerId) async {
    final response = await http
        .get(Uri.https(API_BASE_URL, '/game', {"player": "$playerId"}));

    if (response.statusCode == 200) {
      return GameDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load game');
    }
  }

  static Future<bool> makeMove(
      String gameId, String playerId, chess.Move move) async {
    Map<String, String> queryParameters = {
      "game": gameId,
      "player": playerId,
      "from": move.fromAlgebraic,
      "to": move.toAlgebraic
    };

    if (move.promotion != null) {
      queryParameters["promotion"] = move.promotion.name;
    }

    var response =
        await http.post(Uri.https(API_BASE_URL, '/move', queryParameters));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
