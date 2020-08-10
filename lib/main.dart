import 'package:flutter/material.dart';
import 'package:youtube_downloader/home.dart';
import 'package:youtube_downloader/id.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      title: "Youtube Video Downloader",
      routes: {
        '/id': (context) => ID(),
      },
      theme: ThemeData(
        fontFamily: "Ubuntu",
        primarySwatch: Colors.red,
      ),
    );
  }
}
