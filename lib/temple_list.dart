import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:temple/screens/year_temple_display_screen.dart';

class TempleList extends StatefulWidget {
  @override
  _TempleListState createState() => _TempleListState();
}

class _TempleListState extends State<TempleList> {
  List<String> years = List();

  @override
  void initState() {
    super.initState();

    _getTempleData();
  }

  _getTempleData() async {
    Response response =
        await get('http://worldtimeapi.org/api/timezone/Asia/Tokyo');
    Map data = jsonDecode(response.body);
    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1, 3);

    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));

    List<String> explodedNow = (now).toString().split(' ');
    List<String> explodedNowDate = (explodedNow[0]).split('-');
    int end_year = int.parse(explodedNowDate[0]).toInt();

    years.add('image');
    for (int i = end_year; i >= 2014; i--) {
      years.add(i.toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('temple'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _yearList(),
        ),
      ),
    );
  }

  Widget _yearList() {
    return ListView.builder(
      itemCount: years.length,
      itemBuilder: (context, int position) => _listItem(position),
    );
  }

  Widget _listItem(int position) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey[900],
      child: ListTile(
        title: (years[position] == "image")
            ? _getTempleImage()
            : Text(
                "${years[position]}",
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
        onTap: () => _goYearTempleDisplayScreen(years[position]),
      ),
    );
  }

  _goYearTempleDisplayScreen(String year) {
    if (year == "image") {
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => YearTempleDisplayScreen(year: year)));
  }

  _getTempleImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Image.asset('assets/image/temple.png'),
    );
  }
}
