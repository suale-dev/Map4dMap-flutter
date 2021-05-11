part of map4d_map_flutter;

/// Pass to [Map4dMap.onMapCreated] to receive a [MFMapViewController] when the map is created.
typedef void MapCreatedCallback(MFMapViewController controller);

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
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,

    this.circles = const <MFCircle>{},
  })  : super(key: key);

  @override
  State createState() => _MFMapViewState();

  /// Circles to be placed on the map.
  final Set<MFCircle> circles;

  /// Callback method for when the map is ready to be used.
  /// Used to receive a [MFMapViewController] for this [Map4dMap].
  final MapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  final MFCameraPosition? initialCameraPosition;

  /// Called when the camera starts moving.
  final VoidCallback? onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an onCameraMoveStarted call.
  final CameraPositionCallback? onCameraMove;

  /// Called when camera movement has ended, there are no pending animations and the user has stopped interacting with the map.
  final VoidCallback? onCameraIdle;
}

class _MFMapViewState extends State<MFMapView> {

  final Completer<MFMapViewController> _controller = Completer<MFMapViewController>();
  Map<MFCircleId, MFCircle> _circles = <MFCircleId, MFCircle>{};

  @override
  Widget build(BuildContext context) {    
    // This is used in the platform side to register the view.
    final String viewType = 'plugin:map4d-map-view-type';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'initialCameraPosition': widget.initialCameraPosition?.toMap(),
      'circlesToAdd': serializeCircleSet(widget.circles),
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
    return Text('$defaultTargetPlatform is not yet supported by the maps plugin');    
  }

  @override
  void initState() {
    super.initState();
    _circles = keyByCircleId(widget.circles);
  }

  @override
  void didUpdateWidget(MFMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCircles();
  }

  Future<void> onPlatformViewCreated(int id) async {
    final controller = await MFMapViewController.init(id, this);
    _controller.complete(controller);
    final MapCreatedCallback? onMapCreated = widget.onMapCreated;
    if (onMapCreated != null) {
      onMapCreated(controller);
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

  void _updateCircles() async {
    final MFMapViewController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateCircles(
        CircleUpdates.from(_circles.values.toSet(), widget.circles));
    _circles = keyByCircleId(widget.circles);
  }
}
