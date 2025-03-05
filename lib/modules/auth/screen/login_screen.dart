import 'dart:ui';
import 'package:anilist/constant/dimension.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/routes/route.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/modules/auth/bloc/auth_bloc.dart';
import 'package:anilist/modules/dashboard/screen/dashboard_screen.dart';
import 'package:anilist/services/remote_config_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/button/custom_button.dart';
import 'package:anilist/widget/button/custom_switch_button.dart';
import 'package:anilist/widget/custom_devider.dart';
import 'package:anilist/widget/image/svg_ui.dart';
import 'package:anilist/widget/text/text_widget.dart';
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
  @override
  void initState() {
    super.initState();
    RemoteConfigService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
        body: Stack(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Spacer(),
                  SvgUI(
                    'ic_logo.svg',
                    size: 200,
                  ),
                  const Spacer(),
                  BlocProvider(
                    create: (context) => AuthBloc(),
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is LoginByGoogleLoadedState) {
                          context
                              .read<AppBloc>()
                              .add(SetUserDataEvent(userData: state.userData));

                          showCustomSnackBar('Welcome ${state.userData.email}');

                          pushAndRemoveUntil(context,
                              screen: const DashboardScreen());
                        } else if (state is LoginByGoogleFailedState) {
                          showCustomSnackBar(state.message, isSuccess: false);
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Sign in with Google',
                          isLoading: state is LoginByGoogleLoadingState,
                          imagePath: 'assets/images/google.png',
                          onTap: () {
                            context.read<AuthBloc>().add(LoginByGoogleEvent());
                          },
                        );
                      },
                    ),
                  ),
                  divide24,
                  CustomDivider(
                    text: 'or',
                    textSpacing: MediaQuery.sizeOf(context).width * 0.10,
                  ),
                  divide6,
                  TextButton(
                    onPressed: () {
                      pushAndRemoveUntil(context,
                          screen: const DashboardScreen(),
                          routeName: DashboardScreen.path);
                    },
                    child: const TextWidget(
                      'Continue as Guest',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + 12, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: BlocConsumer<AppBloc, AppState>(
                  buildWhen: (previous, current) => previous != current,
                  listener: (context, state) {},
                  builder: (context, state) {
                    return CustomSwitchButton(
                      value: true,
                      // isLoading:
                      //     state.appStateLoadingType == AppStateLoadingType.notification,
                      switchType: SwitchType.language,
                      enable: false,
                      onChanged: (value) {},
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
