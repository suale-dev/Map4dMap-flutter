//
//  FMFMapView.m
//  map4d_map
//
//  Created by Sua Le on 05/05/2021.
//

#import "FMFMapView.h"
#import <Map4dMap/MFMapView.h>
#import <UIKit/UIKit.h>

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

@implementation FMFMapView {
    MFMapView* _mapView;
    int64_t _viewId;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  if (self = [super init]) {
    _viewId = viewId;
      _mapView = [[MFMapView alloc] initWithFrame:frame];
  }
    return self;
}

- (UIView*)view {
  return _mapView;
}

@end
    
    
