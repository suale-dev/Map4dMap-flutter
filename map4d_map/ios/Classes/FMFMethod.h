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
  
  // map#update
  FMFMethodMapUpdate,

  // map#getZoomLevel
  FMFMethodGetZoomLevel,
  
  // map#fitBounds
  FMFMethodFitBounds,
  
  // map#cameraForBounds
  FMFMethodCameraForBounds,
  
  // camera#move
  FMFMethodMoveCamera,
  
  // camera#animate
  FMFMethodAnimateCamera,
  
  // tileOverlays#update
  FMFMethodTileOverlaysUpdate,
  
  // tileOverlays#clearTileCache
  FMFMethodTileOverlaysClearTileCache,
  
  // poi#update
  FMFMethodPOIUpdate,
  
  // building#update
  FMFMethodBuildingUpdate,
  
  // polylines#update
  FMFMethodPolylineUpdate,
  
  // polygons#update
  FMFMethodPolygonUpdate,
  
  // circles#update
  FMFMethodCirclesUpdate,
  
  // markesr#update
  FMFMethodMarkersUpdate,

  //map#enable3DMode
  FMFMethodEnable3DMode

} FMFMethodID;

@interface FMFMethod : NSObject

+(FMFMethodID)getMethodIdByName:(NSString*)name;

@end

#endif /* FMFMethod_h */
