//
//  FMFCircle.h
//  Pods
//
//  Created by Huy Dang on 10/05/2021.
//

#ifndef FMFCircle_h
#define FMFCircle_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@protocol FMFCircleOptionsSink
- (void)setConsumeTapEvents:(BOOL)consume;
- (void)setVisible:(BOOL)visible;
- (void)setStrokeColor:(UIColor*)color;
- (void)setStrokeWidth:(CGFloat)width;
- (void)setFillColor:(UIColor*)color;
- (void)setCenter:(CLLocationCoordinate2D)center;
- (void)setRadius:(CLLocationDistance)radius;
- (void)setZIndex:(int)zIndex;
@end

@interface FMFCircle : NSObject<FMFCircleOptionsSink>
@property(atomic, readonly) NSString* circleId;
- (instancetype)initCircleWithId:(NSString*)circleId;
- (void)setMap:(MFMapView*)mapView;
- (void)removeCircle;
- (void)interpretCircleOptions:(NSDictionary*)data;
@end

#endif /* FMFCircle_h */
