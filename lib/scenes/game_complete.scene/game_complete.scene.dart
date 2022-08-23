import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rectanglo/models/level.dart';

import '../../objects/blockTile.dart';

class GameCompleteScene extends FlameGame {
  final Level level;
  final List<List<BlockTile>> matrixBlocks;

  double horizontalCenter = 0;
  double verticalCenter = 0;

  int widthBlock = 5;
  int heightBlock = 5;

  double objBlockWidth = 0;
  double objBlockHeight = 0;
  double boardWidth = 0;
  double boardHeight = 0;

  GameCompleteScene({
    required this.level,
    required this.matrixBlocks,
  });

  @override
  Future<void>? onLoad() {
    widthBlock = (level.difficulty + 1) * 5;
    heightBlock = (level.difficulty + 1) * 5;

    objBlockWidth = (size.x - (32 * 4)) / widthBlock;
    objBlockHeight = (size.x - (32 * 4)) / widthBlock;
    boardWidth = widthBlock * objBlockWidth;
    boardHeight = widthBlock * objBlockHeight;

    horizontalCenter = ((size.x - boardWidth) / 2);
    verticalCenter = ((size.y - boardHeight) / 2);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          horizontalCenter - 32 + 24,
          verticalCenter - 32 + 24,
          boardWidth + (12 / (level.difficulty + 1)),
          boardWidth + (12 / (level.difficulty + 1)),
        ),
        const Radius.circular(8),
      ),
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white,
    );

    for (int y = 0; y < matrixBlocks.length; y++) {
      for (int x = 0; x < matrixBlocks[y].length; x++) {
        BlockTile block = matrixBlocks[y][x];

        canvas.drawRect(
          Rect.fromLTWH(
            horizontalCenter + (x * (objBlockWidth - 1)),
            verticalCenter + (y * (objBlockHeight - 1)),
            objBlockWidth,
            objBlockHeight,
          ),
          Paint()
            ..style = PaintingStyle.fill
            ..color = block.state == 0 ? level.backgroundColor : block.color,
        );
      }
    }
    super.render(canvas);
  }
}
