part of map4d_map_flutter;

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
      case 'polyline#onTap':
        _mapState.onPolylineTap(MFPolylineId(call.arguments['polylineId']));
        break;
      case 'circle#onTap':
        _mapState.onCircleTap(MFCircleId(call.arguments['circleId']));
        break;
      case 'map#didTapAtCoordinate':
        if (_mapState.widget.onTap != null) {
          final coordinate = LatLng.fromJson(call.arguments['coordinate']);
          _mapState.widget.onTap!(coordinate!);
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

  Future<MFCameraPosition> cameraForBounds(LatLngBounds bounds, { double padding = 0 }) async {
    final Map<String, dynamic> cameraPosition = (await _channel.invokeMapMethod<String, dynamic>('map#cameraForBounds',
        <String, dynamic>{'bounds': bounds.toJson(), 'padding': padding}))!;
    return MFCameraPosition.fromMap(cameraPosition)!;
  }

  Future<void> fitBounds(LatLngBounds bounds, { double padding = 0 }) async {
    return _channel.invokeMethod<void>('map#fitBounds',
        <String, dynamic>{'bounds': bounds.toJson(), 'padding': padding});
  }

  Future<void> enable3DMode(bool isEnable) {
    return _channel.invokeMethod<bool>(
        'map#enable3DMode', <String, Object>{'enable3DMode': isEnable});
  }

  /// Updates configuration options of the map user interface.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateMapOptions(Map<String, dynamic> optionsUpdate) {
    assert(optionsUpdate != null);
    return _channel.invokeMethod<void>('map#update', <String, dynamic>{'options': optionsUpdate},
    );
  }

  /// Updates POI configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updatePOIs(POIUpdates poiUpdates) {
    assert(poiUpdates != null);
    return _channel.invokeMethod<void>(
        'poi#update', poiUpdates.toJson());
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
}
