//
//  FMFMapView.h
//  map4d_map
//
//  Created by Sua Le on 05/05/2021.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <Map4dMap/Map4dMap.h>

NS_ASSUME_NONNULL_BEGIN

// Defines map UI options writable from Flutter.
@protocol FMFMapViewOptionsSink
- (void)setCameraTargetBounds:(nullable MFCoordinateBounds *)bounds;
//TODO
//- (void)setCompassEnabled:(BOOL)enabled;
//- (void)setIndoorEnabled:(BOOL)enabled;
//- (void)setTrafficEnabled:(BOOL)enabled;
- (void)setBuildingsEnabled:(BOOL)enabled;
//TODO
//- (void)setMapType:(GMSMapViewType)type;
- (void)setMinZoom:(float)minZoom maxZoom:(float)maxZoom;
//- (void)setPaddingTop:(float)top left:(float)left bottom:(float)bottom right:(float)right;//TODO
- (void)setRotateGesturesEnabled:(BOOL)enabled;
- (void)setScrollGesturesEnabled:(BOOL)enabled;
- (void)setTiltGesturesEnabled:(BOOL)enabled;
- (void)setTrackCameraPosition:(BOOL)enabled;
- (void)setZoomGesturesEnabled:(BOOL)enabled;
- (void)setMyLocationEnabled:(BOOL)enabled;
- (void)setMyLocationButtonEnabled:(BOOL)enabled;
//TODO
//- (nullable NSString *)setMapStyle:(NSString *)mapStyle;
- (void)set3DModeEnabled:(BOOL)enabled;
- (void)setWaterEffectEnabled:(BOOL)enabled;
@end

// Defines map overlay controllable from Flutter.
@interface FMFMapView : NSObject<FlutterPlatformView, MFMapViewDelegate, FMFMapViewOptionsSink>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(nullable id)args
                    registrar:(NSObject<FlutterPluginRegistrar> *)registrar;
@end


// Allows the engine to create new Map4d map instances.
@interface FMFMapViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
@end

NS_ASSUME_NONNULL_END
