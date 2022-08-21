import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rectanglo/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/level.dart';

class LevelController extends GetxController {
  SharedPreferences? _prefs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxList<Level> levels = RxList([]);
  RxList<String> finishedLevel = RxList([]);

  void saveLocalData() async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs?.setStringList(Constant.finishedLevel, finishedLevel);
  }

  void loadLocalData() async {
    _prefs ??= await SharedPreferences.getInstance();
    List<String> localFinishedLevel =
        _prefs?.getStringList(Constant.finishedLevel) ?? [];
    finishedLevel.clear();
    finishedLevel.addAll(localFinishedLevel);
  }

  void updatePlayTime(Level level) {
    firebaseFirestore.collection('levels').doc(level.id).update({
      "playersCount": level.playersCount + 1,
    });
  }

  @override
  void onInit() {
    super.onInit();
    loadLocalData();
    firebaseFirestore.collection('levels').snapshots().listen((event) {
      levels.clear();
      for (DocumentSnapshot document in event.docs) {
        Level level = Level.fromJson(Map.from(document.data() as Map));
        levels.add(level);
      }
    });
  }
}
