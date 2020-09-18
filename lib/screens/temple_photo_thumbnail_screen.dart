import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:temple/screens/temple_photo_screen.dart';

class TemplePhotoThumbnailScreen extends StatefulWidget {
  final String date;
  final String temple;
  final String address;
  final String station;
  TemplePhotoThumbnailScreen({
    @required this.date,
    @required this.temple,
    @required this.address,
    @required this.station,
  });

  @override
  _TemplePhotoThumbnailScreenState createState() =>
      _TemplePhotoThumbnailScreenState();
}

class _TemplePhotoThumbnailScreenState
    extends State<TemplePhotoThumbnailScreen> {
  List<Map<dynamic, dynamic>> _templePhotoData = List();

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
        var _map = Map();
        _map['photo'] = data['data'][i];

        _templePhotoData.add(_map);
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
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.black.withOpacity(0.3),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverGrid.count(
                        crossAxisCount: 3,
                        children: (_templePhotoData.isEmpty)
                            ? [Container()]
                            : List.generate(
                                _templePhotoData.length,
                                (int index) => InkWell(
                                  onTap: () => _openPhotoScreen(context, index),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TransitionToImage(
                                      image: AdvancedNetworkImage(
                                        _templePhotoData[index]['photo'],
                                        useDiskCache: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _openPhotoScreen(BuildContext context, int index) {
    var photo = _templePhotoData[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplePhotoScreen(
          photo: photo,
        ),
      ),
    );
  }
}
