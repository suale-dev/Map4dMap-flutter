import 'dart:ui' show hashValues, Offset;
import 'location.dart';

class MFCameraPosition {
  /// Creates a immutable representation of the [Map4dMap] camera.
  ///
  /// [AssertionError] is thrown if [bearing], [target], [tilt], or [zoom] are
  /// null.
  const MFCameraPosition({
    this.bearing = 0.0,
    required this.target,
    this.tilt = 0.0,
    this.zoom = 0.0,
  })  : assert(bearing != null),
        assert(target != null),
        assert(tilt != null),
        assert(zoom != null);

  /// The camera's bearing in degrees, measured clockwise from north.
  ///
  /// A bearing of 0.0, the default, means the camera points north.
  /// A bearing of 90.0 means the camera points east.
  final double bearing;

  /// The geographical location that the camera is pointing at.
  final MFLatLng target;

  /// The angle, in degrees, of the camera angle from the nadir.
  ///
  /// A tilt of 0.0, the default and minimum supported value, means the camera
  /// is directly facing the Earth.
  ///
  /// The maximum tilt value depends on the current zoom level. Values beyond
  /// the supported range are allowed, but on applying them to a map they will
  /// be silently clamped to the supported range.
  final double tilt;

  /// The zoom level of the camera.
  ///
  /// A zoom of 0.0, the default, means the screen width of the world is 256.
  /// Adding 1.0 to the zoom level doubles the screen width of the map. So at
  /// zoom level 3.0, the screen width of the world is 2³x256=2048.
  ///
  /// Larger zoom levels thus means the camera is placed closer to the surface
  /// of the Earth, revealing more detail in a narrower geographical region.
  ///
  /// The supported zoom level range depends on the map data and device. Values
  /// beyond the supported range are allowed, but on applying them to a map they
  /// will be silently clamped to the supported range.
  final double zoom;

  /// Serializes [MFCameraPosition].
  ///
  /// Mainly for internal use when calling [CameraUpdate.newCameraPosition].
  Object toMap() => <String, Object>{
        'bearing': bearing,
        'target': target.toJson(),
        'tilt': tilt,
        'zoom': zoom,
      };

  /// Deserializes [MFCameraPosition] from a map.
  ///
  /// Mainly for internal use.
  static MFCameraPosition? fromMap(Object? json) {
    if (json == null || !(json is Map<dynamic, dynamic>)) {
      return null;
    }
    final MFLatLng? target = MFLatLng.fromJson(json['target']);
    if (target == null) {
      return null;
    }
    return MFCameraPosition(
      bearing: json['bearing'],
      target: target,
      tilt: json['tilt'],
      zoom: json['zoom'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final MFCameraPosition typedOther = other as MFCameraPosition;
    return bearing == typedOther.bearing &&
        target == typedOther.target &&
        tilt == typedOther.tilt &&
        zoom == typedOther.zoom;
  }

  @override
  int get hashCode => hashValues(bearing, target, tilt, zoom);

  @override
  String toString() =>
      'CameraPosition(bearing: $bearing, target: $target, tilt: $tilt, zoom: $zoom)';
}

class MFCameraUpdate {
  const MFCameraUpdate._(this._json);

  /// Returns a camera update that moves the camera to the specified position.
  static MFCameraUpdate newCameraPosition(MFCameraPosition cameraPosition) {
    return MFCameraUpdate._(
      <Object>['newCameraPosition', cameraPosition.toMap()],
    );
  }

  /// Returns a camera update that moves the camera target to the specified
  /// geographical location.
  static MFCameraUpdate newLatLng(MFLatLng latLng) {
    return MFCameraUpdate._(<Object>['newLatLng', latLng.toJson()]);
  }

  /// Returns a camera update that transforms the camera so that the specified
  /// geographical bounding box is centered in the map view at the greatest
  /// possible zoom level. A non-zero [padding] insets the bounding box from the
  /// map view's edges. The camera's new tilt and bearing will both be 0.0.
  static MFCameraUpdate newLatLngBounds(MFLatLngBounds bounds, double padding) {
    return MFCameraUpdate._(<Object>[
      'newLatLngBounds',
      bounds.toJson(),
      padding,
    ]);
  }

  /// Returns a camera update that moves the camera target to the specified
  /// geographical location and zoom level.
  static MFCameraUpdate newLatLngZoom(MFLatLng latLng, double zoom) {
    return MFCameraUpdate._(
      <Object>['newLatLngZoom', latLng.toJson(), zoom],
    );
  }

  /// Returns a camera update that moves the camera target the specified screen
  /// distance.
  ///
  /// For a camera with bearing 0.0 (pointing north), scrolling by 50,75 moves
  /// the camera's target to a geographical location that is 50 to the east and
  /// 75 to the south of the current location, measured in screen coordinates.
  // static MFCameraUpdate scrollBy(double dx, double dy) {
  //   return MFCameraUpdate._(
  //     <Object>['scrollBy', dx, dy],
  //   );
  // }

  /// Returns a camera update that modifies the camera zoom level by the
  /// specified amount. The optional [focus] is a screen point whose underlying
  /// geographical location should be invariant, if possible, by the movement.
  // static MFCameraUpdate zoomBy(double amount, [Offset? focus]) {
  //   if (focus == null) {
  //     return MFCameraUpdate._(<Object>['zoomBy', amount]);
  //   } else {
  //     return MFCameraUpdate._(<Object>[
  //       'zoomBy',
  //       amount,
  //       <double>[focus.dx, focus.dy],
  //     ]);
  //   }
  // }

  /// Returns a camera update that zooms the camera in, bringing the camera
  /// closer to the surface of the Earth.
  ///
  /// Equivalent to the result of calling `zoomBy(1.0)`.
  // static MFCameraUpdate zoomIn() {
  //   return const MFCameraUpdate._(<Object>['zoomIn']);
  // }

  /// Returns a camera update that zooms the camera out, bringing the camera
  /// further away from the surface of the Earth.
  ///
  /// Equivalent to the result of calling `zoomBy(-1.0)`.
  // static MFCameraUpdate zoomOut() {
  //   return const MFCameraUpdate._(<Object>['zoomOut']);
  // }

  /// Returns a camera update that sets the camera zoom level.
  // static MFCameraUpdate zoomTo(double zoom) {
  //   return MFCameraUpdate._(<Object>['zoomTo', zoom]);
  // }

  final Object _json;

  /// Converts this object to something serializable in JSON.
  Object toJson() => _json;
}
