import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class TemplePhotoDisplayScreen extends StatefulWidget {
  final String date;
  final String temple;
  final String address;
  final String station;
  TemplePhotoDisplayScreen({
    @required this.date,
    @required this.temple,
    @required this.address,
    @required this.station,
  });

  @override
  _TemplePhotoDisplayScreenState createState() =>
      _TemplePhotoDisplayScreenState();
}

class _TemplePhotoDisplayScreenState extends State<TemplePhotoDisplayScreen> {
  List<String> _templePhotoData = List();

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
        await get('http://toyohide.work/Temple/${widget.date}/templephotoapi');

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (int i = 0; i < data['data'].length; i++) {
        _templePhotoData.add(data['data'][i]);
      }
    }

    print(_templePhotoData);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.date}'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.black.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                    '${widget.temple}\n${widget.address}\n${widget.station}'),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _templePhotoData.length,
              itemBuilder: (context, int position) =>
                  _listItem(position: position),
            ),
          ),
        ],
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
          child: Image.network(_templePhotoData[position]),
        ),
      ),
    );
  }
}
