import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:get/get.dart';
import 'package:rectanglo/r.dart';

class AssetsController extends GetxController {
  late AudioPool _win;
  late AudioPool _lose;
  late AudioPool _confetti;
  late AudioPool _positiveTap;
  late AudioPool _negativeTap;
  double volume = 1.0;

  Future<Stoppable> playWin() {
    return _win.start(volume: volume);
  }

  Future<Stoppable> playLose() {
    return _lose.start(volume: volume);
  }

  Future<Stoppable> playConfetti() {
    return _confetti.start(volume: volume);
  }

  Future<Stoppable> playPositiveTap() {
    return _positiveTap.start(volume: volume);
  }

  Future<Stoppable> playNegativeTap() {
    return _negativeTap.start(volume: volume);
  }

  void loadAssets() async {
    _win = await FlameAudio.createPool(
      AssetSfx.win.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
    _lose = await FlameAudio.createPool(
      AssetSfx.lose.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
    _confetti = await FlameAudio.createPool(
      AssetSfx.confetti.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
    _positiveTap = await FlameAudio.createPool(
      AssetSfx.tapPositive.replaceAll("assets/audio/sfx/", "sfx/"),
      minPlayers: 3,
      maxPlayers: 4,
    );
    _negativeTap = await FlameAudio.createPool(
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
