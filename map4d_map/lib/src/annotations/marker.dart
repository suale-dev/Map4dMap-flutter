import 'dart:ui' show hashValues, Offset;
import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter/foundation.dart' show ValueChanged;
import 'package:meta/meta.dart' show immutable;
import 'annotations.dart';

Object _offsetToJson(Offset offset) {
  return <Object>[offset.dx, offset.dy];
}

/// Text labels for a [Marker] info window.
class InfoWindow {
  /// Creates an immutable representation of a label on for [Marker].
  const InfoWindow({
    this.title,
    this.snippet,
    this.anchor = const Offset(0.5, 0.0),
    this.onTap,
  });

  /// Text labels specifying that no text is to be displayed.
  static const InfoWindow noText = InfoWindow();

  final String? title;

  final String? snippet;

  final Offset anchor;

  /// onTap callback for this [InfoWindow].
  final VoidCallback? onTap;

  /// Creates a new [InfoWindow] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  InfoWindow copyWith({
    String? titleParam,
    String? snippetParam,
    Offset? anchorParam,
    VoidCallback? onTapParam,
  }) {
    return InfoWindow(
      title: titleParam ?? title,
      snippet: snippetParam ?? snippet,
      anchor: anchorParam ?? anchor,
      onTap: onTapParam ?? onTap,
    );
  }

  Object _toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('title', title);
    addIfPresent('snippet', snippet);
    addIfPresent('anchor', _offsetToJson(anchor));

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final InfoWindow typedOther = other as InfoWindow;
    return title == typedOther.title &&
        snippet == typedOther.snippet &&
        anchor == typedOther.anchor;
  }

  @override
  int get hashCode => hashValues(title.hashCode, snippet, anchor);
}

@immutable
class MFMarkerId extends MapsObjectId<MFMarker> {
  /// Creates an immutable identifier for a [MFMarker].
  const MFMarkerId(String value) : super(value);
}

@immutable
class MFMarker implements MapsObject {
  final MFMarkerId markerId;

  @override
  MFMarkerId get mapsId => markerId;

  /// True if the [MFMarker] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  final LatLng position;

  final double elevation;

  final double rotation;

  final Offset anchor;

  final bool draggable;

  final bool visible;

  final double zIndex;

  /// The window is displayed when the marker is tapped.
  final InfoWindow infoWindow;

  /// Callbacks to receive tap events for marker placed on this map.
  final VoidCallback? onTap;

  /// Signature reporting the new [LatLng] at the end of a drag event.
  final ValueChanged<LatLng>? onDragEnd;

  const MFMarker({
    required this.markerId,
    this.consumeTapEvents = false,
    this.position = const LatLng(0.0, 0.0),
    this.elevation = 0.0,
    this.rotation = 0.0,
    this.anchor = const Offset(0.5, 0.5),
    this.draggable = false,
    this.visible = true,
    this.zIndex = 0.0,
    this.infoWindow = InfoWindow.noText,
    this.onTap,
    this.onDragEnd,
  });

  /// Creates a new [MFMarker] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  MFMarker copyWith({
    bool? consumeTapEventsParam,
    LatLng? positionParam,
    Offset? anchorParam,
    double? elevationParam,
    double? rotationParam,
    bool? draggableParam,
    bool? visibleParam,
    double? zIndexParam,
    InfoWindow? infoWindowParam,
    VoidCallback? onTapParam,
    ValueChanged<LatLng>? onDragEndParam,
  }) {
    return MFMarker(
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      markerId: markerId,
      position: positionParam ?? position,
      elevation: elevationParam ?? elevation,
      rotation: rotationParam ?? rotation,
      anchor: anchorParam ?? anchor,
      draggable: draggableParam ?? draggable,
      visible: visibleParam ?? visible,
      zIndex: zIndexParam ?? zIndex,
      infoWindow: infoWindowParam ?? infoWindow,
      onTap: onTapParam ?? onTap,
      onDragEnd: onDragEndParam ?? onDragEnd,
    );
  }

  MFMarker clone() => copyWith();

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('markerId', markerId.value);
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('position', position.toJson());
    addIfPresent('elevation', elevation);
    addIfPresent('rotation', rotation);
    addIfPresent('anchor', _offsetToJson(anchor));
    addIfPresent('draggable', draggable);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    addIfPresent('infoWindow', infoWindow._toJson());
    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final MFMarker typedOther = other as MFMarker;
    return markerId == typedOther.markerId &&
        consumeTapEvents == typedOther.consumeTapEvents &&
        position == typedOther.position &&
        elevation == typedOther.elevation &&
        rotation == typedOther.rotation &&
        anchor == typedOther.anchor &&
        draggable == typedOther.draggable &&
        visible == typedOther.visible &&
        infoWindow == typedOther.infoWindow &&
        zIndex == typedOther.zIndex;
  }

  @override
  int get hashCode => markerId.hashCode;
}
