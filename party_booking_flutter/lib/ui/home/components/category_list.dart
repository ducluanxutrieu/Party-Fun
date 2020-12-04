import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/ui/home/bloc/home_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  //by default first item will be selected
  // int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ItemScrollController itemScrollController = ItemScrollController();
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.selectedPage != current.selectedPage,
      listener: (context, state) => itemScrollController.scrollTo(
          index: state.selectedPage,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease),
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.selectedPage != current.selectedPage ||
            previous.listMenu != current.listMenu,
        builder: (context, state) => Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          height: 30,
          width: MediaQuery.of(context).size.width,
          child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              physics: BouncingScrollPhysics(),
              itemCount: state.listMenu.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () => context
                        .read<HomeBloc>()
                        .add(OnPageChangeEvent(itemSelected: index)),
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: kDefaultPadding,
                          right: index != state.listMenu.length - 1
                              ? kDefaultPadding / 4
                              : 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      decoration: BoxDecoration(
                        color: index == state.selectedPage
                            ? Theme.of(context).textTheme.headline5.color.withOpacity(0.4)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        state.listMenu[index].menuName,
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
