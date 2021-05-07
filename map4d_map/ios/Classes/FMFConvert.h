//
//  FMFConvert.h
//  Pods
//
//  Created by Huy Dang on 07/05/2021.
//

#ifndef FMFConvert_h
#define FMFConvert_h

#import <Flutter/Flutter.h>
#import <CoreLocation/CoreLocation.h>
#import <Map4dMap/Map4dMap.h>

@interface FMFConvert : NSObject

+ (bool)toBool:(NSNumber*)data;
+ (int)toInt:(NSNumber*)data;
+ (double)toDouble:(NSNumber*)data;
+ (float)toFloat:(NSNumber*)data;
+ (CLLocationCoordinate2D)toLocation:(NSArray*)data;
+ (MFCoordinateBounds*) toCoordinateBounds:(NSArray*)data;
+ (MFCameraPosition*)toCameraPosition:(NSDictionary*)data;
+ (MFCameraUpdate*)toCameraUpdate:(NSArray*)data;

// Response
+ (NSArray*) locationToJson:(CLLocationCoordinate2D)location;
+ (NSDictionary*) positionToJson:(MFCameraPosition*)position;
@end

#endif /* FMFConvert_h */
