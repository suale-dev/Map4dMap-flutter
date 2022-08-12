import 'overlays.dart';

/// Update specification for a set of [MFImageOverlay]s.
class ImageOverlayUpdates extends MapsObjectUpdates<MFImageOverlay> {
  /// Computes [ImageOverlayUpdates] given previous and current [MFImageOverlay]s.
  ImageOverlayUpdates.from(
      Set<MFImageOverlay> previous, Set<MFImageOverlay> current)
      : super.from(previous, current, objectName: 'imageOverlay');

  /// Set of ImageOverlays to be added in this update.
  Set<MFImageOverlay> get imageOverlaysToAdd => objectsToAdd;

  /// Set of ImageOverlayIds to be removed in this update.
  Set<MFImageOverlayId> get imageOverlayIdsToRemove =>
      objectIdsToRemove.cast<MFImageOverlayId>();

  /// Set of ImageOverlays to be changed in this update.
  Set<MFImageOverlay> get imageOverlaysToChange => objectsToChange;
}
