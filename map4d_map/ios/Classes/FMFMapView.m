//
//  FMFMapView.m
//  map4d_map
//
//  Created by Sua Le on 05/05/2021.
//

#import "FMFMapView.h"
#import "FMFConvert.h"
#import "FMFInterpretation.h"
#import "FMFMethod.h"
#import "FMFCircle.h"
#import "FMFMarker.h"
#import <Map4dMap/Map4dMap.h>
#import <UIKit/UIKit.h>

#pragma mark - FMFMapViewFactory

@implementation FMFMapViewFactory {
  NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  self = [super init];
  if (self) {
    _registrar = registrar;
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[FMFMapView alloc] initWithFrame:frame
                            viewIdentifier:viewId
                                 arguments:args
                                 registrar:_registrar];
}
@end

#pragma mark - Event tracking configurations

@interface FMFEventTracking : NSObject
@property (nonatomic) BOOL cameraPosition;
@end
@implementation FMFEventTracking
- (instancetype)init {
  self = [super init];
  if (self) {
    _cameraPosition = NO;
  }
  return self;
}
@end


#pragma mark - FMFMapView

@implementation FMFMapView {
  MFMapView* _mapView;
  int64_t _viewId;
  FlutterMethodChannel* _channel;
  NSObject<FlutterPluginRegistrar>* _registrar;
  FMFEventTracking* _track;
  
  FMFPOIsController* _poisController;
  FMFBuildingsController* _buildingsController;
  FMFPolylinesController* _polylinesController;
  FMFCirclesController* _circlesController;
  FMFMarkersController* _markersController;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  if (self = [super init]) {
    _viewId = viewId;
    _registrar = registrar;
    _track = [[FMFEventTracking alloc] init];
    _mapView = [[MFMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    
    // initial map options
    [FMFInterpretation interpretMapOptions:args[@"options"] sink:self];
    
    // initial camera position
    MFCameraPosition* camera = [FMFConvert toCameraPosition:args[@"initialCameraPosition"]];
    if (camera != nil) {
      _mapView.camera = camera;
    }
    
    // flutter channel
    NSString* channelName = [NSString stringWithFormat:@"plugin:map4d-map-view-type_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName
                                           binaryMessenger:registrar.messenger];
    __weak __typeof__(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall * call, FlutterResult result) {
      if (weakSelf) {
        [weakSelf onMethodCall:call result:result];
      }
    }];
    
    // annotations controller
    _poisController = [[FMFPOIsController alloc] init:_channel
                                              mapView:_mapView
                                            registrar:registrar];
    
    _buildingsController = [[FMFBuildingsController alloc] init:_channel
                                                        mapView:_mapView
                                                      registrar:registrar];

    _polylinesController = [[FMFPolylinesController alloc] init:_channel
                                                        mapView:_mapView
                                                      registrar:registrar];

    _circlesController = [[FMFCirclesController alloc] init:_channel
                                                    mapView:_mapView
                                                  registrar:registrar];
    
    _markersController = [[FMFMarkersController alloc] init: _channel
                                                    mapView:_mapView
                                                  registrar:registrar];
    // initial annotations
    id poisToAdd = args[@"poisToAdd"];
    if ([poisToAdd isKindOfClass:[NSArray class]]) {
      [_poisController addPOIs:poisToAdd];
    }
    
    id buildingsToAdd = args[@"buildingsToAdd"];
    if ([buildingsToAdd isKindOfClass:[NSArray class]]) {
      [_buildingsController addBuildings:buildingsToAdd];
    }
    
    id polylinesToAdd = args[@"polylinesToAdd"];
    if ([polylinesToAdd isKindOfClass:[NSArray class]]) {
      [_polylinesController addPolylines:polylinesToAdd];
    }

    id circlesToAdd = args[@"circlesToAdd"];
    if ([circlesToAdd isKindOfClass:[NSArray class]]) {
      [_circlesController addCircles:circlesToAdd];
    }
    
    id markersToAdd = args[@"markersToAdd"];
    if ([markersToAdd isKindOfClass:[NSArray class]]) {
      [_markersController addMarkers:markersToAdd];
    }
  }
  return self;
}

- (UIView*)view {
  return _mapView;
}

// Method call handler
- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  FMFMethodID methodID = [FMFMethod getMethodIdByName:call.method];
  switch (methodID) {
    case FMFMethodMapUpdate:
      [FMFInterpretation interpretMapOptions:call.arguments[@"options"] sink:self];
      result(nil);
      break;
    case FMFMethodGetZoomLevel:
      result(@(_mapView.camera.zoom));
      break;
    case FMFMethodCameraForBounds: {
      MFCoordinateBounds* bounds = [FMFConvert toCoordinateBounds:call.arguments[@"bounds"]];
      double padding = [FMFConvert toDouble:call.arguments[@"padding"]];
      UIEdgeInsets insets = UIEdgeInsetsMake(padding, padding, padding, padding);
      MFCameraPosition* camera = [_mapView cameraForBounds:bounds insets:insets];
      result([FMFConvert positionToJson:camera]);
      break;
    }
    case FMFMethodFitBounds: {
      MFCoordinateBounds* bounds = [FMFConvert toCoordinateBounds:call.arguments[@"bounds"]];
      double padding = [FMFConvert toDouble:call.arguments[@"padding"]];
      UIEdgeInsets insets = UIEdgeInsetsMake(padding, padding, padding, padding);
      [_mapView moveCamera:[MFCameraUpdate fitBounds:bounds withEdgeInsets:insets]];
      result(nil);
      break;
    }
    case FMFMethodMoveCamera: {
      MFCameraUpdate* cameraUpdate = [FMFConvert toCameraUpdate:call.arguments[@"cameraUpdate"]];
      [_mapView moveCamera:cameraUpdate];
      result(nil);
      break;
    }
    case FMFMethodAnimateCamera: {
      MFCameraUpdate* cameraUpdate = [FMFConvert toCameraUpdate:call.arguments[@"cameraUpdate"]];
      [_mapView animateCamera:cameraUpdate];
      result(nil);
      break;
    }
    case FMFMethodPOIUpdate: {
      id poisToAdd = call.arguments[@"poisToAdd"];
      if ([poisToAdd isKindOfClass:[NSArray class]]) {
        [_poisController addPOIs:poisToAdd];
      }
      id poisToChange = call.arguments[@"poisToChange"];
      if ([poisToChange isKindOfClass:[NSArray class]]) {
        [_poisController changePOIs:poisToChange];
      }
      id poiIdsToRemove = call.arguments[@"poiIdsToRemove"];
      if ([poiIdsToRemove isKindOfClass:[NSArray class]]) {
        [_poisController removePOIIds:poiIdsToRemove];
      }
      result(nil);
      break;
    }
    case FMFMethodBuildingUpdate: {
      id buildingsToAdd = call.arguments[@"buildingsToAdd"];
      if ([buildingsToAdd isKindOfClass:[NSArray class]]) {
        [_buildingsController addBuildings:buildingsToAdd];
      }
      id buildingsToChange = call.arguments[@"buildingsToChange"];
      if ([buildingsToChange isKindOfClass:[NSArray class]]) {
        [_buildingsController changeBuildings:buildingsToChange];
      }
      id buildingIdsToRemove = call.arguments[@"buildingIdsToRemove"];
      if ([buildingIdsToRemove isKindOfClass:[NSArray class]]) {
        [_buildingsController removeBuildingIds:buildingIdsToRemove];
      }
      result(nil);
      break;
    }
    case FMFMethodPolylineUpdate: {
      id polylinesToAdd = call.arguments[@"polylinesToAdd"];
      if ([polylinesToAdd isKindOfClass:[NSArray class]]) {
        [_polylinesController addPolylines:polylinesToAdd];
      }
      id polylinesToChange = call.arguments[@"polylinesToChange"];
      if ([polylinesToChange isKindOfClass:[NSArray class]]) {
        [_polylinesController changePolylines:polylinesToChange];
      }
      id polylineIdsToRemove = call.arguments[@"polylineIdsToRemove"];
      if ([polylineIdsToRemove isKindOfClass:[NSArray class]]) {
        [_polylinesController removePolylineIds:polylineIdsToRemove];
      }
      result(nil);
      break;
    }
    case FMFMethodCirclesUpdate: {
      id circlesToAdd = call.arguments[@"circlesToAdd"];
      if ([circlesToAdd isKindOfClass:[NSArray class]]) {
        [_circlesController addCircles:circlesToAdd];
      }
      id circlesToChange = call.arguments[@"circlesToChange"];
      if ([circlesToChange isKindOfClass:[NSArray class]]) {
        [_circlesController changeCircles:circlesToChange];
      }
      id circleIdsToRemove = call.arguments[@"circleIdsToRemove"];
      if ([circleIdsToRemove isKindOfClass:[NSArray class]]) {
        [_circlesController removeCircleIds:circleIdsToRemove];
      }
      break;
    }
    
    case FMFMethodMarkersUpdate: {
      id markersToAdd = call.arguments[@"markersToAdd"];
      if ([markersToAdd isKindOfClass: [NSArray class]]) {
        [_markersController addMarkers: markersToAdd];
      }
      id markerToChange = call.arguments[@"markersToChange"];
      if ([markerToChange isKindOfClass:[NSArray class]]) {
        [_markersController changeMarkers:markerToChange];
      }
      id markerIdsToRemove = call.arguments[@"markerIdsToRemove"];
      if ([markerIdsToRemove isKindOfClass:[NSArray class]]) {
        [_markersController removeMarkerIds:markerIdsToRemove];
      }
      break;
    }
      
    case FMFMethodEnable3DMode: {
      BOOL isEnable = [FMFConvert toBool:call.arguments[@"enable3DMode"]];
      [_mapView enable3DMode: isEnable];
      result(nil);
      break;
    }
    default:
      NSLog(@"Unknow call method: %@", call.method);
      result(nil);
      break;
  }
}

