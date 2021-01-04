import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart';

class TempleMapDisplayScreen extends StatefulWidget {
  final String year;
  TempleMapDisplayScreen({@required this.year});

  @override
  _TempleMapDisplayScreenState createState() => _TempleMapDisplayScreenState();
}

class _TempleMapDisplayScreenState extends State<TempleMapDisplayScreen> {
  List<Map<dynamic, dynamic>> _templeLatLngData = List();

  /**
   * 初期動作
   */
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /**
   * 初期データ作成
   */
  void _makeDefaultDisplayData() async {
    Response response = await get(
        'http://toyohide.work/Temple/${widget.year}-01-01/templelatlnglistapi');

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (int i = 0; i < data['data'].length; i++) {
        _templeLatLngData.add(data['data'][i]);
      }
    }

    print(_templeLatLngData);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.year}'),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/image/bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            children: <Widget>[],
          ),
        ],
      ),
    );
  }
}
