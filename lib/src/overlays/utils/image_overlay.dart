import '../overlays.dart';

/// Converts an [Iterable] of ImageOverlay in a Map of ImageOverlayId -> ImageOverlay.
Map<MFImageOverlayId, MFImageOverlay> keyImageOverlayId(
    Iterable<MFImageOverlay> imageOverlays) {
  return keyByMapsObjectId<MFImageOverlay>(imageOverlays)
      .cast<MFImageOverlayId, MFImageOverlay>();
}

/// Converts a Set of ImageOverlays into something serializable in JSON.
Object serializeImageOverlaySet(Set<MFImageOverlay> imageOverlays) {
  return serializeMapsObjectSet(imageOverlays);
}