#pragma mark - FMFMapViewOptionsSink methods

- (void)setCamera:(MFCameraPosition*)camera {
  _mapView.camera = camera;
}

- (void)setCameraTargetBounds:(MFCoordinateBounds*)bounds {
  //TODO
  //  _mapView.cameraTargetBounds = bounds;
}

- (void)setBuildingsEnabled:(BOOL)enabled {
  [_mapView setBuildingsEnabled:enabled];
}

- (void)setPOIsEnabled:(BOOL)enabled {
  [_mapView setPOIsEnabled:enabled];
}

- (void)setMinZoom:(float)minZoom maxZoom:(float)maxZoom {
  [_mapView setMinZoom:minZoom maxZoom:maxZoom];
}

- (void)setRotateGesturesEnabled:(BOOL)enabled {
  _mapView.settings.rotateGestures = enabled;
}

- (void)setScrollGesturesEnabled:(BOOL)enabled {
  _mapView.settings.scrollGestures = enabled;
}

- (void)setTiltGesturesEnabled:(BOOL)enabled {
  _mapView.settings.tiltGestures = enabled;
}

- (void)setZoomGesturesEnabled:(BOOL)enabled {
  _mapView.settings.zoomGestures = enabled;
}

- (void)setMyLocationEnabled:(BOOL)enabled {
  [_mapView setMyLocationEnabled:enabled];
}

