package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.map.annotations.MFDirectionsRendererOptions;
import vn.map4d.types.MFLocationCoordinate;

class FMFDirectionsRendererBuilder implements FMFDirectionsRendererOptionsSink {

  private final MFDirectionsRendererOptions directionsRendererOptions;
  private boolean consumeTapEvents;
  private final float density;

  FMFDirectionsRendererBuilder(float density) {
    this.directionsRendererOptions = new MFDirectionsRendererOptions();
    this.density = density;
    this.consumeTapEvents = true;
  }

  MFDirectionsRendererOptions build() {
    return directionsRendererOptions;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
  }

  @Override
  public void setPaths(List<List<MFLocationCoordinate>> paths) {
    directionsRendererOptions.paths(paths);
  }

  @Override
  public void setJsonData(String jsonData) {
    directionsRendererOptions.jsonData(jsonData);
  }

  @Override
  public void setActivedIndex(int activedIndex) {
    directionsRendererOptions.activedIndex(activedIndex);
  }

  @Override
  public void setActiveStrokeColor(int color) {
    directionsRendererOptions.activeStrokeColor(color);
  }

  @Override
  public void setActiveOutlineColor(int color) {
    directionsRendererOptions.activeOutlineColor(color);
  }

  @Override
  public void setInactiveStrokeColor(int color) {
    directionsRendererOptions.inactiveStrokeColor(color);
  }

  @Override
  public void setInactiveOutlineColor(int color) {
    directionsRendererOptions.inactiveOutlineColor(color);
  }

  @Override
  public void setWidth(float width) {
    directionsRendererOptions.width(width);
  }

  @Override
  public void setStartLocation(MFLocationCoordinate location) {
    directionsRendererOptions.startLocation(location);
  }

  @Override
  public void setStartIcon(MFBitmapDescriptor iconDescriptor) {
    directionsRendererOptions.startIcon(iconDescriptor);
  }

  @Override
  public void setStartLabel(String startLabel) {
    directionsRendererOptions.startLabel(startLabel);
  }

  @Override
  public void setOriginPOIVisible(boolean visible) {
    directionsRendererOptions.originPOIVisible(visible);
  }

  @Override
  public void setEndLocation(MFLocationCoordinate location) {
    directionsRendererOptions.endLocation(location);
  }

  @Override
  public void setEndIcon(MFBitmapDescriptor iconDescriptor) {
    directionsRendererOptions.endIcon(iconDescriptor);
  }

  @Override
  public void setEndLabel(String endLabel) {
    directionsRendererOptions.endLabel(endLabel);
  }

  @Override
  public void setDestinationPOIVisible(boolean visible) {
    directionsRendererOptions.destinationPOIVisible(visible);
  }

  @Override
  public void setTitleColor(int color) {
    directionsRendererOptions.titleColor(color);
  }
}
