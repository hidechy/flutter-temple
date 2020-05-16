import 'package:flutter/material.dart';
import 'package:temple/parts/temple_data.dart';
import 'package:temple/screens/temple_photo_display_screen.dart';

class YearTempleDisplayScreen extends StatefulWidget {
  final String year;

  YearTempleDisplayScreen({@required this.year});

  @override
  _YearTempleDisplayScreenState createState() =>
      _YearTempleDisplayScreenState();
}

class _YearTempleDisplayScreenState extends State<YearTempleDisplayScreen> {
  String year;
  List<String> templeData = List();

  @override
  void initState() {
    super.initState();

    _getSamedayData();
  }

  _getSamedayData() async {
    year = widget.year;

    TempleData instance = TempleData(year: year);
    await instance.getData();

    templeData = instance.templeData;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.year),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _templeList(),
        ),
      ),
    );
  }

  Widget _templeList() {
    return ListView.builder(
      itemCount: templeData.length,
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
        title: Text(
          "${templeData[position]}",
          style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        ),
        onTap: () => _goTemplePhotoDisplayScreen(templeData[position]),
      ),
    );
  }

  _goTemplePhotoDisplayScreen(String templeData) {
    List<String> explodedTempleData = (templeData).split(' 　');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TemplePhotoDisplayScreen(date: explodedTempleData[0])));
  }
}