- (void)setMyLocationButtonEnabled:(BOOL)enabled {
  _mapView.settings.myLocationButton = enabled;
}

- (void)set3DModeEnabled:(BOOL)enabled {
  [_mapView enable3DMode:enabled];
}

- (void)setWaterEffectEnabled:(BOOL)enabled {
  [_mapView enableWaterEffect:enabled];
}

- (void)setTrackCameraPosition:(BOOL)enabled {
  _track.cameraPosition = enabled;
}

#pragma mark - MFMapViewDelegate

- (BOOL)mapview: (MFMapView*) mapView didTapMarker: (MFMarker*) marker {
  NSArray* userData = (NSArray*) marker.userData;
  NSString* markerId = userData[0];
  [_markersController onMarkerTap:markerId];
  return false;
}

- (void)mapview: (MFMapView*) mapView didEndDraggingMarker: (MFMarker*) marker {
  NSArray* userData = (NSArray*) marker.userData;
  NSString* markerId = userData[0];
  [_markersController onDragEndMarker: markerId position: marker.position];
}

- (void)mapview: (MFMapView*) mapView didTapInfoWindowOfMarker: (MFMarker*) marker{
  NSArray* userData = (NSArray*) marker.userData;
  NSString* markerId = userData[0];
  [_markersController onInfoWindowTap:markerId];
}

