import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/modules/account/screen/account_screen.dart';
import 'package:anilist/modules/home/screen/home_screen.dart';
import 'package:anilist/modules/my_list/screen/my_list_screen.dart';
import 'package:anilist/services/deeplink_service.dart';
import 'package:anilist/services/internet_connection_service.dart';
import 'package:anilist/services/remote_config_service.dart';
import 'package:anilist/services/session_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/wrapper/glassmorphism.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String path = 'dashboardScreen';

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
      value: (context.read<AppBloc>().state.isDarkMode
              ? systemUiOverlayStyleLight
              : systemUiOverlayStyleDark)
          .copyWith(statusBarColor: AppColor.secondary),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.secondary,
        body: Stack(
          children: [
            [
              const HomeScreen(),
              MyListScreen(),
              AccountScreen(
                onValueChanged: () {
                  setState(() {});
                },
              ),
            ].elementAt(_selectedIndex),
            Align(
              alignment: const Alignment(0.0, 0.95),
              child: Glassmorphism(
                blur: 1,
                opacity: 0.05,
                borderRadius: 300,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(300),
                      border: Border.all(color: AppColor.primary)),
                  width: MediaQuery.sizeOf(context).width * 0.70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: BottomNavigationBar(
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_filled),
                          label: LocaleKeys.home.tr(),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.my_library_books_rounded),
                          label: LocaleKeys.mylist.tr(),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: LocaleKeys.account.tr(),
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      backgroundColor: context.read<AppBloc>().state.isDarkMode
                          ? Colors.black.withOpacity(0.20)
                          : Colors.black,
                      selectedItemColor: AppColor.primary,
                      unselectedItemColor: Colors.white,
                      selectedLabelStyle: const TextStyle(fontSize: 12),
                      showUnselectedLabels: false,
                      showSelectedLabels: true,
                      onTap: _onItemTapped,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
