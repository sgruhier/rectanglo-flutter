// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String name;
  String email;
  String avatar;
  int exp;
  int playtime;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.exp,
    required this.playtime,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        exp: json["exp"],
        playtime: json["playtime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "exp": exp,
        "playtime": playtime,
      };
}
