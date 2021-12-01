import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

class PlaceDirectionsRendererPage extends Map4dMapExampleAppPage {
  PlaceDirectionsRendererPage() : super(const Icon(Icons.linear_scale), 'DirectionsRenderer');

  @override
  Widget build(BuildContext context) {
    return const PlaceDirectionsRendererBody();
  }
}

class PlaceDirectionsRendererBody extends StatefulWidget {
  const PlaceDirectionsRendererBody();

  @override
  State<StatefulWidget> createState() => PlaceDirectionsRendererBodyState();
}

class PlaceDirectionsRendererBodyState extends State<PlaceDirectionsRendererBody> {
  PlaceDirectionsRendererBodyState() {
    final MFDirectionsRendererId rendererId = MFDirectionsRendererId('renderer_id_0');
    final MFDirectionsRenderer renderer = MFDirectionsRenderer(
      rendererId: rendererId,
      routes: _createRoutes(),
      onTap: () {
        _onTapped(rendererId);
      },
    );

    renderers[rendererId] = renderer;
  }

  MFMapViewController? controller;
  Map<MFDirectionsRendererId, MFDirectionsRenderer> renderers = <MFDirectionsRendererId, MFDirectionsRenderer>{};

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  void _onTapped(MFDirectionsRendererId rendererId) {
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 600.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                target: MFLatLng(16.077491, 108.221735),
                zoom: 16.0,
              ),
              directionsRenderers: Set<MFDirectionsRenderer>.of(renderers.values),

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
                  ],
                )
              ],
            ),
          ),
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
