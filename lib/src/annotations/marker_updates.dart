import 'annotations.dart';

/// [MFMarker] update events to be applied to the [Map4dMap].
///
/// Used in [MFMapViewController] when the map is updated.
// (Do not re-export)
class MarkerUpdates extends MapsObjectUpdates<MFMarker> {
  /// Computes [MarkerUpdates] given previous and current [MFMarker]s.
  MarkerUpdates.from(Set<MFMarker> previous, Set<MFMarker> current)
      : super.from(previous, current, objectName: 'marker');

  /// Set of Markers to be added in this update.
  Set<MFMarker> get markersToAdd => objectsToAdd;

  /// Set of MarkerIds to be removed in this update.
  Set<MFMarkerId> get markerIdsToRemove => objectIdsToRemove.cast<MFMarkerId>();

  /// Set of Markers to be changed in this update.
  Set<MFMarker> get markersToChange => objectsToChange;
}
