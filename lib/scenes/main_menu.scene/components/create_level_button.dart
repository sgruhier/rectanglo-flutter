import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../components/pop_button.dart';
import '../../../config/themes.dart';
import '../../../r.dart';
import '../../../utils/nav_helper.dart';
import '../../create_level.scene/create_level_info.scene.dart';

class CreateLevelButton extends StatelessWidget {
  const CreateLevelButton({
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
        NavHelper.navigatePush(context, const CreateLevelInfo());
      },
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
                      AssetImages.paintbrush,
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
