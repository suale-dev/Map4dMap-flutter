import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

class TileOverlayPage extends Map4dMapExampleAppPage {
  TileOverlayPage() : super(const Icon(Icons.map), 'Tile overlay');

  @override
  Widget build(BuildContext context) {
    return const TileOverlayBody();
  }
}

class TileOverlayBody extends StatefulWidget {
  const TileOverlayBody();

  @override
  State<StatefulWidget> createState() => TileOverlayBodyState();
}

class TileOverlayBodyState extends State<TileOverlayBody> {
  TileOverlayBodyState();

  MFMapViewController? controller;
  MFTileOverlay? _tileOverlay;

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _removeTileOverlay() {
    setState(() {
      _tileOverlay = null;
    });
  }

  void _addTileOverlay() {
    final MFTileOverlay tileOverlay = MFTileOverlay.newWithUrlPattern(
      MFTileOverlayId('tile_overlay_1'),
      'https://a.tile.opentopomap.org/{zoom}/{x}/{y}.png',
    );
    setState(() {
      _tileOverlay = tileOverlay;
    });
  }

  void _clearTileCache() {
    if (_tileOverlay != null && controller != null) {
      controller!.clearTileCache(_tileOverlay!.tileOverlayId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<MFTileOverlay> overlays = <MFTileOverlay>{
      if (_tileOverlay != null) _tileOverlay!,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                target: MFLatLng(59.935460, 30.325177),
                zoom: 7.0,
              ),
              tileOverlays: overlays,
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        TextButton(
          child: const Text('Add tile overlay'),
          onPressed: _addTileOverlay,
        ),
        TextButton(
          child: const Text('Remove tile overlay'),
          onPressed: _removeTileOverlay,
        ),
        TextButton(
          child: const Text('Clear tile cache'),
          onPressed: _clearTileCache,
        ),
      ],
    );
  }
}
