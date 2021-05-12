//
//  FMFPolyline.h
//  Pods
//
//  Created by Huy Dang on 12/05/2021.
//

#ifndef FMFPolyline_h
#define FMFPolyline_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@protocol FMFPolylineOptionsSink
- (void)setConsumeTapEvents:(BOOL)consume;
- (void)setVisible:(BOOL)visible;
- (void)setColor:(UIColor*)color;
- (void)setStrokeWidth:(CGFloat)width;
- (void)setPoints:(NSArray<CLLocation*>*)points;
- (void)setZIndex:(int)zIndex;
- (void)setStyle:(MFPolylineStyle)style;
@end

@interface FMFPolyline : NSObject<FMFPolylineOptionsSink>
@property(atomic, readonly) NSString* polylineId;
- (instancetype)initPolylineWithId:(NSString*)polylineId;
- (void)removePolyline;
@end


#pragma mark - FMFPolylinesController

@interface FMFPolylinesController : NSObject
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addPolylines:(NSArray*)polylinesToAdd;
- (void)changePolylines:(NSArray*)polylinesToChange;
- (void)removePolylineIds:(NSArray*)polylineIdsToRemove;
- (void)onPolylineTap:(NSString*)polylineId;
@end

#endif /* FMFPolyline_h */
