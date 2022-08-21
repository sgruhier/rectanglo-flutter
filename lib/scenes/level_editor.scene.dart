import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/components/flat_card.dart';
import 'package:rectanglo/components/pop_button.dart';
import 'package:rectanglo/components/ripple_button.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/data/controller/level_controller.dart';
import 'package:rectanglo/data/controller/player_controller.dart';
import 'package:rectanglo/models/level.dart';
import 'package:rectanglo/scenes/level_selection.scene.dart';
import 'package:rectanglo/utils/nav_helper.dart';
import 'package:widget_helper/widget_helper.dart';

import '../components/question_dialog.dart';
import '../data/controller/assets_controller.dart';
import '../objects/blockTile.dart';
import '../utils/tools.dart';

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

class LevelEditorScreen extends StatefulWidget {
  final Level level;

  const LevelEditorScreen({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  State<LevelEditorScreen> createState() => _LevelEditorScreenState();
}

class _LevelEditorScreenState extends State<LevelEditorScreen>
    with TickerProviderStateMixin {
  final AssetsController assetsController = Get.put(AssetsController());
  final PlayerController playerController = Get.put(PlayerController());
  final LevelController levelController = Get.put(LevelController());

  List<List<BlockTile>> maxtrix = [];

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
              game: LevelEditor(
                screenSize: MediaQuery.of(context).size,
                level: widget.level,
                onChangeMatrix: (blockMatrix) {
                  maxtrix = blockMatrix;
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
                        RippleButton(
                          onTap: () {
                            showPublishDialog();
                          },
                          child: const Icon(
                            Icons.save_rounded,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Themes.colors.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                          ),
                          itemBuilder: (context, index) {
                            return PopButton(
                              onTap: () {
                                playerController.pointer.value = PenTool.mark;
                                playerController.selectedColor.value =
                                    Themes.colors[index];
                              },
                              radius: 4,
                              color: Themes.colors[index],
                              border: Border.all(
                                color: Themes.black,
                                width: 1,
                              ),
                            ).addAllMargin(4);
                          },
                        ),
                      ),
                      Obx(
                        () => FlatCard(
                          width: (MediaQuery.of(context).size.height * 0.1) - 8,
                          height:
                              (MediaQuery.of(context).size.height * 0.1) - 8,
                          color: playerController.selectedColor.value,
                          border: Border.all(
                            color: Themes.black,
                            width: 1,
                          ),
                        ).addMarginLeft(8),
                      ),
                    ],
                  ).addMarginBottom(24),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PopButton(
                          radius: 4,
                          color: playerController.pointer.value == PenTool.mark
                              ? Themes.primary
                              : Themes.white,
                          border: Border.all(
                            color: Themes.black,
                            width: 1,
                          ),
                          onTap: () {
                            playerController.pointer.value = PenTool.mark;
                          },
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Themes.black,
                            size: 24,
                          ),
                        ),
                        Container(width: 12),
                        PopButton(
                          radius: 4,
                          color:
                              playerController.pointer.value == PenTool.delete
                                  ? Themes.primary
                                  : Themes.white,
                          border: Border.all(
                            color: Themes.black,
                            width: 1,
                          ),
                          onTap: () {
                            playerController.pointer.value = PenTool.delete;
                          },
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Themes.black,
                            size: 24,
                          ),
                        ),
                      ],
                    ).addMarginBottom(24),
                  ),
                ],
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
        title: "Exit Editor",
        message: "Are you sure want exit? your data will not be saved",
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

  void showPublishDialog() {
    Tools.showCustomDialog(
      context,
      dismissable: false,
      child: QuestionDialog(
        title: "Publish Level",
        message: "Are you sure want publish this level?",
        positiveText: "Save",
        negativeText: "Cancel",
        onConfirm: () {
          Navigator.pop(context);
          List<BlockTile> data = [];
          for (List<BlockTile> tiles in maxtrix) {
            for (BlockTile tile in tiles) {
              tile.currentState = 0;
              data.add(tile);
            }
          }

          String id =
              levelController.firebaseFirestore.collection('levels').doc().id;
          widget.level.data = data;
          widget.level.id = id;

          levelController.firebaseFirestore
              .collection('levels')
              .add(
                widget.level.toJson(),
              )
              .whenComplete(() {
            Tools.showToast(text: "Level published");
            NavHelper.navigateReplace(
              context,
              const LevelSelectionScene(),
            );
          });
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
