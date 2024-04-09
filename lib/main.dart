import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeedit/blocs/authentication_bloc.dart';
import 'package:timeedit/blocs/booking_bloc.dart';
import 'package:timeedit/blocs/navigation_bloc.dart';
import 'package:timeedit/screens/after-checkin.dart';
import 'package:timeedit/screens/booking.dart';
import 'package:timeedit/screens/checkin.dart';
import 'package:timeedit/screens/favourite_rooms.dart';
import 'package:timeedit/screens/favourites.dart';
import 'package:timeedit/screens/firstcome.dart';
import 'package:timeedit/screens/home.dart';
import 'package:timeedit/screens/maps.dart';
import 'package:timeedit/screens/mybookings.dart';
import 'package:timeedit/screens/new-booking.dart';
import 'package:timeedit/screens/settings.dart';
import 'package:timeedit/services/firebase_service.dart';
import 'package:timeedit/widgets/navbar.dart';
import 'package:timeedit/screens/filter.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:timeedit/blocs/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  await FirebaseService.initialize(); // Initialize Firebase first
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
      BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc()),
      BlocProvider<BookingBloc>(create: (context) => BookingBloc()),
      BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
      BlocProvider<SettingsBloc>(create: (context) => SettingsBloc())
    ],
    child: const MyApp(),
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
            path: '/booking',
            builder: (context, state) => BookingScreen(),
          ),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/checkin',
            builder: (context, state) => CheckInScreen(),
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
        path: '/new-booking/:room/:time',
        builder: (context, state) => NewBookingScreen(
            room: state.pathParameters['room'].toString(),
            time: state.pathParameters['time'].toString())),
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
    GoRoute(
        path: '/favourite_rooms',
        builder: (context, state) => FavouritesScreen()),
    GoRoute(
        path: '/first-come-first-served',
        builder: (context, state) => FirstComeScreen()),
    GoRoute(
        path: '/my-bookings', builder: (context, state) => MyBookingsScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return MaterialApp.router(
        routerConfig: _router,
        title: 'TimeEdit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(191, 213, 188, 1),
            background: Color(0xFFEFECEC),
            primary: Color(0xFFBFD5BC),
            primaryContainer: Color(0xFFF1F1F1),
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
        themeMode: themeState.themeMode,
      );
    });
  }
}
