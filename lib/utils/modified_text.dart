import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModifiedText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final List<Shadow>? shadows;

  const ModifiedText({
    super.key,
    required this.text,
    required this.size,
    required this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.breeSerif(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
        shadows: shadows,
      ),
    );
  }
}
