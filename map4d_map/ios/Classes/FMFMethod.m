//
//  FMFMethod.m
//  map4d_map
//
//  Created by Huy Dang on 07/05/2021.
//

#import "FMFMethod.h"s

@implementation FMFMethod

+(FMFMethodID)getMethodIdByName:(NSString*)name {
  
  if ([name isEqualToString:@"map#getZoomLevel"]) {
    return FMFMethodGetZoomLevel;
  }
  
  if ([name isEqualToString:@"camera#move"]) {
    return FMFMethodMoveCamera;
  }
  
  if ([name isEqualToString:@"camera#animate"]) {
    return FMFMethodAnimateCamera;
  }
  
  return FMFMethodUnknow;
}

@end
