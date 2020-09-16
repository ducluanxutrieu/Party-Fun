import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PostDetailScreen extends StatelessWidget {
  final String postUrl;
  final String postTitle;

  PostDetailScreen({@required this.postUrl, @required this.postTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _temp(),
    );
  }

  Widget _temp() {
    return WebviewScaffold(
      url: postUrl,
      appBar: AppBar(
        title: Text(postTitle),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: false,
    );
  }

//  Widget _showWebView() {
//    final flutterWebviewPlugin = new FlutterWebviewPlugin();
//
//    flutterWebviewPlugin.launch(
//      'https://tinhte.vn/thread/trai-nghiem-ticktick-mot-cong-cu-nhac-viec-duoc-nhieu-thanh-vien-tinhte-de-xuat-p1.3135165/',
//      rect: new Rect.fromLTWH(
//        0.0,
//        0.0,
//        MediaQuery.of(context).size.width,
//        300.0,
//      ),
//    );
//  }

 /* void _showHtml() async {
    final response = await http.Client().get(Uri.parse(
        widget.postUrl));

    if (response.statusCode == 200) {
      var document = parse(response.body);
      print('*********************');
//      print(document.getElementsByTagName("p").length);
//      print(document.outerHtml);
      print('*********************');
      setState(() {
        _htmlContent = SingleChildScrollView(
          child: Html(
            data: document.outerHtml,
            shrinkWrap: true,
            onLinkTap: (url) {
              print("Opening $url...");
            },
          ),
        );
      });
    } else {
      throw Exception();
    }
  }*/
}
