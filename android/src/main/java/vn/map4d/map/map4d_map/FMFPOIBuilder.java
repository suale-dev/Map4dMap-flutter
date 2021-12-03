package vn.map4d.map.map4d_map;

import android.view.View;

import vn.map4d.map.annotations.MFBitmapDescriptor;
import vn.map4d.map.annotations.MFPOIOptions;
import vn.map4d.types.MFLocationCoordinate;

class FMFPOIBuilder implements FMFPOIOptionsSink {

  private final MFPOIOptions poiOptions;
  private final float density;
  private boolean consumeTapEvents;

  FMFPOIBuilder(float density) {
    this.poiOptions = new MFPOIOptions();
    this.density = density;
  }

  MFPOIOptions build() {
    return poiOptions;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    poiOptions.touchable(consumeTapEvents);
  }

  @Override
  public void setPosition(MFLocationCoordinate position) {
    poiOptions.position(position);
  }

  @Override
  public void setTitle(String title) {
    poiOptions.title(title);
  }

  @Override
  public void setSubTitle(String subTitle) {
    poiOptions.subtitle(subTitle);
  }

  @Override
  public void setType(String type) {
    poiOptions.type(type);
  }

  @Override
  public void setTitleColor(int titleColor) {
    poiOptions.titleColor(titleColor);
  }

  @Override
  public void setIconView(View iconView) {
    poiOptions.iconView(iconView);
  }

  @Override
  public void setIcon(MFBitmapDescriptor icon) {
    poiOptions.icon(icon);
  }

  @Override
  public void setVisible(boolean visible) {
    poiOptions.visible(visible);
  }

  @Override
  public void setZIndex(float zIndex) {
    poiOptions.zIndex(zIndex);
  }
}
