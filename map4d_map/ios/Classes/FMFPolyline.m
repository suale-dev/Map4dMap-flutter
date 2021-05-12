//
//  FMFPolyline.m
//  map4d_map
//
//  Created by Huy Dang on 12/05/2021.
//

#import "FMFPolyline.h"
#import "FMFInterpretation.h"

@implementation FMFPolyline {
  MFPolyline* _polyline;
}

- (instancetype)initPolylineWithId:(NSString *)polylineId {
  self = [super init];
  if (self) {
    _polyline = [[MFPolyline alloc] init];
    _polyline.userData = @[ polylineId ];
    _polylineId = polylineId;
  }
  return self;
}

- (void)removePolyline {
  _polyline.map = nil;
}

- (void)addToMap:(MFMapView*)mapView {
  _polyline.map = mapView;
}

// FMFPolylineOptionsSink
- (void)setConsumeTapEvents:(BOOL)consume {
  _polyline.userInteractionEnabled = consume;
}

- (void)setVisible:(BOOL)visible {
  _polyline.isHidden = !visible;
}

- (void)setColor:(UIColor*)color {
  _polyline.color = color;
}

- (void)setStrokeWidth:(CGFloat)width {
  _polyline.width = width;
}

- (void)setPoints:(NSArray<CLLocation*>*)points {
  MFMutablePath* path = [[MFMutablePath alloc] init];
  for (CLLocation* location in points) {
    [path addCoordinate:location.coordinate];
  }
  _polyline.path = path;
}

- (void)setZIndex:(int)zIndex {
  _polyline.zIndex = zIndex;
}

- (void)setStyle:(MFPolylineStyle)style {
  _polyline.style = style;
}

@end


#pragma mark - FMFPolylinesController

@implementation FMFPolylinesController {
  NSMutableDictionary<NSString*, FMFPolyline*>* _polylines;
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
    _polylines = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addPolylines:(NSArray*)polylinesToAdd {
  for (NSDictionary* polyline in polylinesToAdd) {
//    GMSMutablePath* path = [FLTPolylinesController getPath:polyline];
    NSString* polylineId = polyline[@"polylineId"];
    FMFPolyline* fPolyline = [[FMFPolyline alloc] initPolylineWithId:polylineId];
    [FMFInterpretation interpretPolylineOptions:polyline sink:fPolyline];
    [fPolyline addToMap:_mapView];
    _polylines[polylineId] = fPolyline;
  }
}

- (void)changePolylines:(NSArray*)polylinesToChange {
  for (NSDictionary* polyline in polylinesToChange) {
    NSString* polylineId = polyline[@"polylineId"];
    FMFPolyline* fPolyline = _polylines[polylineId];
    if (fPolyline != nil) {
      [FMFInterpretation interpretPolylineOptions:polyline sink:fPolyline];
    }
  }
}

- (void)removePolylineIds:(NSArray*)polylineIdsToRemove {
  for (NSString* polylineId in polylineIdsToRemove) {
    if (!polylineId) {
      continue;
    }
    FMFPolyline* fPolyline = _polylines[polylineId];
    if (fPolyline != nil) {
      [fPolyline removePolyline];
      [_polylines removeObjectForKey:polylineId];
    }
  }
}

- (void)onPolylineTap:(NSString*)polylineId {
  if (!polylineId) return;
  FMFPolyline* fPolyline = _polylines[polylineId];
  if (fPolyline != nil) {
    [_channel invokeMethod:@"polyline#onTap" arguments:@{@"polylineId" : polylineId}];
  }
}

@end
