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
- (void)setBuildingsEnabled:(BOOL)enabled;
- (void)setPOIsEnabled:(BOOL)enabled;
- (void)setMapType:(MFMapType)type;
- (void)setMinZoom:(float)minZoom maxZoom:(float)maxZoom;
//- (void)setPaddingTop:(float)top left:(float)left bottom:(float)bottom right:(float)right;//TODO
- (void)setRotateGesturesEnabled:(BOOL)enabled;
- (void)setScrollGesturesEnabled:(BOOL)enabled;
- (void)setTiltGesturesEnabled:(BOOL)enabled;
- (void)setZoomGesturesEnabled:(BOOL)enabled;
- (void)setMyLocationEnabled:(BOOL)enabled;
- (void)setMyLocationButtonEnabled:(BOOL)enabled;
//TODO
//- (nullable NSString *)setMapStyle:(NSString *)mapStyle;
- (void)set3DModeEnabled:(BOOL)enabled;
- (void)setWaterEffectEnabled:(BOOL)enabled;
// Track
- (void)setTrackCameraPosition:(BOOL)enabled;
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
- (id<FlutterPlatformView> _Nullable)getFlutterMapViewById:(int64_t)viewId;
@end

NS_ASSUME_NONNULL_END
