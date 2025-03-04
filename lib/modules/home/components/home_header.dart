import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          title,
          fontSize: 18,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}
