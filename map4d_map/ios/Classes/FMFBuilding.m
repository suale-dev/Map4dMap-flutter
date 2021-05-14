//
//  FMFBuilding.m
//  map4d_map
//
//  Created by Huy Dang on 14/05/2021.
//

#import "FMFBuilding.h"
#import "FMFInterpretation.h"

@implementation FMFBuilding {
  MFBuilding* _building;
}

- (instancetype)initBuildingWithId:(NSString *)buildingId {
  self = [super init];
  if (self) {
    _building = [[MFBuilding alloc] init];
    _building.userData = @[ buildingId ];
    _buildingId = buildingId;
  }
  return self;
}

- (void)removeBuilding {
  _building.map = nil;
}

- (void)addToMap:(MFMapView*)mapView {
  _building.map = mapView;
}

/*
 FMFBuildingOptionsSink
 */
- (void)setConsumeTapEvents:(BOOL)consume {
  _building.userInteractionEnabled = consume;
}

- (void)setVisible:(BOOL)visible {
  _building.isHidden = !visible;
}

- (void)setName:(NSString*)name {
  _building.name = name;
}

- (void)setPosition:(CLLocationCoordinate2D)position {
  _building.position = position;
}

- (void)setModel:(NSString*)model {
  _building.model = model;
}

- (void)setTexture:(NSString*)texture {
  _building.texture = texture;
}

- (void)setCoordinates:(NSArray<CLLocation*>*)coordinates {
  MFMutablePath* path = [[MFMutablePath alloc] init];
  for (CLLocation* location in coordinates) {
    [path addCoordinate:location.coordinate];
  }
  if (path.count > 0) {
    _building.coordinates = path;
  }
  else {
    _building.coordinates = nil;
  }
}

- (void)setHeight:(double)height {
  _building.height = height;
}

- (void)setScale:(double)scale {
  _building.scale = scale;
}

- (void)setBearing:(CGFloat)bearing {
  _building.bearing = bearing;
}

- (void)setElevation:(double)elevation {
  _building.elevation = elevation;
}

- (void)setSelected:(bool)selected {
  _building.selected = selected;
}

@end


#pragma mark - FMFBuildingsController

@implementation FMFBuildingsController {
  NSMutableDictionary<NSString*, FMFBuilding*>* _buildings;
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
    _buildings = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addBuildings:(NSArray*)buildingsToAdd {
  for (NSDictionary* building in buildingsToAdd) {
    NSString* buildingId = building[@"buildingId"];
    FMFBuilding* fBuilding = [[FMFBuilding alloc] initBuildingWithId:buildingId];
    [FMFInterpretation interpretBuildingOptions:building sink:fBuilding];
    [fBuilding addToMap:_mapView];
    _buildings[buildingId] = fBuilding;
  }
}

- (void)changeBuildings:(NSArray*)buildingsToChange {
  for (NSDictionary* building in buildingsToChange) {
    NSString* buildingId = building[@"buildingId"];
    FMFBuilding* fBuilding = _buildings[buildingId];
    if (fBuilding != nil) {
      [FMFInterpretation interpretBuildingOptions:building sink:fBuilding];
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

- (void)onBuildingTap:(NSString*)buildingId {
  if (!buildingId) return;
  FMFBuilding* fBuilding = _buildings[buildingId];
  if (fBuilding != nil) {
    [_channel invokeMethod:@"building#onTap" arguments:@{@"buildingId" : buildingId}];
  }
}

@end
