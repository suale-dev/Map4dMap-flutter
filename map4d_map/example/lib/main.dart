import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:map4d_map/map4d_map_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isMapCreated = false;
  Map4dMapController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final MFMap4dMap map = MFMap4dMap(
      onMapCreated: onMapCreated,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child:  SizedBox(
            width: 480.0,
            height: 800.0,
            child: map,
          )
        ),
      ),
    );
  }

  void onMapCreated(Map4dMapController controller) {
    print('onMapCreated');
    setState(() {
      _controller = controller;
      _isMapCreated = true;
    });
    getZoomLevel();
    moveCamera();
  }

  void moveCamera() {
    final cameraUpdate = MFCameraUpdate.newLatLng(LatLng(10.779348472547028, 106.71295166015625));
    print('moveCamera to: ' + cameraUpdate.toString());
    _controller.moveCamera(cameraUpdate);
  }

  void getZoomLevel() {
    print("Get Zoom level");
    final zoom = _controller.getZoomLevel();
    zoom.then((value) => print('zoom level: ' + value.toString()));
  }
}
