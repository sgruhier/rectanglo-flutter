import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:rectanglo/models/user.dart';

import '../objects/blockTile.dart';

Level levelFromJson(String str) => Level.fromJson(json.decode(str));

String levelToJson(Level data) => json.encode(data.toJson());

class Level {
  String id;
  int difficulty;
  List<BlockTile> data;
  User creator;
  int playersCount;
  double rate;
  String description;
  List<Player> players;
  Color backgroundColor;

  Level({
    required this.id,
    required this.difficulty,
    required this.data,
    required this.creator,
    required this.playersCount,
    required this.rate,
    required this.description,
    required this.players,
    required this.backgroundColor,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        difficulty: json["difficulty"],
        data: List<BlockTile>.from(
            json["data"].map((x) => BlockTile.fromJson(x))),
        creator: User.fromJson(json["creator"]),
        playersCount: json["playersCount"],
        rate: json["rate"] is int ? json["rate"].toDouble() : json["rate"],
        description: json["description"],
        players: List<Player>.from(
          json["players"].map((x) => Player.fromJson(x)),
        ),
        backgroundColor: Color.fromRGBO(
          json["backgroundColor"][0],
          json["backgroundColor"][1],
          json["backgroundColor"][2],
          json["backgroundColor"][3].toDouble(),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "difficulty": difficulty,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "creator": creator.toJson(),
        "playersCount": playersCount,
        "rate": rate,
        "description": description,
        "players": List<dynamic>.from(players.map((x) => x.toJson())),
        "backgroundColor": [
          backgroundColor.red,
          backgroundColor.green,
          backgroundColor.blue,
          backgroundColor.opacity.toDouble(),
        ],
      };
}

class Player {
  int rate;
  int points;
  int time;
  User user;

  Player({
    required this.rate,
    required this.points,
    required this.time,
    required this.user,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        rate: json["rate"],
        points: json["points"],
        time: json["time"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "points": points,
        "time": time,
        "user": user.toJson(),
      };
}
