//
//  FMFBuilding.m
//  map4d_map
//
//  Created by Huy Dang on 14/05/2021.
//

#import "FMFBuilding.h"
#import "Map4dFLTConvert.h"

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

- (void)setMap:(MFMapView*)mapView {
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

#pragma mark - Interpret Building Options
- (void)interpretBuildingOptions:(NSDictionary*)data {
  NSNumber* consumeTapEvents = data[@"consumeTapEvents"];
  if (consumeTapEvents != nil) {
    [self setConsumeTapEvents:[Map4dFLTConvert toBool:consumeTapEvents]];
  }
  
  NSNumber* visible = data[@"visible"];
  if (visible != nil) {
    [self setVisible:[Map4dFLTConvert toBool:visible]];
  }
  
  NSNumber* selected = data[@"selected"];
  if (selected != nil) {
    [self setSelected:[Map4dFLTConvert toBool:selected]];
  }
  
  NSArray* position = data[@"position"];
  if (position) {
    [self setPosition:[Map4dFLTConvert toLocation:position]];
  }
  
  NSString* name = data[@"name"];
  if (name != nil) {
    [self setName:name];
  }
  
  NSArray* coordinates = data[@"coordinates"];
  if (coordinates) {
    [self setCoordinates:[Map4dFLTConvert toPoints:coordinates]];
  }
  
  NSString* modelUrl = data[@"modelUrl"];
  if (modelUrl != nil) {
    [self setModel:modelUrl];
  }
  
  NSString* textureUrl = data[@"textureUrl"];
  if (textureUrl != nil) {
    [self setTexture:textureUrl];
  }
  
  NSNumber* height = data[@"height"];
  if (height != nil) {
    [self setHeight:[Map4dFLTConvert toDouble:height]];
  }
  
  NSNumber* scale = data[@"scale"];
  if (scale != nil) {
    [self setScale:[Map4dFLTConvert toDouble:scale]];
  }
  
  NSNumber* bearing = data[@"bearing"];
  if (bearing != nil) {
    [self setBearing:[Map4dFLTConvert toFloat:bearing]];
  }
  
  NSNumber* elevation = data[@"elevation"];
  if (elevation != nil) {
    [self setElevation:[Map4dFLTConvert toDouble:elevation]];
  }
}

@end

