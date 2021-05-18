// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:map4d_map/src/annotations/polygon.dart';

import 'annotations.dart';

/// [MFPolygon] update events to be applied to the [MFMapView].
///
/// Used in [MFMapViewController] when the map is updated.
// (Do not re-export)
class PolygonUpdates extends MapsObjectUpdates<MFPolygon> {
  /// Computes [PolygonUpdates] given previous and current [MFPolygon]s.
  PolygonUpdates.from(Set<MFPolygon> previous, Set<MFPolygon> current)
      : super.from(previous, current, objectName: 'polygon');

  /// Set of Polygons to be added in this update.
  Set<MFPolygon> get polygonsToAdd => objectsToAdd;

  /// Set of PolygonIds to be removed in this update.
  Set<MFPolygonId> get polygonIdsToRemove =>
      objectIdsToRemove.cast<MFPolygonId>();

  /// Set of Polygons to be changed in this update.
  Set<MFPolygon> get polygonsToChange => objectsToChange;
}
