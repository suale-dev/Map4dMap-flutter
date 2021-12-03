package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFPolylineOptions;
import vn.map4d.map.core.MFPolylineStyle;
import vn.map4d.types.MFLocationCoordinate;

class FMFPolylineBuilder implements FMFPolylineOptionsSink {

  private final MFPolylineOptions polylineOptions;
  private boolean consumeTapEvents;
  private final float density;

  FMFPolylineBuilder(float density) {
    this.polylineOptions = new MFPolylineOptions();
    this.density = density;
  }

  MFPolylineOptions build() {
    return polylineOptions;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    polylineOptions.touchable(consumeTapEvents);
  }

  @Override
  public void setColor(int color) {
    polylineOptions.color(color);
  }

  @Override
  public void setPoints(List<MFLocationCoordinate> points) {
    for (MFLocationCoordinate point : points) {
      polylineOptions.add(point);
    }
  }

  @Override
  public void setStyle(MFPolylineStyle style) {
    polylineOptions.style(style);
  }

  @Override
  public void setVisible(boolean visible) {
    polylineOptions.visible(visible);
  }

  @Override
  public void setWidth(float width) {
    polylineOptions.width(width);
  }

  @Override
  public void setZIndex(float zIndex) {
    polylineOptions.zIndex(zIndex);
  }
}
