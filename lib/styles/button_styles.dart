import 'package:flutter/material.dart';

class AppButtonStyle {
  static ButtonStyle buttonWithBackground = ButtonStyle(
    shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)))),
  );

  static ButtonStyle buttonWithoutBackground = ButtonStyle(
    shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)))),
  );
}
