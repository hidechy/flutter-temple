import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';

class TemplePhotoData {
  List<String> templePhotoData = List();
  String date;

  TemplePhotoData({@required this.date});

  Future<void> getData() async {
    Response response =
        await get('http://toyohide.work/Temple/$date/templephotoapi');

    Map data = jsonDecode(response.body);

    templePhotoData = (data['data']
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('{', '')
            .replaceAll('}', '')
            )
        .split(', ');
  }
}
