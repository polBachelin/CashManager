library color_theme;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:area/theme.dart' as theme;

const Color primaryColor = Color.fromARGB(255, 211, 109, 42);
const Color primaryLightColor = Color.fromARGB(255, 214, 86, 0);
const Color reset = Color.fromARGB(255, 197, 0, 0);
const Color labelColor = Color(0xffc5c5c5);

const Color white = Color(0xffffffff);
const Color lightText = Color(0xffffffff);

const Color githubBlack = Color(0xff171515);
const Color background = Color.fromARGB(255, 0, 0, 0);

const Color disable = Color.fromARGB(255, 156, 156, 156);
const Color validate = Color.fromARGB(255, 224, 167, 8);

TextStyle titleStyle = GoogleFonts.poppins(
    color: primaryColor, fontSize: 25, fontWeight: FontWeight.w600);
TextStyle buttonTextStyle = GoogleFonts.poppins(
  color: const Color.fromARGB(255, 255, 255, 255),
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

InputDecoration decorationInput = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: theme.primaryColor, width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
  border: OutlineInputBorder(
    borderSide: const BorderSide(color: theme.primaryColor, width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
  filled: true,
  fillColor: Colors.white,
);
