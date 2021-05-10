package vn.map4d.map.map4d_map;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;


import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import vn.map4d.map.annotations.MFCircle;
import vn.map4d.map.annotations.MFMarker;
import vn.map4d.map.annotations.MFPolygon;
import vn.map4d.map.annotations.MFPolyline;
import vn.map4d.map.camera.MFCameraUpdate;
import vn.map4d.map.core.MFMapView;
import vn.map4d.map.core.Map4D;
import vn.map4d.map.core.OnMapReadyCallback;
import vn.map4d.types.MFLocationCoordinate;

public class FMFMapViewController implements
  PlatformView,
  OnMapReadyCallback,
  MethodChannel.MethodCallHandler,
  FMFMapViewListener {
  private static final String TAG = "FMFMapViewController";
  private final int id;
  private final MethodChannel methodChannel;
  private Map4D map4D;
  @Nullable
  private MFMapView mapView;
  private final Context context;
  private boolean myLocationEnabled = true;
  private boolean myLocationButtonEnabled = true;
  private boolean disposed = false;
  private final float density;

  FMFMapViewController(@NonNull Context context, int id, BinaryMessenger binaryMessenger, @Nullable Map<String, Object> creationParams) {
    this.mapView = new MFMapView(context, null);
    this.id = id;
    this.mapView.getMapAsync(this);
    this.context = context;
    this.density = context.getResources().getDisplayMetrics().density;
    this.methodChannel = new MethodChannel(binaryMessenger, "plugin:map4d-map-view-type_" + id);
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public View getView() {
    return mapView;
  }

  @Override
  public void dispose() {
    if (disposed) {
      return;
    }
    disposed = true;
    methodChannel.setMethodCallHandler(null);
    setMap4dListener(null);
    destroyMapViewIfNecessary();
  }

  @Override
  public void onMapReady(Map4D map4D) {
    this.map4D = map4D;
    setMap4dListener(this);
    updateMyLocationSettings();
  }

  private void setMap4dListener(@Nullable FMFMapViewListener listener) {
    map4D.setOnCameraMoveStartedListener(listener);
    map4D.setOnCameraMoveListener(listener);
    map4D.setOnCameraIdleListener(listener);
    map4D.setOnMarkerClickListener(listener);
    map4D.setOnMarkerDragListener(listener);
    map4D.setOnPolygonClickListener(listener);
    map4D.setOnPolylineClickListener(listener);
    map4D.setOnCircleClickListener(listener);
    map4D.setOnMapClickListener(listener);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "camera#move": {
        final MFCameraUpdate cameraUpdate =
          Convert.toCameraUpdate(call.argument("cameraUpdate"), density);
        moveCamera(cameraUpdate);
        result.success(null);
        break;
      }
      case "camera#animate": {
        final MFCameraUpdate cameraUpdate =
          Convert.toCameraUpdate(call.argument("cameraUpdate"), density);
        animateCamera(cameraUpdate);
        result.success(null);
        break;
      }
      case "map#getZoomLevel": {
        result.success(map4D.getCameraPosition().getZoom());
        break;
      }
    }
  }

  private void moveCamera(MFCameraUpdate cameraUpdate) {
    map4D.moveCamera(cameraUpdate);
  }

  private void animateCamera(MFCameraUpdate cameraUpdate) {
    map4D.animateCamera(cameraUpdate);
  }

  private void destroyMapViewIfNecessary() {
    if (mapView == null) {
      return;
    }
    mapView.onDestroy();
    mapView = null;
  }

  private void updateMyLocationSettings() {
    if (hasLocationPermission()) {
      // The plugin doesn't add the location permission by default so that apps that don't need
      // the feature won't require the permission.
      // Gradle is doing a static check for missing permission and in some configurations will
      // fail the build if the permission is missing. The following disables the Gradle lint.
      // noinspection ResourceType
      map4D.setMyLocationEnabled(myLocationEnabled);
      map4D.getUiSettings().setMyLocationButtonEnabled(myLocationButtonEnabled);
    } else {
      Log.e(TAG, "Cannot enable MyLocation layer as location permissions are not granted");
    }
  }

  private boolean hasLocationPermission() {
    return checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
      == PackageManager.PERMISSION_GRANTED
      || checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
      == PackageManager.PERMISSION_GRANTED;
  }

  private int checkSelfPermission(String permission) {
    if (permission == null) {
      throw new IllegalArgumentException("permission is null");
    }
    return context.checkPermission(
      permission, android.os.Process.myPid(), android.os.Process.myUid());
  }

  @Override
  public void onCameraIdle() {
    methodChannel.invokeMethod("camera#onIdle", Collections.singletonMap("map", id));
  }

  @Override
  public void onCameraMove() {
    final Map<String, Object> arguments = new HashMap<>(2);
    arguments.put("position", Convert.cameraPositionToJson(map4D.getCameraPosition()));
    methodChannel.invokeMethod("camera#onMove", arguments);
  }

  @Override
  public void onCameraMoveStarted(int reason) {
    final Map<String, Object> arguments = new HashMap<>(2);
    boolean isGesture = reason == Map4D.OnCameraMoveStartedListener.REASON_GESTURE;
    arguments.put("isGesture", isGesture);
    methodChannel.invokeMethod("camera#onMoveStarted", arguments);
  }

  @Override
  public void onCircleClick(MFCircle mfCircle) {

  }

  @Override
  public void onInfoWindowClick(@NonNull MFMarker mfMarker) {

  }

  @Override
  public void onMapClick(MFLocationCoordinate mfLocationCoordinate) {
    final Map<String, Object> arguments = new HashMap<>(2);
    arguments.put("position", Convert.latLngToJson(mfLocationCoordinate));
    methodChannel.invokeMethod("map#onTap", arguments);
  }

  @Override
  public boolean onMarkerClick(MFMarker mfMarker) {
    return false;
  }

  @Override
  public void onMarkerDrag(MFMarker mfMarker) {

  }

  @Override
  public void onMarkerDragEnd(MFMarker mfMarker) {

  }

  @Override
  public void onMarkerDragStart(MFMarker mfMarker) {

  }

  @Override
  public void onPolygonClick(MFPolygon mfPolygon) {

  }

  @Override
  public void onPolylineClick(MFPolyline mfPolyline) {

  }
}
