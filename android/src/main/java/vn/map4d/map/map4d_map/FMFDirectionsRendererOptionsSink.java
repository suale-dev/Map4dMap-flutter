package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.types.MFLocationCoordinate;

/** Receiver of Directions Renderer configuration options. */
interface FMFDirectionsRendererOptionsSink {

  void setConsumeTapEvents(boolean consumeTapEvents);

  void setPaths(List<List<MFLocationCoordinate>> paths);

  void setJsonData(String jsonData);

  void setActivedIndex(int activedIndex);

  void setActiveStrokeColor(int color);

  void setActiveOutlineColor(int color);

  void setInactiveStrokeColor(int color);

  void setInactiveOutlineColor(int color);

  void setWidth(float width);

  void setStartLocation(MFLocationCoordinate location);

  void setStartIcon(MFBitmapDescriptor iconDescriptor);

  void setStartLabel(String startLabel);

  void setOriginPOIVisible(boolean visible);

  void setEndLocation(MFLocationCoordinate location);

  void setEndIcon(MFBitmapDescriptor iconDescriptor);

  void setEndLabel(String endLabel);

  void setDestinationPOIVisible(boolean visible);

  void setTitleColor(int color);
}
