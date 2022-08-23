import 'package:flutter/material.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../components/pop_button.dart';
import '../../../config/themes.dart';
import '../../../r.dart';
import '../../../utils/nav_helper.dart';
import '../../about.scene/about.scene.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({
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
          const AboutScreen(),
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
                      "About",
                      style: Themes().blackBold20,
                    ),
                    Text(
                      "Developer Information",
                      style: Themes().black14,
                    ).addMarginTop(4),
                  ],
                ).addExpanded,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      Icons.info_outline_rounded,
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
    );
  }
}
