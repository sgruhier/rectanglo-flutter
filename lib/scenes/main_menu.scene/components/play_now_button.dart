import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../components/pop_button.dart';
import '../../../config/themes.dart';
import '../../../r.dart';
import '../../../utils/nav_helper.dart';
import '../../level_selection.scene/level_selection.scene.dart';

class PlayNowButton extends StatelessWidget {
  const PlayNowButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopButton(
      radius: 20,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      enableShadow: true,
      onTap: () {
        NavHelper.navigatePush(
          context,
          const LevelSelectionScene(),
        );
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
    );
  }
}
