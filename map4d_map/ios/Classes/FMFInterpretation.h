//
//  FMFInterpretation.h
//  Pods
//
//  Created by Huy Dang on 10/05/2021.
//

#ifndef FMFInterpretation_h
#define FMFInterpretation_h

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FMFMapView.h"
#import "FMFPOI.h"
#import "FMFBuilding.h"
#import "FMFPolyline.h"
#import "FMFCircle.h"
#import "FMFMarker.h"

@interface FMFInterpretation : NSObject

+ (void)interpretMapOptions:(NSDictionary*)data sink:(id<FMFMapViewOptionsSink>)sink;
+ (void)interpretPOIOptions:(NSDictionary*) data sink:(id<FMFPOIOptionsSink>)sink;// registrar:(NSObject<FlutterPluginRegistrar>*) registrar;
+ (void)interpretBuildingOptions:(NSDictionary*) data sink:(id<FMFBuildingOptionsSink>)sink;
+ (void)interpretPolylineOptions:(NSDictionary*) data sink:(id<FMFPolylineOptionsSink>)sink;
+ (void)interpretCircleOptions:(NSDictionary*)data sink:(id<FMFCircleOptionsSink>)sink;
+ (void)interpretMarkerOptions:(NSDictionary*)data
                          sink:(id<FMFMarkerOptionsSink>)sink
                     registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end

#endif /* FMFInterpretation_h */
