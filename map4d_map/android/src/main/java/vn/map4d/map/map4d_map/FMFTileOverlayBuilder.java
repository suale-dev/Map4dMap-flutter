package vn.map4d.map.map4d_map;

import vn.map4d.map.overlays.MFTileOverlayOptions;
import vn.map4d.map.overlays.MFTileProvider;

class FMFTileOverlayBuilder implements FMFTileOverlaySink {

  private final MFTileOverlayOptions tileOverlayOptions;

  private String urlPattern;

  FMFTileOverlayBuilder() {
    this.tileOverlayOptions = new MFTileOverlayOptions();
    this.urlPattern = null;
  }

  MFTileOverlayOptions build() {
    return tileOverlayOptions;
  }

  @Override
  public void setZIndex(float zIndex) {
    tileOverlayOptions.zIndex(zIndex);
  }

  @Override
  public void setVisible(boolean visible) {
    tileOverlayOptions.visible(visible);
  }

  @Override
  public void setUrlPattern(String urlPattern) {
    this.urlPattern = urlPattern;
  }

  @Override
  public void setTileProvider(MFTileProvider tileProvider) {
    tileOverlayOptions.tileProvider(tileProvider);
  }

  String getUrlPattern() {
    return urlPattern;
  }
}
