//
//  Map4dOverlayManager.m
//  map4d_map
//
//  Created by Huy Dang on 17/05/2021.
//

#import "Map4dOverlayManager.h"
#import "FMFTileOverlay.h"

@interface Map4dOverlayManager()
@property(nonatomic, weak) MFMapView* mapView;
@property(nonatomic, weak) FlutterMethodChannel* channel;
@property(nonatomic, weak) NSObject<FlutterPluginRegistrar>* registrar;

@property(nonatomic, strong) NSMutableDictionary* tileOverlays;
@end


@implementation Map4dOverlayManager


- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  self = [super init];
  if (self) {
    _channel = methodChannel;
    _registrar = registrar;
    _mapView = mapView;
    _tileOverlays = [NSMutableDictionary dictionaryWithCapacity:1];
  }
  return self;
}

- (void)addTileOverlays:(NSArray *)tileOverlaysToAdd {
  for (NSDictionary* tileOverlay in tileOverlaysToAdd) {
    NSString* tileOverlayId = tileOverlay[@"tileOverlayId"];
    NSString* urlPattern = tileOverlay[@"urlPattern"];
    FMFTileURLConstructor* constructor = [[FMFTileURLConstructor alloc] initWithUrlPattern:urlPattern];
    FMFTileOverlay* overlay = [[FMFTileOverlay alloc] initWithTileURLConstructor:constructor tileOverlayId:tileOverlayId];
    [overlay interpretTileOverlayOptions:tileOverlay];
    [overlay addToMap:_mapView];
    _tileOverlays[tileOverlayId] = overlay;
  }
}

- (void)changeTileOverlays:(NSArray *)tileOverlaysToChange {
  for (NSDictionary* tileOverlayData in tileOverlaysToChange) {
    NSString* tileOverlayId = tileOverlayData[@"tileOverlayId"];
    FMFTileOverlay* overlay = _tileOverlays[tileOverlayId];
    if (overlay != nil) {
      [overlay interpretTileOverlayOptions:tileOverlayData];
    }
  }
}

- (void)removeTileOverlayIds:(NSArray *)tileOverlayIdsToRemove {
  for (NSString* tileOverlayId in tileOverlayIdsToRemove) {
    if (!tileOverlayId) {
      continue;
    }
    FMFTileOverlay* overlay = _tileOverlays[tileOverlayId];
    if (overlay != nil) {
      [overlay removeTileOverlay];
      [_tileOverlays removeObjectForKey:tileOverlayId];
    }
  }
}

- (void)clearTileOverlayCache:(NSString *)tileOverlayId {
  if (!tileOverlayId) {
    return;
  }
  FMFTileOverlay* overlay = _tileOverlays[tileOverlayId];
  if (overlay != nil) {
    [overlay clearTileCache];
  }
}

@end
