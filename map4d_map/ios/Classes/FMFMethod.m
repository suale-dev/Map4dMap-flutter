//
//  FMFMethod.m
//  map4d_map
//
//  Created by Huy Dang on 07/05/2021.
//

#import "FMFMethod.h"

@implementation FMFMethod

+(FMFMethodID)getMethodIdByName:(NSString*)name {
  
  if ([name isEqualToString:@"map#update"]) {
    return FMFMethodMapUpdate;
  }
  
  if ([name isEqualToString:@"map#getZoomLevel"]) {
    return FMFMethodGetZoomLevel;
  }
  
  if ([name isEqualToString:@"map#fitBounds"]) {
    return FMFMethodFitBounds;
  }
   
  if ([name isEqualToString:@"map#cameraForBounds"]) {
    return FMFMethodCameraForBounds;
  }
  
  if ([name isEqualToString:@"camera#move"]) {
    return FMFMethodMoveCamera;
  }
  
  if ([name isEqualToString:@"camera#animate"]) {
    return FMFMethodAnimateCamera;
  }
  
  // Annotation
  if ([name isEqualToString:@"poi#update"]) {
    return FMFMethodPOIUpdate;
  }
  
  if ([name isEqualToString:@"building#update"]) {
    return FMFMethodBuildingUpdate;
  }

  if ([name isEqualToString:@"polylines#update"]) {
    return FMFMethodPolylineUpdate;
  }
  
  if ([name isEqualToString:@"polygons#update"]) {
    return FMFMethodPolygonUpdate;
  }
  
  if ([name isEqualToString:@"circles#update"]) {
    return FMFMethodCirclesUpdate;
  }
  
  if ([name isEqualToString:@"markers#update"]) {
    return FMFMethodMarkersUpdate;
  }
  
  if ([name isEqualToString:@"map#enable3DMode"]) {
    return FMFMethodEnable3DMode;
  }
  
  return FMFMethodUnknow;
}

@end
