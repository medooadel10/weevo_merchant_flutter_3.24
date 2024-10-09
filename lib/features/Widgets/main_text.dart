import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainText extends StatelessWidget {
  final String? text;
  final String? family;
  final double? font;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final TextAlign textAlign;
  final Color? color;
  final FontWeight? weight;
  final double? lineHeight;
  final int? maxLines;

  const MainText({
    super.key,
    this.text,
    this.font,
    this.overflow,
    this.weight,
    this.lineHeight,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.color,
    this.maxLines,
    this.family,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text ?? '',
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: font ?? 20.sp,
          height: lineHeight,
          fontWeight: weight,
          fontFamily: family,
          decoration: decoration ?? TextDecoration.none,
        ));
  }
}
