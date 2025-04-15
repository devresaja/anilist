import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

class SmallRoundedCard extends StatelessWidget {
  const SmallRoundedCard({
    super.key,
    required this.text,
    this.icon,
    this.fontSize,
    this.iconSize,
    this.color,
    this.borderColor,
    this.onTap,
    this.textColor,
    this.iconColor,
    this.fontWeight,
    this.padding,
    this.selected = true,
    this.prefixIcon,
  });

  final String text;
  final double? fontSize;
  final String? icon;
  final double? iconSize;
  final Function()? onTap;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final bool selected;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          padding:
              padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: selected ? color ?? AppColor.primary : null,
            borderRadius: BorderRadius.circular(6),
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                // SvgUI(
                //   icon,
                //   width: iconSize,
                //   height: iconSize,
                //   color: iconColor,
                // ),
                if (icon != null) divideW4,
              TextWidget(
                text,
                color: textColor ?? AppColor.white,
                fontSize: fontSize ?? 12,
                weight: fontWeight,
              ),
              if (icon != null) divideW4,
              if (prefixIcon != null) prefixIcon!
            ],
          ),
        ),
      ),
    );
  }
}
