import 'package:flutter/material.dart';
import 'package:timeedit/screens/home.dart';
import 'package:timeedit/screens/booking.dart';
import 'package:timeedit/screens/maps.dart';
import 'package:timeedit/screens/settings.dart';
import 'package:timeedit/widgets/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    BookingScreen(qrCode: "test"),
    MapsScreen(),
    SettingsScreen(),
    // Add more screens here
  ];

  void onNavBarPageSelected(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: screens[currentPageIndex],
        bottomNavigationBar: NavBar(
          currentPageIndex: currentPageIndex,
          onNavBarPageSelected: onNavBarPageSelected,
        ),
      ),
    );
  }
}
