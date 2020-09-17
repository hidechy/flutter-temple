import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class TemplePhotoScreen extends StatefulWidget {
  final String photo;
  TemplePhotoScreen({@required this.photo});

  @override
  _TemplePhotoScreenState createState() => _TemplePhotoScreenState();
}

class _TemplePhotoScreenState extends State<TemplePhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: TransitionToImage(
          image: AdvancedNetworkImage(
            widget.photo,
            useDiskCache: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
