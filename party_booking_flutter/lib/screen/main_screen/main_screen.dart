import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/authentication/bloc/authentication_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/home/bloc/home_bloc.dart';
import 'package:party_booking/screen/modify_disk/modify_dish_screen.dart';
import 'package:party_booking/src/dish_repository.dart';

import 'components/drawer.dart';
import 'components/main_app_bar.dart';
import 'components/main_list_menu.dart';

class MainScreen extends StatelessWidget {

  void _goToAddDish(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ModifyDishScreen(isAddNewDish: true,)));
  }
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('Main Screen Init');
    return RepositoryProvider(
      create: (context) => DishRepository(),
      child: BlocProvider(
        create: (context) => HomeBloc(dishRepository: new DishRepository()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          buildWhen: (previous, current) =>
              previous.status != current.status || previous.user != current.user,
          builder: (context, authState) {
            print('Main Screen Bloc Authentication Builder');
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: MainAppBar(fullName: authState.user.fullName, textController: _textController,),
              ),
              floatingActionButton: buildFABAddNewDish(context, authState.user),
              drawer: MainDrawer(
                accountModel: authState.user,
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  context.bloc<HomeBloc>().add(GetListDishEvent());
                  Future.delayed(Duration(milliseconds: 300));
                  return;
                },
                child: MainListMenu(
                  accountModel: authState.user,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Visibility buildFABAddNewDish(
      BuildContext context, AccountModel accountModel) {
    bool isVisible =
        (accountModel != null && accountModel.role == Role.Staff.index);
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton(
        onPressed: () => _goToAddDish(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
