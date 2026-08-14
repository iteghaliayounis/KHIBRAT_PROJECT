import 'package:flutter/material.dart';

class AssistantPalette {
  AssistantPalette._();

  static const Color navy = Color(0xFF0A1D47);
  static const Color navyDeep = Color(0xFF001B4D);
  static const Color gold = Color(0xFFF5C453);
  static const Color goldDeep = Color(0xFFE6B422);
  static const Color goldSoft = Color(0xFFFFE082);
  static const Color connected = Color(0xFF2E7D32);
  static const Color chipBlue = Color(0xFFE8F1FF);
  static const Color subtitle = Color(0xFF8A97B0);
  static const Color dust = Color(0xFF90CAF9);

  static Color background(bool dark) =>
      dark ? const Color(0xFF0B1220) : const Color(0xFFF8F9FB);

  static Color surface(bool dark) =>
      dark ? const Color(0xFF152238) : Colors.white;

  static Color text(bool dark) =>
      dark ? Colors.white : navy;

  static Color muted(bool dark) =>
      dark ? const Color(0xFF9AA6C1) : subtitle;

  static Color headerButton(bool dark) =>
      dark ? const Color(0xFF1C2B45) : Colors.white;

  static Color inputFill(bool dark) =>
      dark ? const Color(0xFF1A2740) : Colors.white;

  static Color bubbleUser = navy;

  static Color bubbleAssistant(bool dark) =>
      dark ? const Color(0xFF1A2740) : Colors.white;

  static Color drawerScrim = const Color(0x99000C24);

  static Color sessionSelected(bool dark) =>
      dark ? const Color(0xFF1E3A5F) : const Color(0xFFEAF3FF);

  static Color iconMuted(bool dark) =>
      dark ? const Color(0xFFB0B8C9) : const Color(0xFF4A5568);
}
