import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map4D Map',
      home: Map4dSample(),
    );
  }
}

class Map4dSample extends StatefulWidget {
  @override
  _Map4dSampleState createState() => _Map4dSampleState();
}

class _Map4dSampleState extends State<Map4dSample> {

  Completer<MFMapViewController> _controller = Completer();
  bool _is3dMode = false;

  static final MFLatLng _kLandmark81 = MFLatLng(10.794630856464138, 106.72229460050636);
  static final MFCameraPosition _kInitialCameraPosition = MFCameraPosition(target: _kLandmark81, zoom: 16);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 150.0,
            child: MFMapView(
              initialCameraPosition: _kInitialCameraPosition,
              onMapCreated: (MFMapViewController controller) {
                _controller.complete(controller);
              },
              onPOITap: _onPOITap,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 350.0,
            height: 150.0,
            child: MFMapView(
              initialCameraPosition: _kInitialCameraPosition,
              onMapCreated: (MFMapViewController controller) {
                _controller.complete(controller);
              },
              onPOITap: _onPOITap,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 350.0,
            height: 150.0,
            child: MFMapView(
              initialCameraPosition: _kInitialCameraPosition,
              onMapCreated: (MFMapViewController controller) {
                _controller.complete(controller);
              },
              onPOITap: _onPOITap,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 350.0,
            height: 150.0,
            child: MFMapView(
              initialCameraPosition: _kInitialCameraPosition,
              onMapCreated: (MFMapViewController controller) {
                _controller.complete(controller);
              },
              onPOITap: _onPOITap,
            ),
          ),
        ),
        TextButton(
          child: const Text('Action'),
          onPressed: _actionButton,
        ),
      ],
    );
  }

  void _onPOITap(String placeId, String name, MFLatLng location) {
    print('Tap on place: $placeId, name: $name, location: $location');
  }

  void _actionButton() async {
    final MFMapViewController controller = await _controller.future;
    // _is3dMode = !_is3dMode;
    // controller.enable3DMode(_is3dMode);
    // print('Camera position: ');

    // if (controller.getCameraPosition() != null) {
    //   print('Get camera postion');
    // }
    _showLocation(context);
  }

  Future _showLocation(BuildContext context) async {
    String title = "Chia sẻ vị trí";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height * 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) => BottomSheet(
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close)),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      MFMapView(
                        onMapCreated: (MFMapViewController controller) {
                          controller.animateCamera(MFCameraUpdate.newLatLng(
                              MFLatLng(16.020179, 108.211212)));
                        },
                        markers: {
                          MFMarker(
                              markerId: MFMarkerId('position'),
                              position:
                              MFLatLng(16.024634, 108.209217)),
                        },
                      ),
                      Positioned(
                        child: Container(
                          width: 200,
                          height: 50,
                          color: Colors.green,
                        ),
                        bottom: 32,
                        left: 0,
                        right: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        onClosing: () {},
      ),
    );
  }

}