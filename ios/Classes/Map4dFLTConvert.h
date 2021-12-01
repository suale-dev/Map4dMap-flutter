//
//  Map4dFLTConvert.h
//  Pods
//
//  Created by Huy Dang on 07/05/2021.
//

#ifndef Map4dFLTConvert_h
#define Map4dFLTConvert_h

#import <Flutter/Flutter.h>
#import <CoreLocation/CoreLocation.h>
#import <Map4dMap/Map4dMap.h>

@interface Map4dFLTConvert : NSObject

+ (bool)toBool:(NSNumber*)data;
+ (int)toInt:(NSNumber*)data;
+ (double)toDouble:(NSNumber*)data;
+ (float)toFloat:(NSNumber*)data;
+ (CLLocationCoordinate2D)toLocation:(NSArray*)data;
+ (CGPoint)toPoint:(NSArray*)data;
+ (UIColor*)toColor:(NSNumber*)data;
+ (NSArray<CLLocation*>*)toPoints:(NSArray*)data;
+ (NSArray<NSArray<CLLocation*>*>*)toHoles:(NSArray*)data;
+ (MFPath*)toPath:(NSArray*)data;
+ (NSArray<MFPath*>*)toPaths:(NSArray*)data;
+ (MFCoordinateBounds*) toCoordinateBounds:(NSArray*)data;
+ (MFCameraPosition*)toCameraPosition:(NSDictionary*)data;
+ (MFCameraUpdate*)toCameraUpdate:(NSArray*)data;
+ (MFPolylineStyle)toPolylineStyle:(NSNumber*)data;

// Response
+ (NSArray*) locationToJson:(CLLocationCoordinate2D)location;
+ (NSDictionary*) positionToJson:(MFCameraPosition*)position;

// Utility
+ (UIImage*)scaleImage:(UIImage*)image scale:(NSNumber*)scaleParam;
+ (UIImage*)extractIcon:(NSArray*)iconData registrar:(NSObject<FlutterPluginRegistrar>*)registrar;//move to marker
@end

#endif /* Map4dFLTConvert_h */
