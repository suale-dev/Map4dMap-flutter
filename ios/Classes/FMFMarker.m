//
//  FMFMarker.m
//  map4d_map
//
//  Created by iMacbook on 5/11/21.
//

#import "FMFMarker.h"
#import "Map4dFLTConvert.h"

@implementation FMFMarker {
  MFMarker* _marker;
}

- (instancetype)initMarkerWithId:(NSString*)markerId {
  self = [super init];
  if (self) {
    _marker = [[MFMarker alloc] init];
    _marker.userData = @[ markerId ];
    _markerId = markerId;
  }
  return self;
}
- (void)removeMarker {
  _marker.map = nil;
}

- (void)setMap:(MFMapView*)mapView {
  _marker.map = mapView;
}

// FMFmarkerOptionsSink

- (void)setConsumeTapEvents:(BOOL)consumes {
  _marker.userInteractionEnabled = consumes;
}

- (void)setPosition:(CLLocationCoordinate2D)position {
  _marker.position = position;
}

- (void)setAnchor: (CGPoint) anchor {
  _marker.infoWindowAnchor = anchor;
}

- (void)setElevation: (double) elevation {
  _marker.elevation = elevation;
}

- (void)setRotation: (double) rotation {
  _marker.rotation = rotation;
}

- (void)setDraggable: (bool) draggable {
  _marker.draggable = draggable;
}

- (void)setZIndex:(float) zIndex {
  _marker.zIndex = zIndex;
}

- (void)setVisible:(bool) visible {
  _marker.isHidden = !visible;
}

- (void)setInfoWindowAnchor:(CGPoint) anchor {
  _marker.infoWindowAnchor = anchor;
}

- (void)setTitle:(NSString *) title {
  _marker.title = title;
}

- (void)setSnippet: (NSString *) snippet {
  _marker.snippet = snippet;
}

- (void)setIconView: (UIView*) iconView {
  _marker.iconView = iconView;
}

- (void)setIcon: (UIImage*) icon {
  if (_marker.icon == nil && icon == nil) {
    return;
  }
  _marker.icon = icon;
}

// Interpret marker options
- (void)interpretMarkerOptions:(NSDictionary*)data
                     registrar:(NSObject<FlutterPluginRegistrar>*)registrar{
  
  NSNumber* consumeTapEvents = data[@"consumeTapEvents"];
  if (consumeTapEvents != nil) {
    [self setConsumeTapEvents:[Map4dFLTConvert toBool:consumeTapEvents]];
  }
  
  NSArray* position = data[@"position"];
  if (position) {
    [self setPosition:[Map4dFLTConvert toLocation:position]];
  }
  
  NSNumber* elevation = data[@"elevation"];
  if (elevation != nil) {
    [self setElevation:[Map4dFLTConvert toDouble:elevation]];
  }
  
  NSNumber* rotation = data[@"rotation"];
  if (rotation != nil) {
    [self setRotation:[Map4dFLTConvert toDouble:rotation]];
  }
  
  NSNumber* draggable = data[@"draggable"];
  if (draggable != nil) {
    [self setDraggable:[Map4dFLTConvert toBool:draggable]];
  }
  
  NSNumber* visible = data[@"visible"];
  if (visible != nil) {
    [self setVisible:[Map4dFLTConvert toBool:visible]];
  }
  
  NSNumber* zIndex = data[@"zIndex"];
  if (zIndex != nil) {
    [self setZIndex:[Map4dFLTConvert toFloat:zIndex]];
  }
  
  NSArray* anchor = data[@"anchor"];
  if (anchor) {
    [self setAnchor:[Map4dFLTConvert toPoint:anchor]];
  }
  
  NSArray* icon = data[@"icon"];
  if (icon) {
    UIImage* image = [Map4dFLTConvert extractIcon:icon registrar:registrar];
    [self setIcon:image];
  }
  
  NSDictionary* infoWindow = data[@"infoWindow"];
  if (infoWindow) {
    NSString* title = infoWindow[@"title"];
    NSString* snippet = infoWindow[@"snippet"];
    if (title) {
      [self setTitle:title];
    }
    if (snippet) {
      [self setSnippet:snippet];
    }
    NSArray* anchor = infoWindow[@"anchor"];
    if (anchor) {
      [self setInfoWindowAnchor:[Map4dFLTConvert toPoint:anchor]];
    }
  }
  
}

@end
