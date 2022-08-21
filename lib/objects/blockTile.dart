import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart' as img;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rectanglo/data/controller/assets_controller.dart';
import 'package:rectanglo/data/controller/player_controller.dart';
import 'package:rectanglo/r.dart';

class BlockTile extends PositionComponent with Tappable {
  final PlayerController playerController = Get.put(PlayerController());
  final AssetsController assetsController = Get.put(AssetsController());
  final Paint blockPaint = Paint();
  VoidCallback? onTap;
  VoidCallback? onWrongMove;

  img.Image? image;
  Sprite? block;
  int state;
  int currentState;
  Color color;

  double scaleSize = 0.0;
  double trigger = 0;

  void loadImage() async {
    image = await Flame.images.load(AssetImages.cross.split("/").last);
    if (image != null) {
      block = Sprite(image!);
    }
  }

  BlockTile({
    required this.state,
    required this.currentState,
    required this.color,
    this.onWrongMove,
    this.onTap,
    super.size,
    super.position,
  }) {
    loadImage();
    blockPaint.style = PaintingStyle.fill;
  }

  BlockTile copyWith() => this;

  void tapBlockTile() {
    if (currentState == 0) {
      if (state == 1) {
        assetsController.playPositiveTap();
      } else {
        assetsController.playNegativeTap();
        if (onWrongMove != null) onWrongMove!();
      }
    }

    currentState = 1;
    trigger = 0.2;

    if (onTap != null) onTap!();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    tapBlockTile();

    return true;
  }

  @override
  void render(Canvas canvas) {
    scaleSize += trigger;
    if (scaleSize >= 1) {
      trigger = 0;
      scaleSize = 1;
    }

    if (currentState == 1 && state == 1) {
      blockPaint.color = color;
    } else {
      blockPaint.color = Colors.transparent;
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      blockPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black.withOpacity(0.1),
    );

    if (block != null && currentState == 1 && state == 0) {
      block!.renderRect(
          canvas,
          Rect.fromCenter(
            center: Offset(size.x / 2, size.y / 2),
            width: (size.x * 0.6) * (scaleSize / 1),
            height: (size.y * 0.6) * (scaleSize / 1),
          ));
    }
  }

  factory BlockTile.fromJson(Map<String, dynamic> json) => BlockTile(
        state: json["state"],
        currentState: json["currentState"],
        color: Color.fromRGBO(
          json["color"][0],
          json["color"][1],
          json["color"][2],
          json["color"][3] is int
              ? (json["color"][3] as int).toDouble()
              : json["color"][3],
        ),
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "currentState": currentState,
        "color": [
          color.red,
          color.green,
          color.blue,
          color.opacity,
        ],
      };
}
