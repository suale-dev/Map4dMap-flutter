package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFBuilding;
import vn.map4d.types.MFLocationCoordinate;

/** Controller of a single Polyline on the map. */
class FMFBuildingController implements FMFBuildingOptionsSink {

  private final MFBuilding building;
  private final long mfBuildingId;
  private final float density;
  private boolean consumeTapEvents;

  FMFBuildingController(MFBuilding building, boolean consumeTapEvents, float density) {
    this.building = building;
    this.consumeTapEvents = consumeTapEvents;
    this.density = density;
    this.mfBuildingId = this.building.getId();
  }

  void remove() {
    building.remove();
  }

  long getMFBuildingId() {
    return mfBuildingId;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    building.setTouchable(consumeTapEvents);
  }

  @Override
  public void setLocation(MFLocationCoordinate location) {
    building.setLocation(location);
  }

  @Override
  public void setName(String name) {
    building.setName(name);
  }

  @Override
  public void setModel(String model) {
    building.setModel(model);
  }

  @Override
  public void setTexture(String texture) {
    building.setTexture(texture);
  }

  @Override
  public void setModel(List<MFLocationCoordinate> coordinates) {
    building.setModel(coordinates);
  }

  @Override
  public void setHeight(double height) {
    building.setHeight(height);
  }

  @Override
  public void setScale(double scale) {
    building.setScale(scale);
  }

  @Override
  public void setBearing(double bearing) {
    building.setBearing(bearing);
  }

  @Override
  public void setElevation(float elevation) {
    building.setElevation(elevation);
  }

  @Override
  public void setSelected(boolean selected) {
    building.setSelected(selected);
  }

  @Override
  public void setVisible(boolean visible) {
    building.setVisible(visible);
  }
}
