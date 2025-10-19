import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/extension/view_extension.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/modules/account/screen/account_screen.dart';
import 'package:anilist/modules/home/screen/home_screen.dart';
import 'package:anilist/modules/my_list/screen/my_list_screen.dart';
import 'package:anilist/services/deeplink_service.dart';
import 'package:anilist/services/internet_connection_service.dart';
import 'package:anilist/services/remote_config_service.dart';
import 'package:anilist/services/session_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:anilist/widget/wrapper/glassmorphism.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String name = 'dashboard';
  static const String path = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    InternetConnectionService.instance.init();
    SessionService.instance.init(context);
    RemoteConfigService.instance.init();
    DeepLinkService.init(context);
  }

  @override
  void dispose() {
    SessionService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          (context.read<AppBloc>().state.isDarkMode
                  ? systemUiOverlayStyleLight
                  : systemUiOverlayStyleDark)
              .copyWith(statusBarColor: AppColor.secondary),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.secondary,
        body: Stack(
          children: [
            Row(
              children: [
                if (context.isWideScreen) _buildNaviRail(context),
                Expanded(
                  child: [
                    const HomeScreen(),
                    MyListScreen(),
                    AccountScreen(
                      onValueChanged: () {
                        setState(() {});
                      },
                    ),
                  ].elementAt(_selectedIndex),
                ),
              ],
            ),
            if (!context.isWideScreen) _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  Align _buildBottomNav(BuildContext context) {
    return Align(
      alignment: const Alignment(0.0, 0.95),
      child: Glassmorphism(
        blur: 1,
        opacity: 0.05,
        borderRadius: 300,
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.70,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(300),
            border: Border.all(color: AppColor.primary),
            color: context.read<AppBloc>().state.isDarkMode
                ? Colors.black.withOpacity(0.20)
                : Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_filled,
                label: LocaleKeys.home.tr(),
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.my_library_books_rounded,
                label: LocaleKeys.mylist.tr(),
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.person,
                label: LocaleKeys.account.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          height: 64,
          width: 64,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? AppColor.primary : Colors.white,
                    size: constraint.minHeight * 0.38,
                  ),
                  const SizedBox(height: 4),
                  if (isSelected)
                    TextWidget(
                      label,
                      fontSize: constraint.maxHeight * 0.19,
                      color: isSelected ? AppColor.primary : Colors.white,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNaviRail(BuildContext context) {
    return Glassmorphism(
      blur: 1,
      opacity: 0.05,
      borderRadius: 0,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: context.read<AppBloc>().state.isDarkMode
              ? Colors.black
              : Colors.white,
          border: Border(right: BorderSide(color: AppColor.primary)),
        ),
        child: SafeArea(
          right: false,
          left: false,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildNavRailItem(
                  index: 0,
                  icon: Icons.home_filled,
                  label: LocaleKeys.home.tr(),
                ),
                divide16,
                _buildNavRailItem(
                  index: 1,
                  icon: Icons.my_library_books_rounded,
                  label: LocaleKeys.mylist.tr(),
                ),
                divide16,
                _buildNavRailItem(
                  index: 2,
                  icon: Icons.person,
                  label: LocaleKeys.account.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavRailItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(300),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(300),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColor.primary
                    : context.read<AppBloc>().state.isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
              divideW16,
              TextWidget(
                label,
                color: isSelected
                    ? AppColor.primary
                    : context.read<AppBloc>().state.isDarkMode
                    ? Colors.white
                    : Colors.black,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
