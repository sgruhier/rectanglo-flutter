import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rectanglo/components/pop_button.dart';
import 'package:rectanglo/r.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_helper/widget_helper.dart';

import '../components/ripple_button.dart';
import '../config/themes.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.primary,
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 441 : MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RippleButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 32,
                    ),
                  ),
                ],
              ),
              PopButton(
                padding: EdgeInsets.zero,
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    AssetImages.dany,
                    width: 100,
                    height: 100,
                  ),
                ),
              ).addSymmetricMargin(
                vertical: 32,
              ),
              Text(
                "Hello, I'm the Dev",
                style: Themes().blackBold26,
                textAlign: TextAlign.center,
              ),
              Text(
                "I know I know, you don't care\nmuch about it",
                style: Themes().black16,
                textAlign: TextAlign.center,
              ),
              Text(
                "I create this page only for formality, honestly I don't even know what I want to say to you but, thanks for playing my game cheers!\n\nI will just leave my social media here so you can eee... I don't know, Follow me I guess or just hit me on direct message",
                style: Themes().black16,
                textAlign: TextAlign.center,
              ).addAllMargin(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PopButton(
                    onTap: () {
                      launchUrl(
                          Uri.parse("https://www.instagram.com/yasfdany/"));
                    },
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      AssetImages.instagram,
                      width: 32,
                      height: 32,
                    ),
                  ),
                  Container(width: 24),
                  PopButton(
                    onTap: () {
                      launchUrl(Uri.parse("https://twitter.com/yasfdany"));
                    },
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      AssetImages.twitter,
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ).addMarginTop(24),
            ],
          ),
        ),
      ),
    );
  }
}
