package vn.map4d.map.map4d_map;

import android.view.View;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.map.annotations.MFPOI;
import vn.map4d.types.MFLocationCoordinate;

class FMFPOIController implements FMFPOIOptionsSink {

  private final MFPOI poi;
  private final long mfPOIId;
  private final float density;
  private boolean consumeTapEvents;

  FMFPOIController(MFPOI poi, boolean consumeTapEvents, float density) {
    this.poi = poi;
    this.consumeTapEvents = consumeTapEvents;
    this.density = density;
    this.mfPOIId = poi.getId();
  }

  void remove() {
    poi.remove();
  }

  long getMFPOIId() {
    return mfPOIId;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    poi.setTouchable(consumeTapEvents);
  }

  @Override
  public void setPosition(MFLocationCoordinate position) {
    poi.setPosition(position);
  }

  @Override
  public void setTitle(String title) {
    poi.setTitle(title);
  }

  @Override
  public void setSubTitle(String subTitle) {
    poi.setSubTitle(subTitle);
  }

  @Override
  public void setType(String type) {
    poi.setType(type);
  }

  @Override
  public void setTitleColor(int titleColor) {
    poi.setTitleColor(titleColor);
  }

  @Override
  public void setIconView(View iconView) {
    poi.setIconView(iconView);
  }

  @Override
  public void setIcon(MFBitmapDescriptor icon) {
    poi.setIcon(icon);
  }

  @Override
  public void setVisible(boolean visible) {
    poi.setVisible(visible);
  }

  @Override
  public void setZIndex(float zIndex) {
    poi.setZIndex(zIndex);
  }
}
