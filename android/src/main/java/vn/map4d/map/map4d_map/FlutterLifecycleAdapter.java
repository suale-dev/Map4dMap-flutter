package vn.map4d.map.map4d_map;

import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;

/** Provides a static method for extracting lifecycle objects from Flutter plugin bindings. */
class FlutterLifecycleAdapter {

  /**
   * Returns the lifecycle object for the activity a plugin is bound to.
   *
   * <p>Returns null if the Flutter engine version does not include the lifecycle extraction code.
   * (this probably means the Flutter engine version is too old).
   */
  @NonNull
  public static Lifecycle getActivityLifecycle(
    @NonNull ActivityPluginBinding activityPluginBinding) {
    HiddenLifecycleReference reference =
      (HiddenLifecycleReference) activityPluginBinding.getLifecycle();
    return reference.getLifecycle();
  }
}
