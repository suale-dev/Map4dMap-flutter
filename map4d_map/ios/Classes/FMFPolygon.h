//
//  FMFPolygon.h
//  Pods
//
//  Created by iMacbook on 5/14/21.
//

#ifndef FMFPolygon_h
#define FMFPolygon_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>
#import <CoreLocation/CoreLocation.h>

@protocol FMFPolygonOptionsSink
- (void)setConsumeTapEvents:(BOOL)consume;
- (void)setVisible:(BOOL)visible;
- (void)setFillColor:(UIColor*)color;
- (void)setStrokeColor:(UIColor*)color;
- (void)setStrokeWidth:(CGFloat)width;
- (void)setPoints:(NSArray<CLLocation*>*)points;
- (void)setHoles:(NSArray<NSArray<CLLocation*>*>*)points;
- (void)setZIndex:(int)zIndex;
@end

@interface FMFPolygon : NSObject<FMFPolygonOptionsSink>
@property(atomic, readonly) NSString* polygonId;
- (instancetype)initPolygonWithId:(NSString*)polygonId;
- (void)setMap:(MFMapView*)mapView;
- (void)removePolygon;
- (void)interpretPolygonOptions:(NSDictionary*)data;
@end

#endif /* FMFPolygon_h */
