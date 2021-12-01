import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

class PlaceCirclePage extends Map4dMapExampleAppPage {
  PlaceCirclePage() : super(const Icon(Icons.animation), 'Place circle');

  @override
  Widget build(BuildContext context) {
    return const PlaceCircleBody();
  }
}

class PlaceCircleBody extends StatefulWidget {
  const PlaceCircleBody();

  @override
  State<StatefulWidget> createState() => PlaceCircleBodyState();
}

class PlaceCircleBodyState extends State<PlaceCircleBody> {
  PlaceCircleBodyState() {
    final MFCircleId circleId = MFCircleId('circle_id_0');
    final MFCircle circle = MFCircle(
        circleId: circleId,
        consumeTapEvents: true,
        strokeColor: Colors.orange,
        fillColor: Colors.green,
        strokeWidth: 5,
        center: MFLatLng(51.4816, -3.1791),
        radius: 50000,
        onTap: () {
          _onCircleTapped(circleId);
        });
    circles[circleId] = circle;
  }

  MFMapViewController? controller;
  Map<MFCircleId, MFCircle> circles = <MFCircleId, MFCircle>{};
  int _circleIdCounter = 1;
  MFCircleId? selectedCircle;

  // Values when toggling circle color
  int fillColorsIndex = 0;
  int strokeColorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling circle stroke width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onCircleTapped(MFCircleId circleId) {
    setState(() {
      selectedCircle = circleId;
    });
  }

  void _remove(MFCircleId circleId) {
    setState(() {
      if (circles.containsKey(circleId)) {
        circles.remove(circleId);
      }
      if (circleId == selectedCircle) {
        selectedCircle = null;
      }
    });
  }

  void _add() {
    final int circleCount = circles.length;

    if (circleCount == 12) {
      return;
    }

    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    final MFCircleId circleId = MFCircleId(circleIdVal);

    final MFCircle circle = MFCircle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Colors.orange,
      fillColor: Colors.green,
      strokeWidth: 5,
      center: _createCenter(),
      radius: 50000,
      onTap: () {
        _onCircleTapped(circleId);
      },
    );

    setState(() {
      circles[circleId] = circle;
    });
  }

  void _toggleVisible(MFCircleId circleId) {
    final MFCircle circle = circles[circleId]!;
    setState(() {
      circles[circleId] = circle.copyWith(
        visibleParam: !circle.visible,
      );
    });
  }

  void _changeFillColor(MFCircleId circleId) {
    final MFCircle circle = circles[circleId]!;
    setState(() {
      circles[circleId] = circle.copyWith(
        fillColorParam: colors[++fillColorsIndex % colors.length],
      );
    });
  }

  void _changeStrokeColor(MFCircleId circleId) {
    final MFCircle circle = circles[circleId]!;
    setState(() {
      circles[circleId] = circle.copyWith(
        strokeColorParam: colors[++strokeColorsIndex % colors.length],
      );
    });
  }

  void _changeStrokeWidth(MFCircleId circleId) {
    final MFCircle circle = circles[circleId]!;
    setState(() {
      circles[circleId] = circle.copyWith(
        strokeWidthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MFCircleId? selectedId = selectedCircle;
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
                target: MFLatLng(52.4478, -3.5402),
                zoom: 7.0,
              ),
              circles: Set<MFCircle>.of(circles.values),
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
                          child: const Text('change stroke width'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeStrokeWidth(selectedId),
                        ),
                        TextButton(
                          child: const Text('change stroke color'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeStrokeColor(selectedId),
                        ),
                        TextButton(
                          child: const Text('change fill color'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeFillColor(selectedId),
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

  MFLatLng _createCenter() {
    final double offset = _circleIdCounter.ceilToDouble();
    return _createLatLng(51.4816 + offset * 0.2, -3.1791);
  }

  MFLatLng _createLatLng(double lat, double lng) {
    return MFLatLng(lat, lng);
  }
}
