package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.map.annotations.MFDirectionsRenderer;
import vn.map4d.types.MFLocationCoordinate;

/** Controller of a single Directions Renderer on the map. */
class FMFDirectionsRendererController implements FMFDirectionsRendererOptionsSink {

  private final MFDirectionsRenderer directionsRenderer;
  private final long mfDirectionsRendererId;
  private boolean consumeTapEvents;
  private final float density;

  FMFDirectionsRendererController(MFDirectionsRenderer directionsRenderer, boolean consumeTapEvents, float density) {
    this.directionsRenderer = directionsRenderer;
    this.consumeTapEvents = consumeTapEvents;
    this.density = density;
    this.mfDirectionsRendererId = directionsRenderer.getId();
  }

  void remove() {
    directionsRenderer.remove();
  }

  long getMFDirectionsRendererId() {
    return mfDirectionsRendererId;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
  }

  @Override
  public void setPaths(List<List<MFLocationCoordinate>> paths) {
    directionsRenderer.setPaths(paths);
  }

  @Override
  public void setJsonData(String jsonData) {
    directionsRenderer.setJsonData(jsonData);
  }

  @Override
  public void setActivedIndex(int activedIndex) {
    directionsRenderer.setActivedIndex(activedIndex);
  }

  @Override
  public void setActiveStrokeColor(int color) {
    directionsRenderer.setActiveStrokeColor(color);
  }

  @Override
  public void setActiveOutlineColor(int color) {
    directionsRenderer.setActiveOutlineColor(color);
  }

  @Override
  public void setInactiveStrokeColor(int color) {
    directionsRenderer.setInactiveStrokeColor(color);
  }

  @Override
  public void setInactiveOutlineColor(int color) {
    directionsRenderer.setInactiveOutlineColor(color);
  }

  @Override
  public void setWidth(float width) {
    directionsRenderer.setWidth(width);
  }

  @Override
  public void setStartLocation(MFLocationCoordinate location) {
    directionsRenderer.setStartLocation(location);
  }

  @Override
  public void setStartIcon(MFBitmapDescriptor iconDescriptor) {
    directionsRenderer.setStartIcon(iconDescriptor);
  }

  @Override
  public void setStartLabel(String startLabel) {
    directionsRenderer.setStartLabel(startLabel);
  }

  @Override
  public void setOriginPOIVisible(boolean visible) {
    directionsRenderer.setOriginPOIVisible(visible);
  }

  @Override
  public void setEndLocation(MFLocationCoordinate location) {
    directionsRenderer.setEndLocation(location);
  }

  @Override
  public void setEndIcon(MFBitmapDescriptor iconDescriptor) {
    directionsRenderer.setEndIcon(iconDescriptor);
  }

  @Override
  public void setEndLabel(String endLabel) {
    directionsRenderer.setEndLabel(endLabel);
  }

  @Override
  public void setDestinationPOIVisible(boolean visible) {
    directionsRenderer.setDestinationPOIVisible(visible);
  }

  @Override
  public void setTitleColor(int color) {
    directionsRenderer.setTitleColor(color);
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }
}
