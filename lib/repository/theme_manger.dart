import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './const_values.dart';
import './system_bars.dart';
import '../screens/main_screen/tabs/settings_tab/providers/setting_data.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeProvider, ThemeMode>((final ref) {
  return ThemeModeProvider(ref.read);
});

class ThemeModeProvider extends StateNotifier<ThemeMode> {
  final Reader read;

  ThemeModeProvider(this.read) : super(ThemeMode.system) {
    final index = read(settingsDataProvider).ioData.theme;
    state = themeModes[index];
    setAppbarBottombarTheme(index: index);
  }

  void changeThemeMode(final int index) {
    state = themeModes[index];
    read(settingsDataProvider).setThemeMode(index);
    setAppbarBottombarTheme(index: index);
  }

  static const themeModes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];
}

class ThemeManger {
  static void init() {
    darkTheme = _setTheme(true);
    lightTheme = _setTheme(false);
  }

  static late final ThemeData darkTheme;

  static late final ThemeData lightTheme;

  static ThemeData _setTheme(final bool isDark) {
    final primaryColor = isDark ? Colors.green : const Color(0xFF7727FF);

    final scaffoldBackgroundColor =
        isDark ? const Color(0xFF212121) : const Color(0xFFF0F3F6);

    final textColor = isDark ? Colors.white : const Color(0xFF15192A);

    return ThemeData(
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      backgroundColor: isDark ? const Color(0xFF616161) : Colors.white,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary:
            isDark ? const Color(0xFF424242) : Colors.white.withOpacity(0.75),
        background: isDark ? Colors.black : const Color(0xFFDDE4EF),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeThroughPageTransitionsBuilder(
            fillColor: scaffoldBackgroundColor,
          ),
          TargetPlatform.windows: FadeThroughPageTransitionsBuilder(
            fillColor: scaffoldBackgroundColor,
          ),
        },
      ),
      iconTheme: IconThemeData(color: primaryColor),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(5),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(paddingH20V10),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            shapeBorderRadius10,
          ),
          backgroundColor: MaterialStateProperty.all(primaryColor),
        ),
      ),
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: primaryColor,
          fontSize: 16,
        ),
        headline1: GoogleFonts.rubik(
          fontSize: 32.0,
          color: textColor,
        ),
        headline2: TextStyle(
          color: primaryColor,
          fontSize: 20,
        ),
        headline3: GoogleFonts.rubik(
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.w300,
        ),
        headline4: GoogleFonts.rubik(
          fontSize: 18.0,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w300,
        ),
        headline5: TextStyle(
          color: primaryColor,
          fontSize: 17,
        ),
        headline6: TextStyle(
          color: primaryColor,
          fontSize: 17,
        ),
        subtitle1: GoogleFonts.roboto(
          fontSize: 12.0,
          color: textColor,
        ),
        subtitle2: GoogleFonts.roboto(
          fontSize: 12.0,
          color: textColor.withOpacity(0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.roboto(
          fontSize: 17.0,
          color: textColor.withOpacity(0.5),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: primaryColor),
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle: GoogleFonts.roboto(
            fontSize: 17.0,
            color: textColor.withOpacity(0.5),
          ),
        ),
      ),
      dividerColor: isDark ? Colors.white30 : Colors.black26,
      checkboxTheme: CheckboxThemeData(
        shape: shapeBorderRadius10,
        fillColor: MaterialStateProperty.all<Color>(primaryColor),
        checkColor: MaterialStateProperty.all<Color>(scaffoldBackgroundColor),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }
}
