//
//  FMFMethod.h
//  Pods
//
//  Created by Huy Dang on 07/05/2021.
//

#ifndef FMFMethod_h
#define FMFMethod_h

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {

  // Unknow method
  FMFMethodUnknow,

  // map#getZoomLevel
  FMFMethodGetZoomLevel,
  
  // camera#move
  FMFMethodMoveCamera,
  
  // camera#animate
  FMFMethodAnimateCamera

} FMFMethodID;

@interface FMFMethod : NSObject

+(FMFMethodID)getMethodIdByName:(NSString*)name;

@end

#endif /* FMFMethod_h */
