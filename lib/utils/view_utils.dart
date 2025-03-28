import 'package:anilist/constant/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/routes/navigator_key.dart';
import 'package:anilist/core/routes/route.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:anilist/widget/button/custom_button.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

SystemUiOverlayStyle systemUiOverlayStyleLight = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light);

Widget loading({double? size}) {
  return Center(
    child: SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator.adaptive(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(AppColor.primary),
        strokeWidth: 3,
      ),
    ),
  );
}

Widget refreshComponent({required Function() onTap}) {
  return IconButton(
    onPressed: onTap,
    icon: const Icon(
      Icons.refresh,
      color: AppColor.primary,
    ),
  );
}

void showCustomSnackBar(String text, {bool isSuccess = true}) {
  ScaffoldMessenger.of(navigatorKey.currentState!.context)
      .showSnackBar(SnackBar(
    content: Row(
      children: [
        Icon(
          isSuccess ? Icons.check_circle : Icons.error_outline,
          color: isSuccess ? AppColor.primary : AppColor.error,
        ),
        const SizedBox(width: 10),
        Flexible(child: TextWidget(text))
      ],
    ),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.blueGrey,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ));
}

void showAccessDeniedDialog(BuildContext context) {
  showConfirmationDialog(
    context: context,
    title: 'Access Denied',
    description: 'Please log in to continue.',
    okText: 'Log In',
    onTapOk: () => pushAndRemoveUntil(context, screen: LoginScreen()),
  );
}

Future<dynamic> showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? description,
  String? infoText,
  String? okText,
  String? cancelText,
  Function()? onTapOk,
  Function()? onTapCancel,
  bool barrierDismissible = true,
  bool hideCancel = false,
}) async {
  return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return barrierDismissible;
          },
          child: AlertDialog(
            backgroundColor: AppColor.secondary,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  title,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w500,
                  fontSize: 16,
                ),
                if (description != null) divide4,
                if (description != null)
                  TextWidget(
                    description,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    color: AppColor.whiteAccent,
                  ),
                if (infoText != null) divide4,
                if (infoText != null)
                  TextWidget(
                    infoText,
                    fontSize: 12,
                    color: AppColor.errorText,
                  ),
                divide12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (!hideCancel)
                      Flexible(
                        child: CustomButton(
                            color: Colors.red,
                            borderColor: Colors.red,
                            textColor: Colors.white,
                            text: cancelText ?? 'Close',
                            fontSize: 12,
                            onTap: onTapCancel ??
                                () {
                                  Navigator.pop(context);
                                }),
                      ),
                    if (!hideCancel) divideW10,
                    Flexible(
                      child: CustomButton(
                        textColor: Colors.black,
                        color: AppColor.primary,
                        text: okText ?? 'Yes',
                        fontSize: 12,
                        onTap: onTapOk ??
                            () {
                              Navigator.pop(context);
                            },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}

Future<void> customLaunchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    showCustomSnackBar('Could not launch $url', isSuccess: false);
  }
}
