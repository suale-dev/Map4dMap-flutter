import '../annotations.dart';

/// Converts an [Iterable] of Circles in a Map of CircleId -> Circle.
Map<MFCircleId, MFCircle> keyByCircleId(Iterable<MFCircle> circles) {
  return keyByMapsObjectId<MFCircle>(circles).cast<MFCircleId, MFCircle>();
}

/// Converts a Set of Circles into something serializable in JSON.
Object serializeCircleSet(Set<MFCircle> circles) {
  return serializeMapsObjectSet(circles);
}
