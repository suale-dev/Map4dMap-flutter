package vn.map4d.map.map4d_map;

import vn.map4d.map.annotations.MFCircle;
import vn.map4d.types.MFLocationCoordinate;

/** Controller of a single Circle on the map. */
class FMFCircleController implements FMFCircleOptionsSink {

  private final MFCircle circle;
  private final long mfCircleId;
  private final float density;
  private boolean consumeTapEvents;

  FMFCircleController(MFCircle circle, boolean consumeTapEvents, float density) {
    this.circle = circle;
    this.consumeTapEvents = consumeTapEvents;
    this.density = density;
    this.mfCircleId = circle.getId();
  }

  void remove() {
    circle.remove();
  }

  long getMFCircleId() {
    return mfCircleId;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    circle.setTouchable(consumeTapEvents);
  }

  @Override
  public void setStrokeColor(int strokeColor) {
    circle.setStrokeColor(strokeColor);
  }

  @Override
  public void setFillColor(int fillColor) {
    circle.setFillColor(fillColor);
  }

  @Override
  public void setCenter(MFLocationCoordinate center) {
    circle.setCenter(center);
  }

  @Override
  public void setRadius(double radius) {
    circle.setRadius(radius);
  }

  @Override
  public void setVisible(boolean visible) {
    circle.setVisible(visible);
  }

  @Override
  public void setStrokeWidth(float strokeWidth) {
    circle.setStrokeWidth(strokeWidth);
  }

  @Override
  public void setZIndex(float zIndex) {
    circle.setZIndex(zIndex);
  }
}
