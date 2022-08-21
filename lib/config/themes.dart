import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static const Color primary = Color(0xffFCC233);
  static const Color black = Color(0xff000000);
  static const Color red = Color(0xffEB5757);
  static const Color green = Color(0xff27AE60);
  static const Color lightGreen = Color(0xffb5e61c);
  static const Color greenish = Color(0xff46e655);
  static const Color stroke = Color(0xffBCBCBC);
  static const Color blue = Color(0xff4751D7);
  static const Color reddish = Color(0xfff65b63);
  static const Color cyan = Color(0xff0CEAE2);
  static const Color orange = Color(0xffffff904a);
  static const Color purple = Color(0xff874EDC);
  static const Color purplish = Color(0xff7f86e3);
  static const Color blueGrey = Color(0xffA9C8F2);
  static const Color magenta = Color(0xffE92B96);
  static const Color yellow = Color(0xffFFD228);
  static const Color grey = Color(0xff757575);
  static const Color greyBg = Color(0xffECEBE8);
  static const Color line = Color(0xff424242);
  static const Color white = Color(0xffffffff);
  static const Color brown = Color(0xffb97a56);
  static const Color darkerBrown = Color(0xff880014);
  static const Color sea = Color(0xff99d9ea);
  static const Color sky = Color(0xff35a2e8);

  static const List<Color> colors = [
    white,
    black,
    grey,
    red,
    reddish,
    green,
    lightGreen,
    greenish,
    blue,
    purple,
    purplish,
    magenta,
    orange,
    primary,
    brown,
    darkerBrown,
    sea,
    sky,
  ];

  static BoxShadow emptyShadow = BoxShadow(
    offset: const Offset(0, 0),
    spreadRadius: 0,
    blurRadius: 0,
    color: const Color(0xff7090B0).withOpacity(0),
  );

  static BoxShadow dropShadow = BoxShadow(
    offset: const Offset(0, 14),
    spreadRadius: 6,
    blurRadius: 20,
    color: const Color(0xff7090B0).withOpacity(0.14),
  );
  static BoxShadow softShadow = BoxShadow(
    offset: const Offset(0, 0),
    spreadRadius: 6,
    blurRadius: 20,
    color: const Color(0xff7090B0).withOpacity(0.14),
  );

  static MaterialColor primaryMaterialColor = const MaterialColor(
    0xffFF9E2C,
    <int, Color>{
      50: Color(0xffFF9E2C),
      100: Color(0xffFF9E2C),
      200: Color(0xffFF9E2C),
      300: Color(0xffFF9E2C),
      400: Color(0xffFF9E2C),
      500: Color(0xffFF9E2C),
      600: Color(0xffFF9E2C),
      700: Color(0xffFF9E2C),
      800: Color(0xffFF9E2C),
      900: Color(0xffFF9E2C),
    },
  );

  TextStyle? white18;
  TextStyle? white16;
  TextStyle? white14;
  TextStyle? white12;
  TextStyle? white10;

  TextStyle? whiteBold32;
  TextStyle? whiteBold28;
  TextStyle? whiteBold26;
  TextStyle? whiteBold24;
  TextStyle? whiteBold22;
  TextStyle? whiteBold20;
  TextStyle? whiteBold18;
  TextStyle? whiteBold16;
  TextStyle? whiteBold14;
  TextStyle? whiteBold12;

  TextStyle? black10;
  TextStyle? black12;
  TextStyle? black14;
  TextStyle? black16;
  TextStyle? black18;
  TextStyle? black20;
  TextStyle? black24;

  TextStyle? blackBold12;
  TextStyle? blackBold14;
  TextStyle? blackBold16;
  TextStyle? blackBold18;
  TextStyle? blackBold20;
  TextStyle? blackBold22;
  TextStyle? blackBold24;
  TextStyle? blackBold26;

  TextStyle? gray10;
  TextStyle? gray12;
  TextStyle? gray14;
  TextStyle? gray16;

  TextStyle? primary12;
  TextStyle? primaryBold22;
  TextStyle? primaryBold18;
  TextStyle? primaryBold16;
  TextStyle? primaryBold14;
  TextStyle? primaryBold12;

  TextStyle textStyle({
    double size = 14,
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) {
    return GoogleFonts.lato(
      height: height != null ? height / size : null,
      fontSize: size,
      color: color ?? Themes.black,
      fontWeight: fontWeight,
    );
  }

  Themes({bool withLineHeight = false}) {
    primary12 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 12,
      color: Themes.primary,
    );

    primaryBold12 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 12,
      color: Themes.primary,
      fontWeight: FontWeight.bold,
    );

    primaryBold16 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 16,
      color: Themes.primary,
      fontWeight: FontWeight.bold,
    );

    primaryBold14 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 14,
      color: Themes.primary,
      fontWeight: FontWeight.bold,
    );

    primaryBold22 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 22,
      color: Themes.primary,
      fontWeight: FontWeight.bold,
    );

    primaryBold18 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 18,
      color: Themes.primary,
      fontWeight: FontWeight.bold,
    );

    blackBold20 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 20,
      color: Themes.black,
      fontWeight: FontWeight.bold,
    );

    blackBold24 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 24,
      color: Themes.black,
      fontWeight: FontWeight.bold,
    );

    blackBold22 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 22,
      color: Themes.black,
      fontWeight: FontWeight.bold,
    );

    blackBold26 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 26,
      color: Themes.black,
      fontWeight: FontWeight.bold,
    );

    black16 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 16,
      color: Themes.black,
    );

    black18 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 18,
      color: Themes.black,
    );

    black20 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 20,
      color: Themes.black,
    );

    black24 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 24,
      color: Themes.black,
    );

    blackBold18 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 18,
      color: Themes.black,
      fontWeight: FontWeight.bold,
    );

    blackBold16 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 16,
      color: Themes.black,
      fontWeight: FontWeight.bold,
    );

    blackBold12 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 12,
      color: Themes.black,
      fontWeight: FontWeight.bold,
    );

    blackBold14 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 14,
      color: Themes.black,
      fontWeight: FontWeight.bold,
    );

    black10 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 10,
      color: Themes.black,
    );

    black12 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 12,
      color: Themes.black,
    );

    white18 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 18,
      color: Colors.white,
    );

    white16 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 16,
      color: Colors.white,
    );

    white14 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 14,
      color: Colors.white,
    );

    white12 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 12,
      color: Colors.white,
    );

    white10 = GoogleFonts.lato(
      height: withLineHeight ? 1.2 : null,
      fontSize: 10,
      color: Colors.white,
    );

    black14 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 14,
      color: Themes.black,
    );

    whiteBold20 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold18 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold16 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold12 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold14 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold32 = GoogleFonts.lato(
      fontSize: 32,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold28 = GoogleFonts.lato(
      fontSize: 28,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold26 = GoogleFonts.lato(
      fontSize: 26,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold24 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    whiteBold22 = GoogleFonts.lato(
      height: withLineHeight ? 1.5 : 1.2,
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }
}

extension AddDecoration on TextStyle {
  TextStyle withUnderline({
    double width = 1,
    Color? lineColor,
    double offset = 4,
    bool visible = true,
  }) {
    return visible
        ? copyWith(
            decoration: TextDecoration.underline,
            shadows: [
              Shadow(
                color: lineColor ?? Colors.black,
                offset: Offset(0, -offset),
              ),
            ],
            color: Colors.transparent,
            decorationThickness: width,
            decorationColor: color,
          )
        : copyWith();
  }

  TextStyle lineThrough() {
    return copyWith(
      decoration: TextDecoration.lineThrough,
    );
  }

  TextStyle boldText() {
    return copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle withColor(Color? color) {
    return copyWith(
      color: color,
    );
  }

  TextStyle withSize(double? size) {
    return copyWith(
      fontSize: size,
    );
  }

  TextStyle withFontWeight(FontWeight? fontWeight) {
    return copyWith(
      fontWeight: fontWeight,
    );
  }
}

extension TextHelper on String {
  Text get text12 => Text(this, style: Themes().black12);
  Text get text14 => Text(this, style: Themes().black14);
  Text get text16 => Text(this, style: Themes().black16);
  Text get text18 => Text(this, style: Themes().black18);

  Text get textBold12 => Text(this, style: Themes().blackBold12);
  Text get textBold14 => Text(this, style: Themes().blackBold14);
  Text get textBold16 => Text(this, style: Themes().blackBold16);
  Text get textBold18 => Text(this, style: Themes().blackBold18);
  Text get textBold20 => Text(this, style: Themes().blackBold20);
  Text get textBold22 => Text(this, style: Themes().blackBold22);
  Text get textBold24 => Text(this, style: Themes().blackBold24);
  Text get textBold26 => Text(this, style: Themes().blackBold26);
}
