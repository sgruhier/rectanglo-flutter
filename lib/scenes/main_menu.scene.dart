import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rectanglo/components/pop_button.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/r.dart';
import 'package:rectanglo/scenes/level_selection.scene.dart';
import 'package:rectanglo/utils/nav_helper.dart';
import 'package:widget_helper/widget_helper.dart';

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
            children: [
              Row(
                children: [
                  PopButton(
                    radius: 20,
                    color: Colors.white,
                    shadowColor: Colors.black.withOpacity(0.1),
                    enableShadow: true,
                    onTap: () {
                      NavHelper.navigatePush(
                          context, const LevelSelectionScene());
                    },
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      width: double.infinity,
                      height: 168,
                      child: Stack(
                        children: [
                          Image.asset(
                            AssetImages.glow,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Play Now",
                                    style: Themes().blackBold20,
                                  ),
                                  Text(
                                    "Play Nonongram\nlevels",
                                    style: Themes().black14,
                                  ).addMarginTop(4),
                                ],
                              ).addExpanded,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    AssetImages.controller,
                                    width: 56,
                                    height: 56,
                                  ),
                                ],
                              )
                            ],
                          ).addAllMargin(16),
                        ],
                      ),
                    ),
                  ).addExpanded,
                  Container(width: 24),
                  PopButton(
                    radius: 20,
                    color: Colors.white,
                    shadowColor: Colors.black.withOpacity(0.1),
                    enableShadow: true,
                    onTap: () {},
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      width: double.infinity,
                      height: 168,
                      child: Stack(
                        children: [
                          Image.asset(
                            AssetImages.glow,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Setting",
                                    style: Themes().blackBold20,
                                  ),
                                  Text(
                                    "Minimal game\nsettings",
                                    style: Themes().black14,
                                  ).addMarginTop(4),
                                ],
                              ).addExpanded,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(
                                    Icons.settings,
                                    color: Themes.primary,
                                    size: 48,
                                  ),
                                ],
                              )
                            ],
                          ).addAllMargin(16),
                        ],
                      ),
                    ),
                  ).addExpanded,
                ],
              ),
              PopButton(
                radius: 20,
                color: Colors.white,
                shadowColor: Colors.black.withOpacity(0.1),
                enableShadow: true,
                onTap: () {},
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: double.infinity,
                  height: 168,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Image.asset(
                          AssetImages.glow,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create Level",
                                style: Themes().blackBold20,
                              ),
                              Text(
                                "Play or create your own level and\nchallenge your friends",
                                style: Themes().black14,
                              ).addMarginTop(4),
                            ],
                          ).addExpanded,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                AssetImages.controller,
                                width: 56,
                                height: 56,
                              ),
                            ],
                          )
                        ],
                      ).addAllMargin(16),
                    ],
                  ),
                ),
              ).addMarginTop(24),
            ],
          ).addAllPadding(24),
        ),
      ),
    );
  }
}
