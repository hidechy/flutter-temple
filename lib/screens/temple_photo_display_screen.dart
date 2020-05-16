import 'package:flutter/material.dart';
import 'package:temple/parts/temple_photo_data.dart';

class TemplePhotoDisplayScreen extends StatefulWidget {
  final String date;

  TemplePhotoDisplayScreen({@required this.date});

  @override
  _TemplePhotoDisplayScreenState createState() =>
      _TemplePhotoDisplayScreenState();
}

class _TemplePhotoDisplayScreenState extends State<TemplePhotoDisplayScreen> {
  String date;
  List<String> templePhotoData = List();

  @override
  void initState() {
    super.initState();
    _getSamedayData();
  }

  _getSamedayData() async {
    date = widget.date;

    TemplePhotoData instance = TemplePhotoData(date: date);
    await instance.getData();

    templePhotoData = instance.templePhotoData;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.date),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _templePhotoList(),
        ),
      ),
    );
  }

  Widget _templePhotoList() {
    return ListView.builder(
      itemCount: templePhotoData.length,
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
        title: templePhotoDisplay(templePhotoData[position], position),
      ),
    );
  }

  Widget templePhotoDisplay(String templePhotoData, int position) {
    if (position == 0) {
      List<String> explodedTemplePhotoData = (templePhotoData).split('\n');
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Container(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  explodedTemplePhotoData[0],
                  style: TextStyle(fontSize: 20.0),
                ),
                Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                Text(explodedTemplePhotoData[1]),
                Text(explodedTemplePhotoData[2]),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Image.network(templePhotoData),
    );
  }
}
