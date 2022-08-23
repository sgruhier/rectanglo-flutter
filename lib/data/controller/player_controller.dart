import 'dart:ui';

import 'package:get/get.dart';
import 'package:rectanglo/config/themes.dart';

enum PenTool {
  mark,
  delete,
}

class PlayerController extends GetxController {
  Rx<PenTool> pointer = Rx(PenTool.mark);
  Rx<Color> selectedColor = Rx(Themes.primary);
}
