import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/data/controller/player_controller.dart';
import 'package:rectanglo/models/level.dart';

import '../../data/controller/assets_controller.dart';
import '../../objects/blockTile.dart';

class LevelEditor extends FlameGame with HasTappables, HasDraggables {
  final AssetsController assetsController = Get.put(AssetsController());
  final PlayerController playerController = Get.put(PlayerController());
  final Level level;
  final Size screenSize;
  final Function(List<List<BlockTile>>) onChangeMatrix;

  int widthBlock = 5;
  int heightBlock = 5;

  List<BlockTile> blocks = [];
  List<Color> colorStates = [];

  List<List<BlockTile>> matrixBlocks = [];

  double horizontalCenter = 0;
  double verticalCenter = 0;

  double objBlockWidth = 0;
  double objBlockHeight = 0;
  double boardWidth = 0;
  double boardHeight = 0;

  int pointerType = 0;

  late TextPaint textPaint;
  late TextPaint textDonePaint;

  LevelEditor({
    required this.screenSize,
    required this.level,
    required this.onChangeMatrix,
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

  void loadGame() {
    widthBlock = 5;
    heightBlock = 5;

    blocks = [];
    colorStates = [];

    matrixBlocks = [];

    horizontalCenter = 0;
    verticalCenter = 0;

    objBlockWidth = 0;
    objBlockHeight = 0;
    boardWidth = 0;
    boardHeight = 0;

    pointerType = 0;

    for (Component component in children) {
      component.removeFromParent();
    }
    double fontSize = (3 - level.difficulty) / 3 * 24;

    if (fontSize >= 24) fontSize = 18;

    textPaint = TextPaint(
      style: Themes().black18!.copyWith(
            fontSize: fontSize,
          ),
    );

    textDonePaint = TextPaint(
      style: Themes().blackBold18!.copyWith(
            color: Themes.red,
            fontSize: fontSize,
          ),
    );

    colorStates.add(Themes.primary.withOpacity(0));
    colorStates.add(Themes.primary);
    colorStates.add(Themes.red);
    colorStates.add(Themes.primary.withOpacity(0));
    loadLevel();

    objBlockWidth = (size.x - (24 * 2)) / widthBlock;
    objBlockHeight = (size.x - (24 * 2)) / widthBlock;
    boardWidth = widthBlock * objBlockWidth;
    boardHeight = widthBlock * objBlockHeight;

    horizontalCenter = ((screenSize.width - boardWidth) / 2);
    verticalCenter = ((size.y - boardHeight) / 2) - 100;

    for (int y = 0; y < matrixBlocks.length; y++) {
      for (int x = 0; x < matrixBlocks[y].length; x++) {
        BlockTile currentBlock = matrixBlocks[y][x];

        BlockTile block = BlockTile(
          state: currentBlock.state,
          currentState: currentBlock.currentState,
          color: currentBlock.color,
          editMode: currentBlock.editMode,
          position: Vector2(
            horizontalCenter + (x * objBlockWidth),
            verticalCenter + (y * objBlockHeight),
          ),
          size: Vector2(
            objBlockWidth,
            objBlockHeight,
          ),
          onTap: () {
            switch (playerController.pointer.value) {
              case PenTool.mark:
                currentBlock.state = 1;
                currentBlock.color = playerController.selectedColor.value;
                break;
              case PenTool.delete:
                currentBlock.state = 0;
                currentBlock.color = Colors.white;
                break;
            }
            onChangeMatrix(matrixBlocks);
          },
          onWrongMove: () {
            if (!camera.shaking) {
              camera.shake(intensity: 1);
            }
          },
        );
        add(block);
      }
    }
  }

  @override
  Future<void>? onLoad() {
    loadGame();
    return super.onLoad();
  }

  double getTextWidth(String text) {
    return textPaint.measureTextWidth(text);
  }

  double getTextHeight(String text) {
    return textPaint.measureTextHeight(text);
  }

  void loadLevel() async {
    widthBlock = (level.difficulty + 1) * 5;
    heightBlock = (level.difficulty + 1) * 5;

    for (BlockTile block in level.data) {
      block.currentState = 0;
      blocks.add(block);
    }

    generateLevelMatrix();
  }

  void generateLevelMatrix() {
    matrixBlocks.clear();
    for (var i = 0; i < blocks.length; i += widthBlock) {
      matrixBlocks.add(blocks.sublist(i, i + widthBlock));
    }
    onChangeMatrix(matrixBlocks);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        horizontalCenter,
        verticalCenter,
        widthBlock * objBlockWidth,
        heightBlock * objBlockHeight,
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black,
    );
    super.render(canvas);
  }
}
