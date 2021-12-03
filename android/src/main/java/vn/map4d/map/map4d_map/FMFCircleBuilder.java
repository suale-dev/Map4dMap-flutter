package vn.map4d.map.map4d_map;

import vn.map4d.map.annotations.MFCircleOptions;
import vn.map4d.types.MFLocationCoordinate;

class FMFCircleBuilder implements FMFCircleOptionsSink {

  private final MFCircleOptions circleOptions;
  private final float density;
  private boolean consumeTapEvents;

  FMFCircleBuilder(float density) {
    this.circleOptions = new MFCircleOptions();
    this.density = density;
  }

  MFCircleOptions build() {
    return circleOptions;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
  }

  @Override
  public void setStrokeColor(int strokeColor) {
    circleOptions.strokeColor(strokeColor);
  }

  @Override
  public void setFillColor(int fillColor) {
    circleOptions.fillColor(fillColor);
  }

  @Override
  public void setCenter(MFLocationCoordinate center) {
    circleOptions.center(center);
  }

  @Override
  public void setRadius(double radius) {
    circleOptions.radius(radius);
  }

  @Override
  public void setVisible(boolean visible) {
    circleOptions.visible(visible);
  }

  @Override
  public void setStrokeWidth(float strokeWidth) {
    circleOptions.strokeWidth(strokeWidth);
  }

  @Override
  public void setZIndex(float zIndex) {
    circleOptions.zIndex(zIndex);
  }
}
