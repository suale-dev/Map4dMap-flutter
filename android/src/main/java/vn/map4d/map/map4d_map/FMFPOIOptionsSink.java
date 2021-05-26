package vn.map4d.map.map4d_map;

import android.view.View;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.types.MFLocationCoordinate;

/** Receiver of User POI configuration options. */
interface FMFPOIOptionsSink {
  void setConsumeTapEvents(boolean consumeTapEvents);

  void setPosition(MFLocationCoordinate position);

  void setTitle(String title);

  void setSubTitle(String subTitle);

  void setType(String type);

  void setTitleColor(int titleColor);

  void setIconView(View iconView);

  void setIcon(MFBitmapDescriptor icon);

  void setVisible(boolean visible);

  void setZIndex(float zIndex);
}
