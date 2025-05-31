import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/widget/image/svg_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hintText, icon;
  final TextEditingController? controller;
  final bool readOnly, withPaddingHorizontal, autoFocus;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final void Function()? onTap;
  final Color? color;
  final double? width, radius, iconSize, height;
  final EdgeInsetsGeometry? padding, margin;
  const CustomSearchBar({
    super.key,
    this.hintText,
    this.icon,
    this.iconSize,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.withPaddingHorizontal = true,
    this.autoFocus = false,
    this.onTap,
    this.color,
    this.width,
    this.padding,
    this.margin,
    this.radius,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: withPaddingHorizontal ? 16 : 0.0,
          ),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 40,
        decoration: BoxDecoration(
            color: color ?? AppColor.secondary,
            borderRadius: BorderRadius.circular(radius ?? 300),
            border: Border.all(color: Colors.blueGrey)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 6),
              child: SvgUI(
                icon ?? 'ic_search.svg',
                size: iconSize,
              ),
            ),
            Flexible(
              child: TextField(
                readOnly: readOnly,
                controller: controller,
                autofocus: autoFocus,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: AppColor.black,
                ),
                onTap: onTap,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 13.5),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: hintText?.tr(),
                  hintStyle: TextStyle(
                    color: AppColor.whiteAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
