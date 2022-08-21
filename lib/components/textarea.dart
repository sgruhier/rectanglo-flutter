import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/themes.dart';

class TextArea extends StatefulWidget {
  final String? hint;
  final String? label;
  final Widget? icon;
  final Widget? endIcon;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final bool secureInput;
  final int? maxLenght;
  final int maxLine;
  final Function(String value)? onKeyUp;
  final Function(String value)? onChangedText;
  final Function(String value)? onSubmitText;
  final VoidCallback? onClearText;
  final double? width;
  final double? height;
  final TextCapitalization textCapitalization;
  final MainAxisAlignment mainAxisAlignment;
  final Color? color;
  final bool enable;
  final bool error;
  final String errorMessage;
  final bool autoFocus;
  final TextAlign textAlign;
  final double? radius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final bool isDense;
  final Border? border;
  final List<String>? autofillHints;

  const TextArea({
    Key? key,
    this.padding,
    this.radius,
    this.hint,
    this.label,
    this.icon,
    this.endIcon,
    this.controller,
    this.inputType,
    this.secureInput = false,
    this.inputFormatter,
    this.maxLenght,
    this.maxLine = 1,
    this.onChangedText,
    this.width,
    this.height,
    this.onKeyUp,
    this.onSubmitText,
    this.onClearText,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.color,
    this.enable = true,
    this.error = false,
    this.autoFocus = false,
    this.errorMessage = "",
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.hintTextStyle,
    this.isDense = false,
    this.border,
    this.autofillHints,
  }) : super(key: key);

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  Timer? _debounce;
  final FocusNode _focus = FocusNode();
  RxBool isFocus = RxBool(false);

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (widget.onKeyUp != null) widget.onKeyUp!(query);
    });
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      isFocus.value = _focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Themes.primary.withOpacity(0.3),
        ),
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: (widget.controller ?? TextEditingController()),
        builder: (context, value, _) {
          return Obx(
            () => TextField(
              autofillHints: widget.autofillHints ?? [],
              focusNode: _focus,
              textAlign: widget.textAlign,
              autofocus: widget.autoFocus,
              enabled: widget.enable,
              minLines: 1,
              maxLines: widget.maxLine,
              textCapitalization: widget.textCapitalization,
              textInputAction: widget.textInputAction,
              onSubmitted: (value) {
                if (widget.onSubmitText != null) {
                  widget.onSubmitText!(value);
                }
              },
              onChanged: (value) {
                if (widget.onChangedText != null) {
                  widget.onChangedText!(value);
                }

                if (widget.onKeyUp != null) {
                  _onSearchChanged(value);
                }
              },
              obscureText: widget.secureInput,
              controller: widget.controller,
              keyboardType: widget.inputType,
              style: widget.textStyle ??
                  GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black,
                  ),
              inputFormatters: widget.inputFormatter,
              maxLength: widget.maxLenght,
              cursorColor: Themes.primary,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Themes.stroke),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xff7B7B7B)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                errorText: widget.error ? widget.errorMessage : null,
                isDense: widget.isDense,
                contentPadding: widget.padding ??
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: isFocus.value || value.text.isNotEmpty
                      ? Colors.black
                      : Themes.stroke,
                ),
                hintText: widget.hint,
                hintStyle: widget.hintTextStyle ??
                    GoogleFonts.inter(
                      fontSize: 14,
                      color: Themes.stroke,
                    ),
                suffixIcon: widget.endIcon,
              ),
            ),
          );
        },
      ),
    );
  }
}
