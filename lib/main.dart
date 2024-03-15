
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeedit/screens/after-checkin.dart';
import 'package:timeedit/screens/book.dart';
import 'package:timeedit/screens/checkin.dart';
import 'package:timeedit/screens/home.dart';
import 'package:timeedit/screens/maps.dart';
import 'package:timeedit/screens/settings.dart';
import 'package:timeedit/widgets/navbar.dart';
import 'package:timeedit/screens/filter.dart';

void main() => runApp(MyApp());

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavbar(navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _sectionNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (context, state) => HomeScreen(),
              routes: <RouteBase>[],
            ),
          ],
        ),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/book',
            builder: (context, state) => BookScreen(),
          ),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/maps',
            builder: (context, state) => MapsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/settings',
            builder: (context, state) => SettingsScreen(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/checkin',
      builder: (context, state) => CheckInScreen(),
    ),
    GoRoute(
        path: '/checkin/:id',
        builder: (context, state) =>
            AfterCheckInScreen(id: state.pathParameters['id'].toString())),
    GoRoute(
      path: '/filter',
      builder: (context, state) {
        return FilterScreen();
      },
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'TimeEdit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(191, 213, 188, 1),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(191, 213, 188, 1),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
