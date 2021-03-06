import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData mainTheme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionHandleColor: primaryColor,
      selectionColor: primaryColor,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: darkColor, // Your accent color
    ),
    primaryColor: primaryColor,
    hintColor: darkColor,
    scaffoldBackgroundColor: mainBackgroundColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: mainBackgroundColor,
    ),
    textTheme: GoogleFonts.montserratTextTheme(),
    // textTheme: GoogleFonts.varelaTextTheme(),
    backgroundColor: mainBackgroundColor,
  );

  static Color primaryColor = Colors.amber.shade800; //Color(0xffFF8F00);
  static Color darkColor = Color(0xff744203);
  static Color mainBackgroundColor = Colors.black;
  static Color cardColor = Color(0xff171717);

  static Color mainTextColor = Colors.grey.shade100;

  static TextStyle montText = TextStyle(
    color: mainTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle montTextTitle = TextStyle(
    color: mainTextColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle montTextGrey =
      TextStyle(color: Colors.grey.shade400, fontSize: 14);

  static TextStyle montTextLittle = TextStyle(
    color: mainTextColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tileTitleTextStyle = TextStyle(
    color: mainTextColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static Text appTitle = Text(
    'RID',
    style: GoogleFonts.racingSansOne(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: mainTextColor,
    ),
  );

  static Text appTitleMainColor = Text(
    'RID',
    style: GoogleFonts.racingSansOne(
        fontSize: 26, fontWeight: FontWeight.bold, color: primaryColor),
  );

  static BorderRadius circularBorderRadius =
      BorderRadius.all(Radius.circular(100));

  static BorderRadius defaultCardBorderRadius =
      BorderRadius.all(Radius.circular(18));

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    primary: Styles.primaryColor,
  );

  static BoxDecoration specsBoxDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.all(Radius.circular(24)),
  );

  static getTextFieldDecorationUnderline(String value) {
    return InputDecoration(
      border: UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade900),
      ),
      labelText: value,
      labelStyle: TextStyle(color: Colors.grey.shade400),
    );
  }
}
