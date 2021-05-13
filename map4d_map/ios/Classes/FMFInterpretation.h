//
//  FMFInterpretation.h
//  Pods
//
//  Created by Huy Dang on 10/05/2021.
//

#ifndef FMFInterpretation_h
#define FMFInterpretation_h

#import <Foundation/Foundation.h>
#import "FMFMapView.h"
#import "FMFPOI.h"
#import "FMFPolyline.h"
#import "FMFCircle.h"

@interface FMFInterpretation : NSObject

+ (void)interpretMapOptions:(NSDictionary*)data sink:(id<FMFMapViewOptionsSink>)sink;
+ (void)interpretPOIOptions:(NSDictionary*) data sink:(id<FMFPOIOptionsSink>)sink;// registrar:(NSObject<FlutterPluginRegistrar>*) registrar;
+ (void)interpretPolylineOptions:(NSDictionary*) data sink:(id<FMFPolylineOptionsSink>)sink;
+ (void)interpretCircleOptions:(NSDictionary*)data sink:(id<FMFCircleOptionsSink>)sink;

@end

#endif /* FMFInterpretation_h */
