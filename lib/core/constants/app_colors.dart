import 'package:flutter/material.dart';

class AppColors {
  static const Color creme = Color(0xFFFFF8F0);
  static const Color azulSuave = Color(0xFF7FA8FF);
  static const Color verdeSalvia = Color(0xFFA3B18A);
  static const Color coralSuave = Color(0xFFFF8A80);
  static const Color cinzaMorno = Color(0xFFB0A8A0);
  static const Color brancoPuro = Color(0xFFFFFFFF);
  static const Color carvao = Color(0xFF2C2C2C);

  // Spacing
  static const double paddingLateral = 20.0;
  static const double paddingCard = 16.0;
  static const double gapCards = 12.0;

  // Border radius
  static const double radiusCard = 20.0;
  static const double radiusButton = 14.0;
  static const double radiusAvatar = 50.0;

  // Shadows
  static const List<BoxShadow> shadowPadrao = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> shadowElevado = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, 8)),
  ];
}
