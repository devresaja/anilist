import 'package:anilist/constant/app_constant.dart';
import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AccountDeletionGuideScreen extends StatefulWidget {
  const AccountDeletionGuideScreen({super.key});

  static const String name = 'accountDeletionGuide';
  static const String path = '/account-deletion-guide';

  @override
  State<AccountDeletionGuideScreen> createState() =>
      _AccountDeletionGuideScreenState();
}

class _AccountDeletionGuideScreenState
    extends State<AccountDeletionGuideScreen> {
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
                    'Account Deletion Guide',
                    translate: false,
                    color: AppColor.black,
                    fontSize: 28,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),

                _h2('Data Deletion'),
                const SizedBox(height: 8),
                Text(
                  'When you request to delete your account, the following types of data will be permanently removed within 14 days:',
                  style: _textStyle,
                ),
                const SizedBox(height: 8),
                _bullets([
                  _boldFirst(
                    bold: 'User-Generated Content (UGC):',
                    rest:
                        ' All User-Generated Content (UGC) related to your activity in the application.',
                  ),
                ]),

                const SizedBox(height: 24),
                _h2('Data Retention'),
                const SizedBox(height: 8),
                Text(
                  'While your account data will be deleted, the following data will be retained for operational purposes:',
                  style: _textStyle,
                ),
                const SizedBox(height: 8),
                _bullets([
                  _boldFirst(
                    bold: 'Email:',
                    rest:
                        ' Retained to block further login attempts using the deleted account.',
                  ),
                  _boldFirst(
                    bold: 'Advertising ID:',
                    rest:
                        ' Retained to ensure compliance with advertising policies and improve service relevance.',
                  ),
                ]),

                const SizedBox(height: 24),
                _h2('Guide'),
                const SizedBox(height: 8),
                Text(
                  'If you would like to delete your account, please send us an email with your request.',
                  style: _textStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  'Click the link below to send an email with a pre-filled subject and body:',
                  style: _textStyle,
                ),
                const SizedBox(height: 10),
                _linkLine(
                  text: 'Send Email Request',
                  onTap: () async {
                    final body = '''
                      I would like to request the deletion of my account. Please find the details below:

                      - Name: [Your Name]
                      - Email: [Your Registered Email]
                      ''';
                    final uri = buildMailtoUri(
                      AppConstant.supportEmail,
                      subject: 'Delete Account - Anilist',
                      body: body,
                    );
                    customLaunchUrl(uri.toString());
                  },
                ),

                const SizedBox(height: 24),
                Text(
                  'If the link does not work, you can manually send an email to ',
                  style: _textStyle,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppConstant.supportEmail,
                        style: TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final uri = Uri(
                              scheme: 'mailto',
                              path: AppConstant.supportEmail,
                            );
                            customLaunchUrl(uri.toString());
                          },
                      ),
                      const TextSpan(text: ' with the following template:'),
                    ],
                  ),
                  style: _textStyle,
                ),

                const SizedBox(height: 16),
                _templateBox(),
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

  static Widget _bullets(List<InlineSpan> items) {
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
                      style: TextStyle(
                        color: AppColor.accent,
                        fontSize: 18,
                        height: 1.6,
                      ),
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

  static Widget _linkLine({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: TextWidget(
        text,
        translate: false,
        color: AppColor.primary,
        fontSize: 18,
        weight: FontWeight.w700,
        decoration: TextDecoration.underline,
        decorationColor: AppColor.primary,
        decorationThickness: 1,
      ),
    );
  }

  static Widget _templateBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.secondary.withOpacity(0.6),
        border: Border.all(color: AppColor.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Subject: Delete Account - Anilist\n\n'
        'Body:\n'
        'I would like to request the deletion of my account. Please find the details below:\n\n'
        '- Name: [Your Name]\n'
        '- Email: [Your Registered Email]',
        style: TextStyle(color: AppColor.black, fontSize: 16, height: 1.6),
      ),
    );
  }
}
