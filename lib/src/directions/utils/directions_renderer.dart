import '../directions.dart';

/// Converts an [Iterable] of MFDirectionsRenderers in a Map of MFDirectionsRendererId -> MFDirectionsRenderer.
Map<MFDirectionsRendererId, MFDirectionsRenderer> keyByDirectionsRendererId(Iterable<MFDirectionsRenderer> renderers) {
  return keyByMapsObjectId<MFDirectionsRenderer>(renderers).cast<MFDirectionsRendererId, MFDirectionsRenderer>();
}

/// Converts a Set of MFDirectionsRenderers into something serializable in JSON.
Object serializeDirectionsRendererSet(Set<MFDirectionsRenderer> renderers) {
  return serializeMapsObjectSet(renderers);
}
