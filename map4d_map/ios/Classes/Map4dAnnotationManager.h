//
//  Map4dAnnotationManager.h
//  Pods
//
//  Created by Huy Dang on 19/05/2021.
//

#ifndef Map4dAnnotationManager_h
#define Map4dAnnotationManager_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@interface Map4dAnnotationManager : NSObject

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

// Marker
- (void)addMarkers:(NSArray*)markersToAdd;
- (void)changeMarkers:(NSArray*)markersToChange;
- (void)removeMarkerIds:(NSArray*)markerIdsToRemove;
- (BOOL)hasMarker:(NSString*)markerId;
- (BOOL)isShowMarkerInfoWindow:(NSString*)markerId;

// Circle
- (void)addCircles:(NSArray*)circlesToAdd;
- (void)changeCircles:(NSArray*)circlesToChange;
- (void)removeCircleIds:(NSArray*)circleIdsToRemove;
- (BOOL)hasCircle:(NSString*)circleId;

// Polyline
- (void)addPolylines:(NSArray*)polylinesToAdd;
- (void)changePolylines:(NSArray*)polylinesToChange;
- (void)removePolylineIds:(NSArray*)polylineIdsToRemove;
- (BOOL)hasPolyline:(NSString*)polylineId;

// Polygon
- (void)addPolygons:(NSArray*)polygonsToAdd;
- (void)changePolygons:(NSArray*)polygonsToChange;
- (void)removePolygonIds:(NSArray*)polygonIdsToRemove;
- (BOOL)hasPolygon:(NSString*)polygonId;

// POI
- (void)addPOIs:(NSArray*)poisToAdd;
- (void)changePOIs:(NSArray*)poisToChange;
- (void)removePOIIds:(NSArray*)poiIdsToRemove;
- (BOOL)hasPOI:(NSString*)poiId;

// Building
- (void)addBuildings:(NSArray*)buildingsToAdd;
- (void)changeBuildings:(NSArray*)buildingsToChange;
- (void)removeBuildingIds:(NSArray*)buildingIdsToRemove;
- (BOOL)hasBuilding:(NSString*)buildingId;

@end


#endif /* Map4dAnnotationManager_h */
