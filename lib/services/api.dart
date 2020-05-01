import 'dart:io';
import 'package:chess/chess.dart' as chess;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:socialchess/models/game_dto.dart';
import 'package:socialchess/services/auth.dart';

class Api {
  static const String API_BASE_URL = 'social-chess.herokuapp.com';
  static AuthService _authService = AuthService();

  static Future<GameDto> getRandomGame() async {
    String playerId = (await _authService.getCurrentUser()).uid;
    String token = (await _authService.getCurrentUserIdToken()).token;

    final response = await http.get(
      Uri.https(API_BASE_URL, '/game', {"player": playerId}),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return GameDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load game');
    }
  }

  static Future<bool> makeMove(String gameId, chess.Move move) async {
    String playerId = (await _authService.getCurrentUser()).uid;
    String token = (await _authService.getCurrentUserIdToken()).token;

    Map<String, String> queryParameters = {
      "game": gameId,
      "player": playerId,
      "from": move.fromAlgebraic,
      "to": move.toAlgebraic
    };

    if (move.promotion != null) {
      queryParameters["promotion"] = move.promotion.name;
    }

    var response = await http.post(
      Uri.https(API_BASE_URL, '/move', queryParameters),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
