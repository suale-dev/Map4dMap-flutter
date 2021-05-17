import 'package:map4d_map/src/annotations/polygon.dart';

import '../annotations.dart';

/// Converts an [Iterable] of Polygons in a Map of PolygonId -> Polygon.
Map<MFPolygonId, MFPolygon> keyByPolygonId(Iterable<MFPolygon> polygons) {
  return keyByMapsObjectId<MFPolygon>(polygons).cast<MFPolygonId, MFPolygon>();
}

/// Converts a Set of Polygons into something serializable in JSON.
Object serializePolygonSet(Set<MFPolygon> polygons) {
  return serializeMapsObjectSet(polygons);
}
