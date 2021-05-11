//
//  FMFCircle.m
//  map4d_map
//
//  Created by Huy Dang on 10/05/2021.
//

#import "FMFCircle.h"
#import "FMFInterpretation.h"

@implementation FMFCircle {
  MFCircle* _circle;
}

- (instancetype)initCircleWithId:(NSString*)circleId {
  self = [super init];
  if (self) {
    _circle = [[MFCircle alloc] init];
    _circle.userData = @[ circleId ];
    _circleId = circleId;
  }
  return self;
}

- (void)removeCircle {
  _circle.map = nil;
}

- (void)addToMap:(MFMapView*)mapView {
  _circle.map = mapView;
}

/*
 FMFCircleOptionsSink
 */
- (void)setConsumeTapEvents:(BOOL)consumes {
  _circle.userInteractionEnabled = consumes;
}

- (void)setVisible:(BOOL)visible {
  _circle.isHidden = !visible;
}

- (void)setZIndex:(int)zIndex {
  _circle.zIndex = zIndex;
}

- (void)setCenter:(CLLocationCoordinate2D)center {
  _circle.position = center;
}

- (void)setRadius:(CLLocationDistance)radius {
  _circle.radius = radius;
}

- (void)setStrokeColor:(UIColor*)color {
  _circle.strokeColor = color;
}

- (void)setStrokeWidth:(CGFloat)width {
  _circle.strokeWidth = width;
}

- (void)setFillColor:(UIColor*)color {
  _circle.fillColor = color;
}

@end

#pragma mark - FMFCirclesController

@implementation FMFCirclesController {
  NSMutableDictionary<NSString*, FMFCircle*>* _circles;
  MFMapView* _mapView;
  FlutterMethodChannel* _channel;
  NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  self = [super init];
  if (self) {
    _channel = methodChannel;
    _mapView = mapView;
    _circles = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addCircles:(NSArray*)circlesToAdd {
  for (NSDictionary* circle in circlesToAdd) {
    NSString* circleId = circle[@"circleId"];
    FMFCircle *fCircle = [[FMFCircle alloc] initCircleWithId:circleId];
    [FMFInterpretation interpretCircleOptions:circle sink:fCircle];
    [fCircle addToMap:_mapView];
    _circles[circleId] = fCircle;
  }
}

- (void)changeCircles:(NSArray*)circlesToChange {
  for (NSDictionary* circle in circlesToChange) {
    NSString* circleId = circle[@"circleId"];
    FMFCircle* fCircle = _circles[circleId];
    if (fCircle != nil) {
      [FMFInterpretation interpretCircleOptions:circle sink:fCircle];
    }
  }
}

- (void)removeCircleIds:(NSArray*)circleIdsToRemove {
  for (NSString* circleId in circleIdsToRemove) {
    if (!circleId) {
      continue;
    }
    FMFCircle* fCircle = _circles[circleId];
    if (fCircle != nil) {
      [fCircle removeCircle];
      [_circles removeObjectForKey:circleId];
    }
  }
}

- (void)onCircleTap:(NSString*)circleId {
  if (!circleId) return;
  FMFCircle* fCircle = _circles[circleId];
  if (fCircle != nil) {
    [_channel invokeMethod:@"circle#onTap" arguments:@{@"circleId" : circleId}];
  }
}

@end
