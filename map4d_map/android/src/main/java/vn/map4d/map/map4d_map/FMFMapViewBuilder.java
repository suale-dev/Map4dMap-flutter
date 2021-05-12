package vn.map4d.map.map4d_map;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import vn.map4d.map.camera.MFCameraPosition;

public class FMFMapViewBuilder implements FMFMapViewOptionsSink {

  MFCameraPosition initialCameraPosition;
  private Object initialCircles;

  FMFMapViewController build(
    int id,
    Context context,
    BinaryMessenger binaryMessenger) {
    final FMFMapViewController controller = new FMFMapViewController(context, id, binaryMessenger, initialCameraPosition);
    controller.init();
    controller.setInitialCircles(initialCircles);
    return controller;
  }

  void setInitialCameraPosition(MFCameraPosition position) {
    this.initialCameraPosition = position;
  }

  @Override
  public void setInitialCircles(Object initialCircles) {
    this.initialCircles = initialCircles;
  }
}
