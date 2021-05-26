//
//  FMFPolygon.m
//  map4d_map
//
//  Created by iMacbook on 5/14/21.
//

#import "FMFPolygon.h"
#import "Map4dFLTConvert.h"

@implementation FMFPolygon {
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

- (void)setMap:(MFMapView*)mapView {
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

#pragma mark - Interpret Polygon Options

- (void)interpretPolygonOptions:(NSDictionary*)data {
  NSNumber* consumeTapEvents = data[@"consumeTapEvents"];
  if (consumeTapEvents != nil) {
    [self setConsumeTapEvents:[Map4dFLTConvert toBool:consumeTapEvents]];
  }
  
  NSNumber* visible = data[@"visible"];
  if (visible != nil) {
    [self setVisible:[Map4dFLTConvert toBool:visible]];
  }

  NSNumber* zIndex = data[@"zIndex"];
  if (zIndex != nil) {
    [self setZIndex:[Map4dFLTConvert toInt:zIndex]];
  }

  NSArray* points = data[@"points"];
  if (points) {
    [self setPoints:[Map4dFLTConvert toPoints:points]];
  }
  
  NSArray* holes = data[@"holes"];
  if (holes) {
    [self setHoles:[Map4dFLTConvert toHoles:holes]];
  }

  NSNumber* strokeColor = data[@"strokeColor"];
  if (strokeColor != nil) {
    [self setStrokeColor:[Map4dFLTConvert toColor:strokeColor]];
  }
  
  NSNumber* fillColor = data[@"fillColor"];
  if (fillColor != nil) {
    [self setFillColor:[Map4dFLTConvert toColor:fillColor]];
  }

  NSNumber* strokeWidth = data[@"strokeWidth"];
  if (strokeWidth != nil) {
    [self setStrokeWidth:[Map4dFLTConvert toInt:strokeWidth]];
  }
}


@end

