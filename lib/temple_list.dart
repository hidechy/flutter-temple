import 'package:flutter/material.dart';

import 'screens/year_temple_display_screen.dart';

class TempleList extends StatefulWidget {
  @override
  _TempleListState createState() => _TempleListState();
}

class _TempleListState extends State<TempleList> {
  List<String> _yearlist = List();

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
      _yearlist.add(i.toString());
    }

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Image.asset('assets/image/temple.png'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _yearlist.length,
            itemBuilder: (context, int position) =>
                _listItem(position: position),
          ),
        ),
      ],
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
          child: Text('${_yearlist[position]}'),
        ),
        onTap: () =>
            _goYearTempleDisplayScreen(context: context, position: position),
      ),
    );
  }

  /**
   * 画面遷移（_goYearTempleDisplayScreen）
   */
  void _goYearTempleDisplayScreen({BuildContext context, int position}) {
    var year = _yearlist[position];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YearTempleDisplayScreen(
          year: year,
        ),
      ),
    );
  }
}
