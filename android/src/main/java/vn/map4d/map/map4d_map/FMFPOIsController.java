package vn.map4d.map.map4d_map;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.annotations.MFPOI;
import vn.map4d.map.annotations.MFPOIOptions;
import vn.map4d.map.core.Map4D;

class FMFPOIsController {
  private final Map<String, FMFPOIController> poiIdToController;
  private final Map<Long, String> mfPOIIdToDartPOIId;
  private final MethodChannel methodChannel;
  private Map4D map4D;
  private final float density;

  FMFPOIsController(@NonNull Context context, MethodChannel methodChannel, float density) {
    this.poiIdToController = new HashMap<>();
    this.mfPOIIdToDartPOIId = new HashMap<>();
    this.methodChannel = methodChannel;
    this.density = density;
  }

  void setMap(Map4D map4D) {
    this.map4D = map4D;
  }

  void addPOIs(List<Object> poisToAdd) {
    if (poisToAdd != null) {
      for (Object poiToAdd : poisToAdd) {
        addPOI(poiToAdd);
      }
    }
  }

  void changePOIs(List<Object> poisToChange) {
    if (poisToChange != null) {
      for (Object poiToChange : poisToChange) {
        changePOI(poiToChange);
      }
    }
  }

  void removePOIs(List<Object> poiIdsToRemove) {
    if (poiIdsToRemove == null) {
      return;
    }
    for (Object rawPOIId : poiIdsToRemove) {
      if (rawPOIId == null) {
        continue;
      }
      String poiId = (String) rawPOIId;
      final FMFPOIController poiController = poiIdToController.remove(poiId);
      if (poiController != null) {
        poiController.remove();
        mfPOIIdToDartPOIId.remove(poiController.getMFPOIId());
      }
    }
  }

  boolean onPOITap(long mfPOIId) {
    String poiId = mfPOIIdToDartPOIId.get(mfPOIId);
    if (poiId == null) {
      return false;
    }
    methodChannel.invokeMethod("poi#onTap", Convert.poiIdToJson(poiId));
    FMFPOIController poiController = poiIdToController.get(poiId);
    if (poiController != null) {
      return poiController.consumeTapEvents();
    }
    return false;
  }

  private void addPOI(Object poi) {
    if (poi == null) {
      return;
    }
    FMFPOIBuilder poiBuilder = new FMFPOIBuilder(density);
    String poiId = Convert.interpretPOIOptions(poi, poiBuilder);
    MFPOIOptions options = poiBuilder.build();
    addPOI(poiId, options, poiBuilder.consumeTapEvents());
  }

  private void addPOI(String poiId, MFPOIOptions poiOptions, boolean consumeTapEvents) {
    final MFPOI poi = map4D.addPOI(poiOptions);
    FMFPOIController controller = new FMFPOIController(poi, consumeTapEvents, density);
    poiIdToController.put(poiId, controller);
    mfPOIIdToDartPOIId.put(poi.getId(), poiId);
  }

  private void changePOI(Object poi) {
    if (poi == null) {
      return;
    }
    String poiId = getPOIId(poi);
    FMFPOIController poiController = poiIdToController.get(poiId);
    if (poiController != null) {
      Convert.interpretPOIOptions(poi, poiController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getPOIId(Object poi) {
    Map<String, Object> poiMap = (Map<String, Object>) poi;
    return (String) poiMap.get("poiId");
  }
}
