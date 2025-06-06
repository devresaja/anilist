import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/widget/button/custom_button.dart';
import 'package:anilist/widget/image/svg_ui.dart';
import 'package:anilist/widget/text/text_widget.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  static const String path = '/not-found';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          double clamp(double value, double min, double max) {
            return value.clamp(min, max);
          }

          final iconSize = clamp(width * 0.25, 120, 160);
          final titleFontSize = clamp(width * 0.03, 16, 20);
          final subtitleFontSize = clamp(width * 0.03, 14, 16);
          final buttonWidth = clamp(width * 0.4, 200, 300);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgUI('ic_error.svg', size: iconSize),
                divide24,
                TextWidget(
                  LocaleKeys.page_not_found,
                  fontSize: titleFontSize,
                  weight: FontWeight.bold,
                ),
                divide8,
                TextWidget(
                  LocaleKeys.page_not_found_description,
                  fontSize: subtitleFontSize,
                  color: AppColor.accent,
                ),
                divide32,
                CustomButton(
                  width: buttonWidth,
                  text: LocaleKeys.back,
                  color: AppColor.secondary,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
