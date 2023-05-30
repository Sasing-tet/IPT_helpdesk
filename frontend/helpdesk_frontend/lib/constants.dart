import 'package:flutter/material.dart';

const MaterialColor colorpalette =
    MaterialColor(_colorpalettePrimaryValue, <int, Color>{
  50: Color(0xFFE1E6E9),
  100: Color(0xFFB3C2C9),
  200: Color(0xFF8199A5),
  300: Color(0xFF4F7080),
  400: Color(0xFF295165),
  500: Color(_colorpalettePrimaryValue),
  600: Color(0xFF032D43),
  700: Color(0xFF02263A),
  800: Color(0xFF021F32),
  900: Color(0xFF011322),
});
const int _colorpalettePrimaryValue = 0xFF03324A;

const MaterialColor colorpaletteAccent =
    MaterialColor(_colorpaletteAccentValue, <int, Color>{
  100: Color(0xFF5EA3FF),
  200: Color(_colorpaletteAccentValue),
  400: Color(0xFF006AF7),
  700: Color(0xFF005FDE),
});
const int _colorpaletteAccentValue = 0xFF2B86FF;
