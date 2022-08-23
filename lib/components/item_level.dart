import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rectanglo/components/cover_card.dart';
import 'package:rectanglo/components/flat_card.dart';
import 'package:rectanglo/components/pop_button.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/data/controller/level_controller.dart';
import 'package:widget_helper/widget_helper.dart';

import '../models/level.dart';

class ItemLevel extends StatefulWidget {
  final Level level;
  final VoidCallback onTap;

  ItemLevel({
    super.key,
    required this.level,
    required this.onTap,
  });

  @override
  State<ItemLevel> createState() => _ItemLevelState();
}

class _ItemLevelState extends State<ItemLevel>
    with SingleTickerProviderStateMixin {
  late AnimationController itemAnimation = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );
  final List<Color> levelColor = [
    Themes.green,
    Themes.primary,
    Themes.red,
  ];

  final List<String> alpha = ["E", "N", "H"];

  final List<String> levelDifficulty = ["Easy", "Normal", "Hard"];

  final LevelController levelController = Get.put(LevelController());

  @override
  Widget build(BuildContext context) {
    return PopButton(
      radius: 10,
      enableShadow: true,
      padding: const EdgeInsets.all(4),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      onTap: widget.onTap,
      child: Obx(
        () => Column(
          children: [
            if (levelController.finishedLevel.contains(widget.level.id))
              FlatCard(
                color: widget.level.backgroundColor,
                child: Center(
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: CoverCard(level: widget.level),
                  ),
                ),
              ).addExpanded
            else
              FlatCard(
                width: double.infinity,
                color: levelColor[widget.level.difficulty],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alpha[widget.level.difficulty],
                      style: Themes().whiteBold32,
                    ),
                    Text(
                      levelDifficulty[widget.level.difficulty],
                      style: Themes().whiteBold14,
                    ),
                  ],
                ),
              ).addExpanded,
            Row(
              children: [
                Text(
                  widget.level.description,
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
                  widget.level.playersCount.toString(),
                  style: Themes().black16,
                ).addMarginLeft(4),
                const Icon(
                  Icons.person_rounded,
                  size: 16,
                  color: Themes.primary,
                ).addMarginLeft(12),
                Text(
                  widget.level.creatorName,
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
