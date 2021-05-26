package vn.map4d.map.map4d_map;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.core.Map4D;
import vn.map4d.map.overlays.MFTileOverlay;
import vn.map4d.map.overlays.MFTileOverlayOptions;

class FMFTileOverlaysController {

  private final Map<String, FMFTileOverlayController> tileOverlayIdToController;
  private final MethodChannel methodChannel;
  private Map4D map4D;

  FMFTileOverlaysController(MethodChannel methodChannel) {
    this.tileOverlayIdToController = new HashMap<>();
    this.methodChannel = methodChannel;
  }

  void setMap(Map4D map4D) {
    this.map4D = map4D;
  }

  void addTileOverlays(List<Map<String, ?>> tileOverlaysToAdd) {
    if (tileOverlaysToAdd == null) {
      return;
    }
    for (Map<String, ?> tileOverlayToAdd : tileOverlaysToAdd) {
      addTileOverlay(tileOverlayToAdd);
    }
  }

  void changeTileOverlays(List<Map<String, ?>> tileOverlaysToChange) {
    if (tileOverlaysToChange == null) {
      return;
    }
    for (Map<String, ?> tileOverlayToChange : tileOverlaysToChange) {
      changeTileOverlay(tileOverlayToChange);
    }
  }

  void removeTileOverlays(List<String> tileOverlayIdsToRemove) {
    if (tileOverlayIdsToRemove == null) {
      return;
    }
    for (String tileOverlayId : tileOverlayIdsToRemove) {
      if (tileOverlayId == null) {
        continue;
      }
      removeTileOverlay(tileOverlayId);
    }
  }

  void clearTileCache(String tileOverlayId) {
    if (tileOverlayId == null) {
      return;
    }
    FMFTileOverlayController tileOverlayController = tileOverlayIdToController.get(tileOverlayId);
    if (tileOverlayController != null) {
      tileOverlayController.clearTileCache();
    }
  }

  private void addTileOverlay(Map<String, ?> tileOverlayOptions) {
    if (tileOverlayOptions == null) {
      return;
    }
    FMFTileOverlayBuilder tileOverlayOptionsBuilder = new FMFTileOverlayBuilder();
    String tileOverlayId = Convert.interpretTileOverlayOptions(tileOverlayOptions, tileOverlayOptionsBuilder);
    FMFTileProviderController tileProviderController = new FMFTileProviderController(tileOverlayOptionsBuilder.getUrlPattern());
    tileOverlayOptionsBuilder.setTileProvider(tileProviderController);
    MFTileOverlayOptions options = tileOverlayOptionsBuilder.build();
    MFTileOverlay tileOverlay = map4D.addTileOverlay(options);
    FMFTileOverlayController tileOverlayController = new FMFTileOverlayController(tileOverlay);
    tileOverlayIdToController.put(tileOverlayId, tileOverlayController);
  }

  private void changeTileOverlay(Map<String, ?> tileOverlayOptions) {
    if (tileOverlayOptions == null) {
      return;
    }
    String tileOverlayId = getTileOverlayId(tileOverlayOptions);
    FMFTileOverlayController tileOverlayController = tileOverlayIdToController.get(tileOverlayId);
    if (tileOverlayController != null) {
      Convert.interpretTileOverlayOptions(tileOverlayOptions, tileOverlayController);
    }
  }

  private void removeTileOverlay(String tileOverlayId) {
    FMFTileOverlayController tileOverlayController = tileOverlayIdToController.get(tileOverlayId);
    if (tileOverlayController != null) {
      tileOverlayController.remove();
      tileOverlayIdToController.remove(tileOverlayId);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getTileOverlayId(Map<String, ?> tileOverlay) {
    return (String) tileOverlay.get("tileOverlayId");
  }
}
