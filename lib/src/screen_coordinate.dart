import 'package:flutter/foundation.dart' show immutable, objectRuntimeType;

/// Represents a point coordinate in the [Map4D]'s view.
///
/// The screen location is specified in screen pixels (not display pixels) relative
/// to the top left of the map, not top left of the whole screen. (x, y) = (0, 0)
/// corresponds to top-left of the [Map4D] not the whole screen.
@immutable
class MFScreenCoordinate {
  /// Creates an immutable representation of a point coordinate in the [Map4D]'s view.
  const MFScreenCoordinate({
    required this.x,
    required this.y,
  });

  /// Represents the number of pixels from the left of the [Map4D].
  final int x;

  /// Represents the number of pixels from the top of the [Map4D].
  final int y;

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    return <String, int>{
      'x': x,
      'y': y,
    };
  }

  /// Initialize a MFScreenCoordinate from an \[x, y\] array.
  static MFScreenCoordinate? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is List && json.length == 2);
    final list = json as List;
    return MFScreenCoordinate(x: list[0], y: list[1]);
  }

  @override
  String toString() => '${objectRuntimeType(this, 'MFScreenCoordinate')}($x, $y)';

  @override
  bool operator ==(Object other) {
    return other is MFScreenCoordinate && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
