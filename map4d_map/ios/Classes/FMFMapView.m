//
//  FMFMapView.m
//  map4d_map
//
//  Created by Sua Le on 05/05/2021.
//

#import "FMFMapView.h"
#import "FMFConvert.h"
#import "FMFMethod.h"
#import <Map4dMap/Map4dMap.h>
#import <UIKit/UIKit.h>

// MARK: - FMFMapViewFactory

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


// MARK: - FMFMapView

@implementation FMFMapView {
  MFMapView* _mapView;
  int64_t _viewId;
  FlutterMethodChannel* _channel;
  NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  if (self = [super init]) {
    _viewId = viewId;
    _mapView = [[MFMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    NSString* channelName = [NSString stringWithFormat:@"plugin:map4d-map-view-type_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName
                                           binaryMessenger:registrar.messenger];
    __weak __typeof__(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall * call, FlutterResult result) {
      if (weakSelf) {
        [weakSelf onMethodCall:call result:result];
      }
    }];
    _registrar = registrar;
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
    default:
      NSLog(@"Unknow call method: %@", call.method);
      result(nil);
      break;
  }
}

// MARK: - MFMapViewDelegate
//- (BOOL)mapview: (MFMapView*)  mapView didTapMarker: (MFMarker*) marker {
//- (void)mapview: (MFMapView*)  mapView didBeginDraggingMarker: (MFMarker*) marker;
//- (void)mapview: (MFMapView*)  mapView didEndDraggingMarker: (MFMarker*) marker;
//- (void)mapview: (MFMapView*)  mapView didDragMarker: (MFMarker*) marker;
//- (void)mapview: (MFMapView*)  mapView didTapInfoWindowOfMarker: (MFMarker*) marker;
//- (void)mapview: (MFMapView*)  mapView didTapPolyline: (MFPolyline*) polyline;
//- (void)mapview: (MFMapView*)  mapView didTapPolygon: (MFPolygon*) polygon;
//- (void)mapview: (MFMapView*)  mapView didTapCircle: (MFCircle*) circle;
- (void)mapView: (MFMapView*)  mapView willMove: (BOOL) gesture {
  [_channel invokeMethod:@"camera#onMoveStarted" arguments:@{@"isGesture" : @(gesture)}];
}

- (void)mapView: (MFMapView*)  mapView movingCameraPosition: (MFCameraPosition*) position {
  NSDictionary* response = [FMFConvert positionToJson:position];
  [_channel invokeMethod:@"camera#onMove" arguments:@{@"position" : response}];
}

//- (void)mapView: (MFMapView*)  mapView didChangeCameraPosition:(MFCameraPosition*) position {}

- (void)mapView: (MFMapView*)  mapView idleAtCameraPosition: (MFCameraPosition *) position {
  [_channel invokeMethod:@"camera#onIdle" arguments:@{}];
}

//- (void)mapView: (MFMapView*)  mapView didTapAtCoordinate: (CLLocationCoordinate2D) coordinate;
//- (void)mapView: (MFMapView*)  mapView onModeChange: (bool) is3DMode;
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
