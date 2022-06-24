// ignore_for_file: avoid-global-state

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

abstract class AppTextStyle {
  static TextStyle bigTitle = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 25,
    letterSpacing: 0.5,
    color: Colors.blueAccent,
  );

  static TextStyle title = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.5,
  );

  static TextStyle normal = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.5,
  );

  static TextStyle small = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    letterSpacing: 0.3,
  );
}

abstract class AppShadow {
  static BoxShadow card = const BoxShadow(
    color: Color.fromARGB(0, 34, 34, 37),
    blurRadius: 20,
    spreadRadius: 3,
    offset: Offset(0, 3),
  );
}
