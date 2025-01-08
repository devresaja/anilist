import 'package:anilist/constant/app_color.dart';
import 'package:flutter/material.dart';

class CostumTextField extends StatelessWidget {
  const CostumTextField({
    super.key,
    required this.textController,
    this.obscure,
    this.visible,
    this.ontap,
    required this.hint,
    required this.prefixIcon,
  });

  final TextEditingController textController;
  final bool? obscure;
  final bool? visible;
  final VoidCallback? ontap;
  final String hint;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .85,
      height: .08,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColor.primary)),
      padding: const EdgeInsets.only(
        left: .03,
        right: .03,
      ),
      child: TextField(
          controller: textController,
          cursorColor: AppColor.primary,
          obscureText: obscure ?? false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColor.accent, fontSize: .04),
            prefixIcon: Icon(
              prefixIcon,
              color: AppColor.accent,
              size: .07,
            ),
            suffixIcon: visible != null
                ? GestureDetector(
                    onTap: ontap,
                    child: Icon(
                        visible == true
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColor.accent,
                        size: .07),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0.025,
            ),
          )),
    );
  }
}
