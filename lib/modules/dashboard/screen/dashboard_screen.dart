import 'package:anilist/constant/app_color.dart';
import 'package:anilist/modules/account/screen/account_screen.dart';
import 'package:anilist/modules/home/screen/home_screen.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/wrapper/glassmorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String path = 'dashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final _pages = <Widget>[const HomeScreen(), AccountScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight.copyWith(
          statusBarColor: AppColor.secondary),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.secondary,
        body: Stack(
          children: [
            _pages.elementAt(_selectedIndex),
            Align(
              alignment: const Alignment(0.0, 0.95),
              child: Glassmorphism(
                blur: 3,
                opacity: 0.05,
                borderRadius: 300,
                child: Container(
                  padding: const EdgeInsets.all(0.2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(300),
                      border: Border.all(color: AppColor.primary)),
                  width: MediaQuery.sizeOf(context).width * 0.70,
                  child: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home_filled), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: 'Account'),
                    ],
                    currentIndex: _selectedIndex,
                    backgroundColor: Colors.black.withOpacity(0.20),
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
          ],
        ),
      ),
    );
  }
}
