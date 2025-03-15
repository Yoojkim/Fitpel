import 'dart:math';

import 'package:flutter/material.dart';

class RandomColorUtil {
  static List<NameIconColorSet> colors = [
    NameIconColorSet(
      backGround: const Color(0xffECFDF3),
      font: const Color(0xff13AB62),
    ),
    NameIconColorSet(
      backGround: const Color(0xffFFFAEB),
      font: const Color(0xffDC6803),
    ),
    NameIconColorSet(
      backGround: const Color(0xffF8F9FC),
      font: const Color(0xff3E4784),
    ),
  ];

  static NameIconColorSet getRandomNamceIconColorSet() {
    Random random = Random();

    return colors[random.nextInt(colors.length)];
  }
}

class NameIconColorSet {
  Color backGround;
  Color font;

  NameIconColorSet({required this.backGround, required this.font});
}
