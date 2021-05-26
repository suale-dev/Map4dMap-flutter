import '../annotations.dart';

/// Converts an [Iterable] of Polylines in a Map of PolylineId -> Polyline.
Map<MFPolylineId, MFPolyline> keyByPolylineId(Iterable<MFPolyline> polylines) {
  return keyByMapsObjectId<MFPolyline>(polylines).cast<MFPolylineId, MFPolyline>();
}

/// Converts a Set of Polylines into something serializable in JSON.
Object serializePolylineSet(Set<MFPolyline> polylines) {
  return serializeMapsObjectSet(polylines);
}
