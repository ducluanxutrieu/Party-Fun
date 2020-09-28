import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/ui/home/bloc/home_bloc.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  //by default first item will be selected
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Container(
        margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        height: 30,
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: state.listCategories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => context.bloc<HomeBloc>().add(OnPageChangeEvent(itemSelected: index)),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: index != state.listCategories.length - 1
                        ? kDefaultPadding / 4
                        : 0),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                decoration: BoxDecoration(
                  color: index == selectIndex
                      ? Colors.white.withOpacity(0.4)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  state.listCategories[index].name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
      ),
    );
  }
}
