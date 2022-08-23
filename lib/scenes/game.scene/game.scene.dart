import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/models/level.dart';
import 'package:rectanglo/scenes/game.scene/controllers/game_controller.dart';

import '../../data/controller/assets_controller.dart';
import '../../objects/blockTile.dart';
import '../../objects/hint.dart';

class GameScene extends FlameGame with HasTappables, HasDraggables {
  final AssetsController assetsController = Get.put(AssetsController());
  final GameContoller controller = Get.put(GameContoller());

  final Level level;
  final Size screenSize;

  GameScene({
    required this.screenSize,
    required this.level,
  });

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
  Vector2 get size {
    if (screenSize.width > screenSize.height) {
      return Vector2(441, 882);
    } else {
      if (screenSize.width < 441) {
        return Vector2(screenSize.width, 882);
      } else {
        return Vector2(441, 882);
      }
    }
  }

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
  void render(Canvas canvas) {
    var horizontalHintCount = controller.horizontalHintCount;
    var verticalHintCount = controller.verticalHintCount;

    var objBlockWidth = controller.objBlockWidth;
    var objBlockHeight = controller.objBlockHeight;
    var horizontalCenter = controller.horizontalCenter;
    var verticalCenter = controller.verticalCenter;
    var textDonePaint = controller.textDonePaint;
    var textPaint = controller.textPaint;

    var hintsVertical = controller.hintsVertical;
    var hintsHorizontal = controller.hintsHorizontal;

    for (int y = 0; y < controller.hintsVertical.length; y++) {
      double horizontalHintSpace = (horizontalHintCount * objBlockWidth);
      double verticalHintSpace = (verticalHintCount - 1) * objBlockHeight;

      bool rowDone = hintsVertical[y].where((element) => !element.done).isEmpty;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            horizontalCenter + horizontalHintSpace + (y * objBlockWidth) + 1,
            verticalCenter,
            objBlockWidth - 2,
            verticalHintCount * (objBlockHeight),
          ),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Themes.primary.withOpacity(rowDone ? 0.4 : 0.2),
      );

      for (int x = 0; x < hintsVertical[y].length; x++) {
        Hint hint = hintsVertical[y][hintsVertical[y].length - 1 - x];
        String text = hint.count.toString();
        double textWidth = controller.getTextWidth(text);
        double textHeight = controller.getTextHeight(text);

        (hint.done ? textDonePaint : textPaint).render(
          canvas,
          text,
          Vector2(
            horizontalCenter +
                horizontalHintSpace +
                (y * objBlockWidth) +
                ((objBlockWidth - textWidth) / 2),
            verticalCenter +
                verticalHintSpace -
                ((x * objBlockHeight)) +
                ((objBlockHeight - textHeight) / 2),
          ),
        );
      }
    }

    for (int y = 0; y < hintsHorizontal.length; y++) {
      double horizontalHintSpace = ((horizontalHintCount - 1) * objBlockWidth);
      double verticalHintSpace = (verticalHintCount * objBlockHeight);

      bool rowDone =
          hintsHorizontal[y].where((element) => !element.done).isEmpty;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            horizontalCenter,
            verticalCenter + verticalHintSpace + (y * objBlockHeight) + 1,
            horizontalHintCount * objBlockWidth,
            objBlockHeight - 2,
          ),
          topLeft: const Radius.circular(4),
          bottomLeft: const Radius.circular(4),
        ),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Themes.primary.withOpacity(rowDone ? 0.4 : 0.2),
      );

      for (int x = 0; x < hintsHorizontal[y].length; x++) {
        Hint hint = hintsHorizontal[y][hintsHorizontal[y].length - 1 - x];
        String text = hint.count.toString();
        double textWidth = controller.getTextWidth(text);
        double textHeight = controller.getTextHeight(text);

        (hint.done ? textDonePaint : textPaint).render(
          canvas,
          text,
          Vector2(
            horizontalCenter +
                horizontalHintSpace -
                (x * objBlockWidth) +
                ((objBlockWidth - textWidth) / 2),
            verticalCenter +
                verticalHintSpace +
                (y * objBlockHeight) +
                ((objBlockHeight - textHeight) / 2),
          ),
        );
      }
    }

    drawBoardBorder(canvas);

    super.render(canvas);
  }

  void drawBoardBorder(Canvas canvas) {
    var horizontalCenter = controller.horizontalCenter;
    var verticalCenter = controller.verticalCenter;

    var objBlockWidth = controller.objBlockWidth;
    var objBlockHeight = controller.objBlockHeight;

    var horizontalHintCount = controller.horizontalHintCount;
    var verticalHintCount = controller.verticalHintCount;

    var widthBlock = controller.widthBlock;
    var heightBlock = controller.heightBlock;

    final double _boardPosX =
        horizontalCenter + (horizontalHintCount * objBlockWidth);
    final double _boardPosY =
        verticalCenter + (verticalHintCount * objBlockHeight);
    final double _boardWidth = widthBlock * objBlockWidth;
    final double _boardHeight = heightBlock * objBlockHeight;

    switch (level.difficulty) {
      case 0:
        canvas.drawRect(
          Rect.fromLTWH(
            _boardPosX,
            _boardPosY,
            _boardWidth,
            _boardHeight,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.black
            ..strokeWidth = 1,
        );
        break;
      case 1:
        double segmentWidth = _boardWidth / 2;
        double segmentHeight = _boardHeight / 2;

        for (int y = 0; y < 2; y++) {
          for (int x = 0; x < 2; x++) {
            canvas.drawRect(
              Rect.fromLTWH(
                _boardPosX + (x * segmentWidth),
                _boardPosY + (y * segmentHeight),
                segmentWidth,
                segmentHeight,
              ),
              Paint()
                ..style = PaintingStyle.stroke
                ..color = Colors.black
                ..strokeWidth = 1,
            );
          }
        }
        break;
      case 2:
        double segmentWidth = _boardWidth / 3;
        double segmentHeight = _boardHeight / 3;

        for (int y = 0; y < 3; y++) {
          for (int x = 0; x < 3; x++) {
            canvas.drawRect(
              Rect.fromLTWH(
                _boardPosX + (x * segmentWidth),
                _boardPosY + (y * segmentHeight),
                segmentWidth,
                segmentHeight,
              ),
              Paint()
                ..style = PaintingStyle.stroke
                ..color = Colors.black
                ..strokeWidth = 1,
            );
          }
        }
        break;
    }
  }
}
