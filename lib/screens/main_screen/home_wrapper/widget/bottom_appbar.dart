import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);
  
  final int selectedIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      currentIndex: selectedIndex,
      elevation: 0,
      iconSize: 30,
      items: [
        BottomNavigationBarItem(
          
          icon: Image.asset(
            "assets/images/icon_home.png",
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/icon_statistik.png",
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
          label: 'Statistik',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/icon_profile.png",
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
          label: 'Profil',
        ),
      ],
      onTap: onItemTapped,
    );
  }
}
