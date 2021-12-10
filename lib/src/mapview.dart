part of map4d_map;

/// Pass to [Map4dMap.onMapCreated] to receive a [MFMapViewController] when the map is created.
typedef void MFMapCreatedCallback(MFMapViewController controller);

/// Error thrown when an unknown map object ID is provided to a method.
class UnknownMapObjectIdError extends Error {
  /// Creates an assertion error with the provided [message].
  UnknownMapObjectIdError(this.objectType, this.objectId, [this.context]);

  /// The name of the map object whose ID is unknown.
  final String objectType;

  /// The unknown maps object ID.
  final MapsObjectId objectId;

  /// The context where the error occurred.
  final String? context;

  String toString() {
    if (context != null) {
      return 'Unknown $objectType ID "${objectId.value}" in $context';
    }
    return 'Unknown $objectType ID "${objectId.value}"';
  }
}

class MFMapView extends StatefulWidget {
  const MFMapView({
    Key? key,
    this.initialCameraPosition,
    this.onMapCreated,
    this.mapType = MFMapType.roadmap,
    this.minMaxZoomPreference = MFMinMaxZoom.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.poisEnabled = true,
    this.buildingsEnabled = true,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onModeChange,
    this.onPOITap,
    this.onBuildingTap,
    this.onPlaceTap,
    this.markers = const <MFMarker>{},
    this.circles = const <MFCircle>{},
    this.polygons = const <MFPolygon>{},
    this.polylines = const <MFPolyline>{},
    this.pois = const <MFPOI>{},
    this.buildings = const <MFBuilding>{},
    this.tileOverlays = const <MFTileOverlay>{},
    this.directionsRenderers = const <MFDirectionsRenderer>{},
  }) : super(key: key);

  @override
  State createState() => _MFMapViewState();

  /// Tile overlays to be placed on the map.
  final Set<MFTileOverlay> tileOverlays;

  /// POIs to be placed on the map.
  final Set<MFPOI> pois;

  /// Buildings to be placed on the map.
  final Set<MFBuilding> buildings;

  /// Polylines to be placed on the map.
  final Set<MFPolyline> polylines;

  /// Polygons to be placed on the map.
  final Set<MFPolygon> polygons;

  /// Circles to be placed on the map.
  final Set<MFCircle> circles;

  /// Markers to be placed on the map.
  final Set<MFMarker> markers;

  /// Directions renderers to be placed on the map.
  final Set<MFDirectionsRenderer> directionsRenderers;

  /// Callback method for when the map is ready to be used.
  /// Used to receive a [MFMapViewController] for this [Map4dMap].
  final MFMapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  final MFCameraPosition? initialCameraPosition;

  /// Type of map tiles to be rendered.
  final MFMapType mapType;

  /// Preferred bounds for the camera zoom level.
  final MFMinMaxZoom minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// Enabling this feature requires adding location permissions to both native platforms of your app.
  final bool myLocationEnabled;

  /// Enables or disables the my-location button.
  final bool myLocationButtonEnabled;

  /// Enables or disables showing 3D buildings where available
  final bool buildingsEnabled;

  /// Enables or disables showing points of interest
  final bool poisEnabled;

  /// Called when the camera starts moving.
  final VoidCallback? onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an onCameraMoveStarted call.
  final MFCameraPositionCallback? onCameraMove;

  /// Called when camera movement has ended, there are no pending animations and the user has stopped interacting with the map.
  final VoidCallback? onCameraIdle;

  /// Called when did tap at coordinate
  final MFLatLngCallback? onTap;

  /// Called when map mode change from 2D -> 3D & 3D -> 2D
  final MFModeChangedCallback? onModeChange;

  /// Called after a base map POI has been tapped
  final MFMapPOICallback? onPOITap;

  /// Called after a base map building has been tapped
  final MFMapBuildingCallback? onBuildingTap;

  ///
  final MFMapPlaceCallback? onPlaceTap;
}

