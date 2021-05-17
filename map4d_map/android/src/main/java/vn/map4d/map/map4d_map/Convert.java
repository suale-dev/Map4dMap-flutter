package vn.map4d.map.map4d_map;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import vn.map4d.map.camera.MFCameraPosition;
import vn.map4d.map.camera.MFCameraUpdate;
import vn.map4d.map.camera.MFCameraUpdateFactory;
import vn.map4d.map.core.MFCoordinateBounds;
import vn.map4d.map.core.MFPolylineStyle;
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

  private static int toInt(Object o) {
    return ((Number) o).intValue();
  }

  private static float toFloat(Object o) {
    return ((Number) o).floatValue();
  }

  private static Float toFloatWrapper(Object o) {
    return (o == null) ? null : toFloat(o);
  }

  private static boolean toBoolean(Object o) {
    return (Boolean) o;
  }

  private static Map<?, ?> toMap(Object o) {
    return (Map<?, ?>) o;
  }

  private static List<MFLocationCoordinate> toPoints(Object o) {
    final List<?> data = toList(o);
    final List<MFLocationCoordinate> points = new ArrayList<>(data.size());

    for (Object rawPoint : data) {
      final List<?> point = toList(rawPoint);
      points.add(new MFLocationCoordinate(toFloat(point.get(0)), toFloat(point.get(1))));
    }
    return points;
  }

  static MFLocationCoordinate toCoordinate(Object o) {
    final List<?> data = toList(o);
    return new MFLocationCoordinate(toDouble(data.get(0)), toDouble(data.get(1)));
  }

  static MFPolylineStyle toPolylineStyle(Object o) {
    final int style = toInt(o);
    switch (style) {
      case 1:
        return MFPolylineStyle.Dotted;
      default:
        return MFPolylineStyle.Solid;
    }
  }

  static void interpretMap4dOptions(Object o, FMFMapViewOptionsSink sink) {
    final Map<?, ?> data = toMap(o);
    final Object minMaxZoomPreference = data.get("minMaxZoomPreference");
    if (minMaxZoomPreference != null) {
      final List<?> zoomPreferenceData = toList(minMaxZoomPreference);
      sink.setMinMaxZoomPreference( //
        toFloatWrapper(zoomPreferenceData.get(0)), //
        toFloatWrapper(zoomPreferenceData.get(1)));
    }
    final Object rotateGesturesEnabled = data.get("rotateGesturesEnabled");
    if (rotateGesturesEnabled != null) {
      sink.setRotateGesturesEnabled(toBoolean(rotateGesturesEnabled));
    }
    final Object scrollGesturesEnabled = data.get("scrollGesturesEnabled");
    if (scrollGesturesEnabled != null) {
      sink.setScrollGesturesEnabled(toBoolean(scrollGesturesEnabled));
    }
    final Object tiltGesturesEnabled = data.get("tiltGesturesEnabled");
    if (tiltGesturesEnabled != null) {
      sink.setTiltGesturesEnabled(toBoolean(tiltGesturesEnabled));
    }
    final Object zoomGesturesEnabled = data.get("zoomGesturesEnabled");
    if (zoomGesturesEnabled != null) {
      sink.setZoomGesturesEnabled(toBoolean(zoomGesturesEnabled));
    }
    final Object trackCameraPosition = data.get("trackCameraPosition");
    if (trackCameraPosition != null) {
      sink.setTrackCameraPosition(toBoolean(trackCameraPosition));
    }
    final Object myLocationEnabled = data.get("myLocationEnabled");
    if (myLocationEnabled != null) {
      sink.setMyLocationEnabled(toBoolean(myLocationEnabled));
    }
    final Object myLocationButtonEnabled = data.get("myLocationButtonEnabled");
    if (myLocationButtonEnabled != null) {
      sink.setMyLocationButtonEnabled(toBoolean(myLocationButtonEnabled));
    }
    final Object buildingsEnabled = data.get("buildingsEnabled");
    if (buildingsEnabled != null) {
      sink.setBuildingsEnabled(toBoolean(buildingsEnabled));
    }
    final Object poisEnabled = data.get("poisEnabled");
    if (poisEnabled != null) {
      sink.setPOIsEnabled(toBoolean(poisEnabled));
    }
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

  static MFCameraPosition toCameraPosition(Object o) {
    final Map<?, ?> data = toMap(o);
    final MFCameraPosition.Builder builder = new MFCameraPosition.Builder();
    builder.bearing(toDouble(data.get("bearing")));
    builder.target(toCoordinate(data.get("target")));
    builder.tilt(toDouble(data.get("tilt")));
    builder.zoom(toDouble(data.get("zoom")));
    return builder.build();
  }

  static MFCoordinateBounds toCoordinateBounds(Object o) {
    if (o == null) {
      return null;
    }
    final List<?> data = toList(o);
    return new MFCoordinateBounds(toCoordinate(data.get(0)), toCoordinate(data.get(1)));
  }

  static Object polylineIdToJson(String polylineId) {
    if (polylineId == null) {
      return null;
    }
    final Map<String, Object> data = new HashMap<>(1);
    data.put("polylineId", polylineId);
    return data;
  }

  static Object circleIdToJson(String circleId) {
    if (circleId == null) {
      return null;
    }
    final Map<String, Object> data = new HashMap<>(1);
    data.put("circleId", circleId);
    return data;
  }

  static String interpretPolylineOptions(Object o, FMFPolylineOptionsSink sink) {
    final Map<?, ?> data = toMap(o);
    final Object consumeTapEvents = data.get("consumeTapEvents");
    if (consumeTapEvents != null) {
      sink.setConsumeTapEvents(toBoolean(consumeTapEvents));
    }
    final Object color = data.get("color");
    if (color != null) {
      sink.setColor(toInt(color));
    }
    final Object visible = data.get("visible");
    if (visible != null) {
      sink.setVisible(toBoolean(visible));
    }
    final Object style = data.get("style");
    if (style != null) {
      sink.setStyle(toPolylineStyle(style));
    }
    final Object width = data.get("width");
    if (width != null) {
      sink.setWidth(toInt(width));
    }
    final Object zIndex = data.get("zIndex");
    if (zIndex != null) {
      sink.setZIndex(toFloat(zIndex));
    }
    final Object points = data.get("points");
    if (points != null) {
      sink.setPoints(toPoints(points));
    }
    final String polylineId = (String) data.get("polylineId");
    if (polylineId == null) {
      throw new IllegalArgumentException("polylineId was null");
    } else {
      return polylineId;
    }
  }

  static String interpretCircleOptions(Object o, FMFCircleOptionsSink sink) {
    final Map<?, ?> data = toMap(o);
    final Object consumeTapEvents = data.get("consumeTapEvents");
    if (consumeTapEvents != null) {
      sink.setConsumeTapEvents(toBoolean(consumeTapEvents));
    }
    final Object fillColor = data.get("fillColor");
    if (fillColor != null) {
      sink.setFillColor(toInt(fillColor));
    }
    final Object strokeColor = data.get("strokeColor");
    if (strokeColor != null) {
      sink.setStrokeColor(toInt(strokeColor));
    }
    final Object visible = data.get("visible");
    if (visible != null) {
      sink.setVisible(toBoolean(visible));
    }
    final Object strokeWidth = data.get("strokeWidth");
    if (strokeWidth != null) {
      sink.setStrokeWidth(toInt(strokeWidth));
    }
    final Object zIndex = data.get("zIndex");
    if (zIndex != null) {
      sink.setZIndex(toFloat(zIndex));
    }
    final Object center = data.get("center");
    if (center != null) {
      sink.setCenter(toCoordinate(center));
    }
    final Object radius = data.get("radius");
    if (radius != null) {
      sink.setRadius(toDouble(radius));
    }
    final String circleId = String.valueOf(data.get("circleId"));
    if (circleId == null) {
      throw new IllegalArgumentException("circleId was null");
    } else {
      return circleId;
    }
  }
}
