package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFBuildingOptions;
import vn.map4d.types.MFLocationCoordinate;

class FMFBuildingBuilder implements FMFBuildingOptionsSink {

  private final MFBuildingOptions buildingOptions;
  private final float density;
  private boolean consumeTapEvents;
  private boolean selected = false;

  FMFBuildingBuilder(float density) {
    this.buildingOptions = new MFBuildingOptions();
    this.density = density;
  }

  MFBuildingOptions build() {
    return buildingOptions;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  boolean isSelected() {
    return selected;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    buildingOptions.touchable(consumeTapEvents);
  }

  @Override
  public void setLocation(MFLocationCoordinate location) {
    buildingOptions.location(location);
  }

  @Override
  public void setName(String name) {
    buildingOptions.name(name);
  }

  @Override
  public void setModel(String model) {
    buildingOptions.model(model);
  }

  @Override
  public void setTexture(String texture) {
    buildingOptions.texture(texture);
  }

  @Override
  public void setModel(List<MFLocationCoordinate> coordinates) {
    buildingOptions.model(coordinates);
  }

  @Override
  public void setHeight(double height) {
    buildingOptions.height(height);
  }

  @Override
  public void setScale(double scale) {
    buildingOptions.scale(scale);
  }

  @Override
  public void setBearing(double bearing) {
    buildingOptions.bearing(bearing);
  }

  @Override
  public void setElevation(float elevation) {
    buildingOptions.elevation(elevation);
  }

  @Override
  public void setSelected(boolean selected) {
    this.selected = selected;
  }

  @Override
  public void setVisible(boolean visible) {
    buildingOptions.visible(visible);
  }
}
