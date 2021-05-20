//
//  FMFCircle.m
//  map4d_map
//
//  Created by Huy Dang on 10/05/2021.
//

#import "FMFCircle.h"
#import "Map4dFLTConvert.h"

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

- (void)setMap:(MFMapView*)mapView {
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

#pragma mark - Interpret Circle options
- (void)interpretCircleOptions:(NSDictionary*)data {
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
  
  NSArray* center = data[@"center"];
  if (center) {
    [self setCenter:[Map4dFLTConvert toLocation:center]];
  }
  
  NSNumber* radius = data[@"radius"];
  if (radius != nil) {
    [self setRadius:[Map4dFLTConvert toFloat:radius]];
  }
  
  NSNumber* strokeColor = data[@"strokeColor"];
  if (strokeColor != nil) {
    [self setStrokeColor:[Map4dFLTConvert toColor:strokeColor]];
  }
  
  NSNumber* strokeWidth = data[@"strokeWidth"];
  if (strokeWidth != nil) {
    [self setStrokeWidth:[Map4dFLTConvert toInt:strokeWidth]];
  }
  
  NSNumber* fillColor = data[@"fillColor"];
  if (fillColor != nil) {
    [self setFillColor:[Map4dFLTConvert toColor:fillColor]];
  }
}

@end
