//
//  FMFPolygon.m
//  map4d_map
//
//  Created by iMacbook on 5/14/21.
//

#import "FMFPolygon.h"
#import "FMFInterpretation.h"

@implementation FMFPolygon : NSObject  {
  MFPolygon* _polygon;
}

- (instancetype)initPolygonWithId:(NSString *) polygonId {
  self = [super init];
  if (self) {
    _polygon = [[MFPolygon alloc] init];
    _polygon.userData = @[ polygonId ];
    _polygonId = polygonId;
  }
  return self;
}

- (void)removePolygon {
  _polygon.map = nil;
}

- (void)addToMap:(MFMapView*)mapView {
  _polygon.map = mapView;
}

// FMFPolygonOptionsSink
- (void)setConsumeTapEvents:(BOOL)consume {
  _polygon.userInteractionEnabled = consume;
}

- (void)setVisible:(BOOL)visible {
  _polygon.isHidden = !visible;
}

- (void)setFillColor:(UIColor*)color {
  _polygon.fillColor = color;
}

- (void)setStrokeColor:(UIColor*)color {
  _polygon.strokeColor = color;
}

- (void)setStrokeWidth:(CGFloat)width {
  _polygon.strokeWidth = width;
}
- (void)setPoints:(NSArray<CLLocation*>*)points {
  MFMutablePath* path = [[MFMutablePath alloc] init];
  for (CLLocation* location in points) {
    [path addCoordinate:location.coordinate];
  }
  _polygon.path = path;
}

- (void)setHoles:(NSArray<NSArray<CLLocation*>*>*)rawHoles {
  NSMutableArray<MFMutablePath*>* holes = [[NSMutableArray<MFMutablePath*> alloc] init];
  for (NSArray<CLLocation*>* points in rawHoles) {
    MFMutablePath* path = [[MFMutablePath alloc] init];
    for (CLLocation* location in points) {
      [path addCoordinate:location.coordinate];
    }
    [holes addObject:path];
  }
  _polygon.holes = holes;
}

- (void)setZIndex:(int)zIndex {
  _polygon.zIndex = zIndex;
}

@end


#pragma mark - FMFPolygonsController

@implementation FMFPolygonsController {
  NSMutableDictionary<NSString*, FMFPolygon*>* _polygons;
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
    _polygons = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addPolygons:(NSArray*)polygonsToAdd {
  for (NSDictionary* polygon in polygonsToAdd) {
    NSString* polygonId = polygon[@"polygonId"];
    FMFPolygon* fPolygon = [[FMFPolygon alloc] initPolygonWithId:polygonId];
    [FMFInterpretation interpretPolygonOptions:polygon sink:fPolygon];
    [fPolygon addToMap:_mapView];
    _polygons[polygonId] = fPolygon;
  }
}

- (void)changePolygons:(NSArray*)polygonsToChange {
  for (NSDictionary* polygon in polygonsToChange) {
    NSString* polygonId = polygon[@"polygonId"];
    FMFPolygon* fPolygon = _polygons[polygonId];
    if (fPolygon != nil) {
      [FMFInterpretation interpretPolygonOptions:polygon sink:fPolygon];
    }
  }
}

- (void)removePolygonIds:(NSArray*)polygonIdsToRemove {
  for (NSString* polygonId in polygonIdsToRemove) {
    if (!polygonId) {
      continue;
    }
    FMFPolygon* fPolygon = _polygons[polygonId];
    if (fPolygon != nil) {
      [fPolygon removePolygon];
      [_polygons removeObjectForKey:polygonId];
    }
  }
}

- (void)onPolygonTap:(NSString*)polygonId {
  if (!polygonId) return;
  FMFPolygon* fPolygon = _polygons[polygonId];
  if (fPolygon != nil) {
    [_channel invokeMethod:@"polygon#onTap" arguments:@{@"polygonId" : polygonId}];
  }
}

@end
