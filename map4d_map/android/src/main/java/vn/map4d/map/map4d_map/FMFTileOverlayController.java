package vn.map4d.map.map4d_map;

import java.util.HashMap;
import java.util.Map;

import vn.map4d.map.overlays.MFTileOverlay;
import vn.map4d.map.overlays.MFTileProvider;

class FMFTileOverlayController implements FMFTileOverlaySink {

  private final MFTileOverlay tileOverlay;

  FMFTileOverlayController(MFTileOverlay tileOverlay) {
    this.tileOverlay = tileOverlay;
  }

  void remove() {
    tileOverlay.remove();
  }

  void clearTileCache() {
    tileOverlay.clearTileCache();
  }
  
  @Override
  public void setZIndex(float zIndex) {
    tileOverlay.setZIndex(zIndex);
  }

  @Override
  public void setVisible(boolean visible) {
    tileOverlay.setVisible(visible);
  }

  @Override
  public void setUrlPattern(String urlPattern) {
    // You can not change url pattern after creation
  }

  @Override
  public void setTileProvider(MFTileProvider tileProvider) {
    // You can not change tile provider after creation
  }
}
