import 'camera.dart';
import 'location.dart';

/// Callback that receives updates to the camera position.
/// This is used in [MFMapView.onCameraMove].
typedef void CameraPositionCallback(MFCameraPosition position);
typedef void CoordinateCallback(LatLng coordinate);
typedef void ModeChangeCallback(bool is3DMode);
