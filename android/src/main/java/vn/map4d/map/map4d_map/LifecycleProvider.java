package vn.map4d.map.map4d_map;

import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;

interface LifecycleProvider {
  @Nullable
  Lifecycle getLifecycle();
}
