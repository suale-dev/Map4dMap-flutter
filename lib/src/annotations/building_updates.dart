import 'annotations.dart';

/// [MFBuilding] update events to be applied to the [MFMapView].
///
/// Used in [MFMapViewController] when the map is updated.
// (Do not re-export)
class BuildingUpdates extends MapsObjectUpdates<MFBuilding> {
  /// Computes [BuildingUpdates] given previous and current [MFBuilding]s.
  BuildingUpdates.from(Set<MFBuilding> previous, Set<MFBuilding> current)
      : super.from(previous, current, objectName: 'building');

  /// Set of Buildings to be added in this update.
  Set<MFBuilding> get buildingsToAdd => objectsToAdd;

  /// Set of BuildingIds to be removed in this update.
  Set<MFBuildingId> get buildingIdsToRemove =>
      objectIdsToRemove.cast<MFBuildingId>();

  /// Set of Buildings to be changed in this update.
  Set<MFBuilding> get buildingsToChange => objectsToChange;
}
