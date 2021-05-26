import '../annotations.dart';

/// Converts an [Iterable] of Markers in a Map of MarkerID -> Marker.
Map<MFMarkerId, MFMarker> keyByMarkerId(Iterable<MFMarker> markers) {
  return keyByMapsObjectId<MFMarker>(markers).cast<MFMarkerId, MFMarker>();
}

/// Converts a Set of Markers into something serializable in JSON.
Object serializeMarkerSet(Set<MFMarker> markers) {
  return serializeMapsObjectSet(markers);
}
