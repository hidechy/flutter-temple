import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';

class TempleData {
  List<String> templeData = List();
  String year;

  TempleData({@required this.year});

  Future<void> getData() async {
    Response response =
        await get('http://toyohide.work/Temple/$year/templelistapi');

    Map data = jsonDecode(response.body);

    templeData = (data['data']
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll(':', ''))
        .split(', ');
  }
}
