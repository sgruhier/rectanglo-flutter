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
    // firebaseFirestore.collection('levels').add({
    //   "backgroundColor": [255, 255, 255, 1],
    //   "data": [
    //     {
    //       'color': [144, 144, 144, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [160, 160, 160, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [126, 126, 126, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [160, 160, 160, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [114, 114, 114, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [158, 158, 158, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [118, 118, 118, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [163, 163, 163, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [112, 112, 112, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [160, 160, 160, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [177, 177, 177, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [255, 255, 255, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [190, 190, 190, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [254, 254, 254, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [170, 170, 170, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [251, 251, 251, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [173, 173, 173, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [254, 254, 254, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [168, 170, 159, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [255, 254, 250, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [139, 139, 139, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [154, 154, 154, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [102, 102, 102, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [149, 149, 149, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [89, 89, 89, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [155, 155, 155, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [91, 91, 91, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [151, 151, 151, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [90, 94, 67, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [110, 136, 71, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [185, 185, 185, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [254, 254, 254, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [190, 190, 190, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [254, 254, 254, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [168, 168, 168, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [254, 254, 254, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [176, 176, 176, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [248, 252, 251, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [150, 162, 124, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [145, 205, 49, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [136, 136, 136, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [163, 163, 163, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [112, 112, 112, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [162, 162, 162, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [93, 93, 93, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [163, 163, 163, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [108, 72, 84, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [155, 81, 106, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [110, 39, 43, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [143, 35, 7, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [176, 176, 176, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [255, 255, 255, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [190, 190, 190, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [254, 254, 254, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [170, 170, 170, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [250, 251, 253, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [182, 126, 139, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [250, 109, 144, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [175, 55, 67, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [238, 23, 39, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [147, 147, 147, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [198, 198, 198, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [130, 140, 129, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [120, 157, 77, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [91, 104, 61, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [194, 191, 198, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [132, 69, 78, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [179, 23, 34, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [140, 14, 17, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [191, 15, 25, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [182, 182, 182, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [254, 254, 254, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [180, 191, 157, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [149, 199, 52, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [117, 138, 79, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [252, 251, 255, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [190, 93, 100, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [239, 26, 30, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [177, 17, 17, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [238, 25, 29, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [136, 136, 136, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [163, 163, 163, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [114, 124, 99, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [92, 137, 34, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [52, 86, 10, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [143, 154, 86, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [98, 66, 28, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [134, 66, 17, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [76, 43, 10, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [123, 74, 16, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [177, 177, 177, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [254, 254, 254, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [172, 193, 152, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [153, 204, 51, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [98, 145, 31, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [152, 201, 60, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [101, 145, 24, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [157, 197, 72, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [99, 141, 29, 1],
    //       'currentState': 0,
    //       'state': 0
    //     },
    //     {
    //       'color': [154, 201, 63, 1],
    //       'currentState': 0,
    //       'state': 0
    //     }
    //   ],
    //   "description": "test",
    //   "difficulty": 1,
    //   "id": DateTime.now().millisecondsSinceEpoch.toString(),
    //   "players": [],
    //   "playersCount": 0,
    //   "rate": 0,
    //   "creator": {
    //     "avatar": "",
    //     "exp": 999,
    //     "email": "yasfdany@gmail.com",
    //     "id": "93v74tvon9cn39c",
    //     "name": "Dany",
    //     "playtime": 999,
    //   }
    // });
    firebaseFirestore.collection('levels').snapshots().listen((event) {
      levels.clear();
      for (DocumentSnapshot document in event.docs) {
        Level level = Level.fromJson(Map.from(document.data() as Map));
        levels.add(level);
      }
    });
  }
}
