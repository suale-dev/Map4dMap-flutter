//
//  FMFPOI.m
//  map4d_map
//
//  Created by Huy Dang on 13/05/2021.
//

#import "FMFPOI.h"
#import "Map4dFLTConvert.h"

@implementation FMFPOI {
  MFPOI* _poi;
}

- (instancetype)initPOIWithId:(NSString *)poiId {
  self = [super init];
  if (self) {
    _poi = [[MFPOI alloc] init];
    _poi.userData = @[ poiId ];
    _poiId = poiId;
  }
  return self;
}

- (void)removePOI {
  _poi.map = nil;
}

- (void)setMap:(MFMapView*)mapView {
  _poi.map = mapView;
}

/*
 FMFPOIOptionsSink
 */
- (void)setPosition:(CLLocationCoordinate2D)position {
  _poi.position = position;
}

- (void)setTitle:(NSString*)title {
  _poi.title = title;
}

- (void)setTitleColor:(UIColor*)color {
  _poi.titleColor = color;
}

- (void)setSubtitle:(NSString*)subtitle {
  _poi.subtitle = subtitle;
}

- (void)setIcon:(UIImage*)icon {
  _poi.icon = icon;
}

- (void)setType:(NSString*)type {
  _poi.type = type;
}

- (void)setZIndex:(int)zIndex {
  _poi.zIndex = zIndex;
}

- (void)setVisible:(BOOL)visible {
  _poi.isHidden = !visible;
}

- (void)setConsumeTapEvents:(BOOL)consume {
  _poi.userInteractionEnabled = consume;
}

#pragma mark - Interpret POI Options
- (void)interpretPOIOptions:(NSDictionary*)data registrar:(NSObject<FlutterPluginRegistrar>*) registrar {
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
  
  NSArray* position = data[@"position"];
  if (position) {
    [self setPosition:[Map4dFLTConvert toLocation:position]];
  }
  
  NSString* title = data[@"title"];
  if (title != nil) {
    [self setTitle:title];
  }
  
  NSNumber* titleColor = data[@"titleColor"];
  if (titleColor != nil) {
    [self setTitleColor:[Map4dFLTConvert toColor:titleColor]];
  }
  
  NSString* subtitle = data[@"subtitle"];
  if (subtitle != nil) {
    [self setSubtitle:subtitle];
  }
  
  NSString* type = data[@"type"];
  if (type != nil) {
    [self setType:type];
  }
  
//  NSArray* icon = data[@"icon"];
//  if (icon) {
//    UIImage* image = ExtractIcon(registrar, icon);
//    [sink setIcon:image];
//  }
}

@end


