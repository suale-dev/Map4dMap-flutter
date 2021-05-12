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
#import "FMFPolyline.h"
#import "FMFCircle.h"

@interface FMFInterpretation : NSObject

+ (void)interpretMapOptions:(NSDictionary*)data sink:(id<FMFMapViewOptionsSink>)sink;
+ (void)interpretPolylineOptions:(NSDictionary*) data sink:(id<FMFPolylineOptionsSink>)sink;
+ (void)interpretCircleOptions:(NSDictionary*)data sink:(id<FMFCircleOptionsSink>)sink;

@end

#endif /* FMFInterpretation_h */
