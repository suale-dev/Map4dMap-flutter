import '../overlays.dart';

/// Converts an [Iterable] of TileOverlay in a Map of TileOverlayId -> TileOverlay.
Map<MFTileOverlayId, MFTileOverlay> keyTileOverlayId(
    Iterable<MFTileOverlay> tileOverlays) {
  return keyByMapsObjectId<MFTileOverlay>(tileOverlays)
      .cast<MFTileOverlayId, MFTileOverlay>();
}

/// Converts a Set of TileOverlays into something serializable in JSON.
Object serializeTileOverlaySet(Set<MFTileOverlay> tileOverlays) {
  return serializeMapsObjectSet(tileOverlays);
}
