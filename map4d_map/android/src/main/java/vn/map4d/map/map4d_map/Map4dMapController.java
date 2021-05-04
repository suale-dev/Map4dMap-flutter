package vn.map4d.map.map4d_map;

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;
import vn.map4d.map.core.MFMapView;
import vn.map4d.map.core.Map4D;

public class Map4dMapController implements PlatformView {
    Map4D map4D;

    MFMapView mapView;

    Map4dMapController(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        this.mapView = new MFMapView(context, null);
    }

    @Override
    public View getView() {
        return mapView;
    }

    @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {

    }

    @Override
    public void onFlutterViewDetached() {

    }

    @Override
    public void dispose() {

    }
}
