package vn.map4d.map.map4d_map;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.annotations.MFDirectionsRenderer;
import vn.map4d.map.annotations.MFDirectionsRendererOptions;
import vn.map4d.map.core.Map4D;

class FMFDirectionsRenderersController {

  private final Map<String, FMFDirectionsRendererController> directionsRendererIdToController;
  private final Map<Long, String> mfDirectionsRendererIdToDartDirectionsRendererId;
  private final MethodChannel methodChannel;
  private Map4D map4D;
  private final float density;

  FMFDirectionsRenderersController(MethodChannel methodChannel, float density) {
    this.directionsRendererIdToController = new HashMap<>();
    this.mfDirectionsRendererIdToDartDirectionsRendererId = new HashMap<>();
    this.methodChannel = methodChannel;
    this.density = density;
  }

  void setMap(Map4D map4D) {
    this.map4D = map4D;
  }

  void addDirectionsRenderers(List<Object> directionsRenderersToAdd) {
    if (directionsRenderersToAdd != null) {
      for (Object directionsRenderToAdd : directionsRenderersToAdd) {
        addDirectionsRenderers(directionsRenderToAdd);
      }
    }
  }

  void changeDirectionsRenderers(List<Object> directionsRenderersToChange) {
    if (directionsRenderersToChange != null) {
      for (Object directionsRendererToChange : directionsRenderersToChange) {
        changeDirectionsRenderers(directionsRendererToChange);
      }
    }
  }

  void removeDirectionsRenderers(List<Object> directionsRenderersToRemove) {
    if (directionsRenderersToRemove == null) {
      return;
    }
    for (Object rawDirectionsRendererId : directionsRenderersToRemove) {
      if (rawDirectionsRendererId == null) {
        continue;
      }
      String directionsRendererId = (String) rawDirectionsRendererId;
      final FMFDirectionsRendererController directionsRendererController = directionsRendererIdToController.remove(directionsRendererId);
      if (directionsRendererController != null) {
        directionsRendererController.remove();
        mfDirectionsRendererIdToDartDirectionsRendererId.remove(directionsRendererController.getMFDirectionsRendererId());
      }
    }
  }

  boolean onDirectionsRendererTap(long mfDirectionsRendererId, int index) {
    String directionsRendererId = mfDirectionsRendererIdToDartDirectionsRendererId.get(mfDirectionsRendererId);
    if (directionsRendererId == null) {
      return false;
    }
    methodChannel.invokeMethod("directionsRenderer#onRouteTap", Convert.directionsRendererIdAndActiveIndexToJson(directionsRendererId, index));
    FMFDirectionsRendererController directionsRendererController = directionsRendererIdToController.get(directionsRendererId);
    if (directionsRendererController != null) {
      return directionsRendererController.consumeTapEvents();
    }
    return false;
  }

  private void addDirectionsRenderers(Object directionsRenderer) {
    if (directionsRenderer == null) {
      return;
    }
    FMFDirectionsRendererBuilder directionsRendererBuilder = new FMFDirectionsRendererBuilder(density);
    String directionsRenderId = Convert.interpretDirectionsRendererOptions(directionsRenderer, directionsRendererBuilder);
    MFDirectionsRendererOptions options = directionsRendererBuilder.build();
    addDirectionsRenderers(directionsRenderId, options, directionsRendererBuilder.consumeTapEvents());
  }

  private void addDirectionsRenderers(String directionsRendererId, MFDirectionsRendererOptions directionsRendererOptions, boolean consumeTapEvents) {
    final MFDirectionsRenderer directionsRenderer = map4D.addDirectionsRenderer(directionsRendererOptions);
    FMFDirectionsRendererController controller = new FMFDirectionsRendererController(directionsRenderer, consumeTapEvents, density);
    directionsRendererIdToController.put(directionsRendererId, controller);
    mfDirectionsRendererIdToDartDirectionsRendererId.put(directionsRenderer.getId(), directionsRendererId);
  }

  private void changeDirectionsRenderers(Object directionsRenderer) {
    if (directionsRenderer == null) {
      return;
    }
    String directionsRendererId = getDirectionsRendererId(directionsRenderer);
    FMFDirectionsRendererController directionsRendererController = directionsRendererIdToController.get(directionsRendererId);
    if (directionsRendererController != null) {
      Convert.interpretDirectionsRendererOptions(directionsRenderer, directionsRendererController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getDirectionsRendererId(Object directionsRenderer) {
    Map<String, Object> directionsRendererMap = (Map<String, Object>) directionsRenderer;
    return (String) directionsRendererMap.get("rendererId");
  }
}
