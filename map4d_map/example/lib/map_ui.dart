import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'page.dart';

class MapUiPage extends Map4dMapExampleAppPage {
  MapUiPage() : super(const Icon(Icons.map), 'User interface');

  @override
  Widget build(BuildContext context) {
    return const MapUiBody();
  }
}

class MapUiBody extends StatefulWidget {
  const MapUiBody();

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {
  MapUiBodyState();

  static final MFCameraPosition _kInitialPosition = MFCameraPosition(
    target: MFLatLng(16.0750, 108.2122),
    zoom: 15.0,
  );

  MFCameraPosition _position = _kInitialPosition;
  bool _isMapCreated = false;
  bool _isMoving = false;
  MFMinMaxZoom _minMaxZoomPreference = MFMinMaxZoom.unbounded;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _poisEnabled = true;
  bool _buildingsEnabled = true;
  bool _myLocationEnabled = false;
  bool _myLocationButtonEnabled = false;
  late MFMapViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _fitBoundsToggler() {
    return TextButton(
      child: Text('Fit Bounds'
      ),
      onPressed: () {
        setState(() {
          print('_fitBoundsToggler');
        });
      },
    );
  }

  Widget _zoomBoundsToggler() {
    return TextButton(
      child: Text(_minMaxZoomPreference.minZoom == null
          ? 'Bound Zoom'
          : 'Release Zoom'),
      onPressed: () {
        setState(() {
          _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null ? const MFMinMaxZoom(12.0, 16.0) : MFMinMaxZoom.unbounded;
        });
      },
    );
  }

  Widget _poisEnabledToggler() {
    return TextButton(
      child: Text('${_poisEnabled ? 'Disable' : 'Enable'} POIs'),
      onPressed: () {
        setState(() {
          _poisEnabled = !_poisEnabled;
        });
      },
    );
  }

  Widget _buildingsEnabledToggler() {
    return TextButton(
      child: Text('${_buildingsEnabled ? 'Disable' : 'Enable'} Buildings'),
      onPressed: () {
        setState(() {
          _buildingsEnabled = !_buildingsEnabled;
        });
      },
    );
  }

  Widget _rotateToggler() {
    return TextButton(
      child: Text('${_rotateGesturesEnabled ? 'Disable' : 'Enable'} rotate'),
      onPressed: () {
        setState(() {
          _rotateGesturesEnabled = !_rotateGesturesEnabled;
        });
      },
    );
  }

  Widget _scrollToggler() {
    return TextButton(
      child: Text('${_scrollGesturesEnabled ? 'Disable' : 'Enable'} scroll'),
      onPressed: () {
        setState(() {
          _scrollGesturesEnabled = !_scrollGesturesEnabled;
        });
      },
    );
  }

  Widget _tiltToggler() {
    return TextButton(
      child: Text('${_tiltGesturesEnabled ? 'Disable' : 'Enable'} tilt'),
      onPressed: () {
        setState(() {
          _tiltGesturesEnabled = !_tiltGesturesEnabled;
        });
      },
    );
  }

  Widget _zoomToggler() {
    return TextButton(
      child: Text('${_zoomGesturesEnabled ? 'Disable' : 'Enable'} zoom'),
      onPressed: () {
        setState(() {
          _zoomGesturesEnabled = !_zoomGesturesEnabled;
        });
      },
    );
  }

  Widget _myLocationToggler() {
    return TextButton(
      child: Text(
          '${_myLocationEnabled ? 'Disable' : 'Enable'} my location marker'),
      onPressed: () {
        setState(() {
          _myLocationEnabled = !_myLocationEnabled;
        });
      },
    );
  }

  Widget _myLocationButtonToggler() {
    return TextButton(
      child: Text(
          '${_myLocationButtonEnabled ? 'Disable' : 'Enable'} my location button'),
      onPressed: () {
        setState(() {
          _myLocationButtonEnabled = !_myLocationButtonEnabled;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MFMapView mapView = MFMapView(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      minMaxZoomPreference: _minMaxZoomPreference,
      poisEnabled: _poisEnabled,
      buildingsEnabled: _buildingsEnabled,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationButtonEnabled: _myLocationButtonEnabled,
      onCameraMove: _updateCameraPosition,
    );

    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: mapView,
          ),
        ),
      ),
    ];

    if (_isMapCreated) {
      columnChildren.add(
        Expanded(
          child: ListView(
            children: <Widget>[
              Text('camera bearing: ${_position.bearing}'),
              Text(
                  'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
                  '${_position.target.longitude.toStringAsFixed(4)}'),
              Text('camera zoom: ${_position.zoom}'),
              Text('camera tilt: ${_position.tilt}'),
              Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
              _poisEnabledToggler(),
              _buildingsEnabledToggler(),
              _zoomBoundsToggler(),
              _rotateToggler(),
              _scrollToggler(),
              _tiltToggler(),
              _zoomToggler(),
              _myLocationToggler(),
              _myLocationButtonToggler(),
            ],
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );
  }

  void _updateCameraPosition(MFCameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void onMapCreated(MFMapViewController controller) {
    setState(() {
      _controller = controller;
      _isMapCreated = true;
    });
  }
}
