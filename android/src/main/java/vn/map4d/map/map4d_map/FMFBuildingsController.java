package vn.map4d.map.map4d_map;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.annotations.MFBuilding;
import vn.map4d.map.annotations.MFBuildingOptions;
import vn.map4d.map.core.Map4D;

class FMFBuildingsController {
  private final Map<String, FMFBuildingController> buildingIdToController;
  private final Map<Long, String> mfBuildingIdToDartBuildingId;
  private final MethodChannel methodChannel;
  private final float density;
  private Map4D map4D;

  FMFBuildingsController(MethodChannel methodChannel, float density) {
    this.buildingIdToController = new HashMap<>();
    this.mfBuildingIdToDartBuildingId = new HashMap<>();
    this.methodChannel = methodChannel;
    this.density = density;
  }

  void setMap(Map4D map4D) {
    this.map4D = map4D;
  }

  void addBuildings(List<Object> buildingsToAdd) {
    if (buildingsToAdd != null) {
      for (Object buildingToAdd : buildingsToAdd) {
        addBuilding(buildingToAdd);
      }
    }
  }

  void changeBuildings(List<Object> buildingsToChange) {
    if (buildingsToChange != null) {
      for (Object buildingToChange : buildingsToChange) {
        changeBuilding(buildingToChange);
      }
    }
  }

  void removeBuildings(List<Object> buildingIdsToRemove) {
    if (buildingIdsToRemove == null) {
      return;
    }
    for (Object rawBuildingId : buildingIdsToRemove) {
      if (rawBuildingId == null) {
        continue;
      }
      String buildingId = (String) rawBuildingId;
      final FMFBuildingController buildingController = buildingIdToController.remove(buildingId);
      if (buildingController != null) {
        buildingController.remove();
        mfBuildingIdToDartBuildingId.remove(buildingController.getMFBuildingId());
      }
    }
  }

  boolean onBuildingTap(long mfBuildingId) {
    String buildingId = mfBuildingIdToDartBuildingId.get(mfBuildingId);
    if (buildingId == null) {
      return false;
    }
    methodChannel.invokeMethod("building#onTap", Convert.buildingIdToJson(buildingId));
    FMFBuildingController buildingController = buildingIdToController.get(buildingId);
    if (buildingController != null) {
      return buildingController.consumeTapEvents();
    }
    return false;
  }

  private void addBuilding(Object building) {
    if (building == null) {
      return;
    }
    FMFBuildingBuilder buildingBuilder = new FMFBuildingBuilder(density);
    String buildingId = Convert.interpretBuildingOptions(building, buildingBuilder);
    MFBuildingOptions options = buildingBuilder.build();
    addBuilding(buildingId, options, buildingBuilder.consumeTapEvents(), buildingBuilder.isSelected());
  }

  private void addBuilding(String buildingId, MFBuildingOptions buildingOptions, boolean consumeTapEvents, boolean selected) {
    final MFBuilding building = map4D.addBuilding(buildingOptions);
    building.setSelected(selected);
    FMFBuildingController controller = new FMFBuildingController(building, consumeTapEvents, density);
    buildingIdToController.put(buildingId, controller);
    mfBuildingIdToDartBuildingId.put(building.getId(), buildingId);
  }

  private void changeBuilding(Object building) {
    if (building == null) {
      return;
    }
    String buildingId = getBuildingId(building);
    FMFBuildingController buildingController = buildingIdToController.get(buildingId);
    if (buildingController != null) {
      Convert.interpretBuildingOptions(building, buildingController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getBuildingId(Object building) {
    Map<String, Object> buildingMap = (Map<String, Object>) building;
    return (String) buildingMap.get("buildingId");
  }
}
