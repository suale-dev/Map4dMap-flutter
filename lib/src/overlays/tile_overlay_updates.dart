import 'overlays.dart';

/// Update specification for a set of [MFTileOverlay]s.
class TileOverlayUpdates extends MapsObjectUpdates<MFTileOverlay> {
  /// Computes [TileOverlayUpdates] given previous and current [MFTileOverlay]s.
  TileOverlayUpdates.from(
      Set<MFTileOverlay> previous, Set<MFTileOverlay> current)
      : super.from(previous, current, objectName: 'tileOverlay');

  /// Set of TileOverlays to be added in this update.
  Set<MFTileOverlay> get tileOverlaysToAdd => objectsToAdd;

  /// Set of TileOverlayIds to be removed in this update.
  Set<MFTileOverlayId> get tileOverlayIdsToRemove =>
      objectIdsToRemove.cast<MFTileOverlayId>();

  /// Set of TileOverlays to be changed in this update.
  Set<MFTileOverlay> get tileOverlaysToChange => objectsToChange;
}
