// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

class AppColor {

  static const Color blackColor = Color(0x0ff000000);
  static const Color whiteColor = Color(0x0ffffffff);
  static const Color blueColor = Color(0xff0579d2);
  static const Color addTXTBlueColor = Color(0xffcbfaf1);
  static const Color backBlueColor = Color(0x74c6e5ff);
  static const Color greenColor = Color(0xfa01c72f);
  static const Color addTXTGreenColor = Color(0xfab7fcc7);
  static const Color greenBackColor = Color(0xa1cefdd8);
  static const Color yellowColor = Color(0xffffdd00);
  static const Color addTXTYellowColor = Color(0xfffffbc6);
  static const Color yellowBackColor = Color(0x9df8eda9);
  static const Color orangeColor = Color(0xfffd7919);
  static const Color addTXTOrangeColor = Color(0xfff5e3d6);
  static const Color orangeBackColor = Color(0x94facdae);
  static const Color purpleColor = Color(0xff66028a);
  static const Color addTXTPurpleColor = Color(0xfff9f1fc);
  static const Color purpleBackColor = Color(0x98f1d2fc);
  static const Color blackAccent = Color(0x9B656F73);
  static const Color addTXTBlackAccent = Color(0xFFDBDCDC);
  static const Color blackBackAccent = Color(0x44C0DAE3);
  static const Color redColor = Color(0xffff0909);
  static const Color addTXTRedColor = Color(0xfffff4f4);
  static const Color redBackColor = Color(0x8bfdcaca);
  static const Color whiteAccent = Color(0xffb0b0b0);
  static const Color searchBarColor = Color(0x449FC1D0);
  static const Color displayContainerColor = Color(0x99faea85);

  static Color getColor(String colorName) {
    switch (colorName) {
      case 'yellow':
        return addTXTYellowColor;
      case 'green':
        return addTXTGreenColor;
      case 'blue':
        return addTXTBlueColor;
      case 'red':
        return addTXTRedColor;
      case 'orange':
        return addTXTOrangeColor;
      case 'purple':
        return addTXTPurpleColor;
      case 'blackAccent':
        return addTXTBlackAccent;
      default:
        return addTXTYellowColor; // Default color
    }
  }
}
