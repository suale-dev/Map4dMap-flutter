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
  MFBitmap? _markerIcon;
  Completer<MFMapViewController> _controller = Completer();
  Map<MFMarkerId, MFMarker> markers = <MFMarkerId, MFMarker>{};
  late MFMarkerId markerId;
  static final MFLatLng _kLandmark81 = MFLatLng(10.794630856464138, 106.72229460050636);
  static final MFCameraPosition _kInitialCameraPosition = MFCameraPosition(target: _kLandmark81, zoom: 16);

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 600.0,
            child: MFMapView(
              initialCameraPosition: _kInitialCameraPosition,
              onMapCreated: (MFMapViewController controller) {
                _controller.complete(controller);
              },
              markers: Set<MFMarker>.of(markers.values),
              onPOITap: _onPOITap,
            ),
          ),
        ),
        TextButton(
          child: const Text('Change position'),
          onPressed: _changeMarkerPosition,
        ),
      ],
    );
  }

  void _changeMarkerPosition() {
    final MFMarker marker = markers[markerId]!;
    setState(() {
      markers[markerId] = marker.copyWith(
        positionParam: const MFLatLng(10.794146, 106.723614),
      );
    });
  }

  void _add() {
    const MFMarkerId markerId = MFMarkerId('position');
    final MFMarker marker = MFMarker(
      markerId: markerId,
      position: const MFLatLng(10.794630856464138, 106.72229460050636),
      icon: _markerIcon!,
      // icon: MFBitmap.defaultIcon,
      infoWindow: MFInfoWindow(
          snippet: "Snippet",
          title: "Map4D",
          anchor: const Offset(0.5, 0.0),
          onTap: () {}),
      zIndex: 1.0,
      // onTap: () {},
    );
    setState(() {
      markers[markerId] = marker;
      this.markerId = markerId;
    });
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context, size: Size.square(48));
      _markerIcon = await MFBitmap.fromAssetImage(
          imageConfiguration, 'assets/ic_marker_tracking.png');
    }
    if (_markerIcon != null) {
      _add();
    }
  }

  void _onPOITap(String placeId, String name, MFLatLng location) {
    print('Tap on place: $placeId, name: $name, location: $location');
  }

}