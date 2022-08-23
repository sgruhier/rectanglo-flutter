import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:widget_helper/widget_helper.dart';

import 'components/add_button.dart';
import 'components/create_level_button.dart';
import 'components/play_now_button.dart';

class MainMenuScene extends StatefulWidget {
  const MainMenuScene({super.key});

  @override
  State<MainMenuScene> createState() => _MainMenuSceneState();
}

class _MainMenuSceneState extends State<MainMenuScene> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.primary,
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 441 : MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  PlayNowButton().addExpanded,
                  Container(width: 24),
                  AboutButton().addExpanded,
                ],
              ),
              CreateLevelButton().addMarginTop(24),
            ],
          ).addAllPadding(24),
        ),
      ),
    );
  }
}
