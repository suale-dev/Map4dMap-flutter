import '../annotations.dart';

/// Converts an [Iterable] of Buildings in a Map of BuildingId -> Building.
Map<MFBuildingId, MFBuilding> keyByBuildingId(Iterable<MFBuilding> buildings) {
  return keyByMapsObjectId<MFBuilding>(buildings).cast<MFBuildingId, MFBuilding>();
}

/// Converts a Set of Buildings into something serializable in JSON.
Object serializeBuildingSet(Set<MFBuilding> buildings) {
  return serializeMapsObjectSet(buildings);
}
