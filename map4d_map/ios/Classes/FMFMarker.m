//
//  FMFMarker.m
//  map4d_map
//
//  Created by iMacbook on 5/11/21.
//

#import "FMFMarker.h"
#import "FMFConvert.h"
#import "FMFInterpretation.h"

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

- (void)addToMap:(MFMapView*)mapView {
  _marker.map = mapView;
}

/*
 FMFmarkerOptionsSink
 */

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
  _marker.icon = icon;
}
@end

#pragma mark - FMFMarkersController

@implementation FMFMarkersController {
  NSMutableDictionary<NSString*, FMFMarker*>* _markers;
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
    _markers = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addMarkers:(NSArray*)markersToAdd {
  for (NSDictionary* marker in markersToAdd) {
    NSString* markerId = marker[@"markerId"];
    FMFMarker *fMarker = [[FMFMarker alloc] initMarkerWithId:markerId];
    [FMFInterpretation interpretMarkerOptions:marker sink:fMarker registrar:_registrar];
    [fMarker addToMap:_mapView];
    _markers[markerId] = fMarker;
  }
}

- (void)changeMarkers:(NSArray*)markersToChange {
  for (NSDictionary* marker in markersToChange) {
    NSString* markerId = marker[@"markerId"];
    FMFMarker* fMarker = _markers[markerId];
    if (fMarker != nil) {
      [FMFInterpretation interpretMarkerOptions:marker sink:fMarker registrar:_registrar];
    }
  }
}

- (void)removeMarkerIds:(NSArray*)markerIdsToRemove {
  for (NSString* markerId in markerIdsToRemove) {
    if (!markerId) {
      continue;
    }
    FMFMarker* fMarker = _markers[markerId];
    if (fMarker != nil) {
      [fMarker removeMarker];
      [_markers removeObjectForKey:markerId];
    }
  }
}

- (void)onMarkerTap:(NSString*)markerId {
  if (!markerId) return;
  FMFMarker* fMarker = _markers[markerId];
  if (fMarker != nil) {
    [_channel invokeMethod:@"marker#onTap" arguments:@{@"markerId" : markerId}];
  }
}

- (void)onDragEndMarker:(NSString*)markerId position:(CLLocationCoordinate2D)position {
  if (!markerId) return;
  FMFMarker* fMarker = _markers[markerId];
  if (fMarker != nil) {
    [_channel invokeMethod:@"marker#onDragEnd"
                 arguments:@{@"markerId" : markerId, @"position" : [FMFConvert locationToJson:position]}];
  }
}

- (void)onInfoWindowTap:(NSString*)markerId {
  if (!markerId) return;
  FMFMarker* fMarker = _markers[markerId];
  if (fMarker != nil) {
    [_channel invokeMethod:@"infoWindow#onTap" arguments:@{@"markerId" : markerId}];
  }
}
@end
