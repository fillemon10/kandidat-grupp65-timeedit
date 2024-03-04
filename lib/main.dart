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
  const MyApp({Key? key}) : super(key: key ?? const Key(''));

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;
  ThemeMode _themeMode = ThemeMode.system; // Initialize with system theme

  late List<Widget> screens;

  void onNavBarPageSelected(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  void _handleThemeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode; // Update theme mode
    });
  }

  @override
  void initState() {
    super.initState();
    screens = [
      HomeScreen(),
      BookingScreen(qrCode: "test"),
      MapsScreen(),
      SettingsScreen(
          onThemeChanged:
              _handleThemeChanged), // Initialize with settings screen
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.light,
      )),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 0, 0, 1),
        brightness: Brightness.dark,
      )),
      themeMode: _themeMode, // Use the updated theme mode
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
