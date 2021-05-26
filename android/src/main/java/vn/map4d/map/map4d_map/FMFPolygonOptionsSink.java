package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.types.MFLocationCoordinate;

/** Receiver of Polygon configuration options. */
interface FMFPolygonOptionsSink {

  void setConsumeTapEvents(boolean consumetapEvents);

  void setFillColor(int color);

  void setStrokeColor(int color);

  void setStrokeWidth(float width);

  void setPoints(List<MFLocationCoordinate> points);

  void setHoles(List<List<MFLocationCoordinate>> holes);

  void setVisible(boolean visible);

  void setZIndex(float zIndex);
}
