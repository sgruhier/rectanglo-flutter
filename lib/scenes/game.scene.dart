import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/components/ripple_button.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/models/level.dart';
import 'package:rectanglo/scenes/game_complete.scene.dart';
import 'package:rectanglo/utils/nav_helper.dart';
import 'package:widget_helper/widget_helper.dart';

import '../components/question_dialog.dart';
import '../data/controller/assets_controller.dart';
import '../objects/blockTile.dart';
import '../objects/hint.dart';
import '../utils/tools.dart';

class GameScene extends FlameGame with HasTappables, HasDraggables {
  final AssetsController assetsController = Get.put(AssetsController());
  final Level level;
  final Function(FlameGame game) onWrongMove;
  final Function(List<List<BlockTile>> matrixBlocks) onComplete;
  final Size screenSize;

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

  GameScene({
    required this.screenSize,
    required this.level,
    required this.onWrongMove,
    required this.onComplete,
  });

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

  void loadGame() {
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

    objBlockWidth = (size.x - (24 * 2)) / (widthBlock + horizontalHintCount);
    objBlockHeight = (size.x - (24 * 2)) / (widthBlock + verticalHintCount);
    boardWidth = (widthBlock + horizontalHintCount) * objBlockWidth;
    boardHeight = (widthBlock + verticalHintCount) * objBlockHeight;

    horizontalCenter = ((screenSize.width - boardWidth) / 2);
    verticalCenter = ((size.y - boardHeight) / 2);

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
            checkHint();
          },
          onWrongMove: () {
            if (!camera.shaking) {
              camera.shake(intensity: 1);
            }
            onWrongMove(this);
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

  @override
  void render(Canvas canvas) {
    for (int y = 0; y < hintsVertical.length; y++) {
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
        double textWidth = getTextWidth(text);
        double textHeight = getTextHeight(text);

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
        double textWidth = getTextWidth(text);
        double textHeight = getTextHeight(text);

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

    canvas.drawRect(
      Rect.fromLTWH(
        horizontalCenter + (horizontalHintCount * objBlockWidth),
        verticalCenter + (verticalHintCount * objBlockHeight),
        widthBlock * objBlockWidth,
        heightBlock * objBlockHeight,
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black,
    );

    super.render(canvas);
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

  void checkHint() {
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
}

class GameScreen extends StatefulWidget {
  final Level level;

  const GameScreen({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final RxInt move = 3.obs;
  final AssetsController assetsController = Get.put(AssetsController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showExitDialog();
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              backgroundBuilder: (context) => Stack(
                children: [
                  Container(
                    color: Colors.white,
                  ),
                  if (!kIsWeb)
                    Transform.scale(
                      scale: 1.2,
                      child: AnimatedBackground(
                        behaviour: RandomParticleBehaviour(
                          options: const ParticleOptions(
                            opacityChangeRate: 1,
                            baseColor: Themes.primary,
                            particleCount: 8,
                            spawnMaxSpeed: 40,
                            spawnMinSpeed: 30,
                            spawnMaxRadius: 40,
                            spawnMinRadius: 10,
                            minOpacity: 0.1,
                            maxOpacity: 0.2,
                          ),
                        ),
                        vsync: this,
                        child: Container(),
                      ),
                    ),
                  if (!kIsWeb)
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10.0,
                        sigmaY: 10.0,
                      ),
                      child: Container(),
                    )
                ],
              ),
              game: GameScene(
                screenSize: MediaQuery.of(context).size,
                level: widget.level,
                onWrongMove: (game) {
                  move.value--;
                  if (move.value == 0) {
                    assetsController.playLose();
                    Tools.showCustomDialog(
                      context,
                      dismissable: false,
                      child: QuestionDialog(
                        title: "Game Over",
                        message: "You out of moves",
                        positiveText: "Start Over",
                        negativeText: "Exit",
                        onConfirm: () {
                          Navigator.pop(context);
                          move.value = 3;
                          (game as GameScene).loadGame();
                        },
                        onCancel: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                },
                onComplete: (matrix) {
                  NavHelper.navigateReplace(
                    context,
                    GameCompleteScreen(
                      level: widget.level,
                      matrixBlocks: matrix,
                    ),
                  );
                },
              ),
            ),
            Center(
              child: SizedBox(
                width: kIsWeb ? 441 : MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RippleButton(
                          onTap: () {
                            showExitDialog();
                          },
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            size: 32,
                          ),
                        ),
                        Obx(
                          () => Row(
                            children:
                                List.generate(3, (index) => index).map((e) {
                              return Icon(
                                Icons.favorite_rounded,
                                size: 24,
                                color:
                                    move.value > e ? Themes.red : Colors.grey,
                              );
                            }).toList(),
                          ).addMarginRight(12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showExitDialog() {
    Tools.showCustomDialog(
      context,
      dismissable: false,
      child: QuestionDialog(
        title: "End Session",
        message: "Are you sure want to end this session?",
        positiveText: "Exit",
        negativeText: "Cancel",
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
