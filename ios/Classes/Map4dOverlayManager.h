//
//  Map4dOverlayManager.h
//  Pods
//
//  Created by Huy Dang on 17/05/2021.
//

#ifndef Map4dOverlayManager_h
#define Map4dOverlayManager_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@interface Map4dOverlayManager : NSObject

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

- (void)addTileOverlays:(NSArray *)tileOverlaysToAdd;
- (void)changeTileOverlays:(NSArray *)tileOverlaysToChange;
- (void)removeTileOverlayIds:(NSArray *)tileOverlayIdsToRemove;
- (void)clearTileOverlayCache:(NSString *)tileOverlayId;

- (void)addImageOverlays:(NSArray *)imageOverlaysToAdd;
- (void)changeImageOverlays:(NSArray *)imageOverlaysToChange;
- (void)removeImageOverlayIds:(NSArray *)imageOverlayIdsToRemove;

@end

#endif /* Map4dOverlayManager_h */
