//
//  Map4dAnnotationManager.m
//  map4d_map
//
//  Created by Huy Dang on 19/05/2021.
//

#import "Map4dAnnotationManager.h"
#import "Map4dFLTConvert.h"
#import "FMFMarker.h"
#import "FMFCircle.h"
#import "FMFPolyline.h"
#import "FMFPolygon.h"
#import "FMFPOI.h"
#import "FMFBuilding.h"

@interface Map4dAnnotationManager()

@property(nonatomic, weak) MFMapView* mapView;
@property(nonatomic, weak) FlutterMethodChannel* channel;
@property(nonatomic, weak) NSObject<FlutterPluginRegistrar>* registrar;

@property(nonatomic, strong) NSMutableDictionary<NSString*, FMFMarker*>* markers;
@property(nonatomic, strong) NSMutableDictionary<NSString*, FMFCircle*>* circles;
@property(nonatomic, strong) NSMutableDictionary<NSString*, FMFPolyline*>* polylines;
@property(nonatomic, strong) NSMutableDictionary<NSString*, FMFPolygon*>* polygons;
@property(nonatomic, strong) NSMutableDictionary<NSString*, FMFPOI*>* pois;
@property(nonatomic, strong) NSMutableDictionary<NSString*, FMFBuilding*>* buildings;
@end

@implementation Map4dAnnotationManager

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  self = [super init];
  if (self) {
    _channel = methodChannel;
    _mapView = mapView;
    _registrar = registrar;
    
    _markers = [NSMutableDictionary dictionaryWithCapacity:1];
    _circles = [NSMutableDictionary dictionaryWithCapacity:1];
    _polylines = [NSMutableDictionary dictionaryWithCapacity:1];
    _polygons = [NSMutableDictionary dictionaryWithCapacity:1];
    _pois = [NSMutableDictionary dictionaryWithCapacity:1];
    _buildings = [NSMutableDictionary dictionaryWithCapacity:1];
  }
  return self;
}

#pragma mark - Marker

- (void)addMarkers:(NSArray*)markersToAdd {
  for (NSDictionary* marker in markersToAdd) {
    NSString* markerId = marker[@"markerId"];
    FMFMarker *fMarker = [[FMFMarker alloc] initMarkerWithId:markerId];
    [fMarker interpretMarkerOptions:marker registrar:_registrar];
    [fMarker setMap:_mapView];
    _markers[markerId] = fMarker;
  }
}

