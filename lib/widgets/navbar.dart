import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentPageIndex;
  final ValueChanged<int> onNavBarPageSelected;

  const NavBar({
    Key? key,
    required this.currentPageIndex,
    required this.onNavBarPageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner_outlined),
        onPressed: () {
          onNavBarPageSelected(2);
        },
        //larger
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onNavBarPageSelected,
        selectedIndex: currentPageIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Maps',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
