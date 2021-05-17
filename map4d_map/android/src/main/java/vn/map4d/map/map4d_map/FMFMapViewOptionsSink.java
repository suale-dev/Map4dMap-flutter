package vn.map4d.map.map4d_map;

/** Receiver of Map4D configuration options. */
interface FMFMapViewOptionsSink {

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
}
