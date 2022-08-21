import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:get/get.dart';
import 'package:rectanglo/r.dart';

class AssetsController extends GetxController {
  late AudioPool win;
  late AudioPool lose;
  late AudioPool confetti;
  late AudioPool positiveTap;
  late AudioPool negativeTap;

  void loadAssets() async {
    win = await FlameAudio.createPool(
      AssetSfx.win.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
    lose = await FlameAudio.createPool(
      AssetSfx.lose.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
    confetti = await FlameAudio.createPool(
      AssetSfx.confetti.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
    positiveTap = await FlameAudio.createPool(
      AssetSfx.tapPositive.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
    negativeTap = await FlameAudio.createPool(
      AssetSfx.tapNegative.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadAssets();
  }
}
