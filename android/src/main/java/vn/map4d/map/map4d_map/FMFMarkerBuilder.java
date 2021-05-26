package vn.map4d.map.map4d_map;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.map.annotations.MFMarkerOptions;
import vn.map4d.types.MFLocationCoordinate;

class FMFMarkerBuilder implements FMFMarkerOptionsSink {
  private final MFMarkerOptions markerOptions;
  private boolean consumeTapEvents;
  private final float density;

  FMFMarkerBuilder(float density) {
    this.markerOptions = new MFMarkerOptions();
    this.density = density;
  }

  MFMarkerOptions build() {
    return markerOptions;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    markerOptions.touchable(consumeTapEvents);
  }

  @Override
  public void setPosition(MFLocationCoordinate position) {
    markerOptions.position(position);
  }

  @Override
  public void setRotation(double rotation) {
    markerOptions.rotation(rotation);
  }

  @Override
  public void setElevation(double elevation) {
    markerOptions.elevation(elevation);
  }

  @Override
  public void setAnchor(float anchorU, float anchorV) {
    markerOptions.anchor(anchorU, anchorV);
  }

  @Override
  public void setVisible(boolean visible) {
    markerOptions.visible(visible);
  }

  @Override
  public void setDraggable(boolean draggable) {
    markerOptions.draggable(draggable);
  }

  @Override
  public void setIcon(MFBitmapDescriptor icon) {
    markerOptions.icon(icon);
  }

  @Override
  public void setTitle(String title) {
    markerOptions.title(title);
  }

  @Override
  public void setSnippet(String snippet) {
    markerOptions.snippet(snippet);
  }

  @Override
  public void setWindowAnchor(float windowAnchorU, float windowAnchorV) {
    markerOptions.infoWindowAnchor(windowAnchorU, windowAnchorV);
  }

  @Override
  public void setZIndex(float zIndex) {
    markerOptions.zIndex(zIndex);
  }
}
