package vn.map4d.map.map4d_map;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.annotations.MFPolygon;
import vn.map4d.map.annotations.MFPolygonOptions;
import vn.map4d.map.core.Map4D;

class FMFPolygonsController {
  private final Map<String, FMFPolygonController> polygonIdToController;
  private final Map<Long, String> mfPolygonIdToDartPolygonId;
  private final MethodChannel methodChannel;
  private Map4D map4D;
  private final float density;

  FMFPolygonsController(MethodChannel methodChannel, float density) {
    this.polygonIdToController = new HashMap<>();
    this.mfPolygonIdToDartPolygonId = new HashMap<>();
    this.methodChannel = methodChannel;
    this.density = density;
  }

  void setMap(Map4D map4D) {
    this.map4D = map4D;
  }

  void addPolygons(List<Object> polygonsToAdd) {
    if (polygonsToAdd != null) {
      for (Object polygonToAdd : polygonsToAdd) {
        addPolygon(polygonToAdd);
      }
    }
  }

  void changePolygons(List<Object> polygonsToChange) {
    if (polygonsToChange != null) {
      for (Object polygonToChange : polygonsToChange) {
        changePolygon(polygonToChange);
      }
    }
  }

  void removePolygons(List<Object> polygonIdsToRemove) {
    if (polygonIdsToRemove == null) {
      return;
    }
    for (Object rawPolygonId : polygonIdsToRemove) {
      if (rawPolygonId == null) {
        continue;
      }
      String polygonId = (String) rawPolygonId;
      final FMFPolygonController polygonController = polygonIdToController.remove(polygonId);
      if (polygonController != null) {
        polygonController.remove();
        mfPolygonIdToDartPolygonId.remove(polygonController.getMFPolygonId());
      }
    }
  }

  boolean onPolygonTap(long mfPolygonId) {
    String polygonId = mfPolygonIdToDartPolygonId.get(mfPolygonId);
    if (polygonId == null) {
      return false;
    }
    methodChannel.invokeMethod("polygon#onTap", Convert.polygonIdToJson(polygonId));
    FMFPolygonController polygonController = polygonIdToController.get(polygonId);
    if (polygonController != null) {
      return polygonController.consumeTapEvents();
    }
    return false;
  }

  private void addPolygon(Object polygon) {
    if (polygon == null) {
      return;
    }
    FMFPolygonBuilder polygonBuilder = new FMFPolygonBuilder(density);
    String polygonId = Convert.interpretPolygonOptions(polygon, polygonBuilder);
    MFPolygonOptions options = polygonBuilder.build();
    addPolygon(polygonId, options, polygonBuilder.consumeTapEvents());
  }

  private void addPolygon(String polygonId, MFPolygonOptions polygonOptions, boolean consumeTapEvents) {
    final MFPolygon polygon = map4D.addPolygon(polygonOptions);
    FMFPolygonController controller = new FMFPolygonController(polygon, consumeTapEvents, density);
    polygonIdToController.put(polygonId, controller);
    mfPolygonIdToDartPolygonId.put(polygon.getId(), polygonId);
  }

  private void changePolygon(Object polygon) {
    if (polygon == null) {
      return;
    }
    String polygonId = getPolygonId(polygon);
    FMFPolygonController polygonController = polygonIdToController.get(polygonId);
    if (polygonController != null) {
      Convert.interpretPolygonOptions(polygon, polygonController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getPolygonId(Object polygon) {
    Map<String, Object> polygonMap = (Map<String, Object>) polygon;
    return (String) polygonMap.get("polygonId");
  }
}
