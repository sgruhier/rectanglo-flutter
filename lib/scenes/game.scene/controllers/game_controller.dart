import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../config/themes.dart';
import '../../../models/level.dart';
import '../../../objects/blockTile.dart';
import '../../../objects/hint.dart';

class GameContoller extends GetxController {
  final List<double> fontSizes = [18, 16, 12];

  int widthBlock = 5;
  int heightBlock = 5;

  List<BlockTile> blocks = [];
  List<Color> colorStates = [];

  List<List<BlockTile>> matrixBlocks = [];
  List<List<Hint>> hintsVertical = [];
  List<List<Hint>> hintsHorizontal = [];

  int verticalHintCount = 0;
  int horizontalHintCount = 0;
  double horizontalCenter = 0;
  double verticalCenter = 0;

  double objBlockWidth = 0;
  double objBlockHeight = 0;
  double boardWidth = 0;
  double boardHeight = 0;

  int pointerType = 0;

  late TextPaint textPaint;
  late TextPaint textDonePaint;

  late Function(FlameGame game) onWrongMove;
  late Function(List<List<BlockTile>> matrixBlocks) onComplete;

  void initGameCallback({
    required Function(FlameGame game) onWrongMove,
    required Function(List<List<BlockTile>> matrixBlocks) onComplete,
  }) {
    this.onComplete = onComplete;
    this.onWrongMove = onWrongMove;
  }

  void loadGame({
    required Level level,
    required FlameGame game,
    required Size screenSize,
  }) {
    widthBlock = 5;
    heightBlock = 5;

    blocks = [];
    colorStates = [];

    matrixBlocks = [];
    hintsVertical = [];
    hintsHorizontal = [];

    verticalHintCount = 0;
    horizontalHintCount = 0;
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
    double fontSize = fontSizes[level.difficulty];
    print(fontSize);

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

    objBlockWidth =
        (game.size.x - (24 * 2)) / (widthBlock + horizontalHintCount);
    objBlockHeight =
        (game.size.x - (24 * 2)) / (widthBlock + verticalHintCount);
    boardWidth = (widthBlock + horizontalHintCount) * objBlockWidth;
    boardHeight = (widthBlock + verticalHintCount) * objBlockHeight;

    horizontalCenter = ((screenSize.width - boardWidth) / 2);
    verticalCenter = ((game.size.y - boardHeight) / 2);

    for (int y = 0; y < matrixBlocks.length; y++) {
      double horizontalHintSpace = (horizontalHintCount * objBlockWidth);
      double verticalHintSpace = (verticalHintCount * objBlockHeight);

      for (int x = 0; x < matrixBlocks[y].length; x++) {
        BlockTile currentBlock = matrixBlocks[y][x];

        BlockTile block = BlockTile(
          state: currentBlock.state,
          currentState: currentBlock.currentState,
          color: currentBlock.color,
          position: Vector2(
            horizontalCenter + (x * objBlockWidth) + horizontalHintSpace,
            verticalCenter + (y * objBlockHeight) + verticalHintSpace,
          ),
          size: Vector2(
            objBlockWidth,
            objBlockHeight,
          ),
          onTap: () {
            currentBlock.currentState = 1;
            checkHint(onComplete);
          },
          onWrongMove: () {
            if (!game.camera.shaking) {
              game.camera.shake(intensity: 1);
            }
            onWrongMove(game);
          },
        );
        game.add(block);
      }
    }
  }

  void loadLevel(Level level) async {
    widthBlock = (level.difficulty + 1) * 5;
    heightBlock = (level.difficulty + 1) * 5;

    for (BlockTile block in level.data) {
      block.currentState = 0;
      blocks.add(block);
    }

    generateHint();
  }

  void generateHint() {
    generateLevelMatrix();

    for (int y = 0; y < matrixBlocks.length; y++) {
      int num = 0;
      int start = 0;
      List<Hint> hint = [];
      for (int x = 0; x < matrixBlocks[y].length; x++) {
        BlockTile block = matrixBlocks[y][x];

        if (block.state == 1) {
          if (num == 0) {
            start = x;
          }
          num++;
          if (x == matrixBlocks[y].length - 1 && num > 0) {
            hint.add(
              Hint(count: num, done: false, pos: [
                for (int i = start; i <= x; i++) [i, y]
              ]),
            );
          }
        } else {
          if (num > 0) {
            hint.add(
              Hint(count: num, done: false, pos: [
                for (int i = start; i <= x - 1; i++) [i, y]
              ]),
            );
            num = 0;
          }
        }
      }
      hintsHorizontal.add(hint);
    }

    for (int x = 0; x < matrixBlocks[0].length; x++) {
      int num = 0;
      int start = 0;
      List<Hint> hint = [];
      for (int y = 0; y < matrixBlocks.length; y++) {
        BlockTile block = matrixBlocks[y][x];

        if (block.state == 1) {
          if (num == 0) {
            start = y;
          }
          num++;
          if (y == matrixBlocks[x].length - 1 && num > 0) {
            hint.add(
              Hint(count: num, done: false, pos: [
                for (int i = start; i <= y; i++) [x, i]
              ]),
            );
          }
        } else {
          if (num > 0) {
            hint.add(
              Hint(count: num, done: false, pos: [
                for (int i = start; i <= y - 1; i++) [x, i]
              ]),
            );
            num = 0;
          }
        }
      }
      hintsVertical.add(hint);
    }

    for (List<Hint> hint in hintsHorizontal) {
      if (hint.length > horizontalHintCount) {
        horizontalHintCount = hint.length;
      }
    }

    for (List<Hint> hint in hintsVertical) {
      if (hint.length > verticalHintCount) {
        verticalHintCount = hint.length;
      }
    }
  }

  void checkHint(Function(List<List<BlockTile>> matrixBlocks) onComplete) {
    for (List<Hint> hints in hintsVertical) {
      for (Hint hint in hints) {
        bool done = true;
        for (List<int> pos in hint.pos) {
          if (matrixBlocks[pos[1]][pos[0]].currentState == 0) {
            done = false;
          }
        }

        hint.done = done;
      }
    }

    for (List<Hint> hints in hintsHorizontal) {
      for (Hint hint in hints) {
        bool done = true;
        for (List<int> pos in hint.pos) {
          if (matrixBlocks[pos[1]][pos[0]].currentState == 0) {
            done = false;
          }
        }

        hint.done = done;
      }
    }

    bool verticalDone = hintsVertical
            .where((hints) => hints.where((hint) => !hint.done).isEmpty)
            .length ==
        hintsVertical.length;
    bool horizontalDone = hintsHorizontal
            .where((hints) => hints.where((hint) => !hint.done).isEmpty)
            .length ==
        hintsHorizontal.length;
    if (verticalDone && horizontalDone) onComplete(matrixBlocks);
  }

  void generateLevelMatrix() {
    matrixBlocks.clear();
    for (var i = 0; i < blocks.length; i += widthBlock) {
      matrixBlocks.add(blocks.sublist(i, i + widthBlock));
    }
  }

  double getTextWidth(String text) {
    return textPaint.measureTextWidth(text);
  }

  double getTextHeight(String text) {
    return textPaint.measureTextHeight(text);
  }
}
