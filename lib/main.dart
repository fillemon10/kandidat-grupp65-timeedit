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
import 'app_state.dart';
import 'package:provider/provider.dart'; // new
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  ));
}

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
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        return SignInScreen(
          showPasswordVisibilityToggle: true,
          actions: [
            ForgotPasswordAction(((context, email) {
              final uri = Uri(
                path: 'sign-in/forgot-password',
                queryParameters: <String, String?>{
                  'email': email,
                },
              );
              context.push(uri.toString());
            })),
            AuthStateChangeAction(((context, state) {
              final user = switch (state) {
                SignedIn state => state.user,
                UserCreated state => state.credential.user,
                _ => null
              };
              if (user == null) {
                return;
              }
              if (state is UserCreated) {
                user.updateDisplayName(user.email!.split('@')[0]);
              }
              if (!user.emailVerified) {
                user.sendEmailVerification();
                const snackBar = SnackBar(
                    content: Text(
                        'Please check your email to verify your email address'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              context.go('/');
            })),
          ],
        );
      },
      routes: [
        GoRoute(
          path: 'sign-in/forgot-password',
          builder: (context, state) {
            final arguments = state.uri.queryParameters;
            return ForgotPasswordScreen(
              email: arguments['email'],
              headerMaxExtent: 200,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return ProfileScreen(
          providers: const [],
          actions: [
            SignedOutAction((context) {
              context.pushReplacement('/');
            }),
          ],
        );
      },
    ),
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(191, 213, 188, 1),
          brightness: Brightness.dark,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
