import 'package:anilist/core/theme/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
  final bool translate;

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
    this.translate = true,
  });

  String get _text {
    if (text == null || text!.isEmpty) return '';
    if (maxLength != null && text!.length > maxLength!) {
      return '${text!.substring(0, maxLength)}...';
    }
    return text!;
  }

  TextStyle get _textStyle => TextStyle(
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        color: color ?? AppColor.primary,
        overflow:
            ellipsed == true ? TextOverflow.ellipsis : TextOverflow.visible,
        fontSize: fontSize ?? 14,
        fontWeight: weight,
      );

  @override
  Widget build(BuildContext context) {
    return translate ? _buildText().tr() : _buildText();
  }

  Text _buildText() {
    return Text(
      _text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: _textStyle,
    );
  }
}
