import 'dart:ui' show hashValues;
import 'package:flutter/foundation.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:meta/meta.dart' show immutable;

import 'overlays.dart';

/// Uniquely identifies a [MFImageOverlay] among [Map4dMap] image overlays.
@immutable
class MFImageOverlayId extends MapsObjectId<MFImageOverlay> {
  /// Creates an immutable identifier for a [MFImageOverlay].
  const MFImageOverlayId(String value) : super(value);
}

/// A set of images which are displayed on top of the base map tiles.
class MFImageOverlay implements MapsObject {
  /// Creates an immutable representation of a [MFImageOverlay] to draw on [Map4dMap].
  const MFImageOverlay({
    required this.imageOverlayId,
    required this.image,
    required this.bounds,
    this.transparency = 0.0,
    this.zIndex = 0,
    this.visible = true,
  }) : assert(transparency >= 0.0 && transparency <= 1.0);

  /// Uniquely identifies a [MFImageOverlay].
  final MFImageOverlayId imageOverlayId;

  @override
  MFImageOverlayId get mapsId => imageOverlayId;

  /// 
  final MFBitmap image;

  ///
  final MFLatLngBounds bounds;

  /// The transparency of the image overlay. The default transparency is 0 (opaque).
  final double transparency;

  /// The image overlay's zIndex, i.e., the order in which it will be drawn where
  /// overlays with larger values are drawn above those with lower values
  final int zIndex;

  /// The visibility for the image overlay. The default visibility is true.
  final bool visible;

  /// Creates a new [MFImageOverlay] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  MFImageOverlay copyWith({
    double? transparencyParam,
    int? zIndexParam,
    bool? visibleParam,
  }) {
    return MFImageOverlay(
      imageOverlayId: imageOverlayId,
      image: image,
      bounds: bounds,
      transparency: transparencyParam ?? transparency,
      zIndex: zIndexParam ?? zIndex,
      visible: visibleParam ?? visible,
    );
  }

  MFImageOverlay clone() => copyWith();

  /// Converts this object to JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('imageOverlayId', imageOverlayId.value);
    addIfPresent('image', image.toJson());
    addIfPresent('bounds', bounds.toJson());
    addIfPresent('transparency', transparency);
    addIfPresent('zIndex', zIndex);
    addIfPresent('visible', visible);

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MFImageOverlay &&
        imageOverlayId == other.imageOverlayId &&
        image == other.image &&
        bounds == other.bounds &&
        transparency == other.transparency &&
        zIndex == other.zIndex &&
        visible == other.visible;
  }

  @override
  int get hashCode => hashValues(imageOverlayId, image, bounds, transparency, zIndex, visible);
}
