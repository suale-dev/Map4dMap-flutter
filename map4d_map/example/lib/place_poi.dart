import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:map4d_map/map4d_map_flutter.dart';

import 'page.dart';

class PlacePOIPage extends Map4dMapExampleAppPage {
  PlacePOIPage() : super(const Icon(Icons.room), 'Place POI');

  @override
  Widget build(BuildContext context) {
    return const PlacePOIBody();
  }
}

class PlacePOIBody extends StatefulWidget {
  const PlacePOIBody();

  @override
  State<StatefulWidget> createState() => PlacePOIBodyState();
}

class PlacePOIBodyState extends State<PlacePOIBody> {
  PlacePOIBodyState();

  MFMapViewController? controller;
  MFBitmap? _markerIcon;
  Map<MFPOIId, MFPOI> pois = <MFPOIId, MFPOI>{};
  int _poiIdCounter = 1;
  MFPOIId? selectedPOI;

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  void _onTap(MFLatLng coordinate) {
    _add(coordinate);
  }

  void _onPOITapped(MFPOIId poiId) {
    setState(() {
      selectedPOI = poiId;
    });
  }

  void _remove(MFPOIId poiId) {
    setState(() {
      if (pois.containsKey(poiId)) {
        pois.remove(poiId);
      }
      if (poiId == selectedPOI) {
        selectedPOI = null;
      }
    });
  }

  void _add(MFLatLng position) {
    final String poiIdVal = 'poi_id_$_poiIdCounter';
    _poiIdCounter++;
    final MFPOIId poiId = MFPOIId(poiIdVal);

    final MFPOI poi = MFPOI(
      poiId: poiId,
      consumeTapEvents: true,
      position: position,
      title: WordPair.random().asPascalCase,
      titleColor: _randomColor(null),
      // subtitle: WordPair.random().asLowerCase,
      // icon: _markerIcon!,
      type: _randomType(null),
      onTap: () {
        _onPOITapped(poiId);
      },
    );

    setState(() {
      pois[poiId] = poi;
    });
  }

  void _toggleVisible(MFPOIId poiId) {
    final MFPOI poi = pois[poiId]!;
    setState(() {
      pois[poiId] = poi.copyWith(
        visibleParam: !poi.visible,
      );
    });
  }

  void _changeTitle(MFPOIId poiId) {
    final MFPOI poi = pois[poiId]!;
    setState(() {
      pois[poiId] = poi.copyWith(
        titleParam: WordPair.random().asPascalCase,
      );
    });
  }

  void _changeTitleColor(MFPOIId poiId) {
    final MFPOI poi = pois[poiId]!;
    final Color color = _randomColor(poi.titleColor);
    setState(() {
      pois[poiId] = poi.copyWith(
        titleColorParam: color
      );
    });
  }

  Color _randomColor(Color? ignore) {
    final List<Color> colors = <Color>[Colors.red, Colors.green, Colors.blue, Colors.purple, Colors.pink, Colors.black];
    if (ignore != null) {
      colors.remove(ignore);
    }
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  String _randomType(String? ignore) {
    final List<String> types = <String>['government', 'museum', 'motel', 'bank', 'supermarket', 'restaurant', 'cafe', 'school', 'stadium', 'pharmacy', 'university', 'police', 'bar', 'atm', 'hospital', 'park'];
    if (ignore != null) {
      types.remove(ignore);
    }
    final random = Random();
    return types[random.nextInt(types.length)];
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size.square(48));
      _markerIcon = await MFBitmap.fromAssetImage(imageConfiguration, 'assets/ic_marker_tracking.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    final MFPOIId? selectedId = selectedPOI;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: MFMapView(
              pois: Set<MFPOI>.of(pois.values),
              onMapCreated: _onMapCreated,
              onTap: _onTap,
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
                          child: const Text('change title'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeTitle(selectedId),
                        ),
                        TextButton(
                          child: const Text('change title color'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _changeTitleColor(selectedId),
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
  
}