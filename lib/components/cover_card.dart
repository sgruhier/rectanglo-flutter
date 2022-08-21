import 'package:flutter/material.dart';
import 'package:rectanglo/models/level.dart';

import '../objects/blockTile.dart';

class CoverCard extends CustomPainter {
  final Level level;

  int widthBlock = 5;
  int heightBlock = 5;

  double objBlockWidth = 0;
  double objBlockHeight = 0;
  List<List<BlockTile>> matrixBlocks = [];
  List<BlockTile> blocks = [];

  List<double> blockSize = [20, 10, 6.66666667];

  CoverCard({
    required this.level,
  }) {
    loadLevel();
  }

  void generateLevelMatrix() {
    matrixBlocks.clear();
    for (var i = 0; i < blocks.length; i += widthBlock) {
      matrixBlocks.add(blocks.sublist(i, i + widthBlock));
    }
  }

  void loadLevel() async {
    widthBlock = (level.difficulty + 1) * 5;
    heightBlock = (level.difficulty + 1) * 5;

    for (BlockTile block in level.data) {
      block.currentState = 0;
      blocks.add(block);
    }
    generateLevelMatrix();

    objBlockWidth = blockSize[level.difficulty].toDouble();
    objBlockHeight = blockSize[level.difficulty].toDouble();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      const Rect.fromLTWH(
        0,
        0,
        100,
        100,
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
            x * objBlockWidth,
            y * objBlockHeight,
            objBlockWidth,
            objBlockHeight,
          ),
          Paint()
            ..style = PaintingStyle.fill
            ..color = block.state == 0 ? level.backgroundColor : block.color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}
