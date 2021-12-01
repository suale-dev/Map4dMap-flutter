import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter/material.dart' show Color, Colors;
import 'package:meta/meta.dart' show immutable;

import 'directions.dart';

/// Uniquely identifies a [MFDirectionsRenderer] among [MFMapView] directions renderer.
///
/// This does not have to be globally unique, only unique among the list.
///
class MFDirectionsRendererId extends MapsObjectId<MFDirectionsRenderer> {
  /// Creates an immutable identifier for a [MFDirectionsRenderer].
  const MFDirectionsRendererId(String value) : super(value);
}

/// Draws a gon through geographical locations on the map.
@immutable
class MFDirectionsRenderer implements MapsObject {
  /// Creates an immutable object representing a gon drawn through geographical locations on the map.
  const MFDirectionsRenderer({
    required this.rendererId,
    this.routes = const <List<MFLatLng>>[],
    this.directions = "",
    this.activedIndex = 0,
    this.activeStrokeWidth = 8,
    this.activeStrokeColor = Colors.blue,
    this.activeOutlineWidth = 2,
    this.activeOutlineColor = const Color(0xFF0D47A1),
    this.inactiveStrokeWidth = 8,
    this.inactiveStrokeColor = Colors.blueGrey,
    this.inactiveOutlineWidth = 1,
    this.inactiveOutlineColor = const Color(0xFF263238),
    this.onTap,
  });

  /// Uniquely identifies a [MFDirectionsRenderer].
  final MFDirectionsRendererId rendererId;

  @override
  MFDirectionsRendererId get mapsId => rendererId;

  /// The directions to display on the map.
  ///
  ///Similar to [directions] but has higher priority.
  final List<List<MFLatLng>> routes;

  /// The directions to display on the map, retrieved as a json string from Get route Map4D API (/sdk/route).
  ///
  /// Similar to [routes] but with lower priority.
  final String directions;

  /// The index of the main route, default value is 0.
  final int activedIndex;


  /// The active route stroke width.
  final int activeStrokeWidth;

  /// The active route color.
  /// 
  /// Color in ARGB format, the same format used by Color. The default value is blue (0xff2196f3).
  final Color activeStrokeColor;

  /// The active route outline stroke width.
  final int activeOutlineWidth;

  /// The active route outline color.
  /// 
  /// Color in ARGB format, the same format used by Color. The default value is blue shade 900 (0xff0d47a1).
  final Color activeOutlineColor;

  /// The inactive route stroke width.
  final int inactiveStrokeWidth;

  /// The inactive route color.
  /// 
  /// Color in ARGB format, the same format used by Color. The default value is blue grey (0xff607d8b).
  final Color inactiveStrokeColor;

  /// The inactive route outline stroke width.
  final int inactiveOutlineWidth;

  /// The inactive route outline color.
  /// 
  /// Color in ARGB format, the same format used by Color. The default value is blue grey shade 900 (0xff263238).
  final Color inactiveOutlineColor;

  /// Callbacks to receive tap events for directions renderer placed on this map.
  final VoidCallback? onTap;

  /// Creates a new [MFDirectionsRenderer] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  MFDirectionsRenderer copyWith({
    List<List<MFLatLng>>? routesParam,
    String? directionsParam,
    int? activedIndexParam,
    int? activeStrokeWidthParam,
    Color? activeStrokeColorParam,
    int? activeOutlineWidthParam,
    Color? activeOutlineColorParam,
    int? inactiveStrokeWidthParam,
    Color? inactiveStrokeColorParam,
    int? inactiveOutlineWidthParam,
    Color? inactiveOutlineColorParam,
    //TODO: start, end
    VoidCallback? onTapParam,
  }) {
    return MFDirectionsRenderer(
      rendererId: rendererId,
      routes: routesParam ?? routes,
      directions: directionsParam ?? directions,
      activeStrokeWidth: activeStrokeWidthParam ?? activeStrokeWidth,
      activeStrokeColor: activeStrokeColorParam ?? activeStrokeColor,
      activeOutlineWidth: activeOutlineWidthParam ?? activeOutlineWidth,
      activeOutlineColor: activeOutlineColorParam ?? activeOutlineColor,
      inactiveStrokeWidth: inactiveStrokeWidthParam ?? inactiveStrokeWidth,
      inactiveStrokeColor: inactiveStrokeColorParam ?? inactiveStrokeColor,
      inactiveOutlineWidth: inactiveOutlineWidthParam ?? inactiveOutlineWidth,
      inactiveOutlineColor: inactiveOutlineColorParam ?? inactiveOutlineColor,
      //TODO: start, end
      onTap: onTapParam ?? onTap
    );
  }

  /// Creates a new [MFDirectionsRenderer] object whose values are the same as this instance.
  MFDirectionsRenderer clone() => copyWith();

  /// Converts this object to something serializable in JSON.
  /// Converts this object to something serializable in JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('rendererId', rendererId.value);
    addIfPresent('directions', directions);
    addIfPresent('activedIndex', activedIndex);
    addIfPresent('activeStrokeWidth', activeStrokeWidth);
    addIfPresent('activeStrokeColor', activeStrokeColor.value);
    addIfPresent('activeOutlineWidth', activeOutlineWidth);
    addIfPresent('activeOutlineColor', activeOutlineColor.value);
    addIfPresent('inactiveStrokeWidth', inactiveStrokeWidth);
    addIfPresent('inactiveStrokeColor', inactiveStrokeColor.value);
    addIfPresent('inactiveOutlineWidth', inactiveOutlineWidth);
    addIfPresent('inactiveOutlineColor', inactiveOutlineColor.value);

    if (routes != null && routes.length > 0) {
      json['routes'] = _routesToJson();
    }

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final MFDirectionsRenderer typedOther = other as MFDirectionsRenderer;
    return rendererId == typedOther.rendererId &&
        const DeepCollectionEquality().equals(routes, typedOther.routes) &&
        directions == typedOther.directions &&
        activedIndex == typedOther.activedIndex &&
        activeStrokeWidth == typedOther.activeStrokeWidth &&
        activeStrokeColor == typedOther.activeStrokeColor &&
        activeOutlineWidth == typedOther.activeOutlineWidth &&
        activeOutlineColor == typedOther.activeOutlineColor &&
        inactiveStrokeWidth == typedOther.inactiveStrokeWidth &&
        inactiveStrokeColor == typedOther.inactiveStrokeColor &&
        inactiveOutlineWidth == typedOther.inactiveOutlineWidth &&
        inactiveOutlineColor == typedOther.inactiveOutlineColor;
  }

  @override
  int get hashCode => rendererId.hashCode;

  List<List<Object>> _routesToJson() {
    final List<List<Object>> result = <List<Object>>[];
    for (final List<MFLatLng> route in routes) {
      final List<Object> jsonRoute = <Object>[];
      for (final MFLatLng point in route) {
        jsonRoute.add(point.toJson());
      }
      result.add(jsonRoute);
    }
    return result;
  }
}
