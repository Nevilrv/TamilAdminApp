import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  const CommonText(
      {Key? key,
      required this.text,
      this.color,
      required this.fontSize,
      this.fontWeight,
      this.textAlign})
      : super(key: key);

  final String text;
  final Color? color;
  final double fontSize;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
