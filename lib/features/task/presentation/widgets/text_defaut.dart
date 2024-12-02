import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextDefault extends StatelessWidget {
  const TextDefault(
      {super.key,
      required this.sizeText,
      this.colorText,
      required this.text,
      this.fontWeight = FontWeight.w400,
      this.textAlign,
      this.overflow = TextOverflow.ellipsis,
      this.fontFamily,
      this.decoration});

  final double sizeText;
  final Color? colorText;
  final String text;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final String? fontFamily;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: GoogleFonts.chakraPetch(
          textStyle: TextStyle(
              decoration: decoration,
              decorationColor: Colors.orange,
              decorationThickness: 3.0,
              overflow: overflow,
              color: colorText,
              fontSize: sizeText,
              fontFamily: fontFamily,
              fontWeight: fontWeight),
        ));
  }
}
