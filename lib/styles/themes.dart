import 'package:flutter/material.dart';

// ignore: camel_case_types
class colors {
  static const Color transparent = Color(0x00000000);

  static const Color background = Color(0xFF4f5d75);
  static const Color foreground = Color(0xFF2D3142);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color iconColor = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFBFC0C0);
  static const Color altText = Color(0xFFEF8354);

  // static const Color background = Color(0xFF304D6D);
  // static const Color primaryText = Color(0xFFFFFFFF);
  // static const Color iconColor = Color(0xFFFFFFFF);
  // static const Color foreground = Color(0xFF82A0BC);
  // static const Color secondaryText = Color(0xFFFF0000);
  // static const Color altText = Color(0xFFFF0000);

  // static const Color background = Color(0xFF1C4E80);
  // static const Color primaryText = Color(0xFFFFFFFF);
  // static const Color iconColor = Color(0xFFFFFFFF);
  // static const Color foreground = Color(0xFF87CEEB);
  // static const Color secondaryText = Color(0xFFF4A460);
  // static const Color altText = Color(0xFFDC143C);

  // static const Color background = Color(0xFF000080);
  // static const Color primaryText = Color(0xFFF5F5F5);
  // static const Color iconColor = Color(0xFFF5F5F5);
  // static const Color foreground = Color(0xFF87CEEB);
  // // static const Color secondaryText = Color(0xFFF4A460);
  // static const Color altText = Color(0xFFB22222);
}

class Themes {
  static ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.dark,
    ).copyWith(
      // used
      primaryContainer: colors.foreground,
      onPrimaryContainer: colors.primaryText,
      primary: colors.altText,
      surface: colors.background,
      onSurface: colors.primaryText,
      surfaceContainerHighest: colors.foreground,
      onSurfaceVariant: colors.primaryText,
      outlineVariant: colors.foreground,

      // not used
      // onPrimary: Colors.black,
      // primaryFixed: Colors.black,
      // primaryFixedDim: Colors.black,
      // onPrimaryFixed: Colors.black,
      // onPrimaryFixedVariant: Colors.black,
      // secondary: Colors.black,
      // onSecondary: Colors.black,
      // secondaryContainer: Colors.black,
      // onSecondaryContainer: Colors.black,
      // secondaryFixed: Colors.black,
      // secondaryFixedDim: Colors.black,
      // onSecondaryFixed: Colors.black,
      // onSecondaryFixedVariant: Colors.black,
      // tertiary: Colors.black,
      // onTertiary: Colors.black,
      // tertiaryContainer: Colors.black,
      // onTertiaryContainer: Colors.black,
      // tertiaryFixed: Colors.black,
      // tertiaryFixedDim: Colors.black,
      // onTertiaryFixed: Colors.black,
      // onTertiaryFixedVariant: Colors.black,
      // error: Colors.black,
      // onError: Colors.black,
      // errorContainer: Colors.black,
      // onErrorContainer: Colors.black,
      // surfaceDim: Colors.black,
      // surfaceBright: Colors.black,
      // surfaceContainerLowest: Colors.black,
      // surfaceContainerLow: Colors.black,
      // surfaceContainer: Colors.black,
      // surfaceContainerHigh: Colors.black,
      // outline: Colors.black,
      // shadow: Colors.black,
      // scrim: Colors.black,
      // inverseSurface: Colors.black,
      // onInverseSurface: Colors.black,
      // inversePrimary: Colors.black,
      // surfaceTint: Colors.black,
    ),
    // highlightColor: Colors.red,
  );
}
