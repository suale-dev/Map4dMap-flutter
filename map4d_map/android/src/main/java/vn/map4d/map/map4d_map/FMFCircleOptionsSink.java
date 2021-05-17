package vn.map4d.map.map4d_map;

import vn.map4d.types.MFLocationCoordinate;

interface FMFCircleOptionsSink {
  void setConsumeTapEvents(boolean consumeTapEvents);

  void setStrokeColor(int strokeColor);

  void setFillColor(int fillColor);

  void setCenter(MFLocationCoordinate center);

  void setRadius(double radius);

  void setVisible(boolean visible);

  void setStrokeWidth(float strokeWidth);

  void setZIndex(float zIndex);
}