class _MFMapViewState extends State<MFMapView> {
  final Completer<MFMapViewController> _controller =
      Completer<MFMapViewController>();
  late _MFMapViewOptions _mapOptions;
  Map<MFTileOverlayId, MFTileOverlay> _tileOverlays =
      <MFTileOverlayId, MFTileOverlay>{};
  Map<MFPOIId, MFPOI> _pois = <MFPOIId, MFPOI>{};
  Map<MFBuildingId, MFBuilding> _buildings = <MFBuildingId, MFBuilding>{};
  Map<MFPolylineId, MFPolyline> _polylines = <MFPolylineId, MFPolyline>{};
  Map<MFPolygonId, MFPolygon> _polygons = <MFPolygonId, MFPolygon>{};
  Map<MFCircleId, MFCircle> _circles = <MFCircleId, MFCircle>{};
  Map<MFMarkerId, MFMarker> _markers = <MFMarkerId, MFMarker>{};
  Map<MFDirectionsRendererId, MFDirectionsRenderer> _directionsRenderers =
      <MFDirectionsRendererId, MFDirectionsRenderer>{};

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    final String viewType = 'plugin:map4d-map-view-type';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'options': _mapOptions.toMap(),
      'initialCameraPosition': widget.initialCameraPosition?.toMap(),
      'tileOverlaysToAdd': serializeTileOverlaySet(widget.tileOverlays),
      'poisToAdd': serializePOISet(widget.pois),
      'buildingsToAdd': serializeBuildingSet(widget.buildings),
      'polylinesToAdd': serializePolylineSet(widget.polylines),
      'polygonsToAdd': serializePolygonSet(widget.polygons),
      'circlesToAdd': serializeCircleSet(widget.circles),
      'markersToAdd': serializeMarkerSet(widget.markers),
      'directionsRenderersToAdd':
          serializeDirectionsRendererSet(widget.directionsRenderers),
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: viewType,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  @override
  void initState() {
    super.initState();
    _mapOptions = _MFMapViewOptions.fromWidget(widget);
    _tileOverlays = keyTileOverlayId(widget.tileOverlays);
    _pois = keyByPOIId(widget.pois);
    _buildings = keyByBuildingId(widget.buildings);
    _polylines = keyByPolylineId(widget.polylines);
    _polygons = keyByPolygonId(widget.polygons);
    _circles = keyByCircleId(widget.circles);
    _markers = keyByMarkerId(widget.markers);
    _directionsRenderers =
        keyByDirectionsRendererId(widget.directionsRenderers);
  }

  @override
  void didUpdateWidget(MFMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateOptions();
    _updateTileOverlays();
    _updatePOIs();
    _updateBuildings();
    _updatePolylines();
    _updatePolygons();
    _updateCircles();
    _updateMarkers();
    _updateDirectionsRenderers();
  }

  Future<void> onPlatformViewCreated(int id) async {
    final controller = await MFMapViewController.init(id, this);
    _controller.complete(controller);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final MFMapCreatedCallback? onMapCreated = widget.onMapCreated;
      if (onMapCreated != null) {
        onMapCreated(controller);
      }
    }
  }

  void onPOITap(MFPOIId poiId) {
    assert(poiId != null);
    final MFPOI? poi = _pois[poiId];
    if (poi == null) {
      throw UnknownMapObjectIdError('poi', poiId, 'onTap');
    }
    final VoidCallback? onTap = poi.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onBuildingTap(MFBuildingId buildingId) {
    assert(buildingId != null);
    final MFBuilding? building = _buildings[buildingId];
    if (building == null) {
      throw UnknownMapObjectIdError('building', buildingId, 'onTap');
    }
    final VoidCallback? onTap = building.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onPolylineTap(MFPolylineId polylineId) {
    assert(polylineId != null);
    final MFPolyline? polyline = _polylines[polylineId];
    if (polyline == null) {
      throw UnknownMapObjectIdError('polyline', polylineId, 'onTap');
    }
    final VoidCallback? onTap = polyline.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onPolygonTap(MFPolygonId polygonId) {
    assert(polygonId != null);
    final MFPolygon? polygon = _polygons[polygonId];
    if (polygon == null) {
      throw UnknownMapObjectIdError('polygon', polygonId, 'onTap');
    }
    final VoidCallback? onTap = polygon.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onCircleTap(MFCircleId circleId) {
    assert(circleId != null);
    final MFCircle? circle = _circles[circleId];
    if (circle == null) {
      throw UnknownMapObjectIdError('circle', circleId, 'onTap');
    }
    final VoidCallback? onTap = circle.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onMarkerTap(MFMarkerId markerId) {
    final MFMarker? marker = _markers[markerId];
    if (marker == null) {
      throw UnknownMapObjectIdError('marker', markerId, 'onTap');
    }
    final VoidCallback? onTap = marker.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onInfoWindowTap(MFMarkerId markerId) {
    final MFMarker? marker = _markers[markerId];
    if (marker == null) {
      throw UnknownMapObjectIdError('marker', markerId, 'onTap');
    }
    final VoidCallback? onTap = marker.infoWindow.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onMarkerDragEnd(MFMarkerId markerId, MFLatLng position) {
    final MFMarker? marker = _markers[markerId];
    if (marker == null) {
      throw UnknownMapObjectIdError('marker', markerId, 'onMarkerDragEnd');
    }
    final ValueChanged<MFLatLng>? onDragEnd = marker.onDragEnd;
    if (onDragEnd != null) {
      onDragEnd(position);
    }
  }

  void onDirectionTap(MFDirectionsRendererId rendererId, int routeIndex) {
    final MFDirectionsRenderer? renderer = _directionsRenderers[rendererId];
    if (renderer == null) {
      throw UnknownMapObjectIdError('renderer', rendererId, 'onRouteTap');
    }
    final MFDirectionsCallback? onRouteTap = renderer.onRouteTap;
    if (onRouteTap != null) {
      onRouteTap(routeIndex);
    }
  }

  void _updateOptions() async {
    final _MFMapViewOptions newOptions = _MFMapViewOptions.fromWidget(widget);
    final Map<String, dynamic> updates = _mapOptions.updatesMap(newOptions);
    if (updates.isEmpty) {
      return;
    }
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateMapOptions(updates);
    _mapOptions = newOptions;
  }

  void _updateTileOverlays() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateTileOverlays(TileOverlayUpdates.from(
        _tileOverlays.values.toSet(), widget.tileOverlays));
    _tileOverlays = keyTileOverlayId(widget.tileOverlays);
  }

  void _updatePOIs() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updatePOIs(POIUpdates.from(_pois.values.toSet(), widget.pois));
    _pois = keyByPOIId(widget.pois);
  }

  void _updateBuildings() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateBuildings(
        BuildingUpdates.from(_buildings.values.toSet(), widget.buildings));
    _buildings = keyByBuildingId(widget.buildings);
  }

  void _updatePolylines() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updatePolylines(
        PolylineUpdates.from(_polylines.values.toSet(), widget.polylines));
    _polylines = keyByPolylineId(widget.polylines);
  }

  void _updatePolygons() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updatePolygons(
        PolygonUpdates.from(_polygons.values.toSet(), widget.polygons));
    _polygons = keyByPolygonId(widget.polygons);
  }

  void _updateCircles() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateCircles(
        CircleUpdates.from(_circles.values.toSet(), widget.circles));
    _circles = keyByCircleId(widget.circles);
  }

  void _updateMarkers() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateMarkers(
        MarkerUpdates.from(_markers.values.toSet(), widget.markers));
    _markers = keyByMarkerId(widget.markers);
  }

  void _updateDirectionsRenderers() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateDirectionsRenderers(DirectionsRendererUpdates.from(
        _directionsRenderers.values.toSet(), widget.directionsRenderers));
    _directionsRenderers =
        keyByDirectionsRendererId(widget.directionsRenderers);
  }
}

