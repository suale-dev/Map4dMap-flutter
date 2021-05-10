package vn.map4d.map.map4d_map;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import vn.map4d.map.camera.MFCameraPosition;
import vn.map4d.map.camera.MFCameraUpdate;
import vn.map4d.map.camera.MFCameraUpdateFactory;
import vn.map4d.types.MFLocationCoordinate;

/** Conversions between JSON-like values and Map4D data types. **/
public class Convert {

  static Object latLngToJson(MFLocationCoordinate coordinate) {
    return Arrays.asList(coordinate.getLatitude(), coordinate.getLongitude());
  }

  private static List<?> toList(Object o) {
    return (List<?>) o;
  }

  private static String toString(Object o) {
    return (String) o;
  }

  private static double toDouble(Object o) {
    return ((Number) o).doubleValue();
  }

  static MFLocationCoordinate toCoordinate(Object o) {
    final List<?> data = toList(o);
    return new MFLocationCoordinate(toDouble(data.get(0)), toDouble(data.get(1)));
  }

  static MFCameraUpdate toCameraUpdate(Object o, float density) {
    final List<?> data = toList(o);
    switch (toString(data.get(0))) {
      case "newLatLng":
        return MFCameraUpdateFactory.newCoordinate(toCoordinate(data.get(1)));
      default:
        throw new IllegalArgumentException("Cannot interpret " + o + " as CameraUpdate");
    }
  }

  static Object cameraPositionToJson(MFCameraPosition position) {
    if (position == null) {
      return null;
    }
    final Map<String, Object> data = new HashMap<>();
    data.put("bearing", position.getBearing());
    data.put("target", latLngToJson(position.getTarget()));
    data.put("tilt", position.getTilt());
    data.put("zoom", position.getZoom());
    return data;
  }
}
