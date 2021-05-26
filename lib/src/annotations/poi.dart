import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter/material.dart' show Color, Colors;
import 'package:meta/meta.dart' show immutable;

import 'annotations.dart';

/// Uniquely identifies a [MFPOI] among [Map4dMap] pois.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class MFPOIId extends MapsObjectId<MFPOI> {
  /// Creates an immutable identifier for a [MFPOI].
  const MFPOIId(String value) : super(value);
}

/// Draws a POI on the map.
@immutable
class MFPOI implements MapsObject<MFPOI> {
  /// Creates an immutable representation of a [MFPOI] to draw on [Map4dMap].
  const MFPOI({
    required this.poiId,
    this.consumeTapEvents = false,
    this.position = const MFLatLng(0.0, 0.0),
    this.title = '',
    this.titleColor = Colors.blue,
    // this.subtitle = '',
    this.icon = MFBitmap.defaultIcon,
    this.type = 'point',
    this.visible = true,
    this.zIndex = 0,
    this.onTap
  });

  /// Uniquely identifies a [MFPOI].
  final MFPOIId poiId;

  @override
  MFPOIId get mapsId => poiId;

  /// True if the [MFPOI] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  /// Geographical location of the POI.
  final MFLatLng position;

  /// Title of the POI.
  final String title;

  /// Title color in ARGB format, the same format used by Color. The default value is transparent (0x00000000).
  final Color titleColor;

  /// Subtitle of the POI. - TODO
  // final String subtitle;

  /// Type of the POI.
  final String type;

  /// A description of the bitmap used to draw the POI icon.
  final MFBitmap icon;

  /// True if the POI is visible.
  final bool visible;

  /// The z-index of the POI, used to determine relative drawing order of
  /// map overlays.
  ///
  /// Overlays are drawn in order of z-index, so that lower values means drawn
  /// earlier, and thus appearing to be closer to the surface of the Earth.
  final int zIndex;

  /// Callbacks to receive tap events for POI placed on this map.
  final VoidCallback? onTap;
  
  /// Creates a new [MFPOI] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  MFPOI copyWith({
    bool? consumeTapEventsParam,
    MFLatLng? positionParam,
    String? titleParam,
    Color? titleColorParam,
    // String? subtitleParam,
    String? typeParam,
    MFBitmap? iconParam,
    bool? visibleParam,
    int? zIndexParam,
    VoidCallback? onTapParam,
  }) {
    return MFPOI(
      poiId: poiId,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      position: positionParam ?? position,
      title: titleParam ?? title,
      // subtitle: subtitleParam ?? subtitle,
      titleColor: titleColorParam ?? titleColor,
      icon: iconParam ?? icon,
      type: typeParam ?? type,
      visible: visibleParam ?? visible,
      zIndex: zIndexParam ?? zIndex,
      onTap: onTapParam ?? onTap,
    );
  }

  /// Creates a new [MFPOI] object whose values are the same as this instance.
  MFPOI clone() => copyWith();

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('poiId', poiId.value);
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('position', position.toJson());
    addIfPresent('title', title);
    addIfPresent('titleColor', titleColor.value);
    // addIfPresent('subtitle', subtitle);
    addIfPresent('icon', icon.toJson());
    addIfPresent('type', type);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final MFPOI typedOther = other as MFPOI;
    return poiId == typedOther.poiId &&
        consumeTapEvents == typedOther.consumeTapEvents &&
        position == typedOther.position &&
        title == typedOther.title &&
        titleColor == typedOther.titleColor &&
        // subtitle == typedOther.subtitle &&
        icon == typedOther.icon &&
        type == typedOther.type &&
        visible == typedOther.visible &&
        zIndex == typedOther.zIndex;
  }

  @override
  int get hashCode => poiId.hashCode;
}