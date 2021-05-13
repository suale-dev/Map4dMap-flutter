import 'annotations.dart';

/// [MFPOI] update events to be applied to the [Map4dMap].
///
/// Used in [MFMapViewController] when the map is updated.
// (Do not re-export)
class POIUpdates extends MapsObjectUpdates<MFPOI> {
  /// Computes [POIUpdates] given previous and current [MFPOI]s.
  POIUpdates.from(Set<MFPOI> previous, Set<MFPOI> current)
      : super.from(previous, current, objectName: 'poi');

  /// Set of POIs to be added in this update.
  Set<MFPOI> get poisToAdd => objectsToAdd;

  /// Set of POIIds to be removed in this update.
  Set<MFPOIId> get poiIdsToRemove => objectIdsToRemove.cast<MFPOIId>();

  /// Set of POIs to be changed in this update.
  Set<MFPOI> get poisToChange => objectsToChange;
}