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
    // await GoogleMapsFlutterPlatform.instance.init(id);
    final channel = MethodChannel('plugin:map4d-map-view-type_$mapId');
    return MFMapViewController._(mapId, mapState, channel);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    print('call back method: ${call.method}');
  }

  /// Returns the current zoom level of the map
  Future<double> getZoomLevel() async {
    return (await _channel.invokeMethod<double>('map#getZoomLevel'))!;
  }

  Future<void> moveCamera(MFCameraUpdate cameraUpdate) {
    return _channel.invokeMethod<void>('camera#move', <String, dynamic>{'cameraUpdate': cameraUpdate.toJson()});
  }

  Future<void> animateCamera(MFCameraUpdate cameraUpdate) {
    return _channel.invokeMethod<void>('camera#animate', <String, Object>{'cameraUpdate': cameraUpdate.toJson()});
  }
}
