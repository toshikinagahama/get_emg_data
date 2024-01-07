import 'package:flutter/material.dart';
import 'package:get_emg_data/foundation/app_color.dart';

class AppText {
  static const _normalRegular = TextStyle(
    color: AppColor.textWhiteMain,
    fontWeight: FontWeight.w400,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle h1 = const TextStyle(fontSize: 50).merge(_normalRegular);
  static TextStyle h2 = const TextStyle(fontSize: 48).merge(_normalRegular);
  static TextStyle h3 = const TextStyle(fontSize: 37).merge(_normalRegular);
  static TextStyle h4 = const TextStyle(fontSize: 30).merge(_normalRegular);
  static TextStyle h5 = const TextStyle(fontSize: 24).merge(_normalRegular);
  static TextStyle h6 = const TextStyle(fontSize: 18).merge(_normalRegular);
  static TextStyle caption =
      const TextStyle(fontSize: 9).merge(_normalRegular).light();
  static TextStyle title =
      const TextStyle(fontSize: 16).merge(_normalRegular).medium();
  static TextStyle subtitle =
      const TextStyle(fontSize: 14).merge(_normalRegular).medium();
  static TextStyle button1 =
      const TextStyle(fontSize: 14).merge(_normalRegular).medium();
  static TextStyle button2 =
      const TextStyle(fontSize: 12).merge(_normalRegular);
  static TextStyle body11 = const TextStyle(fontSize: 11).merge(_normalRegular);
  static TextStyle body12 = const TextStyle(fontSize: 12).merge(_normalRegular);
  static TextStyle body14 = const TextStyle(fontSize: 14).merge(_normalRegular);
  static TextStyle body16 = const TextStyle(fontSize: 16).merge(_normalRegular);
}

extension TextStyleExt on TextStyle {
  TextStyle bold() => copyWith(fontWeight: FontWeight.w700);
  TextStyle light() => copyWith(fontWeight: FontWeight.w300);
  TextStyle medium() => copyWith(fontWeight: FontWeight.w600);
}
