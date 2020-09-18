import 'package:flutter/material.dart';
import 'temple_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '参拝記録',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, fontFamily: "Yomogi"),
      home: TempleList(
        year: '',
      ),
    );
  }
}
