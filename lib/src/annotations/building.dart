import 'package:flutter/foundation.dart' show listEquals, VoidCallback;
import 'package:meta/meta.dart' show immutable;

import 'annotations.dart';

/// Uniquely identifies a [MFBuilding] among [MFMapView] buildings.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class MFBuildingId extends MapsObjectId<MFBuilding> {
  /// Creates an immutable object representing a [MFBuildingId] among [MFMapView] buildings.
  ///
  /// An [AssertionError] will be thrown if [value] is null.
  const MFBuildingId(String value) : super(value);
}

/// Draws a Building on the Map
@immutable
class MFBuilding implements MapsObject {
  /// Creates an immutable representation of a [MFPOI] to draw on [Map4dMap].
  const MFBuilding(
      {required this.buildingId,
      this.consumeTapEvents = false,
      this.name = '',
      this.position = const MFLatLng(0, 0),
      this.coordinates = const <MFLatLng>[],
      this.modelUrl = '',
      this.textureUrl = '',
      this.height = 1,
      this.scale = 1,
      this.bearing = 0,
      this.elevation = 0,
      this.selected = false,
      this.visible = true,
      this.onTap});

  /// Uniquely identifies a [MFBuilding].
  final MFBuildingId buildingId;

  @override
  MFBuildingId get mapsId => buildingId;

  /// True if the [MFBuilding] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  /// Geographical location of the POI.
  final MFLatLng position;

  /// Name of the building.
  final String name;

  ///
  final List<MFLatLng> coordinates;

  ///
  final String modelUrl;

  ///
  final String textureUrl;

  ///
  final double height;

  ///
  final double scale;

  ///
  final double bearing;

  ///
  final double elevation;

  ///
  final bool selected;

  /// True if the building is visible.
  final bool visible;

  /// Callbacks to receive tap events for building placed on this map.
  final VoidCallback? onTap;

  /// Creates a new [MFBuilding] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  MFBuilding copyWith({
    bool? consumeTapEventsParam,
    String? nameParam,
    MFLatLng? positionParam,
    List<MFLatLng>? coordinatesParam,
    String? modelUrlParam,
    String? textureUrlParam,
    double? heightParam,
    double? scaleParam,
    double? bearingParam,
    double? elevationParam,
    bool? selectedParam,
    bool? visibleParam,
    VoidCallback? onTapParam,
  }) {
    return MFBuilding(
        buildingId: buildingId,
        consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
        name: nameParam ?? name,
        position: positionParam ?? position,
        coordinates: coordinatesParam ?? coordinates,
        modelUrl: modelUrlParam ?? modelUrl,
        textureUrl: textureUrlParam ?? textureUrl,
        height: heightParam ?? height,
        scale: scaleParam ?? scale,
        bearing: bearingParam ?? bearing,
        elevation: elevationParam ?? elevation,
        selected: selectedParam ?? selected,
        visible: visibleParam ?? visible,
        onTap: onTapParam ?? onTap);
  }

  /// Creates a new [MFBuilding] object whose values are the same as this instance.
  MFBuilding clone() => copyWith();

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('buildingId', buildingId.value);
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('position', position.toJson());
    addIfPresent('name', name);
    addIfPresent('coordinates', _coordinatesToJson());
    addIfPresent('modelUrl', modelUrl);
    addIfPresent('textureUrl', textureUrl);
    addIfPresent('height', height);
    addIfPresent('scale', scale);
    addIfPresent('bearing', bearing);
    addIfPresent('elevation', elevation);
    addIfPresent('visible', visible);
    addIfPresent('selected', selected);

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final MFBuilding typedOther = other as MFBuilding;
    return buildingId == typedOther.buildingId &&
        consumeTapEvents == typedOther.consumeTapEvents &&
        position == typedOther.position &&
        name == typedOther.name &&
        listEquals(coordinates, typedOther.coordinates) &&
        modelUrl == typedOther.modelUrl &&
        textureUrl == typedOther.textureUrl &&
        height == typedOther.height &&
        scale == typedOther.scale &&
        bearing == typedOther.bearing &&
        elevation == typedOther.elevation &&
        visible == typedOther.visible &&
        selected == typedOther.selected;
  }

  @override
  int get hashCode => buildingId.hashCode;

  Object _coordinatesToJson() {
    final List<Object> result = <Object>[];
    for (final MFLatLng coordinate in coordinates) {
      result.add(coordinate.toJson());
    }
    return result;
  }
}
