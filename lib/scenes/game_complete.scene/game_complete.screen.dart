import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../components/pop_button.dart';
import '../../components/ripple_button.dart';
import '../../config/themes.dart';
import '../../data/controller/assets_controller.dart';
import '../../data/controller/level_controller.dart';
import '../../models/level.dart';
import '../../objects/blockTile.dart';
import '../../r.dart';
import 'game_complete.scene.dart';

class GameCompleteScreen extends StatefulWidget {
  final Level level;
  final List<List<BlockTile>> matrixBlocks;

  const GameCompleteScreen({
    Key? key,
    required this.level,
    required this.matrixBlocks,
  }) : super(key: key);

  @override
  State<GameCompleteScreen> createState() => _GameCompleteScreenState();
}

class _GameCompleteScreenState extends State<GameCompleteScreen>
    with SingleTickerProviderStateMixin {
  final AssetsController assetsController = Get.put(AssetsController());
  final LevelController levelController = Get.put(LevelController());
  late AnimationController rotateAnimation;
  late ConfettiController _leftConfetty;
  late ConfettiController _rightConfetty;

  @override
  void dispose() {
    rotateAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    rotateAnimation = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    )..repeat();
    _leftConfetty = ConfettiController(duration: const Duration(seconds: 2));
    _rightConfetty = ConfettiController(duration: const Duration(seconds: 2));

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (!levelController.finishedLevel.contains(widget.level.id)) {
        levelController.finishedLevel.add(widget.level.id);
        levelController.saveLocalData();
        levelController.updatePlayTime(widget.level);
      }
    });

    assetsController.playWin().whenComplete(() {
      Future.delayed(const Duration(seconds: 1), () {
        assetsController.playConfetti();

        _leftConfetty.play();
        _rightConfetty.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.primary,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: kIsWeb ? 441 : MediaQuery.of(context).size.width,
              child: ClipRect(
                child: GameWidget(
                  backgroundBuilder: (context) {
                    return Container(
                      color: Themes.primary,
                      child: Opacity(
                        opacity: 0.2,
                        child: RotationTransition(
                          turns: rotateAnimation,
                          child: Transform.scale(
                            scale: 2.4,
                            child: Image.asset(
                              AssetImages.bgFinal,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  game: GameCompleteScene(
                    level: widget.level,
                    matrixBlocks: widget.matrixBlocks,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.20,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "EXCELLENT!",
                    style: Themes().whiteBold32,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.18,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PopButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    radius: 32,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    enableShadow: true,
                    shadowColor: Colors.black.withOpacity(0.1),
                    text: "Back to Home",
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: ConfettiWidget(
              confettiController: _leftConfetty,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.5,
              maxBlastForce: 150,
              shouldLoop: false,
              blastDirection: -pi / 2,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ConfettiWidget(
              confettiController: _rightConfetty,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 150,
              emissionFrequency: 0.5,
              shouldLoop: false,
              blastDirection: -pi / 2,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
            ),
          ),
          Column(
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
            ],
          ),
        ],
      ),
    );
  }
}
