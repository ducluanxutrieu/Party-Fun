import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/cart/cart_repository.dart';
import 'package:party_booking/dish/dish_bloc.dart';
import 'package:party_booking/ui/home/home_page.dart';
import 'package:party_booking/ui/splash_screen.dart';
import 'package:party_booking/src/dish_repository.dart';
import 'package:party_booking/src/simple_bloc_observer.dart';
import 'package:party_booking/src/theme.dart';
import 'package:party_booking/theme/theme_bloc.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'ui/login/view/login_page.dart';
import 'src/authentication_repository.dart';
import 'src/user_repository.dart';
import 'ui/cart_detail/cart_detail_page.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
    cartRepository: CartRepository(),
    dishRepository: DishRepository(),
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

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
    @required this.cartRepository,
    @required this.dishRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        assert(cartRepository != null),
        assert(dishRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final CartRepository cartRepository;
  final DishRepository dishRepository;


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
          BlocProvider(
            create: (context) => DishBloc(dishRepository),
          ),
          BlocProvider(
            create: (context) => ThemeBloc(),
          )
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.darkThemeEnabled != current.darkThemeEnabled,
      builder: (context, state) => MaterialApp(
        navigatorKey: _navigatorKey,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    MainScreen.route(),
                        (route) => false,
                  );
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
        onGenerateRoute: Router.generateRoute,
        theme: state.darkThemeEnabled ? darkThemeData(context) : themeData(context),
      ),
    );
  }
}


/*
class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
    @required this.cartRepository,
    @required this.dishRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        assert(cartRepository != null),
        assert(dishRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final CartRepository cartRepository;
  final DishRepository dishRepository;

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
          BlocProvider(
            create: (_) => DishBloc(dishRepository),
          )
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
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          // listenWhen: (previous, current) =>
          //     previous.status != current.status ||
          //     previous.user != current.user,
          listener: (context, state) {
            print('main listener');
            print(state.status);
            print('main listener');
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil('/home', (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      body: Center(
                          child: Text('No route defined for')),
                    ));
            }
          },
          child: child,
        );
      },
      theme: */
/*state.darkThemeEnabled ? darkThemeData(context) : *//*
 themeData(
          context),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Router.generateRoute,
      initialRoute: '/',
    );
  }
}


*/

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/cart':
        return MaterialPageRoute(builder: (_) => CartPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}
