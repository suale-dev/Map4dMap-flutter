package vn.map4d.map.map4d_map;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.types.MFLocationCoordinate;

/** Receiver of Marker configuration options. */
interface FMFMarkerOptionsSink {
  void setConsumeTapEvents(boolean consumeTapEvents);

  void setPosition(MFLocationCoordinate position);

  void setRotation(double rotation);

  void setElevation(double elevation);

  void setAnchor(float anchorU, float anchorV);

  void setVisible(boolean visible);

  void setDraggable(boolean draggable);

  void setIcon(MFBitmapDescriptor icon);

  void setTitle(String title);

  void setSnippet(String snippet);

  void setWindowAnchor(float windowAnchorU, float windowAnchorV);

  void setShowWindowInfoOnTap(boolean showWindowInfoOnTap);

  void setZIndex(float zIndex);
}