- (void)changeMarkers:(NSArray*)markersToChange {
  for (NSDictionary* marker in markersToChange) {
    NSString* markerId = marker[@"markerId"];
    FMFMarker* fMarker = _markers[markerId];
    if (fMarker != nil) {
      [fMarker interpretMarkerOptions:marker registrar:_registrar];
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

- (BOOL)hasMarker:(NSString *)markerId {
  if (markerId != nil && _markers[markerId] != nil) {
    return YES;
  }
  return NO;
}

- (BOOL)isShowMarkerInfoWindow:(NSString*)markerId {
  FMFMarker* marker = _markers[markerId];
  if (marker != nil) {
    return marker.showInfoWindowOnTap;
  }
  return NO;
}

#pragma mark - Circle

- (void)addCircles:(NSArray*)circlesToAdd {
  for (NSDictionary* circle in circlesToAdd) {
    NSString* circleId = circle[@"circleId"];
    FMFCircle *fCircle = [[FMFCircle alloc] initCircleWithId:circleId];
    [fCircle interpretCircleOptions:circle];
    [fCircle setMap:_mapView];
    _circles[circleId] = fCircle;
  }
}

- (void)changeCircles:(NSArray*)circlesToChange {
  for (NSDictionary* circle in circlesToChange) {
    NSString* circleId = circle[@"circleId"];
    FMFCircle* fCircle = _circles[circleId];
    if (fCircle != nil) {
      [fCircle interpretCircleOptions:circle];
    }
  }
}

- (void)removeCircleIds:(NSArray*)circleIdsToRemove {
  for (NSString* circleId in circleIdsToRemove) {
    if (!circleId) {
      continue;
    }
    FMFCircle* fCircle = _circles[circleId];
    if (fCircle != nil) {
      [fCircle removeCircle];
      [_circles removeObjectForKey:circleId];
    }
  }
}

- (BOOL)hasCircle:(NSString*)circleId {
  if (circleId != nil && _circles[circleId] != nil) {
    return YES;
  }
  return NO;
}

#pragma mark - Polyline

- (void)addPolylines:(NSArray*)polylinesToAdd {
  for (NSDictionary* polyline in polylinesToAdd) {
    NSString* polylineId = polyline[@"polylineId"];
    FMFPolyline* fPolyline = [[FMFPolyline alloc] initPolylineWithId:polylineId];
    [fPolyline interpretPolylineOptions:polyline];
    [fPolyline setMap:_mapView];
    _polylines[polylineId] = fPolyline;
  }
}

- (void)changePolylines:(NSArray*)polylinesToChange {
  for (NSDictionary* polyline in polylinesToChange) {
    NSString* polylineId = polyline[@"polylineId"];
    FMFPolyline* fPolyline = _polylines[polylineId];
    if (fPolyline != nil) {
      [fPolyline interpretPolylineOptions:polyline];
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

- (BOOL)hasPolyline:(NSString*)polylineId {
  if (polylineId != nil && _polylines[polylineId] != nil) {
    return YES;
  }
  return NO;
}

#pragma mark - Polygon

- (void)addPolygons:(NSArray*)polygonsToAdd {
  for (NSDictionary* polygon in polygonsToAdd) {
    NSString* polygonId = polygon[@"polygonId"];
    FMFPolygon* fPolygon = [[FMFPolygon alloc] initPolygonWithId:polygonId];
    [fPolygon interpretPolygonOptions:polygon];
    [fPolygon setMap:_mapView];
    _polygons[polygonId] = fPolygon;
  }
}

- (void)changePolygons:(NSArray*)polygonsToChange {
  for (NSDictionary* polygon in polygonsToChange) {
    NSString* polygonId = polygon[@"polygonId"];
    FMFPolygon* fPolygon = _polygons[polygonId];
    if (fPolygon != nil) {
      [fPolygon interpretPolygonOptions:polygon];
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

- (BOOL)hasPolygon:(NSString*)polygonId {
  if (polygonId != nil && _polygons[polygonId] != nil) {
    return YES;
  }
  return NO;
}

#pragma mark - POI

- (void)addPOIs:(NSArray*)poisToAdd {
  for (NSDictionary* poi in poisToAdd) {
    NSString* poiId = poi[@"poiId"];
    FMFPOI* fPOI = [[FMFPOI alloc] initPOIWithId:poiId];
    [fPOI interpretPOIOptions:poi registrar:_registrar];
    [fPOI setMap:_mapView];
    _pois[poiId] = fPOI;
  }
}

- (void)changePOIs:(NSArray*)poisToChange {
  for (NSDictionary* poi in poisToChange) {
    NSString* poiId = poi[@"poiId"];
    FMFPOI* fPOI = _pois[poiId];
    if (fPOI != nil) {
      [fPOI interpretPOIOptions:poi registrar:_registrar];
    }
  }
}

- (void)removePOIIds:(NSArray*)poiIdsToRemove {
  for (NSString* poiId in poiIdsToRemove) {
    if (!poiId) {
      continue;
    }
    FMFPOI* fPOI = _pois[poiId];
    if (fPOI != nil) {
      [fPOI removePOI];
      [_pois removeObjectForKey:poiId];
    }
  }
}
- (BOOL)hasPOI:(NSString*)poiId {
  if (poiId != nil && _pois[poiId] != nil) {
    return YES;
  }
  return NO;
}

#pragma mark - Building

- (void)addBuildings:(NSArray*)buildingsToAdd {
  for (NSDictionary* building in buildingsToAdd) {
    NSString* buildingId = building[@"buildingId"];
    FMFBuilding* fBuilding = [[FMFBuilding alloc] initBuildingWithId:buildingId];
    [fBuilding interpretBuildingOptions:building];
    [fBuilding setMap:_mapView];
    _buildings[buildingId] = fBuilding;
  }
}

- (void)changeBuildings:(NSArray*)buildingsToChange {
  for (NSDictionary* building in buildingsToChange) {
    NSString* buildingId = building[@"buildingId"];
    FMFBuilding* fBuilding = _buildings[buildingId];
    if (fBuilding != nil) {
      [fBuilding interpretBuildingOptions:building];
    }
  }
}

- (void)removeBuildingIds:(NSArray*)buildingIdsToRemove {
  for (NSString* buildingId in buildingIdsToRemove) {
    if (!buildingId) {
      continue;
    }
    FMFBuilding* fBuilding = _buildings[buildingId];
    if (fBuilding != nil) {
      [fBuilding removeBuilding];
      [_buildings removeObjectForKey:buildingId];
    }
  }
}

- (BOOL)hasBuilding:(NSString*)buildingId {
  if (buildingId != nil && _buildings[buildingId] != nil) {
    return YES;
  }
  return NO;
}

@end
