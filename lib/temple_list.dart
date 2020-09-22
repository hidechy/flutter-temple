import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'screens/temple_thumbnail_screen.dart';

class TempleList extends StatefulWidget {
  final String year;
  TempleList({@required this.year});

  @override
  _TempleListState createState() => _TempleListState();
}

class _TempleListState extends State<TempleList> {
  List<DropdownMenuItem<String>> _dropdownYears = List();

  String _selectedYear = '';

  List<Map<dynamic, dynamic>> _templeData = List();

  bool isLoading = false;

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
    List explodedDate = DateTime.now().toString().split(' ');
    List explodedSelectedDate = explodedDate[0].split('-');

    for (int i = int.parse(explodedSelectedDate[0]); i >= 2014; i--) {
      _dropdownYears.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Container(
            child: Text('${i.toString()}'),
          ),
        ),
      );
    }

    _selectedYear = (widget.year == '') ? explodedSelectedDate[0] : widget.year;

    Response response =
        await get('http://toyohide.work/Temple/${_selectedYear}/templelistapi');

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (int i = 0; i < data['data'].length; i++) {
        _templeData.add(data['data'][i]);
      }

      isLoading = true;
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
        title: Text('${_selectedYear}'),
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
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    dropdownColor: Colors.black.withOpacity(0.1),
                    items: _dropdownYears,
                    value: _selectedYear,
                    onChanged: (value) => _goTempleList(value: value),
                  ),
                ),
              ),
              Expanded(
                child: (isLoading)
                    ? ListView.builder(
                        itemCount: _templeData.length,
                        itemBuilder: (context, int position) =>
                            _listItem(position: position),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                        ],
                      ),
              ),
            ],
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
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
            '${_templeData[position]['date']}\n${_templeData[position]['temple']}'),
        onTap: () =>
            _goTemplePhotoDisplayScreen(context: context, position: position),
      ),
    );
  }

  /**
   * 画面遷移（TempleList）
   */
  _goTempleList({value}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TempleList(
          year: value,
        ),
      ),
    );
  }

  /**
   * 画面遷移（TemplePhotoDisplayScreen）
   */
  _goTemplePhotoDisplayScreen({BuildContext context, int position}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TempleThumbnailScreen(
          data: _templeData[position],
        ),
      ),
    );
  }
}
