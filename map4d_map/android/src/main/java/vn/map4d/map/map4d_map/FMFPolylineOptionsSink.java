package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.core.MFPolylineStyle;
import vn.map4d.types.MFLocationCoordinate;

/** Receiver of Polyline configuration options. */
interface FMFPolylineOptionsSink {

  void setConsumeTapEvents(boolean consumetapEvents);

  void setColor(int color);

  void setPoints(List<MFLocationCoordinate> points);

  void setStyle(MFPolylineStyle style);

  void setVisible(boolean visible);

  void setWidth(float width);

  void setZIndex(float zIndex);
}
