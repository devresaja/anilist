// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anilist/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final bool? ellipsed;
  final TextAlign? textAlign;
  final double? fontSize;
  final int? maxLines;
  final int? maxLength;
  final FontWeight? weight;
  final TextDecoration? decoration;
  final double? decorationThickness;
  final Color? decorationColor;
  const TextWidget(
    this.text, {
    super.key,
    this.color,
    this.ellipsed,
    this.textAlign,
    this.fontSize,
    this.maxLines,
    this.maxLength,
    this.weight,
    this.decoration,
    this.decorationThickness,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLength != null && text!.length > num.tryParse('$maxLength')!
          ? '${text!.substring(0, maxLength)}...'
          : '$text',
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
          decoration: decoration,
          decorationColor: decorationColor,
          decorationThickness: decorationThickness,
          color: color ?? AppColor.primary,
          overflow:
              ellipsed == true ? TextOverflow.ellipsis : TextOverflow.visible,
          fontSize: fontSize?.sp ?? 14.sp,
          fontWeight: weight),
    );
  }
}
