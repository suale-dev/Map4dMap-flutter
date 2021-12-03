package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFPolyline;
import vn.map4d.map.core.MFPolylineStyle;
import vn.map4d.types.MFLocationCoordinate;

/** Controller of a single Polyline on the map. */
class FMFPolylineController implements FMFPolylineOptionsSink {

  private final MFPolyline polyline;
  private final long mfPolylineId;
  private boolean consumeTapEvents;
  private final float density;

  FMFPolylineController(MFPolyline polyline, boolean consumeTapEvents, float density) {
    this.polyline = polyline;
    this.consumeTapEvents = consumeTapEvents;
    this.density = density;
    this.mfPolylineId = polyline.getId();
  }

  void remove() {
    polyline.remove();
  }

  long getMFPolylineId() {
    return mfPolylineId;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    polyline.setTouchable(consumeTapEvents);
  }

  @Override
  public void setColor(int color) {
    polyline.setColor(color);
  }

  @Override
  public void setPoints(List<MFLocationCoordinate> points) {
    polyline.setPath(points);
  }

  @Override
  public void setStyle(MFPolylineStyle style) {
    polyline.setStyle(style);
  }

  @Override
  public void setVisible(boolean visible) {
    polyline.setVisible(visible);
  }

  @Override
  public void setWidth(float width) {
    polyline.setWidth(width);
  }

  @Override
  public void setZIndex(float zIndex) {
    polyline.setZIndex(zIndex);
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }
}
