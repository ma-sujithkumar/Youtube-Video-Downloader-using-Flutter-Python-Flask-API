import 'package:flutter/widgets.dart';

class vidStructure {
  String author;
  String title;
  String url;
  String thumbnail;
  String views;
  vidStructure({this.author, this.thumbnail, this.title, this.url, this.views});
  factory vidStructure.fromJson(Map<String, dynamic> json) {
    return vidStructure(
      author: json["description"],
      thumbnail: json["url"],
      title: json["title"],
      url: json["url"],
      views: json["views"].toString(),
    );
  }
}
