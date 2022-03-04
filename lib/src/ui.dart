import 'dart:ui' show hashValues;

/// Type of maps to display
enum MFMapType {
  /// Roadmap maps, default
  roadmap,

  /// Raster maps
  raster,

  /// Satellite maps
  satellite,

  /// 3D maps
  map3D,
}

class MFMinMaxZoom {
  /// Creates a immutable representation of the preferred minimum and maximum zoom values for the map camera.
  ///
  /// [AssertionError] will be thrown if [minZoom] > [maxZoom].
  const MFMinMaxZoom(this.minZoom, this.maxZoom)
      : assert(minZoom == null || maxZoom == null || minZoom <= maxZoom);

  /// The preferred minimum zoom level or null, if unbounded from below.
  final double? minZoom;

  /// The preferred maximum zoom level or null, if unbounded from above.
  final double? maxZoom;

  /// Unbounded zooming.
  static const MFMinMaxZoom unbounded = MFMinMaxZoom(null, null);

  /// Converts this object to something serializable in JSON.
  Object toJson() => <Object?>[minZoom, maxZoom];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final MFMinMaxZoom typedOther = other as MFMinMaxZoom;
    return minZoom == typedOther.minZoom && maxZoom == typedOther.maxZoom;
  }

  @override
  int get hashCode => hashValues(minZoom, maxZoom);

  @override
  String toString() {
    return 'MinMaxZoomPreference(minZoom: $minZoom, maxZoom: $maxZoom)';
  }
}
