package vn.map4d.map.map4d_map;

import vn.map4d.map.overlays.MFTileProvider;

/** Receiver of TileOverlayOptions configuration. */
interface FMFTileOverlaySink {
  void setZIndex(float zIndex);

  void setVisible(boolean visible);

  void setUrlPattern(String urlPattern);

  void setTileProvider(MFTileProvider tileProvider);
}