- (void)mapview: (MFMapView*)  mapView didTapPolyline: (MFPolyline*) polyline {
  NSArray* userData = (NSArray*) polyline.userData;
  NSString* polylineId = userData[0];
  [_polylinesController onPolylineTap:polylineId];
}

//- (void)mapview: (MFMapView*)  mapView didTapPolygon: (MFPolygon*) polygon;

- (void)mapview: (MFMapView*)  mapView didTapCircle: (MFCircle*) circle {
  NSArray* userData = (NSArray*) circle.userData;
  NSString* circleId = userData[0];
  [_circlesController onCircleTap:circleId];
}

- (void)mapView: (MFMapView*)  mapView willMove: (BOOL) gesture {
  [_channel invokeMethod:@"camera#onMoveStarted" arguments:@{@"isGesture" : @(gesture)}];
}

- (void)mapView: (MFMapView*)  mapView movingCameraPosition: (MFCameraPosition*) position {
  if (_track.cameraPosition) {
    NSDictionary* response = [FMFConvert positionToJson:position];
    [_channel invokeMethod:@"camera#onMove" arguments:@{@"position" : response}];
  }
}

//- (void)mapView: (MFMapView*)  mapView didChangeCameraPosition:(MFCameraPosition*) position {}

- (void)mapView: (MFMapView*)  mapView idleAtCameraPosition: (MFCameraPosition *) position {
  [_channel invokeMethod:@"camera#onIdle" arguments:@{}];
}

- (void)mapView: (MFMapView*) mapView didTapAtCoordinate: (CLLocationCoordinate2D) coordinate {
  NSArray* response = [FMFConvert locationToJson:coordinate];
  [_channel invokeMethod:@"map#didTapAtCoordinate" arguments:@{@"coordinate": response}];
}

- (void)mapView: (MFMapView*) mapView onModeChange: (bool) is3DMode {
  [_channel invokeMethod:@"map#onModeChange" arguments:@{@"is3DMode": @(is3DMode)}];
}

///* Called after a building annotation has been tapped */
- (void)mapView: (MFMapView*)  mapView didTapBuilding: (MFBuilding*) building {
  NSArray* userData = (NSArray*) building.userData;
  NSString* buildingId = userData[0];
  [_buildingsController onBuildingTap:buildingId];
}

///* Called after a base map building has been tapped */
//- (void)mapView: (MFMapView*)  mapView didTapBuildingWithBuildingID: (NSString*) buildingID name: (NSString*) name location: (CLLocationCoordinate2D) location;

- (void)mapView: (MFMapView*)  mapView didTapPOI: (MFPOI*) poi {
  NSArray* userData = (NSArray*) poi.userData;
  NSString* poiId = userData[0];
  [_poisController onPOITap:poiId];
}

///* Called after a base map POI has been tapped */
//- (void)mapView: (MFMapView*)  mapView didTapPOIWithPlaceID: (NSString*) placeID name: (NSString*) name location: (CLLocationCoordinate2D) location;
//- (void)mapView: (MFMapView*)  mapView didTapMyLocation: (CLLocationCoordinate2D) location;
//
//- (BOOL)shouldChangeMapModeForMapView: (MFMapView*)  mapView;
//- (BOOL)didTapMyLocationButtonForMapView: (MFMapView*) mapView;
//- (UIView *) mapView: (MFMapView *) mapView markerInfoWindow: (MFMarker *) marker;

@end
