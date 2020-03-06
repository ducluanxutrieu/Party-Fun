import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';

class DishDetailScreen extends StatefulWidget {
  final DishModel dishModel;

  DishDetailScreen({Key key, @required this.dishModel});

  @override
  _DishDetailScreenState createState() =>
      _DishDetailScreenState(dishModel: dishModel);
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  final DishModel dishModel;

  _DishDetailScreenState({@required this.dishModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dishModel.name),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                dishModel.image[0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    dishModel.name,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dishModel.type,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 22),
                  ),
                  Expanded(
                    child: Text(
                      dishModel.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
