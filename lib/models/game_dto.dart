class GameDto {
  String id;
  String fen;

  GameDto({this.id, this.fen});

  GameDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fen = json['gameFEN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gameFEN'] = this.fen;
    return data;
  }
}
