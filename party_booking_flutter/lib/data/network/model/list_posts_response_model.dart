import 'dart:convert';

ListPostsResponseModel listPostsResponseModelFromJson(String str) => ListPostsResponseModel.fromJson(json.decode(str));

String listPostsResponseModelToJson(ListPostsResponseModel data) => json.encode(data.toJson());

class ListPostsResponseModel {
  String message;
  ListPosts listPosts;

  ListPostsResponseModel({
    this.message,
    this.listPosts,
  });

  static ListPostsResponseModel fromJsonFactory(Map<String, dynamic> json) => ListPostsResponseModel.fromJson(json);

  factory ListPostsResponseModel.fromJson(Map<String, dynamic> json) => ListPostsResponseModel(
    message: json["message"],
    listPosts: ListPosts.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": listPosts.toJson(),
  };
}

class ListPosts {
  int totalPage;
  int start;
  int end;
  List<PostModel> posts;

  ListPosts({
    this.totalPage,
    this.start,
    this.end,
    this.posts,
  });

  factory ListPosts.fromJson(Map<String, dynamic> json) => ListPosts(
    totalPage: json["total_page"],
    start: json["start"],
    end: json["end"],
    posts: List<PostModel>.from(json["value"].map((x) => PostModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_page": totalPage,
    "start": start,
    "end": end,
    "value": List<dynamic>.from(posts.map((x) => x.toJson())),
  };
}

class PostModel {
  String id;
  String title;
  String featureImage;
  String link;
  String type;
  String author;
  DateTime createAt;
  DateTime updateAt;
  String summary;

  PostModel({
    this.id,
    this.title,
    this.featureImage,
    this.link,
    this.type,
    this.author,
    this.createAt,
    this.updateAt,
    this.summary,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["_id"],
    title: json["title"],
    featureImage: json["feature_image"],
    link: json["link"],
    type: json["type"],
    author: json["author"],
    createAt: DateTime.parse(json["create_at"]),
    updateAt: DateTime.parse(json["update_at"]),
    summary: json["summary"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "feature_image": featureImage,
    "link": link,
    "type": type,
    "author": author,
    "create_at": createAt.toIso8601String(),
    "update_at": updateAt.toIso8601String(),
    "summary": summary,
  };
}