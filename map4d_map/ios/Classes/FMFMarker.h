//
//  FMFMarker.h
//  map4d_map
//
//  Created by iMacbook on 5/11/21.
//

#ifndef FMFMarker_h
#define FMFMarker_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>
#import <CoreLocation/CoreLocation.h>

@protocol FMFMarkerOptionsSink
- (void)setConsumeTapEvents:(BOOL)consumes;
- (void)setPosition:(CLLocationCoordinate2D)position;
- (void)setAnchor:(CGPoint) anchor;
- (void)setElevation:(double) elevation;
- (void)setRotation:(double) rotation;
- (void)setDraggable:(bool) draggable;
- (void)setZIndex:(float) zIndex;
- (void)setVisible:(bool) visible;
- (void)setInfoWindowAnchor:(CGPoint) anchor;
- (void)setTitle:(NSString*) title;
- (void)setSnippet: (NSString*) snippet;
- (void)setIconView: (UIView*) iconView;
- (void)setIcon: (UIImage*) icon;
@end

@interface FMFMarker : NSObject<FMFMarkerOptionsSink>
@property(atomic, readonly) NSString* markerId;
- (instancetype)initMarkerWithId:(NSString*)markerId;
- (void)removeMarker;
@end


#pragma mark - FMFMarkerController

@interface FMFMarkersController : NSObject
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addMarkers:(NSArray*)markersToAdd;
- (void)changeMarkers:(NSArray*)markersToChange;
- (void)removeMarkerIds:(NSArray*)markerIdsToRemove;
- (void)onMarkerTap:(NSString*)markerId;
- (void)onDragEndMarker:(NSString*)markerId position:(CLLocationCoordinate2D)position;
- (void)onInfoWindowTap:(NSString*)markerId;
@end

#endif /* FMFMarker_h */