/// MFMapView configuration options.
class _MFMapViewOptions {
  _MFMapViewOptions.fromWidget(MFMapView map)
      : rotateGesturesEnabled = map.rotateGesturesEnabled,
        scrollGesturesEnabled = map.scrollGesturesEnabled,
        tiltGesturesEnabled = map.tiltGesturesEnabled,
        zoomGesturesEnabled = map.zoomGesturesEnabled,
        myLocationEnabled = map.myLocationEnabled,
        myLocationButtonEnabled = map.myLocationButtonEnabled,
        buildingsEnabled = map.buildingsEnabled,
        poisEnabled = map.poisEnabled,
        mapType = map.mapType,
        minMaxZoomPreference = map.minMaxZoomPreference,
        trackCameraPosition = map.onCameraMove != null;

  // final CameraTargetBounds cameraTargetBounds;
  final MFMapType mapType;
  final MFMinMaxZoom minMaxZoomPreference;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
  final bool tiltGesturesEnabled;
  final bool zoomGesturesEnabled;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool buildingsEnabled;
  final bool poisEnabled;

  final bool trackCameraPosition;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'cameraTargetBounds': cameraTargetBounds.toJson(),
      'mapType': mapType.index,
      'minMaxZoomPreference': minMaxZoomPreference.toJson(),
      'rotateGesturesEnabled': rotateGesturesEnabled,
      'scrollGesturesEnabled': scrollGesturesEnabled,
      'tiltGesturesEnabled': tiltGesturesEnabled,
      'zoomGesturesEnabled': zoomGesturesEnabled,
      'myLocationEnabled': myLocationEnabled,
      'myLocationButtonEnabled': myLocationButtonEnabled,
      'poisEnabled': poisEnabled,
      'buildingsEnabled': buildingsEnabled,
      'trackCameraPosition': trackCameraPosition,
    };
  }

  Map<String, dynamic> updatesMap(_MFMapViewOptions newOptions) {
    final Map<String, dynamic> prevOptionsMap = toMap();

    return newOptions.toMap()
      ..removeWhere(
          (String key, dynamic value) => prevOptionsMap[key] == value);
  }
}
