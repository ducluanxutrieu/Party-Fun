import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_posts_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/post_detail_screen.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPostsScreen extends StatefulWidget {
  @override
  _ListPostsScreenState createState() => _ListPostsScreenState();
}

class _ListPostsScreenState extends State<ListPostsScreen> {
  List<PostModel> _listPosts = List();

  @override
  void initState() {
    _getListPost();
    super.initState();
  }

  void _getListPost() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(Constants.USER_TOKEN);
    var result = await AppApiService.create()
        .getListPosts(token: token)
        .catchError((onError) {
      UiUtiu.showToast(message: onError.toString(), isFalse: true);
    });

    if (result.isSuccessful) {
      setState(() {
        _listPosts = result.body.listPosts.posts;
      });
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Posts'),
      ),
      body: ListView.builder(
        itemCount: _listPosts.length,
        itemBuilder: (BuildContext itemContext, int index) {
          return Card(
            color: Colors.white70,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(
                      postUrl: _listPosts[index].link,
                      postTitle: _listPosts[index].title,
                    ),
                  ),
                );
              },
              title: Text(
                _listPosts[index].title,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(_listPosts[index].featureImage),
                backgroundColor: Colors.transparent,
              ),
              subtitle: Column(
                children: <Widget>[
                  Text(_listPosts[index].summary,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16, color: Colors.lightBlueAccent),
                      overflow: TextOverflow.ellipsis),
                  Text(
                      DateFormat(Constants.DATE_TIME_FORMAT_SERVER)
                          .format(_listPosts[index].createAt),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlue,
                          fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
              trailing: Text(_listPosts[index].author,
                  maxLines: 2,
                  style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent),
                  overflow: TextOverflow.ellipsis),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
