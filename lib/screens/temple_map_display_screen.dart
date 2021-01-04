import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';
import 'package:http/http.dart';

class TempleMapDisplayScreen extends StatefulWidget {
  final String year;
  TempleMapDisplayScreen({@required this.year});

  @override
  _TempleMapDisplayScreenState createState() => _TempleMapDisplayScreenState();
}

class _TempleMapDisplayScreenState extends State<TempleMapDisplayScreen> {
  GoogleMapController mapController;

  LatLng _latLng;
  CameraPosition _cameraPosition = null;

  Set<Marker> _markers = {};

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

      _latLng = LatLng(data['home']['lat'], data['home']['lng']);

      _cameraPosition = CameraPosition(
        target: _latLng,
        zoom: 13.0,
      );

      for (int i = 0; i < data['data'].length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId('${data['data'][i]['temple']}'),
            position: LatLng(
              double.parse(data['data'][i]['lat']),
              double.parse(data['data'][i]['lng']),
            ),
            infoWindow: InfoWindow(title: data['data'][i]['temple']),
          ),
        );
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          (_cameraPosition != null)
              ? GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _cameraPosition,
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                )
              : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  /**
   * マップ表示
   */
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {});
  }
}
