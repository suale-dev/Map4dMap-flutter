package vn.map4d.map.map4d_map;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.map.annotations.MFMarker;
import vn.map4d.types.MFLocationCoordinate;

/** Controller of a single Marker on the map. */
class FMFMarkerController implements FMFMarkerOptionsSink {
  private final MFMarker marker;
  private final long mfMarkerId;
  private boolean consumeTapEvents;
  private final float density;

  FMFMarkerController(MFMarker marker, boolean consumeTapEvents, float density) {
    this.marker = marker;
    this.consumeTapEvents = consumeTapEvents;
    this.density = density;
    this.mfMarkerId = marker.getId();
  }

  void remove() {
    marker.remove();
  }

  long getMFMarkerId() {
    return mfMarkerId;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    marker.setTouchable(consumeTapEvents);
  }

  @Override
  public void setPosition(MFLocationCoordinate position) {
    marker.setPosition(position);
  }

  @Override
  public void setRotation(double rotation) {
    marker.setRotation(rotation);
  }

  @Override
  public void setElevation(double elevation) {
    /** Need update SDK **/
//    marker.setElevation(elevation);
  }

  @Override
  public void setAnchor(float anchorU, float anchorV) {
    /** Need update SDK **/
//    marker.setAnchor(anchorU, anchorV);
  }

  @Override
  public void setVisible(boolean visible) {
    marker.setVisible(visible);
  }

  @Override
  public void setDraggable(boolean draggable) {
    marker.setDraggable(draggable);
  }

  @Override
  public void setIcon(MFBitmapDescriptor icon) {
    marker.setIcon(icon);
  }

  @Override
  public void setTitle(String title) {
    marker.setTitle(title);
  }

  @Override
  public void setSnippet(String snippet) {
    marker.setSnippet(snippet);
  }

  @Override
  public void setWindowAnchor(float windowAnchorU, float windowAnchorV) {
    marker.setWindowAnchor(windowAnchorU, windowAnchorV);
  }

  @Override
  public void setZIndex(float zIndex) {
    marker.setZIndex(zIndex);
  }
}
