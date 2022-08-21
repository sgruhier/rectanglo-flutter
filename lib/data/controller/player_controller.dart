import 'package:get/get.dart';

enum PenTool {
  mark,
  cross,
}

class PlayerController extends GetxController {
  Rx<PenTool> pointer = Rx(PenTool.mark);
}
