//
//  Map4dFLTMethod.m
//  map4d_map
//
//  Created by Huy Dang on 07/05/2021.
//

#import "Map4dFLTMethod.h"

@interface Map4dFLTMethod()
@property(nonatomic, strong) NSDictionary<NSString*, NSNumber*>* methods;
@end

@implementation Map4dFLTMethod

+ (Map4dFLTMethod*)shared {
  static Map4dFLTMethod *instance = nil;
  @synchronized(self) {
    if (instance == nil)
      instance = [[self alloc] init];
  }
  return instance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _methods = @{
      /* map **/
      @"map#update": @(FMFMethodMapUpdate),
      @"map#getZoomLevel": @(FMFMethodGetZoomLevel),
      @"map#fitBounds": @(FMFMethodFitBounds),
      @"map#cameraForBounds": @(FMFMethodCameraForBounds),
      @"map#getCameraPosition" : @(FMFMethodGetCameraPosition),
      @"map#getBounds": @(FMFMethodGetBounds),
      @"map#enable3DMode": @(FMFMethodEnable3DMode),
      /* camera **/
      @"camera#move": @(FMFMethodMoveCamera),
      @"camera#animate": @(FMFMethodAnimateCamera),
      /* annotations **/
      @"markers#update": @(FMFMethodMarkersUpdate),
      @"circles#update": @(FMFMethodCirclesUpdate),
      @"polylines#update": @(FMFMethodPolylineUpdate),
      @"polygons#update": @(FMFMethodPolygonUpdate),
      @"poi#update": @(FMFMethodPOIUpdate),
      @"building#update": @(FMFMethodBuildingUpdate),
      /* overlays **/
      @"tileOverlays#update": @(FMFMethodTileOverlaysUpdate),
      @"tileOverlays#clearTileCache": @(FMFMethodTileOverlaysClearTileCache),
      /* directions renderer **/
      @"directionsRenderers#update": @(FMFMethodDirectionsRenderersUpdate)
    };

    // +1 cause by FMFMethodUnknow
    NSAssert(_methods.count + 1 == FMFMethodMaxItem, @"Missing method define");
  }
  return self;
}

- (FMFMethodID)getIdByName:(NSString*)name {
  NSNumber* methodId = _methods[name];
  if (methodId != nil) {
    return methodId.integerValue;
  }
  return FMFMethodUnknow;
}

@end
