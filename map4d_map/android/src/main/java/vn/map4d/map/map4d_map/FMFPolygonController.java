package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFPolygon;
import vn.map4d.types.MFLocationCoordinate;

/** Controller of a single Polygon on the map. */
class FMFPolygonController implements FMFPolygonOptionsSink {

  private final MFPolygon polygon;
  private final long mfPolygonId;
  private boolean consumeTapEvents;
  private final float density;

  FMFPolygonController(MFPolygon polygon, boolean consumeTapEvents, float density) {
    this.polygon = polygon;
    this.consumeTapEvents = consumeTapEvents;
    this.density = density;
    this.mfPolygonId = polygon.getId();
  }

  void remove() {
    polygon.remove();
  }

  long getMFPolygonId() {
    return mfPolygonId;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumetapEvents) {
    this.consumeTapEvents = consumetapEvents;
    polygon.setTouchable(consumetapEvents);
  }

  @Override
  public void setFillColor(int color) {
    polygon.setFillColor(color);
  }

  @Override
  public void setStrokeColor(int color) {
    polygon.setStrokeColor(color);
  }

  @Override
  public void setStrokeWidth(float width) {
    polygon.setStrokeWidth(width);
  }

  @Override
  public void setPoints(List<MFLocationCoordinate> points) {
    polygon.setPoints(points);
  }

  @Override
  public void setHoles(List<List<MFLocationCoordinate>> holes) {
    polygon.setHoles(holes);
  }

  @Override
  public void setVisible(boolean visible) {
    polygon.setVisible(visible);
  }

  @Override
  public void setZIndex(float zIndex) {
    polygon.setZIndex(zIndex);
  }
}
