import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'page.dart';

class DirectionsRendererPage extends Map4dMapExampleAppPage {
  DirectionsRendererPage() : super(const Icon(Icons.account_tree), 'Directions Renderer');

  @override
  Widget build(BuildContext context) {
    return const DirectionsRendererBody();
  }
}

class DirectionsRendererBody extends StatefulWidget {
  const DirectionsRendererBody();

  @override
  State<StatefulWidget> createState() => DirectionsRendererBodyState();
}

class DirectionsRendererBodyState extends State<DirectionsRendererBody> {
  MFMapViewController? _controller;
  MFDirectionsRenderer? _directionsRenderer;

  DirectionsRendererBodyState() {
    final MFDirectionsRendererId rendererId = MFDirectionsRendererId('renderer_id_0');
    _directionsRenderer = MFDirectionsRenderer(
      rendererId: rendererId,
      routes: _createRoutes(),
      activedIndex: 1,
      originPOIOptions: MFDirectionsPOIOptions(title: 'Begin'),
      destinationPOIOptions: MFDirectionsPOIOptions(title: 'End'),
      onRouteTap: _onTapped
    );
  }

  void _onMapCreated(MFMapViewController controller) {
    this._controller = controller;
  }

  void _onTapped(int routeIndex) {
    setState(() {
      _directionsRenderer = _directionsRenderer!.copyWith(
        activedIndexParam: routeIndex,
      );
    });
  }

  void _add() {
    if (_directionsRenderer != null) {
      return;
    }

    final MFDirectionsRendererId rendererId = MFDirectionsRendererId('renderer_id_1');
    MFDirectionsRenderer renderer = MFDirectionsRenderer(
      rendererId: rendererId,
      routes: _createRoutes(),
      activeStrokeWidth: 12,
      activeStrokeColor: Colors.yellow,
      activeOutlineWidth: 4,
      activeOutlineColor: Colors.yellow.shade900,
      inactiveStrokeWidth: 10,
      inactiveStrokeColor: Colors.brown,
      inactiveOutlineWidth: 4,
      inactiveOutlineColor: Colors.brown.shade900,
      onRouteTap: (int routeIndex) => _onTapped(routeIndex),
    );
    
    setState(() {
      _directionsRenderer = renderer;
    });
  }

  void _remove() {
    if (_directionsRenderer == null) {
      return;
    }

    setState(() {
      _directionsRenderer = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Set<MFDirectionsRenderer> renderers = <MFDirectionsRenderer>{
      if (_directionsRenderer != null) _directionsRenderer!
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 500.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                target: MFLatLng(16.077491, 108.221735),
                zoom: 16.0,
              ),
              directionsRenderers: renderers,
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        TextButton(
          child: const Text('Add Directions Renderer'),
          onPressed: _directionsRenderer != null ? null : () => _add(),
        ),
        TextButton(
          child: const Text('Remove Directions Renderer'),
          onPressed: _directionsRenderer == null ? null : () => _remove(),
        ),
      ],
    );
  }

  List<List<MFLatLng>> _createRoutes() {
    final List<MFLatLng> route0 = <MFLatLng>[];
    route0.add(MFLatLng(16.078814, 108.221592));
    route0.add(MFLatLng(16.078972, 108.223034));
    route0.add(MFLatLng(16.075353, 108.223513));

    final List<MFLatLng> route1 = <MFLatLng>[];
    route1.add(MFLatLng(16.078814, 108.221592));
    route1.add(MFLatLng(16.077491, 108.221735));
    route1.add(MFLatLng(16.077659, 108.223212));
    route1.add(MFLatLng(16.075353, 108.223513));

    final List<List<MFLatLng>> routes = <List<MFLatLng>>[];
    routes.add(route0);
    routes.add(route1);

    return routes;
  }
}
