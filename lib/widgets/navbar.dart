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
    return NavigationBar(
      onDestinationSelected: onNavBarPageSelected,
      indicatorColor: Colors.blue,
      selectedIndex: currentPageIndex,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Check-in',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_today),
          label: 'Booking',
        ),
        NavigationDestination(
          icon: Icon(Icons.map),
          label: 'Maps',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],

    );
  }
}
