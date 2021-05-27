import '../annotations.dart';

/// Converts an [Iterable] of POIs in a Map of POIId -> POI.
Map<MFPOIId, MFPOI> keyByPOIId(Iterable<MFPOI> pois) {
  return keyByMapsObjectId<MFPOI>(pois).cast<MFPOIId, MFPOI>();
}

/// Converts a Set of POIs into something serializable in JSON.
Object serializePOISet(Set<MFPOI> pois) {
  return serializeMapsObjectSet(pois);
}
