import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/models/level.dart';

import '../../../config/themes.dart';
import '../../../data/controller/player_controller.dart';
import '../../../objects/blockTile.dart';

class CreateLevelController extends GetxController {
  PlayerController playerController = Get.put(PlayerController());

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
  late Function(List<List<BlockTile>>) onChangeMatrix;

  void initCallback({
    required Function(List<List<BlockTile>>) onChangeMatrix,
  }) {
    this.onChangeMatrix = onChangeMatrix;
  }

  void loadGame({
    required FlameGame game,
    required Level level,
    required Size screenSize,
  }) {
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

    for (Component component in game.children) {
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
    loadLevel(level);

    objBlockWidth = (game.size.x - (24 * 2)) / widthBlock;
    objBlockHeight = (game.size.x - (24 * 2)) / widthBlock;
    boardWidth = widthBlock * objBlockWidth;
    boardHeight = widthBlock * objBlockHeight;

    horizontalCenter = ((screenSize.width - boardWidth) / 2);
    verticalCenter = ((game.size.y - boardHeight) / 2) - 100;

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
            if (!game.camera.shaking) {
              game.camera.shake(intensity: 1);
            }
          },
        );
        game.add(block);
      }
    }
  }

  double getTextWidth(String text) {
    return textPaint.measureTextWidth(text);
  }

  double getTextHeight(String text) {
    return textPaint.measureTextHeight(text);
  }

  void loadLevel(Level level) async {
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

  void drawBoardBorder({
    required Level level,
    required Canvas canvas,
  }) {
    final double _boardWidth = widthBlock * objBlockWidth;
    final double _boardHeight = heightBlock * objBlockHeight;

    switch (level.difficulty) {
      case 0:
        canvas.drawRect(
          Rect.fromLTWH(
            horizontalCenter,
            verticalCenter,
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
                horizontalCenter + (x * segmentWidth),
                verticalCenter + (y * segmentHeight),
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
                horizontalCenter + (x * segmentWidth),
                verticalCenter + (y * segmentHeight),
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
