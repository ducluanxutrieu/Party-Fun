import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_posts_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/res/custom_icons_icons.dart';
import 'package:party_booking/ui/post_detail_screen.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPostsScreen extends StatefulWidget {
  @override
  _ListPostsScreenState createState() => _ListPostsScreenState();
}

class _ListPostsScreenState extends State<ListPostsScreen> {
  int currentPage = 0;
  int totalPage = -1;
  List<PostModel> _listPosts = List();

  @override
  void initState() {
    _getListPost();
    super.initState();
  }

  void _getListPost() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(Constants.USER_TOKEN);
    currentPage++;
    var result = await AppApiService.create()
        .getListPosts(token: token, page: currentPage);
    if (result.isSuccessful) {
      totalPage = result.body.listPosts.totalPage;
      setState(() => {_listPosts.addAll(result.body.listPosts.posts)});
      print(_listPosts.length);
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
        itemCount: ((_listPosts.length == 0 ? -1 : _listPosts.length) + 1),
        itemBuilder: (BuildContext itemContext, int index) {
          return _locationItem(index, itemContext);
        },
      ),
    );
  }

  Widget _locationItem(int index, BuildContext context) {
    if (index == _listPosts.length &&
        totalPage != -1 &&
        currentPage < totalPage) {
      return Container(
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
            onTap: () {
              print(currentPage);
              _getListPost();
            },
            child: Icon(
              CustomIcons.ic_more,
              size: 35,
            )),
      );
    } else {
      if (index == _listPosts.length && currentPage == totalPage)
        return SizedBox();
      return ItemPost(
        itemPost: _listPosts[index],
      );
    }
  }
}

class ItemPost extends StatelessWidget {
  const ItemPost({
    Key key,
    @required PostModel itemPost,
  })  : _itemPost = itemPost,
        super(key: key);

  final PostModel _itemPost;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(
                postUrl: _itemPost.link,
                postTitle: _itemPost.title,
              ),
            ),
          );
        },
        title: Text(
          _itemPost.title,
          style: TextStyle(
              fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(_itemPost.featureImage),
          backgroundColor: Colors.transparent,
        ),
        subtitle: Column(
          children: <Widget>[
            Text(_itemPost.summary,
                maxLines: 1,
                style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
                overflow: TextOverflow.ellipsis),
            Text(
                DateFormat(Constants.DATE_TIME_FORMAT_SERVER)
                    .format(_itemPost.createAt),
                maxLines: 1,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlue,
                    fontStyle: FontStyle.italic),
                overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: Text(_itemPost.author,
            maxLines: 2,
            style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent),
            overflow: TextOverflow.ellipsis),
        isThreeLine: true,
      ),
    );
  }
}
