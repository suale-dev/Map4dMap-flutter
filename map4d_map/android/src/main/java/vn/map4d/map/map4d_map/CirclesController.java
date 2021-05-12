package vn.map4d.map.map4d_map;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.annotations.MFCircle;
import vn.map4d.map.annotations.MFCircleOptions;
import vn.map4d.map.core.Map4D;

public class CirclesController {

  private final Map<String, CircleController> circleIdToController;
  private final Map<Long, String> mfCircleIdToDartCircleId;
  private final MethodChannel methodChannel;
  private final float density;
  private Map4D map4D;

  CirclesController(MethodChannel methodChannel, float density) {
    this.circleIdToController = new HashMap<>();
    this.mfCircleIdToDartCircleId = new HashMap<>();
    this.methodChannel = methodChannel;
    this.density = density;
  }

  void setMap(Map4D map4D) {
    this.map4D = map4D;
  }

  void addCircles(List<Object> circlesToAdd) {
    if (circlesToAdd != null) {
      for (Object circleToAdd : circlesToAdd) {
        addCircle(circleToAdd);
      }
    }
  }

  void changeCircles(List<Object> circlesToChange) {
    if (circlesToChange != null) {
      for (Object circleToChange : circlesToChange) {
        changeCircle(circleToChange);
      }
    }
  }

  void removeCircles(List<Object> circleIdsToRemove) {
    if (circleIdsToRemove == null) {
      return;
    }
    for (Object rawCircleId : circleIdsToRemove) {
      if (rawCircleId == null) {
        continue;
      }
      String circleId = (String) rawCircleId;
      final CircleController circleController = circleIdToController.remove(circleId);
      if (circleController != null) {
        circleController.remove();
        mfCircleIdToDartCircleId.remove(circleController.getMFCircleId());
      }
    }
  }

  boolean onCircleTap(long mfCircleId) {
    String circleId = mfCircleIdToDartCircleId.get(mfCircleId);
    if (circleId == null) {
      return false;
    }
    methodChannel.invokeMethod("circle#onTap", Convert.circleIdToJson(circleId));
    CircleController circleController = circleIdToController.get(circleId);
    if (circleController != null) {
      return circleController.consumeTapEvents();
    }
    return false;
  }

  private void addCircle(Object circle) {
    if (circle == null) {
      return;
    }
    CircleBuilder circleBuilder = new CircleBuilder(density);
    String circleId = Convert.interpretCircleOptions(circle, circleBuilder);
    MFCircleOptions options = circleBuilder.build();
    addCircle(circleId, options, circleBuilder.consumeTapEvents());
  }

  private void addCircle(String circleId, MFCircleOptions circleOptions, boolean consumeTapEvents) {
    final MFCircle circle = map4D.addCircle(circleOptions);
    CircleController controller = new CircleController(circle, consumeTapEvents, density);
    circleIdToController.put(circleId, controller);
    mfCircleIdToDartCircleId.put(circle.getId(), circleId);
  }

  private void changeCircle(Object circle) {
    if (circle == null) {
      return;
    }
    String circleId = getCircleId(circle);
    CircleController circleController = circleIdToController.get(circleId);
    if (circleController != null) {
      Convert.interpretCircleOptions(circle, circleController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getCircleId(Object circle) {
    Map<String, Object> circleMap = (Map<String, Object>) circle;
    return (String) circleMap.get("circleId");
  }
}
