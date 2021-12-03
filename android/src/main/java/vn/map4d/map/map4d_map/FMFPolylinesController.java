package vn.map4d.map.map4d_map;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.annotations.MFPolyline;
import vn.map4d.map.annotations.MFPolylineOptions;
import vn.map4d.map.core.Map4D;

class FMFPolylinesController {

  private final Map<String, FMFPolylineController> polylineIdToController;
  private final Map<Long, String> mfPolylineIdToDartPolylineId;
  private final MethodChannel methodChannel;
  private Map4D map4D;
  private final float density;

  FMFPolylinesController(MethodChannel methodChannel, float density) {
    this.polylineIdToController = new HashMap<>();
    this.mfPolylineIdToDartPolylineId = new HashMap<>();
    this.methodChannel = methodChannel;
    this.density = density;
  }

  void setMap(Map4D map4D) {
    this.map4D = map4D;
  }

  void addPolylines(List<Object> polylinesToAdd) {
    if (polylinesToAdd != null) {
      for (Object polylineToAdd : polylinesToAdd) {
        addPolyline(polylineToAdd);
      }
    }
  }

  void changePolylines(List<Object> polylinesToChange) {
    if (polylinesToChange != null) {
      for (Object polylineToChange : polylinesToChange) {
        changePolyline(polylineToChange);
      }
    }
  }

  void removePolylines(List<Object> polylineIdsToRemove) {
    if (polylineIdsToRemove == null) {
      return;
    }
    for (Object rawPolylineId : polylineIdsToRemove) {
      if (rawPolylineId == null) {
        continue;
      }
      String polylineId = (String) rawPolylineId;
      final FMFPolylineController polylineController = polylineIdToController.remove(polylineId);
      if (polylineController != null) {
        polylineController.remove();
        mfPolylineIdToDartPolylineId.remove(polylineController.getMFPolylineId());
      }
    }
  }

  boolean onPolylineTap(long mfPolylineId) {
    String polylineId = mfPolylineIdToDartPolylineId.get(mfPolylineId);
    if (polylineId == null) {
      return false;
    }
    methodChannel.invokeMethod("polyline#onTap", Convert.polylineIdToJson(polylineId));
    FMFPolylineController polylineController = polylineIdToController.get(polylineId);
    if (polylineController != null) {
      return polylineController.consumeTapEvents();
    }
    return false;
  }

  private void addPolyline(Object polyline) {
    if (polyline == null) {
      return;
    }
    FMFPolylineBuilder polylineBuilder = new FMFPolylineBuilder(density);
    String polylineId = Convert.interpretPolylineOptions(polyline, polylineBuilder);
    MFPolylineOptions options = polylineBuilder.build();
    addPolyline(polylineId, options, polylineBuilder.consumeTapEvents());
  }

  private void addPolyline(
    String polylineId, MFPolylineOptions polylineOptions, boolean consumeTapEvents) {
    final MFPolyline polyline = map4D.addPolyline(polylineOptions);
    FMFPolylineController controller = new FMFPolylineController(polyline, consumeTapEvents, density);
    polylineIdToController.put(polylineId, controller);
    mfPolylineIdToDartPolylineId.put(polyline.getId(), polylineId);
  }

  private void changePolyline(Object polyline) {
    if (polyline == null) {
      return;
    }
    String polylineId = getPolylineId(polyline);
    FMFPolylineController polylineController = polylineIdToController.get(polylineId);
    if (polylineController != null) {
      Convert.interpretPolylineOptions(polyline, polylineController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getPolylineId(Object polyline) {
    Map<String, Object> polylineMap = (Map<String, Object>) polyline;
    return (String) polylineMap.get("polylineId");
  }
}
