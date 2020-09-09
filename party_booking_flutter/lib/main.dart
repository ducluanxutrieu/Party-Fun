import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/cart/cart_repository.dart';
import 'package:party_booking/screen/main_screen/main_screen.dart';
import 'package:party_booking/screen/splash_screen.dart';
import 'package:party_booking/src/dish_repository.dart';
import 'package:party_booking/src/simple_bloc_observer.dart';
import 'package:party_booking/src/theme.dart';
import 'package:party_booking/theme/theme_bloc.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'login/view/login_page.dart';
import 'screen/cart_detail/cart_detail_screen.dart';
import 'src/authentication_repository.dart';
import 'src/user_repository.dart';

void main() {
  runApp(MyApp(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
    cartRepository: CartRepository(),
  ));
  setupLogging();
}

void setupLogging() {
  Bloc.observer = SimpleBlocObserver();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name} : ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
    @required this.cartRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        assert(cartRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final CartRepository cartRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<DishRepository>(
          create: (context) => DishRepository(),
        ),
        RepositoryProvider<CartRepository>(
          create: (context) => CartRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              userRepository: userRepository,
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(
              cartRepository: cartRepository,
            ),
          ),
          BlocProvider(create: (_) => ThemeBloc()),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.darkThemeEnabled != current.darkThemeEnabled,
      builder: (context, state) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.user != current.user,
              listener: (context, state) {

                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.pushNamedAndRemoveUntil(
                        '/home', (route) => false);
                    break;
                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      LoginPage.route(),
                      (route) => false,
                    );
                    break;
                  default:
                    break;
                }
              },
              child: child,
            );
          },
          theme: state.darkThemeEnabled ? darkThemeData(context) : themeData(context),
          debugShowCheckedModeBanner: false,
          // onGenerateRoute: (_) => MainScreen.route(),
          initialRoute: '/',
          routes: {
            '/cart': (context) => CartPage(),
            '/home': (context) => MainScreen(),
            '/': (_) => SplashScreen(),
          },
        );
      },
    );
  }
}
