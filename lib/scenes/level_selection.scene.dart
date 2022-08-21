import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/data/controller/level_controller.dart';
import 'package:widget_helper/widget_helper.dart';

import '../components/item_level.dart';
import '../components/ripple_button.dart';
import '../data/controller/player_controller.dart';
import '../models/level.dart';
import '../utils/nav_helper.dart';
import 'game.scene.dart';

class LevelSelectionScene extends StatefulWidget {
  const LevelSelectionScene({Key? key}) : super(key: key);

  @override
  State<LevelSelectionScene> createState() => _LevelSelectionSceneState();
}

class _LevelSelectionSceneState extends State<LevelSelectionScene> {
  final PlayerController playerController = Get.put(PlayerController());
  final LevelController levelController = Get.put(LevelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.primary,
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 441 : MediaQuery.of(context).size.width,
          child: Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RippleButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(6),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 8.0 / 11,
                  ),
                  itemCount: levelController.levels.length,
                  itemBuilder: (context, index) {
                    Level level = levelController.levels[index];

                    return ItemLevel(
                      level: level,
                      onTap: () {
                        playerController.pointer.value = PenTool.mark;
                        NavHelper.navigatePush(
                          context,
                          GameScreen(level: level),
                        );
                      },
                    );
                  },
                ).addExpanded,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
