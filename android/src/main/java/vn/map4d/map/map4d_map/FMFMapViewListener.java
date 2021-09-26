package vn.map4d.map.map4d_map;

import vn.map4d.map.core.Map4D;

interface FMFMapViewListener
  extends Map4D.OnCameraIdleListener,
    Map4D.OnCameraMoveListener,
    Map4D.OnCameraMoveStartedListener,
    Map4D.OnInfoWindowClickListener,
    Map4D.OnMarkerClickListener,
    Map4D.OnPolygonClickListener,
    Map4D.OnPolylineClickListener,
    Map4D.OnCircleClickListener,
    Map4D.OnUserPOIClickListener,
    Map4D.OnUserBuildingClickListener,
    Map4D.OnBuildingClickListener,
    Map4D.OnPOIClickListener,
    Map4D.OnPlaceClickListener,
    Map4D.OnMapClickListener,
    Map4D.OnMarkerDragListener {}
