//
//  FMFPolyline.m
//  map4d_map
//
//  Created by Huy Dang on 12/05/2021.
//

#import "FMFPolyline.h"
#import "Map4dFLTConvert.h"

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

- (void)setMap:(MFMapView*)mapView {
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

#pragma mark - Interpret Polyline Options
- (void)interpretPolylineOptions:(NSDictionary*)data {
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

  NSNumber* strokeColor = data[@"color"];
  if (strokeColor != nil) {
    [self setColor:[Map4dFLTConvert toColor:strokeColor]];
  }

  NSNumber* strokeWidth = data[@"width"];
  if (strokeWidth != nil) {
    [self setStrokeWidth:[Map4dFLTConvert toInt:strokeWidth]];
  }

  NSNumber* style = data[@"style"];
  if (style != nil) {
    [self setStyle:[Map4dFLTConvert toPolylineStyle:style]];
  }
}

@end

