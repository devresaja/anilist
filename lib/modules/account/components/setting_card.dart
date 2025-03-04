import 'package:anilist/constant/app_color.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.title,
    this.description,
    this.titleColor,
    this.onTap,
    this.trailing,
  });

  final String title;
  final String? description;
  final Color? titleColor;
  final Function()? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.secondaryAccent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: description == null ? 8.5 : 0),
                  child: TextWidget(
                    title,
                    color: titleColor,
                  ),
                ),
                if (description != null)
                  TextWidget(
                    description,
                    color: AppColor.whiteAccent,
                    fontSize: 12,
                  ),
              ],
            ),
            trailing ?? Icon(Icons.chevron_right, color: AppColor.primary)
          ],
        ),
      ),
    );
  }
}
