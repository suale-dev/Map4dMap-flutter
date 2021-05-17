import 'camera.dart';
import 'location.dart';
import 'annotations/marker.dart';

/// Callback that receives updates to the camera position.
/// This is used in [MFMapView.onCameraMove].
typedef void CameraPositionCallback(MFCameraPosition position);
/// This is used in [MFMapView.onInfoWindowTap].
typedef void InfoWindowCallback(MFMarkerId markerId);
typedef void CoordinateCallback(LatLng coordinate);
typedef void ModeChangeCallback(bool is3DMode);
