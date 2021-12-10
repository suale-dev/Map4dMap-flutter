package vn.map4d.map.map4d_map;

import java.util.List;
import java.util.Map;

import vn.map4d.map.core.MFMapType;

/** Receiver of Map4D configuration options. */
public interface FMFMapViewOptionsSink {

  void setMapType(MFMapType mapType);

  void setMinMaxZoomPreference(Float min, Float max);

  void setRotateGesturesEnabled(boolean rotateGesturesEnabled);

  void setScrollGesturesEnabled(boolean scrollGesturesEnabled);

  void setTiltGesturesEnabled(boolean tiltGesturesEnabled);

  void setZoomGesturesEnabled(boolean zoomGesturesEnabled);

  void setTrackCameraPosition(boolean trackCameraPosition);

  void setMyLocationEnabled(boolean myLocationEnabled);

  void setMyLocationButtonEnabled(boolean myLocationButtonEnabled);

  void setBuildingsEnabled(boolean buildingsEnabled);

  void setPOIsEnabled(boolean poisEnabled);

  void setInitialCircles(Object initialCircles);

  void setInitialPolylines(Object initialPolylines);

  void setInitialPolygons(Object initialPolygons);
  
  void setInitialMarkers(Object initialMarkers);

  void setInitialPOIs(Object initialPOIs);

  void setInitialBuildings(Object initialBuildings);

  void setInitialTileOverlays(List<Map<String, ?>> initialTileOverlays);

  void setInitialDirectionsRenderers(Object initialDirectionsRenderers);
}
