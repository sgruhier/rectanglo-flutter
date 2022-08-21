import 'package:flutter/material.dart';

class NavHelper {
  static Future navigatePushNamed<T>(
    BuildContext context,
    String route,
  ) async {
    return Navigator.pushNamed(context, route);
  }

  static Future navigateReplaceNamed<T>(
    BuildContext context,
    String route,
  ) async {
    return Navigator.pushReplacementNamed(context, route);
  }

  static Future navigateReplace<T>(
    BuildContext context,
    Widget screen,
  ) async {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return screen;
      }),
    );
  }

  static Future navigatePush<T>(
    BuildContext context,
    Widget screen,
  ) async {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) {
        return screen;
      }),
    );
  }
}
