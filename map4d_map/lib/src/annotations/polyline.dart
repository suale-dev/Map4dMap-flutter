// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show listEquals, VoidCallback;
import 'package:flutter/material.dart' show Color, Colors;
import 'package:meta/meta.dart' show immutable;

import 'annotations.dart';

/// Uniquely identifies a [MFPolyline] among [MFMapView] polylines.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class MFPolylineId extends MapsObjectId<MFPolyline> {
  /// Creates an immutable object representing a [MFPolylineId] among [MFMapView] polylines.
  ///
  /// An [AssertionError] will be thrown if [value] is null.
  const MFPolylineId(String value) : super(value);
}

/// Styles for [MFPolyline].
@immutable
class MFPolylineStyle {
  const MFPolylineStyle._(this.value);

  /// The value representing the [MFPolylineStyle] on the sdk.
  final int value;

  static const MFPolylineStyle solid = MFPolylineStyle._(0);
  static const MFPolylineStyle dotted = MFPolylineStyle._(1);
}

/// Draws a line through geographical locations on the map.
@immutable
class MFPolyline implements MapsObject {
  /// Creates an immutable object representing a line drawn through geographical locations on the map.
  const MFPolyline({
    required this.polylineId,
    this.consumeTapEvents = false,
    this.color = Colors.black,
    this.style = MFPolylineStyle.solid,
    this.points = const <LatLng>[],
    this.visible = true,
    this.width = 10,
    this.zIndex = 0,
    this.onTap,
  });

  /// Uniquely identifies a [MFPolyline].
  final MFPolylineId polylineId;

  @override
  MFPolylineId get mapsId => polylineId;

  /// True if the [MFPolyline] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  /// Line segment color in ARGB format, the same format used by Color. The default value is black (0xff000000).
  final Color color;

  /// Style of Polyline: solid or dooted.
  final MFPolylineStyle style;

  /// The vertices of the polyline to be drawn.
  ///
  /// Line segments are drawn between consecutive points. A polyline is not closed by
  /// default; to form a closed polyline, the start and end points must be the same.
  final List<LatLng> points;

  /// True if the marker is visible.
  final bool visible;

  /// Width of the polyline, used to define the width of the line segment to be drawn.
  ///
  /// The width is constant and independent of the camera's zoom level.
  /// The default value is 10.
  final int width;

  /// The z-index of the polyline, used to determine relative drawing order of
  /// map overlays.
  ///
  /// Overlays are drawn in order of z-index, so that lower values means drawn
  /// earlier, and thus appearing to be closer to the surface of the Earth.
  final int zIndex;

  /// Callbacks to receive tap events for polyline placed on this map.
  final VoidCallback? onTap;

  /// Creates a new [MFPolyline] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  MFPolyline copyWith({
    Color? colorParam,
    bool? consumeTapEventsParam,
    MFPolylineStyle? styleParam,
    List<LatLng>? pointsParam,
    bool? visibleParam,
    int? widthParam,
    int? zIndexParam,
    VoidCallback? onTapParam,
  }) {
    return MFPolyline(
      polylineId: polylineId,
      color: colorParam ?? color,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      style: styleParam ?? style,
      points: pointsParam ?? points,
      visible: visibleParam ?? visible,
      width: widthParam ?? width,
      onTap: onTapParam ?? onTap,
      zIndex: zIndexParam ?? zIndex,
    );
  }

  /// Creates a new [MFPolyline] object whose values are the same as this
  /// instance.
  MFPolyline clone() {
    return copyWith(
      pointsParam: List<LatLng>.of(points),
    );
  }

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('polylineId', polylineId.value);
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('color', color.value);
    addIfPresent('style', style.value);
    addIfPresent('visible', visible);
    addIfPresent('width', width);
    addIfPresent('zIndex', zIndex);

    if (points != null) {
      json['points'] = _pointsToJson();
    }

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final MFPolyline typedOther = other as MFPolyline;
    return polylineId == typedOther.polylineId &&
        consumeTapEvents == typedOther.consumeTapEvents &&
        color == typedOther.color &&
        style == typedOther.style &&
        listEquals(points, typedOther.points) &&
        visible == typedOther.visible &&
        width == typedOther.width &&
        zIndex == typedOther.zIndex;
  }

  @override
  int get hashCode => polylineId.hashCode;

  Object _pointsToJson() {
    final List<Object> result = <Object>[];
    for (final LatLng point in points) {
      result.add(point.toJson());
    }
    return result;
  }
}
