package vn.map4d.map.map4d_map;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import vn.map4d.map.camera.MFCameraPosition;

public class FMFMapViewFactory extends PlatformViewFactory {

  private final BinaryMessenger binaryMessenger;

  public FMFMapViewFactory(BinaryMessenger binaryMessenger) {
    super(StandardMessageCodec.INSTANCE);
    this.binaryMessenger = binaryMessenger;
  }

  @Override
  public PlatformView create(Context context, int viewId, Object args) {
    final Map<String, Object> creationParams = (Map<String, Object>) args;
    final FMFMapViewBuilder builder = new FMFMapViewBuilder();

    if (creationParams.containsKey("initialCameraPosition")) {
      MFCameraPosition initialCameraPosition = Convert.toCameraPosition(creationParams.get("initialCameraPosition"));
      builder.setInitialCameraPosition(initialCameraPosition);
    }
    if (creationParams.containsKey("circlesToAdd")) {
      builder.setInitialCircles(creationParams.get("circlesToAdd"));
    }

    return builder.build(viewId, context, binaryMessenger);
  }
}
