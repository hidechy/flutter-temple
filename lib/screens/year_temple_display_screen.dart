import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'temple_photo_display_screen.dart';

class YearTempleDisplayScreen extends StatefulWidget {
  final String year;
  YearTempleDisplayScreen({@required this.year});

  @override
  _YearTempleDisplayScreenState createState() =>
      _YearTempleDisplayScreenState();
}

class _YearTempleDisplayScreenState extends State<YearTempleDisplayScreen> {
  List<Map<dynamic, dynamic>> _templeData = List();

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
    Response response =
        await get('http://toyohide.work/Temple/${widget.year}/templelistapi');

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (int i = 0; i < data['data'].length; i++) {
        var _map = Map();
        _map['date'] = data['data'][i]['date'];
        _map['temple'] = data['data'][i]['temple'];
        _map['address'] = data['data'][i]['address'];
        _map['station'] = data['data'][i]['station'];
        _templeData.add(_map);
      }
    }

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.year}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _templeData.length,
        itemBuilder: (context, int position) => _listItem(position: position),
      ),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Text(
              '${_templeData[position]['date']}\n${_templeData[position]['temple']}'),
        ),
        onTap: () =>
            _goTemplePhotoDisplayScreen(context: context, position: position),
      ),
    );
  }

  _goTemplePhotoDisplayScreen({BuildContext context, int position}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplePhotoDisplayScreen(
          date: _templeData[position]['date'],
          temple: _templeData[position]['temple'],
          address: _templeData[position]['address'],
          station: _templeData[position]['station'],
        ),
      ),
    );
  }
}
