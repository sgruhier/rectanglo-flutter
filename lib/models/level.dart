import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../objects/blockTile.dart';

Level levelFromJson(String str) => Level.fromJson(json.decode(str));

String levelToJson(Level data) => json.encode(data.toJson());

class Level {
  String id;
  int difficulty;
  List<BlockTile> data;
  String creatorName;
  int playersCount;
  double rate;
  String description;
  Color backgroundColor;

  Level({
    required this.id,
    required this.difficulty,
    required this.data,
    required this.creatorName,
    required this.playersCount,
    required this.rate,
    required this.description,
    required this.backgroundColor,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        difficulty: json["difficulty"],
        data: List<BlockTile>.from(
            json["data"].map((x) => BlockTile.fromJson(x))),
        creatorName: json["creatorName"],
        playersCount: json["playersCount"],
        rate: json["rate"] is int ? json["rate"].toDouble() : json["rate"],
        description: json["description"],
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
        "creatorName": creatorName,
        "playersCount": playersCount,
        "rate": rate,
        "description": description,
        "backgroundColor": [
          backgroundColor.red,
          backgroundColor.green,
          backgroundColor.blue,
          backgroundColor.opacity.toDouble(),
        ],
      };
}
