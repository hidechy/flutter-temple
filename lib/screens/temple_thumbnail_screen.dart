import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:temple/screens/temple_photo_screen.dart';

class TempleThumbnailScreen extends StatefulWidget {
  final Map data;
  TempleThumbnailScreen({
    @required this.data,
  });

  @override
  _TempleThumbnailScreenState createState() => _TempleThumbnailScreenState();
}

class _TempleThumbnailScreenState extends State<TempleThumbnailScreen> {
  List<Map<dynamic, dynamic>> _templePhotoData = List();

  GoogleMapController mapController;

  LatLng _latLng;
  CameraPosition _cameraPosition = null;

  Set<Marker> _markers = {};

  bool _mapDisplay = true;
  bool _mapBtnDisplay = true;

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
        'http://toyohide.work/Temple/${widget.data['date']}/templephotoapi');

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (int i = 0; i < data['data'].length; i++) {
        var _map = Map();

        var ex_data = (data['data'][i]).split('/');
        var ex_data_last = (ex_data[ex_data.length - 1]).split('.');
        _map['id'] = ex_data_last[0];

        _map['photo'] = data['data'][i];

        _templePhotoData.add(_map);
      }
    }

    //---------------------------------------//
    Response response2 = await get(
        'http://toyohide.work/Temple/${widget.data['date']}/templelatlngapi');

    if (response2 != null) {
      Map data2 = jsonDecode(response2.body);

      _latLng = LatLng(data2['data']['lat'], data2['data']['lng']);

      _cameraPosition = CameraPosition(
        target: _latLng,
        zoom: 13.0,
      );

      _markers.add(
        Marker(
          markerId: MarkerId('marker_1'),
          position: _latLng,
        ),
      );
    } else {
      _mapDisplay = false;
      _mapBtnDisplay = false;
    }
    //---------------------------------------//

    setState(() {});
  }

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data['date']}'),
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
              //------------------------// temple
              Container(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.black.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('${widget.data['temple']}'),
                  ),
                ),
              ),
              //------------------------//
              //------------------------// map
              (_mapDisplay == true &&
                      _mapBtnDisplay == true &&
                      _cameraPosition != null)
                  ? Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _cameraPosition,
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                      ),
                    )
                  : Container(),
              //------------------------//
              //------------------------// address
              Container(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.black.withOpacity(0.3),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('${_getDisplayText(widget.data)}'),
                        ),
                      ),
                      (_mapBtnDisplay)
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: 60,
                                child: IconButton(
                                  icon: Icon(Icons.map),
                                  onPressed: () => _mapDisplayChange(),
                                  color: Colors.greenAccent,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              //------------------------//
              //------------------------// photo
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
                                    child: Hero(
                                      tag: _templePhotoData[index]['id'],
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
                      ),
                    ],
                  ),
                ),
              ),
              //------------------------//
            ],
          ),
        ],
      ),
    );
  }

  /**
   * 表示文字列取得
   */
  String _getDisplayText(Map data) {
    String ret = '';
    ret += data['address'];
    ret += '\n';
    ret += data['station'];
    return ret;
  }

  /**
   * 画面遷移（TemplePhotoScreen）
   */
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

  /**
   * マップ表示
   */
  void _onMapCreated(GoogleMapController controller) {
    setState(
      () {
        mapController = controller;
      },
    );
  }

  /**
   * マップ表示切り替え
   */
  _mapDisplayChange() {
    _mapDisplay = !_mapDisplay;
    setState(() {});
  }
}
