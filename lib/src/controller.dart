part of map4d_map;

class MFMapViewController {
  final int mapId;
  final _MFMapViewState _mapState;
  final MethodChannel _channel;

  MFMapViewController._(this.mapId, this._mapState, this._channel) {
    _channel.setMethodCallHandler((call) => _handleMethodCall(call));
  }

  /// Initialize control of a [Map4d] with [mapId].
  ///
  /// Mainly for internal use when instantiating a [MFMapViewController] passed
  /// in [Map4dMap.onMapCreated] callback.
  static Future<MFMapViewController> init(
    int mapId,
    _MFMapViewState mapState,
  ) async {
    final channel = MethodChannel('plugin:map4d-map-view-type_$mapId');
    return MFMapViewController._(mapId, mapState, channel);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'camera#onMoveStarted':
        if (_mapState.widget.onCameraMoveStarted != null) {
          _mapState.widget.onCameraMoveStarted!();
        }
        break;
      case 'camera#onMove':
        if (_mapState.widget.onCameraMove != null) {
          final position = MFCameraPosition.fromMap(call.arguments['position']);
          _mapState.widget.onCameraMove!(position!);
        }
        break;
      case 'camera#onIdle':
        if (_mapState.widget.onCameraIdle != null) {
          _mapState.widget.onCameraIdle!();
        }
        break;
      case 'poi#onTap':
        _mapState.onPOITap(MFPOIId(call.arguments['poiId']));
        break;
      case 'building#onTap':
        _mapState.onBuildingTap(MFBuildingId(call.arguments['buildingId']));
        break;
      case 'polyline#onTap':
        _mapState.onPolylineTap(MFPolylineId(call.arguments['polylineId']));
        break;
      case 'polygon#onTap':
        _mapState.onPolygonTap(MFPolygonId(call.arguments['polygonId']));
        break;
      case 'circle#onTap':
        _mapState.onCircleTap(MFCircleId(call.arguments['circleId']));
        break;
      case 'marker#onTap':
        _mapState.onMarkerTap(MFMarkerId(call.arguments['markerId']));
        break;
      case 'infoWindow#onTap':
        _mapState.onInfoWindowTap(MFMarkerId(call.arguments['markerId']));
        break;
      case 'marker#onDragEnd':
        final markerId = MFMarkerId(call.arguments['markerId']);
        final position = MFLatLng.fromJson(call.arguments['position']);
        if (position == null) {
          return;
        }
        _mapState.onMarkerDragEnd(markerId, position);
        break;
      case 'directionsRenderer#onRouteTap':
        final rendererId = MFDirectionsRendererId(call.arguments['rendererId']);
        final routeIndex = call.arguments['routeIndex'];
        _mapState.onDirectionTap(rendererId, routeIndex);
        break;
      case 'map#didTapAtCoordinate':
        if (_mapState.widget.onTap != null) {
          final coordinate = MFLatLng.fromJson(call.arguments['coordinate']);
          _mapState.widget.onTap!(coordinate!);
        }
        break;
      case 'map#onTapPOI':
        final onPOITap = _mapState.widget.onPOITap;
        if (onPOITap != null) {
          final String placeId = call.arguments['placeId'];
          final String name = call.arguments['name'];
          final MFLatLng location =
              MFLatLng.fromJson(call.arguments['location'])!;
          onPOITap(placeId, name, location);
        }
        break;
      case 'map#onTapBuilding':
        final onBuildingTap = _mapState.widget.onBuildingTap;
        if (onBuildingTap != null) {
          final String buildingId = call.arguments['buildingId'];
          final String name = call.arguments['name'];
          final MFLatLng location =
              MFLatLng.fromJson(call.arguments['location'])!;
          onBuildingTap(buildingId, name, location);
        }
        break;
      case 'map#onTapPlace':
        final onPlaceTap = _mapState.widget.onPlaceTap;
        if (onPlaceTap != null) {
          final String name = call.arguments['name'];
          final MFLatLng location =
              MFLatLng.fromJson(call.arguments['location'])!;
          onPlaceTap(name, location);
        }
        break;
      case 'map#onModeChange':
        final is3DMode = call.arguments['is3DMode'];
        _mapState.widget.onModeChange!(is3DMode);
        break;
      default:
        print('Unknow callback method: ${call.method}');
    }
  }

  /// Returns the current zoom level of the map
  Future<double> getZoomLevel() async {
    return (await _channel.invokeMethod<double>('map#getZoomLevel'))!;
  }

  Future<void> moveCamera(MFCameraUpdate cameraUpdate) {
    return _channel.invokeMethod<void>('camera#move',
        <String, dynamic>{'cameraUpdate': cameraUpdate.toJson()});
  }

  Future<void> animateCamera(MFCameraUpdate cameraUpdate) {
    return _channel.invokeMethod<void>('camera#animate',
        <String, Object>{'cameraUpdate': cameraUpdate.toJson()});
  }

  Future<MFCameraPosition> cameraForBounds(MFLatLngBounds bounds,
      {double padding = 0}) async {
    final Map<String, dynamic> cameraPosition = (await _channel
        .invokeMapMethod<String, dynamic>('map#cameraForBounds',
            <String, dynamic>{'bounds': bounds.toJson(), 'padding': padding}))!;
    return MFCameraPosition.fromMap(cameraPosition)!;
  }

  Future<MFCameraPosition?> getCameraPosition() async {
    final Map<String, dynamic> cameraPosition = (await _channel
        .invokeMapMethod<String, dynamic>('map#getCameraPosition'))!;
    return MFCameraPosition.fromMap(cameraPosition);
  }

  /// Return [MFLatLngBounds] defining the region that is visible in a map.
  Future<MFLatLngBounds?> getBounds() async {
    final Map<String, dynamic> latLngBounds =
        (await _channel.invokeMapMethod<String, dynamic>('map#getBounds'))!;
    final MFLatLng? southwest = MFLatLng.fromJson(latLngBounds['southwest']);
    final MFLatLng? northeast = MFLatLng.fromJson(latLngBounds['northeast']);
    if (southwest == null || northeast == null) {
      return null;
    }

    return MFLatLngBounds(southwest: southwest, northeast: northeast);
  }

  Future<void> fitBounds(MFLatLngBounds bounds, {double padding = 0}) async {
    return _channel.invokeMethod<void>('map#fitBounds',
        <String, dynamic>{'bounds': bounds.toJson(), 'padding': padding});
  }

  Future<void> enable3DMode(bool isEnable) {
    return _channel.invokeMethod<bool>(
        'map#enable3DMode', <String, Object>{'enable3DMode': isEnable});
  }

  /// Clears the tile cache so that all tiles will be requested again from the
  /// [TileProvider].
  ///
  /// The current tiles from this tile overlay will also be
  /// cleared from the map after calling this method. The API maintains a small
  /// in-memory cache of tiles. If you want to cache tiles for longer, you
  /// should implement an on-disk cache.
  Future<void> clearTileCache(MFTileOverlayId tileOverlayId) async {
    assert(tileOverlayId != null);
    return _channel.invokeMethod<void>('tileOverlays#clearTileCache',
        <String, Object>{'tileOverlayId': tileOverlayId.value});
  }

  /// Updates configuration options of the map user interface.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateMapOptions(Map<String, dynamic> optionsUpdate) {
    assert(optionsUpdate != null);
    return _channel.invokeMethod<void>(
      'map#update',
      <String, dynamic>{'options': optionsUpdate},
    );
  }

  /// Updates tile overlays configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateTileOverlays(TileOverlayUpdates tileOverlayUpdates) {
    assert(tileOverlayUpdates != null);
    return _channel.invokeMethod<void>(
        'tileOverlays#update', tileOverlayUpdates.toJson());
  }

  /// Updates POI configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updatePOIs(POIUpdates poiUpdates) {
    assert(poiUpdates != null);
    return _channel.invokeMethod<void>('poi#update', poiUpdates.toJson());
  }

  /// Updates Building configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateBuildings(BuildingUpdates buildingUpdates) {
    assert(buildingUpdates != null);
    return _channel.invokeMethod<void>(
        'building#update', buildingUpdates.toJson());
  }

  /// Updates polyline configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updatePolylines(PolylineUpdates polylineUpdates) {
    assert(polylineUpdates != null);
    return _channel.invokeMethod<void>(
        'polylines#update', polylineUpdates.toJson());
  }

  /// Updates polygon configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updatePolygons(PolygonUpdates polygonUpdates) {
    assert(polygonUpdates != null);
    return _channel.invokeMethod<void>(
        'polygons#update', polygonUpdates.toJson());
  }

  /// Updates circle configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateCircles(CircleUpdates circleUpdates) {
    assert(circleUpdates != null);
    return _channel.invokeMethod<void>(
        'circles#update', circleUpdates.toJson());
  }

  /// Updates marker configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateMarkers(MarkerUpdates markerUpdates) {
    assert(markerUpdates != null);
    return _channel.invokeMethod<void>(
        'markers#update', markerUpdates.toJson());
  }

  /// Updates directions renderer configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateDirectionsRenderers(DirectionsRendererUpdates rendererUpdates) {
    assert(rendererUpdates != null);
    return _channel.invokeMethod<void>(
        'directionsRenderers#update', rendererUpdates.toJson());
  }
}
