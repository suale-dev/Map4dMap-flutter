// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'annotations.dart';

/// [MFPolyline] update events to be applied to the [MFMapView].
///
/// Used in [MFMapViewController] when the map is updated.
// (Do not re-export)
class PolylineUpdates extends MapsObjectUpdates<MFPolyline> {
  /// Computes [PolylineUpdates] given previous and current [MFPolyline]s.
  PolylineUpdates.from(Set<MFPolyline> previous, Set<MFPolyline> current)
      : super.from(previous, current, objectName: 'polyline');

  /// Set of Polylines to be added in this update.
  Set<MFPolyline> get polylinesToAdd => objectsToAdd;

  /// Set of PolylineIds to be removed in this update.
  Set<MFPolylineId> get polylineIdsToRemove =>
      objectIdsToRemove.cast<MFPolylineId>();

  /// Set of Polylines to be changed in this update.
  Set<MFPolyline> get polylinesToChange => objectsToChange;
}
