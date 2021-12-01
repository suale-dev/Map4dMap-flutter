import 'directions.dart';

/// [MFDirectionsRenderer] update events to be applied to the [MFMapView].
///
/// Used in [MFMapViewController] when the map is updated.
// (Do not re-export)
class DirectionsRendererUpdates extends MapsObjectUpdates<MFDirectionsRenderer> {
  /// Computes [DirectionsRendererUpdates] given previous and current [MFDirectionsRenderer]s.
  DirectionsRendererUpdates.from(Set<MFDirectionsRenderer> previous, Set<MFDirectionsRenderer> current)
      : super.from(previous, current, objectName: 'directionsRenderer');

  /// Set of DirectionsRenderers to be added in this update.
  Set<MFDirectionsRenderer> get directionsRenderersToAdd => objectsToAdd;

  /// Set of DirectionsRendererIds to be removed in this update.
  Set<MFDirectionsRendererId> get directionsRendererIdsToRemove =>
      objectIdsToRemove.cast<MFDirectionsRendererId>();

  /// Set of DirectionsRenderers to be changed in this update.
  Set<MFDirectionsRenderer> get directionsRenderersToChange => objectsToChange;
}
