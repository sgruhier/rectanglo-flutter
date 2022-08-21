import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/components/cover_card.dart';
import 'package:rectanglo/components/flat_card.dart';
import 'package:rectanglo/components/pop_button.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/data/controller/level_controller.dart';
import 'package:widget_helper/widget_helper.dart';

import '../models/level.dart';

class ItemLevel extends StatelessWidget {
  final Level level;
  final List<Color> levelColor = [
    Themes.green,
    Themes.primary,
    Themes.red,
  ];
  final List<String> alpha = ["E", "N", "H"];
  final List<String> levelDifficulty = ["Easy", "Normal", "Hard"];
  final VoidCallback onTap;
  final LevelController levelController = Get.put(LevelController());

  ItemLevel({
    super.key,
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopButton(
      radius: 10,
      enableShadow: true,
      padding: const EdgeInsets.all(4),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      onTap: onTap,
      child: Obx(
        () => Column(
          children: [
            if (levelController.finishedLevel.contains(level.id))
              FlatCard(
                color: level.backgroundColor,
                child: Center(
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: CoverCard(level: level),
                  ),
                ),
              ).addExpanded
            else
              FlatCard(
                width: double.infinity,
                color: levelColor[level.difficulty],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alpha[level.difficulty],
                      style: Themes().whiteBold32,
                    ),
                    Text(
                      levelDifficulty[level.difficulty],
                      style: Themes().whiteBold14,
                    ),
                  ],
                ),
              ).addExpanded,
            Row(
              children: [
                Text(
                  level.description,
                  style: Themes().blackBold16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).addFlexible,
              ],
            ).addAllMargin(4),
            Row(
              children: [
                const Icon(
                  Icons.gamepad_rounded,
                  size: 16,
                  color: Themes.primary,
                ),
                Text(
                  level.playersCount.toString(),
                  style: Themes().black16,
                ).addMarginLeft(4),
                const Icon(
                  Icons.person_rounded,
                  size: 16,
                  color: Themes.primary,
                ).addMarginLeft(12),
                Text(
                  level.creatorName,
                  style: Themes().black16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).addMarginLeft(4).addFlexible,
              ],
            ).addAllMargin(4),
          ],
        ),
      ),
    ).addAllPadding(12);
  }
}
