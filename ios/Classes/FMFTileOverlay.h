//
//  FMFTileOverlay.h
//  Pods
//
//  Created by Huy Dang on 17/05/2021.
//

#ifndef FMFTileOverlay_h
#define FMFTileOverlay_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@interface FMFTileURLConstructor : NSObject<MFTileURLConstructor>
@property(copy, nonatomic, readonly) NSString* urlPattern;
- (instancetype)initWithUrlPattern:(NSString*)urlPattern;
//- (instancetype)initWithChannel:(FlutterMethodChannel*)channel tileOverlayId:(NSString*)tileOverlayId;
@end

@protocol FMFTileOverlayOptionsSink
- (void)setZIndex:(int)zIndex;
- (void)setVisible:(BOOL)visible;
@end

@interface FMFTileOverlay : NSObject<FMFTileOverlayOptionsSink>
@property(copy, nonatomic, readonly) NSString* tileOverlayId;
- (instancetype)initWithTileURLConstructor:(FMFTileURLConstructor*) constructor tileOverlayId:(NSString*)tileOverlayId;
- (void)removeTileOverlay;
- (void)clearTileCache;
//
- (void)addToMap:(MFMapView*)mapView;
- (void)interpretTileOverlayOptions:(NSDictionary*)data;
@end

#endif /* FMFTileOverlay_h */
