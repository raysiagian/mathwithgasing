import 'package:flutter/material.dart';
import 'package:mathgasing/screens/main_screen/home_screen/pages/home_page.dart';
import 'package:mathgasing/screens/main_screen/home_wrapper/widget/bottom_appbar.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/pages/profile_page.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/pages/statistic_page.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int selectedIndex = 0;
  final pageViewController = PageController();
  
  // get user => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageViewController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          Home(authToken: 'authToken',),
          Statistic(),
          Profile(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          setState(() {
            selectedIndex = index;
            pageViewController.animateTo(
              MediaQuery.of(context).size.width * index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}
