import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeedit/blocs/authentication_bloc.dart';
import 'package:timeedit/blocs/booking_bloc.dart';
import 'package:timeedit/blocs/check_in_bloc.dart';
import 'package:timeedit/blocs/filter_bloc.dart';
import 'package:timeedit/blocs/navigation_bloc.dart';
import 'package:timeedit/screens/after-checkin.dart';
import 'package:timeedit/screens/booking.dart';
import 'package:timeedit/screens/checkin.dart';
import 'package:timeedit/screens/favourites.dart';
import 'package:timeedit/screens/firstcome.dart';
import 'package:timeedit/screens/home.dart';
import 'package:timeedit/screens/maps.dart';
import 'package:timeedit/screens/mybookings.dart';
import 'package:timeedit/screens/report-an-issue.dart';
import 'package:timeedit/screens/settings.dart';
import 'package:timeedit/screens/view-rules.dart';
import 'package:timeedit/services/firebase_service.dart';
import 'package:timeedit/widgets/navbar.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  await FirebaseService.initialize(); // Initialize Firebase first
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
      BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc()),
      BlocProvider<BookingBloc>(create: (context) => BookingBloc()),
      BlocProvider<FilterBloc>(create: (context) => FilterBloc()),
      BlocProvider<CheckInBloc>(create: (context) => CheckInBloc()),
    ],
    child: const MyApp(),
  ));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    var isLoggedIn = context.read<AuthenticationBloc>().state ==
        AuthenticationState.authenticated;
    // check if user is authenticated in firebaseAuth
    if (FirebaseAuth.instance.currentUser != null) {
      isLoggedIn = true;
    }

    // Redirect to 'sign-in' if not logged in and not on 'sign-in' or any 'forgot-password/*' route
    if (!isLoggedIn &&
        !state.uri.toString().startsWith('/sign-in/forgot-password')) {
      return '/sign-in';
    }
    return null;
  },
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
        ])
      ],
    ),
    GoRoute(
      path: '/after-checkin/:id',
      builder: (context, state) =>
          AfterCheckInScreen(id: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        return SignInScreen(
          headerBuilder: (context, constraints, shrinkOffset) => Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Center(
                child: SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Log-in to book group rooms at\n campus Johanneberg',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ))
                  ],
                ),
              )
            )),
          ),
          showPasswordVisibilityToggle: true,
          actions: [
            ForgotPasswordAction(((context, email) {
              final uri = Uri(
                // if email is "" it will be "email"
                path:
                    '/sign-in/forgot-password/${email!.isEmpty ? ' ' : email}',
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
          path: 'forgot-password/:email',
          builder: (context, state) {
            return ForgotPasswordScreen(
                email: state.pathParameters['email'].toString());
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
    GoRoute(path: '/view-rules', builder: (context, state) => RulesScreen()),
    GoRoute(
        path: '/report-an-issue',
        builder: (context, state) => ReportIssueScreen()),
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
          tertiary: Color.fromRGBO(161, 39, 39, 1),
          tertiaryContainer: Color.fromRGBO(238, 118, 118, 1),
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(191, 213, 188, 1),
          tertiary: Color.fromRGBO(161, 39, 39, 1),
          tertiaryContainer: Color.fromRGBO(238, 118, 118, 1),
          brightness: Brightness.dark,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
