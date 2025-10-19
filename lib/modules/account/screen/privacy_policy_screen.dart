import 'package:anilist/constant/app_constant.dart';
import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/modules/account/screen/account_deletion_guide_screen.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  static const String name = 'privacyPolicy';
  static const String path = '/privacy-policy';

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final _textStyle = TextStyle(
    color: AppColor.accent,
    fontSize: 18,
    height: 1.6,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,

      body: SafeArea(
        child: DefaultTextStyle.merge(
          style: _textStyle,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TextWidget(
                    'Privacy Policy',
                    translate: false,
                    color: AppColor.black,
                    fontSize: 28,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                // Effective Date line
                _labelValue(
                  context,
                  label: 'Effective Date:',
                  value: '30 March, 2025',
                ),
                const SizedBox(height: 18),

                TextWidget(
                  'At Anilist, we value your privacy and are committed to protecting your personal data. This Privacy Policy explains how we share your information when you access or use our services.',
                  translate: false,
                  color: AppColor.black,
                  fontSize: 18,
                ),

                const SizedBox(height: 24),
                _h2('1. Information We Collect & Share'),
                const SizedBox(height: 8),
                Text(
                  'We may collect & share the following types of information:',
                  style: _textStyle,
                ),
                const SizedBox(height: 8),
                _bullets(context, [
                  _boldFirst(
                    bold: 'Personal Information:',
                    rest:
                        ' This includes your name, email address, and other information you provide directly to us when creating a profile or interacting with the app.',
                  ),
                  _boldFirst(
                    bold: 'App Activity:',
                    rest:
                        ' Information related to your interactions and usage patterns within the app may be shared to enhance the user experience or provide support services.',
                  ),
                  _boldFirst(
                    bold: 'Advertising ID:',
                    rest:
                        " Your device's advertising ID may be shared with third-party advertising partners to serve personalized ads and measure their performance. This information is used in accordance with applicable data protection laws.",
                  ),
                ]),

                const SizedBox(height: 24),
                _h2('2. Sharing and Disclosure of Information'),
                const SizedBox(height: 8),
                Text(
                  'We share your data only in the following cases:',
                  style: _textStyle,
                ),
                const SizedBox(height: 8),
                _bullets(context, [
                  _boldFirst(
                    bold: 'With Service Providers:',
                    rest:
                        ' We work with third-party service providers to help us operate and manage the app, such as hosting and data management. These service providers will only use the data we share for the purposes we outline.',
                  ),
                  _boldFirst(
                    bold: 'To Comply with Legal Obligations:',
                    rest:
                        ' We may disclose your personal information if required by law or if we believe such disclosure is necessary to protect our rights, property, or safety.',
                  ),
                ]),

                const SizedBox(height: 24),
                _h2('3. Data Security'),
                const SizedBox(height: 8),
                Text(
                  'We are committed to protecting your personal information by using appropriate security measures.',
                  style: _textStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  'However, please note that no system can be completely secure, and we cannot guarantee absolute security for data transmitted or stored in our app.',
                  style: _textStyle,
                ),

                const SizedBox(height: 24),
                _h2('4. Your Rights'),
                const SizedBox(height: 8),
                _bullets(context, [
                  _boldFirst(
                    bold: 'Deletion:',
                    rest:
                        ' You can request to delete your personal information from our records.',
                  ),
                ]),
                const SizedBox(height: 8),
                Text(
                  'If you want to delete your account, please refer to the guide provided below:',
                  style: _textStyle,
                ),
                const SizedBox(height: 6),
                _linkLine(
                  context,
                  text: 'Account Deletion Guide',
                  onTap: () async {
                    if (kIsWeb) {
                      context.pushNamed(AccountDeletionGuideScreen.name);
                    } else {
                      customLaunchUrl(AppConstant.accountDeletionGuide);
                    }
                  },
                ),

                const SizedBox(height: 24),
                _h2('5. Data Retention'),
                const SizedBox(height: 8),
                Text(
                  'We will retain your data for as long as necessary to fulfill the purposes outlined in this Privacy Policy, or as required by law.',
                  style: _textStyle,
                ),

                const SizedBox(height: 24),
                _h2("6. Children's Privacy"),
                const SizedBox(height: 8),
                Text(
                  'We do not knowingly collect personal information from children under the age of 13. If we learn that we have inadvertently collected personal information from a child under 13, we will delete that data as soon as possible.',
                  style: _textStyle,
                ),

                const SizedBox(height: 24),
                _h2('7. Changes to This Privacy Policy'),
                const SizedBox(height: 8),
                Text(
                  'We may update this Privacy Policy from time to time. Any changes will be posted on this page with the updated date. We encourage you to review this Privacy Policy periodically to stay informed about how we are protecting your data.',
                  style: _textStyle,
                ),

                const SizedBox(height: 24),
                _h2('8. Contact Us'),
                const SizedBox(height: 8),
                Text(
                  'If you have any questions or concerns about this Privacy Policy, or if you would like to exercise your rights as mentioned above, please contact us at:',
                  style: _textStyle,
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Email: ',
                        style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: AppConstant.supportEmail,
                        style: TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                          decorationColor: AppColor.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final uri = buildMailtoUri(
                              AppConstant.supportEmail,
                              subject: 'Privacy Policy Support',
                            );
                            customLaunchUrl(uri.toString());
                          },
                      ),
                    ],
                  ),
                  style: _textStyle,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _h2(String text) {
    return TextWidget(
      text,
      translate: false,
      color: AppColor.black,
      fontSize: 18,
      weight: FontWeight.w700,
    );
  }

  static Widget _labelValue(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColor.black,
          fontSize: 18,
          height: 1.6,
        ) ??
        TextStyle(color: AppColor.black, fontSize: 18, height: 1.6);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Effective Date: ',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      style: textStyle,
    );
  }

  static Widget _bullets(BuildContext context, List<InlineSpan> items) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColor.accent,
          fontSize: 18,
          height: 1.6,
        ) ??
        TextStyle(color: AppColor.accent, fontSize: 18, height: 1.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (span) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      color: AppColor.accent,
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [span]),
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  static InlineSpan _boldFirst({required String bold, required String rest}) {
    return TextSpan(
      children: [
        TextSpan(
          text: bold,
          style: TextStyle(color: AppColor.black, fontWeight: FontWeight.w700),
        ),
        const TextSpan(text: ' '),
        TextSpan(
          text: rest.trimLeft(),
          style: TextStyle(color: AppColor.accent, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  static Widget _linkLine(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
  }) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColor.primary,
          fontSize: 18,
          height: 1.6,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
          decorationThickness: 1,
          decorationColor: AppColor.primary,
        ) ??
        TextStyle(
          color: AppColor.primary,
          fontSize: 18,
          height: 1.6,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
          decorationThickness: 1,
          decorationColor: AppColor.primary,
        );

    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Text(text, style: textStyle),
      ),
    );
  }
}
