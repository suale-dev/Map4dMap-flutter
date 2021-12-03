package vn.map4d.map.map4d_map;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import vn.map4d.map.annotations.MFMarker;
import vn.map4d.map.annotations.MFMarkerOptions;
import vn.map4d.map.core.Map4D;
import vn.map4d.types.MFLocationCoordinate;

class FMFMarkersController {
  private final Map<String, FMFMarkerController> markerIdToController;
  private final Map<Long, String> mfMarkerIdToDartMarkerId;
  private final MethodChannel methodChannel;
  private Map4D map4D;
  private final float density;

  FMFMarkersController(@NonNull Context context, MethodChannel methodChannel, float density) {
    this.markerIdToController = new HashMap<>();
    this.mfMarkerIdToDartMarkerId = new HashMap<>();
    this.methodChannel = methodChannel;
    this.density = density;
  }

  void setMap(Map4D map4D) {
    this.map4D = map4D;
  }

  void addMarkers(List<Object> markersToAdd) {
    if (markersToAdd != null) {
      for (Object markerToAdd : markersToAdd) {
        addMarker(markerToAdd);
      }
    }
  }

  void changeMarkers(List<Object> markersToChange) {
    if (markersToChange != null) {
      for (Object markerToChange : markersToChange) {
        changeMarker(markerToChange);
      }
    }
  }

  void removeMarkers(List<Object> markerIdsToRemove) {
    if (markerIdsToRemove == null) {
      return;
    }
    for (Object rawMarkerId : markerIdsToRemove) {
      if (rawMarkerId == null) {
        continue;
      }
      String markerId = (String) rawMarkerId;
      final FMFMarkerController markerController = markerIdToController.remove(markerId);
      if (markerController != null) {
        markerController.remove();
        mfMarkerIdToDartMarkerId.remove(markerController.getMFMarkerId());
      }
    }
  }

  boolean onMarkerTap(long mfMarkerId) {
    String markerId = mfMarkerIdToDartMarkerId.get(mfMarkerId);
    if (markerId == null) {
      return false;
    }
    methodChannel.invokeMethod("marker#onTap", Convert.markerIdToJson(markerId));
    FMFMarkerController markerController = markerIdToController.get(markerId);
    if (markerController != null) {
      return markerController.consumeTapEvents();
    }
    return false;
  }

  void onMarkerDragEnd(long mfMarkerId, MFLocationCoordinate position) {
    String markerId = mfMarkerIdToDartMarkerId.get(mfMarkerId);
    if (markerId == null) {
      return;
    }
    final Map<String, Object> data = new HashMap<>();
    data.put("markerId", markerId);
    data.put("position", Convert.latLngToJson(position));
    methodChannel.invokeMethod("marker#onDragEnd", data);
  }

  void onInfoWindowTap(long mfMarkerId) {
    String markerId = mfMarkerIdToDartMarkerId.get(mfMarkerId);
    if (markerId == null) {
      return;
    }
    methodChannel.invokeMethod("infoWindow#onTap", Convert.markerIdToJson(markerId));
  }

  private void addMarker(Object marker) {
    if (marker == null) {
      return;
    }
    FMFMarkerBuilder markerBuilder = new FMFMarkerBuilder(density);
    String markerId = Convert.interpretMarkerOptions(marker, markerBuilder);
    MFMarkerOptions options = markerBuilder.build();
    addMarker(markerId, options, markerBuilder.consumeTapEvents());
  }

  private void addMarker(String markerId, MFMarkerOptions markerOptions, boolean consumeTapEvents) {
    final MFMarker marker = map4D.addMarker(markerOptions);
    FMFMarkerController controller = new FMFMarkerController(marker, consumeTapEvents, density);
    markerIdToController.put(markerId, controller);
    mfMarkerIdToDartMarkerId.put(marker.getId(), markerId);
  }

  private void changeMarker(Object marker) {
    if (marker == null) {
      return;
    }
    String markerId = getMarkerId(marker);
    FMFMarkerController markerController = markerIdToController.get(markerId);
    if (markerController != null) {
      Convert.interpretMarkerOptions(marker, markerController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getMarkerId(Object marker) {
    Map<String, Object> markerMap = (Map<String, Object>) marker;
    return (String) markerMap.get("markerId");
  }
}
