package vn.map4d.map.map4d_map;

import vn.map4d.map.overlays.MFTileProvider;

class FMFTileProviderController implements MFTileProvider {

  private String patternUrl;

  FMFTileProviderController(String patternUrl) {
    this.patternUrl = patternUrl;
  }

  @Override
  public String getTile(int x, int y, int zoom, boolean is3DMode) {
    if (patternUrl == null) {
      return null;
    }
    String url = patternUrl.replace("{zoom}", String.valueOf(zoom));
    url = url.replace("{x}", String.valueOf(x));
    url = url.replace("{y}", String.valueOf(y));
    return url;
  }
}
