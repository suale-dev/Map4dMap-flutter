package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFPolygonOptions;
import vn.map4d.types.MFLocationCoordinate;

class FMFPolygonBuilder implements FMFPolygonOptionsSink {
  private final MFPolygonOptions polygonOptions;
  private boolean consumeTapEvents;
  private final float density;

  FMFPolygonBuilder(float density) {
    this.polygonOptions = new MFPolygonOptions();
    this.density = density;
  }

  MFPolygonOptions build() {
    return polygonOptions;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumetapEvents) {
    this.consumeTapEvents = consumetapEvents;
    polygonOptions.touchable(consumetapEvents);
  }

  @Override
  public void setFillColor(int color) {
    polygonOptions.fillColor(color);
  }

  @Override
  public void setStrokeColor(int color) {
    polygonOptions.strokeColor(color);
  }

  @Override
  public void setStrokeWidth(float width) {
    polygonOptions.strokeWidth(width);
  }

  @Override
  public void setPoints(List<MFLocationCoordinate> points) {
    for (MFLocationCoordinate point: points) {
      polygonOptions.add(point);
    }
  }

  @Override
  public void setHoles(List<List<MFLocationCoordinate>> holes) {
    for (int i = 0; i < holes.size(); ++i) {
      List<MFLocationCoordinate> hole = holes.get(i);
      MFLocationCoordinate[] holeArray = new MFLocationCoordinate[hole.size()];
      hole.toArray(holeArray);
      polygonOptions.addHole(holeArray);
    }
  }

  @Override
  public void setVisible(boolean visible) {
    polygonOptions.visible(visible);
  }

  @Override
  public void setZIndex(float zIndex) {
    polygonOptions.zIndex(zIndex);
  }
}
