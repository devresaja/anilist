import 'dart:ui';
import 'package:anilist/constant/dimension.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/core/routes/route.dart';
import 'package:anilist/extension/view_extension.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/modules/auth/bloc/auth_bloc.dart';
import 'package:anilist/modules/dashboard/screen/dashboard_screen.dart';
import 'package:anilist/services/deeplink_service.dart';
import 'package:anilist/services/remote_config_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/button/custom_button.dart';
import 'package:anilist/widget/button/custom_switch_button.dart';
import 'package:anilist/widget/custom_devider.dart';
import 'package:anilist/widget/image/svg_ui.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String path = 'loginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    RemoteConfigService.instance.init();
    DeepLinkService.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: SafeArea(
        child: Scaffold(
          body: BlocProvider(
            create: (context) => _authBloc,
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.srcOver),
                  child: Image(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    image: const AssetImage('assets/images/zero.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Padding(
                  padding: Dimension.horizontalPadding,
                  child: context.isWideScreen
                      ? _buildWideScreen(context)
                      : _buildSmallScreen(context),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, right: 16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CustomSwitchButton(
                      value: context.locale.languageCode == 'en',
                      switchType: SwitchType.language,
                      onChanged: (value) {
                        context.setLocale(Locale(value == true ? 'en' : 'id'));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SvgUI(
                    'ic_logo.svg',
                    size: constraints.maxWidth * 0.6,
                  );
                },
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLoginButton(),
                  divide24,
                  CustomDivider(
                    text: LocaleKeys.or,
                    textSpacing: MediaQuery.sizeOf(context).width * 0.06,
                  ),
                  divide6,
                  _buildGuestButton(context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _buildSmallScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const Spacer(),
        SvgUI(
          'ic_logo.svg',
          size: 200,
        ),
        const Spacer(),
        _buildLoginButton(),
        divide24,
        CustomDivider(
          text: LocaleKeys.or,
          textSpacing: MediaQuery.sizeOf(context).width * 0.10,
        ),
        divide6,
        _buildGuestButton(context),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.02,
        )
      ],
    );
  }

  TextButton _buildGuestButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(300),
        ),
      ),
      onPressed: () {
        pushAndRemoveUntil(context,
            screen: const DashboardScreen(), routeName: DashboardScreen.path);
      },
      child: TextWidget(
        LocaleKeys.continue_as_guest,
      ),
    );
  }

  BlocConsumer<AuthBloc, AuthState> _buildLoginButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is LoginByGoogleLoadedState) {
          context
              .read<AppBloc>()
              .add(SetUserDataEvent(userData: state.userData));

          showCustomSnackBar(
              '${LocaleKeys.welcome.tr()} ${state.userData.email}');

          pushAndRemoveUntil(context, screen: const DashboardScreen());
        } else if (state is LoginByGoogleFailedState) {
          showCustomSnackBar(state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        return CustomButton(
          text: LocaleKeys.sign_in_with_google,
          isLoading: state is LoginByGoogleLoadingState,
          imagePath: 'assets/images/google.png',
          onTap: () {
            _authBloc.add(LoginByGoogleEvent());
          },
        );
      },
    );
  }
}
