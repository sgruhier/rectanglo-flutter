import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/data/controller/player_controller.dart';
import 'package:rectanglo/models/level.dart';
import 'package:rectanglo/scenes/create_level.scene/controllers/create_level_controller.dart';

import '../../data/controller/assets_controller.dart';
import '../../objects/blockTile.dart';

class LevelEditor extends FlameGame with HasTappables, HasDraggables {
  final AssetsController assetsController = Get.put(AssetsController());
  final PlayerController playerController = Get.put(PlayerController());
  final CreateLevelController controller = Get.put(CreateLevelController());

  final Level level;
  final Size screenSize;

  LevelEditor({
    required this.screenSize,
    required this.level,
  });

  @override
  Vector2 get size => Vector2(441, 882);

  @override
  void handleDragUpdate(int pointerId, DragUpdateDetails details) {
    for (Component component in children) {
      if (component is BlockTile) {
        if (details.globalPosition.dx > component.position.x &&
            details.globalPosition.dy > component.position.y &&
            details.globalPosition.dx <
                component.position.x + component.size.x &&
            details.globalPosition.dy <
                component.position.y + component.size.y) {
          component.tapBlockTile();
        }
      }
    }
    super.handleDragUpdate(pointerId, details);
  }

  @override
  Future<void>? onLoad() {
    controller.loadGame(
      game: this,
      level: level,
      screenSize: screenSize,
    );
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        controller.horizontalCenter,
        controller.verticalCenter,
        controller.widthBlock * controller.objBlockWidth,
        controller.heightBlock * controller.objBlockHeight,
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black,
    );
    controller.drawBoardBorder(
      level: level,
      canvas: canvas,
    );
    super.render(canvas);
  }
}
