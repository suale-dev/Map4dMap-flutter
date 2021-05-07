//
//  FMFMapView.h
//  map4d_map
//
//  Created by Sua Le on 05/05/2021.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <Map4dMap/MFMapView.h>

NS_ASSUME_NONNULL_BEGIN

// Defines map overlay controllable from Flutter.
@interface FMFMapView : NSObject<FlutterPlatformView>
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
