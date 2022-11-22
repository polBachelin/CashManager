// ignore_for_file: constant_identifier_names

library color_theme; // ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cash_manager/theme.dart' as theme;

const Color blueColor = Color(0xff21579C);
const Color ColorBackground = Color.fromARGB(255, 244, 251, 249);
const Color ColorLogo = Color.fromARGB(255, 51, 119, 165);
const Color ColorText = Color.fromARGB(255, 50, 163, 138);
const Color ColorButton = Color.fromARGB(255, 41, 98, 133);
const Color ColorTextButton = Color.fromARGB(255, 255, 255, 255);

TextStyle titleStyle = GoogleFonts.poppins(
    color: ColorText, fontSize: 25, fontWeight: FontWeight.w600);
TextStyle buttonTextStyle = GoogleFonts.poppins(
  color: const Color.fromARGB(255, 255, 255, 255),
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
