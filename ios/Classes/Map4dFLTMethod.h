//
//  Map4dFLTMethod.h
//  Pods
//
//  Created by Huy Dang on 07/05/2021.
//

#ifndef Map4dFLTMethod_h
#define Map4dFLTMethod_h

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
  
  // map#getCameraPosition
  FMFMethodGetCameraPosition,
  
  // map#getBounds
  FMFMethodGetBounds,
  
  // map#enable3DMode
  FMFMethodEnable3DMode,
  
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
  
  // markers#update
  FMFMethodMarkersUpdate,
  
  // directionsRenderers#update
  FMFMethodDirectionsRenderersUpdate,
  
  // count - all method must add above this
  FMFMethodMaxItem

} FMFMethodID;

@interface Map4dFLTMethod : NSObject

+ (Map4dFLTMethod*)shared;
- (FMFMethodID)getIdByName:(NSString*)name;

@end

#endif /* Map4dFLTMethod_h */
