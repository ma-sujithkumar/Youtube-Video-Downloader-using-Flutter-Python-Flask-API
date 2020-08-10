import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/vidStructure.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool downloading = false;
  var progressString = "";
  bool _loading = true;
  String fetchUrl = "";
  String author = "";
  String title = "";
  String views = "";
  String length = "";
  String task = "Not Downloading";
  String thumbnail =
      "https://cdn4.iconfinder.com/data/icons/48-bubbles/48/23.Videos-512.png";
  String uid = "";
  final myController = TextEditingController();
  void giveUrl(String url) {
    String id = "";
    int leng = url.length;
    if (leng > 11) {
      int start = leng - 11;
      for (int i = start; i < (start + 11); i++) {
        id = id + url[i];
      }
    } else {
      id = id + url;
    }
    print(id);
    setState(() {
      uid = id;
      getData();
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    vidStructure vid;
    var response =
        await http.get("http://masujithultimate.pythonanywhere.com/$uid");
    vid = vidStructure.fromJson(jsonDecode(response.body));
    setState(() {
      title = vid.title.toString();
      author = vid.author.toString();
      fetchUrl = vid.url.toString();
      views = vid.views.toString();
      thumbnail = vid.thumbnail.toString();
      _loading = true;
    });
  }

  Future<void> DownloadVideo() async {
    Dio dio = Dio();
    var path1 = await getExternalStorageDirectory();
    await dio.download(fetchUrl, "${path1.path}/$author.mp4",
        onReceiveProgress: (int receive, int total) {
      setState(() {
        downloading = true;
        progressString = ((receive / total) * 100).toStringAsFixed(0) + "%";
      });
    });
    setState(() {
      downloading = false;
      progressString = "Completed";
      task = "Download Completed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,
            title: Row(
              children: [
                Icon(
                  Icons.music_video,
                ),
                SizedBox(width: 6),
                Text("Youtube Downloader"),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.pushNamed(context, '/id');
                },
              )
            ]),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.red,
              Colors.redAccent,
            ]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) {
                    fetchUrl = value;
                  },
                  controller: myController,
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Enter the URL and click Process',
                  ),
                ),
                RaisedButton(
                  color: Colors.white,
                  child: Text("Process"),
                  onPressed: () {
                    setState(() {
                      _loading = false;
                      giveUrl(fetchUrl);
                      _loading = true;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text(
                  "Title: $title",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  "Views: $views",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  "Author: $author",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                RaisedButton(
                  color: Colors.white,
                  child: Text("Download"),
                  onPressed: () {
                    setState(() {
                      DownloadVideo();
                    });
                  },
                ),
                SizedBox(height: 15),
                Center(
                    child: downloading
                        ? Container(
                            height: 120.0,
                            width: 200.0,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "Downloading File: $progressString",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Text("$task")),
              ],
            ),
          ),
        ));
  }
}
