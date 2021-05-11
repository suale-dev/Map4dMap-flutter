import 'annotations.dart';

/// [MFCircle] update events to be applied to the [Map4dMap].
///
/// Used in [MFMapViewController] when the map is updated.
// (Do not re-export)
class CircleUpdates extends MapsObjectUpdates<MFCircle> {
  /// Computes [CircleUpdates] given previous and current [MFCircle]s.
  CircleUpdates.from(Set<MFCircle> previous, Set<MFCircle> current)
      : super.from(previous, current, objectName: 'circle');

  /// Set of Circles to be added in this update.
  Set<MFCircle> get circlesToAdd => objectsToAdd;

  /// Set of CircleIds to be removed in this update.
  Set<MFCircleId> get circleIdsToRemove => objectIdsToRemove.cast<MFCircleId>();

  /// Set of Circles to be changed in this update.
  Set<MFCircle> get circlesToChange => objectsToChange;
}