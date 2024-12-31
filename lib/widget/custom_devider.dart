// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:anilist/constant/app_color.dart';
import 'package:anilist/widget/text/text_widget.dart';

class CustomDivider extends StatelessWidget {
  final String? text;
  final double? textSpacing;
  final Color? color;
  final Color? textColor;

  const CustomDivider({
    super.key,
    this.text,
    this.textSpacing,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Flexible(
            child: Divider(
              thickness: 1,
              color: color ?? AppColor.primary,
            ),
          ),
          SizedBox(width: textSpacing),
          if (text != null)
            const Padding(
              padding: EdgeInsets.only(left: 0.05, right: 0.05),
              child: TextWidget(
                'or',
                color: AppColor.accent,
              ),
            ),
          SizedBox(width: textSpacing),
          Flexible(
            child: Divider(
              thickness: 1,
              color: color ?? AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}
