import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/scenes/create_level.scene/controllers/create_level_controller.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../components/pop_button.dart';
import '../../components/question_dialog.dart';
import '../../components/ripple_button.dart';
import '../../config/themes.dart';
import '../../data/controller/assets_controller.dart';
import '../../data/controller/level_controller.dart';
import '../../data/controller/player_controller.dart';
import '../../models/level.dart';
import '../../objects/blockTile.dart';
import '../../utils/nav_helper.dart';
import '../../utils/tools.dart';
import '../level_selection.scene/level_selection.scene.dart';
import 'level_editor.scene.dart';

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
  final CreateLevelController createLevelController = Get.put(
    CreateLevelController(),
  );

  List<List<BlockTile>> maxtrix = [];

  @override
  void initState() {
    super.initState();
    createLevelController.initCallback(
      onChangeMatrix: (blockMatrix) {
        maxtrix = blockMatrix;
      },
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
              game: LevelEditor(
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
                  SizedBox(
                    width: kIsWeb
                        ? (441 * 0.6)
                        : MediaQuery.of(context).size.width * 0.6,
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
                        Container(width: 12),
                        PopButton(
                          radius: 4,
                          border: Border.all(
                            color: Themes.black,
                            width: 1,
                          ),
                          color: playerController.selectedColor.value,
                          onTap: () {},
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.transparent,
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
              .doc(id)
              .set(
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
