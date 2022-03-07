import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  
  static const colorPrimary = Color.fromRGBO(127, 57, 251, 1);
  static const colorOnPrimary = Colors.white;
  static const colorSecondary = Colors.cyan;
  static const colorOnSecondary = Colors.white;
  static const colorBackground = Color.fromRGBO(33, 33, 33, 1);
  static const colorOnBackgroundDark = Color.fromRGBO(66, 66, 66, 1);
  static const colorOnBackgroundMedium = Color.fromRGBO(99, 99, 99, 1);
  static const colorOnBackground = Colors.white;
  
  static const String fontName = 'WorkSans';

  static TextTheme textTheme = TextTheme(
    // default theme of the _Text_
    bodyText2: GoogleFonts.nunito(textStyle: _body2),

    // used in titles
    headline1: GoogleFonts.nunito(textStyle: h1),
    // used in body
    headline6: GoogleFonts.nunito(textStyle: h6),
  );

  // default theme of the _Text_
  static const TextStyle _body2 = TextStyle( 
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: 0.2,
    color: colorOnBackground
  );

  static const TextStyle h1 = TextStyle( 
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 24,
    letterSpacing: 0.2,
    color: colorOnBackground
  );

  static const TextStyle h6 = TextStyle( 
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 17,
    letterSpacing: 0.2,
    color: colorOnBackground
  );


  static final inputDecorationTheme = InputDecorationTheme(
    fillColor: colorOnBackgroundDark,
    filled: true,
    hintStyle: textTheme.headline6?.copyWith(color: colorOnBackgroundMedium),        
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: colorOnBackgroundMedium, 
          width: 2.0
        )
      ),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: colorPrimary, 
          width: 3.0
        )
      ),     

  );

}