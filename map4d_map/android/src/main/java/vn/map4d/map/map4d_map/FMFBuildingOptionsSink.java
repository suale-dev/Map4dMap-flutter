package vn.map4d.map.map4d_map;

import java.util.List;

import vn.map4d.types.MFLocationCoordinate;

/** Receiver of User Building configuration options. */
interface FMFBuildingOptionsSink {

  void setConsumeTapEvents(boolean consumeTapEvents);

  void setLocation(MFLocationCoordinate location);

  void setName(String name);

  void setModel(String model);

  void setTexture(String texture);

  void setModel(List<MFLocationCoordinate> coordinates);

  void setHeight(double height);

  void setScale(double scale);

  void setBearing(double bearing);

  void setElevation(float elevation);

  void setSelected(boolean selected);

  void setVisible(boolean visible);

}
