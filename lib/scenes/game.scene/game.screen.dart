import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/scenes/game.scene/controllers/game_controller.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../components/question_dialog.dart';
import '../../components/ripple_button.dart';
import '../../config/themes.dart';
import '../../data/controller/assets_controller.dart';
import '../../models/level.dart';
import '../../utils/nav_helper.dart';
import '../../utils/tools.dart';
import '../game_complete.scene/game_complete.screen.dart';
import 'game.scene.dart';

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
  final GameContoller gameContoller = Get.put(GameContoller());

  @override
  void initState() {
    super.initState();
    gameContoller.initGameCallback(
      onWrongMove: (game) {
        move.value--;
        if (move.value == 0) {
          showLoseDialog(game);
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
    );
  }

  void showLoseDialog(FlameGame game) {
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
          gameContoller.loadGame(
            game: game,
            level: widget.level,
            screenSize: MediaQuery.of(context).size,
          );
        },
        onCancel: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
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
