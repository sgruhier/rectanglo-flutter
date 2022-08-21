import 'package:flutter/material.dart';
import 'package:rectanglo/components/pop_button.dart';

import '../config/themes.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onConfirm,
    this.buttonText = "OK",
  }) : super(key: key);

  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: Themes().blackBold20),
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: Text(
                  message,
                  style: Themes()
                      .black16
                      ?.apply(color: Themes.black.withOpacity(0.8)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    PopButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      text: buttonText,
                      onTap: () {
                        if (onConfirm != null) onConfirm!();
                      },
                      color: Themes.primary,
                      radius: 8,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
