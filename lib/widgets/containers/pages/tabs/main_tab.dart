// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/widgets/containers/pages/tabs/appointment.dart';
import 'package:barangay_repository_app/widgets/containers/pages/tabs/home.dart';
import 'package:barangay_repository_app/widgets/containers/pages/tabs/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:barangay_repository_app/constants/colors.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  FirebaseQuery firebaseQuery = FirebaseQuery();
  PageController _pageController = new PageController();
  int _selectedIndex = 0;
  int maxCount = 3;

  /// widget list
  final List<Widget> bottomBarPages = [
    const HomePage(),
    const AppointmentPage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    firebaseQuery.main();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: bottomBarPages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.primaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Home',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar),
              label: 'Apoointment',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Me',
              backgroundColor: Colors.green,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
