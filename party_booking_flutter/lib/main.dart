import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/screen/main_screen/main_screen.dart';
import 'authentication/bloc/authentication_bloc.dart';
import 'login/view/login_page.dart';
import 'screen/cart_detail/cart_detail_screen.dart';
import 'package:party_booking/screen/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'src/authentication_repository.dart';
import 'src/user_repository.dart';

void main() {
  runApp(MyApp(
    model: CartModel(),
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
  ));
  setupLogging();
}

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name} : ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  final CartModel model;
  const MyApp(
      {Key key,
      @required this.model,
      @required this.authenticationRepository,
      @required this.userRepository})
      : assert(authenticationRepository != null),
        assert(userRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: AppView(model: model),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({
    Key key,
    @required this.model,
  }) : super(key: key);

  final CartModel model;

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CartModel>(
      model: widget.model,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushAndRemoveUntil<void>(
                      MainScreen.route(state.user), (route) => false);
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
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (_) => SplashScreen.route(),
        routes: {'/cart': (context) => CartPage()},
      ),
    );
  }
}
