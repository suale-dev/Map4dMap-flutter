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
  
  FMFCirclesController* _circlesController;
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
    _circlesController = [[FMFCirclesController alloc] init:_channel
                                                    mapView:_mapView
                                                  registrar:registrar];
    
    // initial annotations
    id circlesToAdd = args[@"circlesToAdd"];
    if ([circlesToAdd isKindOfClass:[NSArray class]]) {
      [_circlesController addCircles:circlesToAdd];
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
//- (BOOL)mapview: (MFMapView*)  mapView didTapMarker: (MFMarker*) marker {
//- (void)mapview: (MFMapView*)  mapView didBeginDraggingMarker: (MFMarker*) marker;
//- (void)mapview: (MFMapView*)  mapView didEndDraggingMarker: (MFMarker*) marker;
//- (void)mapview: (MFMapView*)  mapView didDragMarker: (MFMarker*) marker;
//- (void)mapview: (MFMapView*)  mapView didTapInfoWindowOfMarker: (MFMarker*) marker;
//- (void)mapview: (MFMapView*)  mapView didTapPolyline: (MFPolyline*) polyline;
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
//- (void)mapView: (MFMapView*)  mapView didTapBuilding: (MFBuilding*) building;
///* Called after a base map building has been tapped */
//- (void)mapView: (MFMapView*)  mapView didTapBuildingWithBuildingID: (NSString*) buildingID name: (NSString*) name location: (CLLocationCoordinate2D) location;
///* Called after a POI annotation has been tapped */
//- (void)mapView: (MFMapView*)  mapView didTapPOI: (MFPOI*) poi;
///* Called after a base map POI has been tapped */
//- (void)mapView: (MFMapView*)  mapView didTapPOIWithPlaceID: (NSString*) placeID name: (NSString*) name location: (CLLocationCoordinate2D) location;
//- (void)mapView: (MFMapView*)  mapView didTapMyLocation: (CLLocationCoordinate2D) location;
//
//- (BOOL)shouldChangeMapModeForMapView: (MFMapView*)  mapView;
//- (BOOL)didTapMyLocationButtonForMapView: (MFMapView*) mapView;
//- (UIView *) mapView: (MFMapView *) mapView markerInfoWindow: (MFMarker *) marker;

@end
