import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class TemplePhotoScreen extends StatefulWidget {
  final Map photo;
  TemplePhotoScreen({@required this.photo});

  @override
  _TemplePhotoScreenState createState() => _TemplePhotoScreenState();
}

class _TemplePhotoScreenState extends State<TemplePhotoScreen> {
  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Container(
            alignment: Alignment.center,
            child: Hero(
              tag: widget.photo['id'],
              child: TransitionToImage(
                image: AdvancedNetworkImage(
                  widget.photo['photo'],
                  useDiskCache: true,
                ),
              ),
            ),
          ),
        ],
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
