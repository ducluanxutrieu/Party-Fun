import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/src/dish_repository.dart';
import 'package:party_booking/ui/home/components/dish_card.dart';
import 'package:party_booking/ui/search/bloc/search_bloc.dart';
import 'package:party_booking/widgets/search_box.dart';

class HomeSearch extends StatelessWidget {
  HomeSearch(this.accountModel);

  final AccountModel accountModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) =>
              SearchBloc(RepositoryProvider.of<DishRepository>(context)),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) => Column(
              children: [
                SearchBox(
                  onChanged: (searchText) => context
                      .bloc<SearchBloc>()
                      .add(OnSearchDishChangeEvent(searchText: searchText)),
                ),
                state.listDishes.isNotEmpty
                    ? _itemGridView(state.listDishes, accountModel, context)
                    : Flexible(
                        fit: FlexFit.tight,
                        child: Hero(
                            tag: 'search_id',
                            child: Lottie.asset(
                              Assets.animSearch,
                              width: 300,
                            )),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemGridView(
      List<DishModel> dishes, AccountModel accountModel, BuildContext context) {
    return Expanded(
      child: StaggeredGridView.countBuilder(
        scrollDirection: Axis.vertical,
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        itemCount: dishes.length,
        itemBuilder: (BuildContext context, int index) => DishCard(
          dishModel: dishes[index],
          accountModel: accountModel,
        ),
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        primary: false,
        shrinkWrap: true,
      ),
    );
  }
}
