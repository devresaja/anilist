import 'package:anilist/constant/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/routes/route.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/modules/account/components/setting_card.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/button/custom_switch_button.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const String path = 'account';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    isLogin = context.read<AppBloc>().state.user != null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._applicationSection(context),
                divide24,
                ..._otherInfoSection(context),
                divide24,
                ..._accountSection(context),
                SizedBox(
                    height: kBottomNavigationBarHeight +
                        MediaQuery.paddingOf(context).bottom +
                        20)
              ],
            ),
          )),
    );
  }

  List<Widget> _applicationSection(BuildContext context) {
    return [
      _sectionHeader('Application Settings'),
      divide12,
      SettingCard(
        title: 'Language',
        description: 'Choose your language',
        trailing: CustomSwitchButton(
          value: true,
          // isLoading:
          //     state.appStateLoadingType == AppStateLoadingType.notification,
          switchType: SwitchType.language,
          enable: false,
          onChanged: (value) {},
        ),
      ),
      divide8,
      SettingCard(
        title: 'Notification',
        description: 'Enable notification',
        trailing: BlocConsumer<AppBloc, AppState>(
          buildWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state.appStateErrorType == AppStateErrorType.notification) {
              showConfirmationDialog(
                context: context,
                title: 'Allow permission to receive notification',
                okText: 'Settings',
                onTapOk: () async {
                  await openAppSettings();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            }
          },
          builder: (context, state) {
            return CustomSwitchButton(
              value: state.isNotificationEnable,
              isLoading:
                  state.appStateLoadingType == AppStateLoadingType.notification,
              onChanged: (value) {
                context
                    .read<AppBloc>()
                    .add(UpdateNotificationSettingEvent(isEnable: value));
              },
            );
          },
        ),
      ),
      divide8,
      SettingCard(
        title: 'Dark Mode',
        trailing: BlocBuilder<AppBloc, AppState>(
          buildWhen: (previous, current) =>
              previous.isDarkMode != current.isDarkMode,
          builder: (context, state) {
            return CustomSwitchButton(
              value: state.isDarkMode,
              initialValue: state.isDarkMode,
              enable: false,
              onChanged: (value) {
                context
                    .read<AppBloc>()
                    .add(UpdateThemeEvent(isDarkMode: value));
              },
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _otherInfoSection(BuildContext context) {
    return [
      _sectionHeader('Other Information'),
      divide12,
      SettingCard(
        title: 'Privacy Policy',
        onTap: () {
          customLaunchUrl(
              'https://anilist-433306.firebaseapp.com/privacy_policy.html');
        },
      ),
      divide8,
      SettingCard(
        title: 'Leave a Review',
        titleColor: Colors.yellow,
        description: 'v1.0.0',
        onTap: () {
          customLaunchUrl(
              'https://play.google.com/store/apps/details?id=com.android.anilist');
        },
        trailing: Icon(Icons.star, color: Colors.yellow),
      ),
    ];
  }

  List<Widget> _accountSection(BuildContext context) {
    return [
      _sectionHeader('Account Settings'),
      divide12,
      if (isLogin) ...[
        SettingCard(
          title: 'Delete Account',
          description: 'Delete your account permanently',
          titleColor: AppColor.error,
          onTap: () {
            customLaunchUrl(
                'https://anilist-433306.firebaseapp.com/delete_account_guide.html');
          },
          trailing: Icon(Icons.delete, color: AppColor.error),
        ),
        divide8,
        SettingCard(
          title: 'Logout',
          titleColor: AppColor.error,
          onTap: () async {
            showConfirmationDialog(
                context: context,
                title: 'Are you sure want to logout?',
                onTapOk: () async {
                  Navigator.pop(context);
                  await GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  await LocalStorageService.removeValue();

                  if (context.mounted) {
                    context.read<AppBloc>().add(RemoveUserDataEvent());
                    pushAndRemoveUntil(context, screen: LoginScreen());
                  }
                });
          },
          trailing: Icon(Icons.logout, color: AppColor.error),
        ),
      ] else ...[
        SettingCard(
          title: 'Login',
          titleColor: AppColor.primary,
          onTap: () {
            pushAndRemoveUntil(context, screen: LoginScreen());
          },
          trailing: Icon(Icons.login, color: AppColor.primary),
        ),
      ],
    ];
  }

  TextWidget _sectionHeader(String text) {
    return TextWidget(
      text,
      fontSize: 16,
    );
  }
}