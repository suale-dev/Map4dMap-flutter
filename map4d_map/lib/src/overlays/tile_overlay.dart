// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show hashValues;

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart' show immutable;
import 'overlays.dart';

/// Uniquely identifies a [MFTileOverlay] among [Map4dMap] tile overlays.
@immutable
class MFTileOverlayId extends MapsObjectId<MFTileOverlay> {
  /// Creates an immutable identifier for a [MFTileOverlay].
  const MFTileOverlayId(String value) : super(value);
}

/// A set of images which are displayed on top of the base map tiles.
class MFTileOverlay implements MapsObject {
  /// Creates an immutable representation of a [MFTileOverlay] to draw on [Map4dMap].
  const MFTileOverlay._({
    required this.tileOverlayId,
    this.urlPattern = '',
    this.zIndex = 0,
    this.visible = true,
  });

  static MFTileOverlay newWithUrlPattern(MFTileOverlayId tileOverlayId, String urlPattern, {int zIndex = 0, bool visible = true }) {
    return MFTileOverlay._(tileOverlayId: tileOverlayId, urlPattern: urlPattern, zIndex: zIndex, visible: visible);
  }

  /// Uniquely identifies a [MFTileOverlay].
  final MFTileOverlayId tileOverlayId;

  @override
  MFTileOverlayId get mapsId => tileOverlayId;

  final String urlPattern;

  /// The tile overlay's zIndex, i.e., the order in which it will be drawn where
  /// overlays with larger values are drawn above those with lower values
  final int zIndex;

  /// The visibility for the tile overlay. The default visibility is true.
  final bool visible;

  /// Creates a new [MFTileOverlay] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  MFTileOverlay copyWith({
    int? zIndexParam,
    bool? visibleParam,
  }) {
    return MFTileOverlay._(
      tileOverlayId: tileOverlayId,
      urlPattern: urlPattern,
      zIndex: zIndexParam ?? zIndex,
      visible: visibleParam ?? visible,
    );
  }

  MFTileOverlay clone() => copyWith();

  /// Converts this object to JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('tileOverlayId', tileOverlayId.value);
    addIfPresent('urlPattern', urlPattern);
    addIfPresent('zIndex', zIndex);
    addIfPresent('visible', visible);

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MFTileOverlay &&
        tileOverlayId == other.tileOverlayId &&
        urlPattern == other.urlPattern &&
        zIndex == other.zIndex &&
        visible == other.visible;
  }

  @override
  int get hashCode => hashValues(tileOverlayId, urlPattern, zIndex, visible);
}
