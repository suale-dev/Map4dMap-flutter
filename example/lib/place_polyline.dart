import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

class PlacePolylinePage extends Map4dMapExampleAppPage {
  PlacePolylinePage() : super(const Icon(Icons.line_weight), 'Place polyline');

  @override
  Widget build(BuildContext context) {
    return const PlacePolylineBody();
  }
}

class PlacePolylineBody extends StatefulWidget {
  const PlacePolylineBody();

  @override
  State<StatefulWidget> createState() => PlacePolylineBodyState();
}

class PlacePolylineBodyState extends State<PlacePolylineBody> {
  PlacePolylineBodyState() {
    final MFPolylineId polylineId = MFPolylineId('polyline_id_0');
    List<MFLatLng> points = <MFLatLng>[
      MFLatLng(52.30176096373671, -5.767822265625),
      MFLatLng(50.93073802371819, -4.954833984374999),
      MFLatLng(52.1267438596429, -1.8896484375),
      MFLatLng(53.35710874569601, -5.33935546875),
      MFLatLng(54.59752785211386, -2.252197265625)
    ];
    final MFPolyline polyline = MFPolyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.yellow,
      width: 5,
      points: points,
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );
    polylines[polylineId] = polyline;
  }

  MFMapViewController? controller;
  Map<MFPolylineId, MFPolyline> polylines = <MFPolylineId, MFPolyline>{};
  int _polylineIdCounter = 1;
  MFPolylineId? selectedPolyline;

  // Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polyline width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  int polylineStyleIndex = 0;
  List<MFPolylineStyle> polylineStyles = <MFPolylineStyle>[
    MFPolylineStyle.solid,
    MFPolylineStyle.dotted,
  ];

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPolylineTapped(MFPolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void _remove(MFPolylineId polylineId) {
    setState(() {
      if (polylines.containsKey(polylineId)) {
        polylines.remove(polylineId);
      }
      selectedPolyline = null;
    });
  }

  void _add() {
    final int polylineCount = polylines.length;

    if (polylineCount == 12) {
      return;
    }

    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final MFPolylineId polylineId = MFPolylineId(polylineIdVal);

    final MFPolyline polyline = MFPolyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: _createPoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  void _toggleVisible(MFPolylineId polylineId) {
    final MFPolyline polyline = polylines[polylineId]!;
    setState(() {
      polylines[polylineId] = polyline.copyWith(
        visibleParam: !polyline.visible,
      );
    });
  }

  void _changeColor(MFPolylineId polylineId) {
    final MFPolyline polyline = polylines[polylineId]!;
    setState(() {
      polylines[polylineId] = polyline.copyWith(
        colorParam: colors[++colorsIndex % colors.length],
      );
    });
  }

  void _changeWidth(MFPolylineId polylineId) {
    final MFPolyline polyline = polylines[polylineId]!;
    setState(() {
      polylines[polylineId] = polyline.copyWith(
        widthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  void _changeStyle(MFPolylineId polylineId) {
    final MFPolyline polyline = polylines[polylineId]!;
    setState(() {
      polylines[polylineId] = polyline.copyWith(
        styleParam:
            polylineStyles[++polylineStyleIndex % polylineStyles.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    final MFPolylineId? selectedId = selectedPolyline;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                target: MFLatLng(53.1721, -3.5402),
                zoom: 5.0,
              ),
              polylines: Set<MFPolyline>.of(polylines.values),
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: const Text('add'),
                          onPressed: _add,
                        ),
                        TextButton(
                          child: const Text('remove'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _remove(selectedId),
                        ),
                        TextButton(
                          child: const Text('toggle visible'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _toggleVisible(selectedId),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: const Text('change width'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeWidth(selectedId),
                        ),
                        TextButton(
                          child: const Text('change color'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeColor(selectedId),
                        ),
                        TextButton(
                          child: const Text('change style'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeStyle(selectedId),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<MFLatLng> _createPoints() {
    final List<MFLatLng> points = <MFLatLng>[];
    final double offset = _polylineIdCounter.ceilToDouble();
    points.add(_createLatLng(51.4816 + offset, -3.1791));
    points.add(_createLatLng(53.0430 + offset, -2.9925));
    points.add(_createLatLng(53.1396 + offset, -4.2739));
    points.add(_createLatLng(52.4153 + offset, -4.0829));
    return points;
  }

  MFLatLng _createLatLng(double lat, double lng) {
    return MFLatLng(lat, lng);
  }
}
