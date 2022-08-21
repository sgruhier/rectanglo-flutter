import 'package:flutter/material.dart';
import 'package:rectanglo/components/flat_card.dart';
import 'package:rectanglo/components/pop_button.dart';
import 'package:widget_helper/widget_helper.dart';

import '../config/themes.dart';

class QuestionDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String positiveText;
  final String negativeText;
  final bool negativeAction;

  const QuestionDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    this.positiveText = "Ok",
    this.negativeText = "Batalkan",
    this.negativeAction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          // padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width >
                  MediaQuery.of(context).size.height
              ? MediaQuery.of(context).size.height * 0.4
              : MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatCard(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                width: double.infinity,
                color: Themes.primary,
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.help_center_rounded,
                      color: Colors.white,
                      size: 24,
                    ).addMarginRight(6),
                    Text(title, style: Themes().whiteBold18),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(top: 4),
                child: Text(
                  message,
                  style: Themes()
                      .black16
                      ?.apply(color: Themes.black.withOpacity(0.8)),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 14,
                  right: 14,
                  bottom: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PopButton(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onTap: onCancel,
                      text: negativeText,
                      textColor: Themes.black,
                      border: Border.all(color: Themes.black.withOpacity(0.4)),
                      color: Colors.white,
                    ).addExpanded,
                    Container(
                      width: 16,
                    ),
                    PopButton(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onTap: onConfirm,
                      color: negativeAction ? Themes.red : Themes.primary,
                      text: positiveText,
                    ).addExpanded,
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
