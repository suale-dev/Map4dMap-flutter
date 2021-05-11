//
//  FMFInterpretation.m
//  map4d_map
//
//  Created by Huy Dang on 10/05/2021.
//

#import "FMFInterpretation.h"
#import "FMFConvert.h"

//TODO
#define kMFMinZoomLevel 2
#define kMFMaxZoomLevel 22

@implementation FMFInterpretation

#pragma mark - Interpret Map options
+ (void)interpretMapOptions:(NSDictionary*)data sink:(id<FMFMapViewOptionsSink>)sink {
//  NSArray* cameraTargetBounds = data[@"cameraTargetBounds"];
//  if (cameraTargetBounds) {
//    [sink setCameraTargetBounds:ToOptionalBounds(cameraTargetBounds)];
//  }
  
  id buildingsEnabled = data[@"buildingsEnabled"];
  if (buildingsEnabled) {
    [sink setBuildingsEnabled:[FMFConvert toBool:buildingsEnabled]];
  }
  
  id poisEnabled = data[@"poisEnabled"];
  if (poisEnabled) {
    [sink setPOIsEnabled:[FMFConvert toBool:poisEnabled]];
  }

  NSArray* zoomData = data[@"minMaxZoomPreference"];
  if (zoomData) {
    float minZoom = (zoomData[0] == [NSNull null]) ? kMFMinZoomLevel : [FMFConvert toFloat:zoomData[0]];
    float maxZoom = (zoomData[1] == [NSNull null]) ? kMFMaxZoomLevel : [FMFConvert toFloat:zoomData[1]];
    [sink setMinZoom:minZoom maxZoom:maxZoom];
  }
  
  NSNumber* rotateGesturesEnabled = data[@"rotateGesturesEnabled"];
  if (rotateGesturesEnabled != nil) {
    [sink setRotateGesturesEnabled:[FMFConvert toBool:rotateGesturesEnabled]];
  }
  NSNumber* scrollGesturesEnabled = data[@"scrollGesturesEnabled"];
  if (scrollGesturesEnabled != nil) {
    [sink setScrollGesturesEnabled:[FMFConvert toBool:scrollGesturesEnabled]];
  }
  NSNumber* tiltGesturesEnabled = data[@"tiltGesturesEnabled"];
  if (tiltGesturesEnabled != nil) {
    [sink setTiltGesturesEnabled:[FMFConvert toBool:tiltGesturesEnabled]];
  }
  NSNumber* trackCameraPosition = data[@"trackCameraPosition"];
  if (trackCameraPosition != nil) {
    [sink setTrackCameraPosition:[FMFConvert toBool:trackCameraPosition]];
  }
  NSNumber* zoomGesturesEnabled = data[@"zoomGesturesEnabled"];
  if (zoomGesturesEnabled != nil) {
    [sink setZoomGesturesEnabled:[FMFConvert toBool:zoomGesturesEnabled]];
  }
  NSNumber* myLocationEnabled = data[@"myLocationEnabled"];
  if (myLocationEnabled != nil) {
    [sink setMyLocationEnabled:[FMFConvert toBool:myLocationEnabled]];
  }
  NSNumber* myLocationButtonEnabled = data[@"myLocationButtonEnabled"];
  if (myLocationButtonEnabled != nil) {
    [sink setMyLocationButtonEnabled:[FMFConvert toBool:myLocationButtonEnabled]];
  }
  NSNumber* mode3dEnabled = data[@"mode3dEnabled"];
  if (mode3dEnabled != nil) {
    [sink set3DModeEnabled:[FMFConvert toBool:mode3dEnabled]];
  }
  NSNumber* waterEffectEnabled = data[@"waterEffectEnabled"];
  if (waterEffectEnabled != nil) {
    [sink setWaterEffectEnabled:[FMFConvert toBool:waterEffectEnabled]];
  }
}

#pragma mark - Interpret Circle options
+ (void)interpretCircleOptions:(NSDictionary*)data sink:(id<FMFCircleOptionsSink>)sink {
  NSNumber* consumeTapEvents = data[@"consumeTapEvents"];
  if (consumeTapEvents != nil) {
    [sink setConsumeTapEvents:[FMFConvert toBool:consumeTapEvents]];
  }
  
  NSNumber* visible = data[@"visible"];
  if (visible != nil) {
    [sink setVisible:[FMFConvert toBool:visible]];
  }
  
  NSNumber* zIndex = data[@"zIndex"];
  if (zIndex != nil) {
    [sink setZIndex:[FMFConvert toInt:zIndex]];
  }
  
  NSArray* center = data[@"center"];
  if (center) {
    [sink setCenter:[FMFConvert toLocation:center]];
  }
  
  NSNumber* radius = data[@"radius"];
  if (radius != nil) {
    [sink setRadius:[FMFConvert toFloat:radius]];
  }
  
  NSNumber* strokeColor = data[@"strokeColor"];
  if (strokeColor != nil) {
    [sink setStrokeColor:[FMFConvert toColor:strokeColor]];
  }
  
  NSNumber* strokeWidth = data[@"strokeWidth"];
  if (strokeWidth != nil) {
    [sink setStrokeWidth:[FMFConvert toInt:strokeWidth]];
  }
  
  NSNumber* fillColor = data[@"fillColor"];
  if (fillColor != nil) {
    [sink setFillColor:[FMFConvert toColor:fillColor]];
  }
}

@end