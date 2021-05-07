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

@end


