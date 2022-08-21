import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tools {
  static changeStatusbarIconColor({
    bool darkIcon = true,
    Color statusBarColor = Colors.transparent,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: darkIcon ? Brightness.dark : Brightness.light,
      ),
    );
  }

  static Future<dynamic> showCustomDialog(
    BuildContext context, {
    Widget? child,
    bool dismissable = false,
  }) {
    return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform(
          transform: Matrix4.identity()..scale(1.3 - (a1.value * 0.3)),
          // ..rotateZ(0.1 - (a1.value * 0.1)),
          alignment: Alignment.center,
          child: Opacity(
            opacity: a1.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 100),
      barrierDismissible: dismissable,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) => Container(),
    );
  }
}
