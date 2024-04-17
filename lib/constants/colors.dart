import 'package:flutter/material.dart';

class ColorConstants {
  static const Color primary = Color(0xFFFB9C2A);
  static const Color secondary = Color(0xFF898121);
  static const Color iconColor = Colors.white;

  static const Color success = Color(0xFF4BB543);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFFF0000);

  static const Color bg = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x33000000);
  static const Color hover = Color(0xFFEAEAEA);

  static const Color grey = Color(0xFF707070);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2, 8).toUpperCase()}';
  }

  static MaterialColor createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  static MaterialStateProperty<Color> createMaterialStateColor(Color color) {
    return MaterialStateProperty.resolveWith((states) => color);
  }

  static ThemeData get themeData {
    return ThemeData(
      primarySwatch: createMaterialColor(primary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: primary,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: createMaterialColor(primary),
      ).copyWith(
        secondary: secondary,
        background: bg,
      ),
    );
  }
}
