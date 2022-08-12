//
//  Map4dOverlayManager.m
//  map4d_map
//
//  Created by Huy Dang on 17/05/2021.
//

#import "Map4dOverlayManager.h"
#import "Map4dFLTConvert.h"
#import "FMFTileOverlay.h"
#import "FMFImageOverlay.h"

@interface Map4dOverlayManager()

@property(nonatomic, weak) MFMapView* mapView;
@property(nonatomic, weak) FlutterMethodChannel* channel;
@property(nonatomic, weak) NSObject<FlutterPluginRegistrar>* registrar;

@property(nonatomic, strong) NSMutableDictionary* tileOverlays;
@property(nonatomic, strong) NSMutableDictionary* imageOverlays;

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
    _imageOverlays = [NSMutableDictionary dictionaryWithCapacity:1];
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

- (void)addImageOverlays:(NSArray *)imageOverlaysToAdd {
  for (NSDictionary *options in imageOverlaysToAdd) {
    NSString *overlayId = options[@"imageOverlayId"];
    UIImage *image = [Map4dFLTConvert extractIcon:options[@"image"] registrar:_registrar];
    MFCoordinateBounds *bounds = [Map4dFLTConvert toCoordinateBounds:options[@"bounds"]];
    FMFImageOverlay *imageOverlay = [[FMFImageOverlay alloc] initWithImage:image bounds:bounds];
    [imageOverlay interpretOptions:options];
    [imageOverlay addToMapView:_mapView];
    _imageOverlays[overlayId] = imageOverlay;
  }
}

- (void)changeImageOverlays:(NSArray *)imageOverlaysToChange {
  for (NSDictionary *options in imageOverlaysToChange) {
    NSString *overlayId = options[@"imageOverlayId"];
    FMFImageOverlay *overlay = _imageOverlays[overlayId];
    [overlay interpretOptions:options];
  }
}

- (void)removeImageOverlayIds:(NSArray *)imageOverlayIdsToRemove {
  for (NSString *overlayId in imageOverlayIdsToRemove) {
    FMFImageOverlay *overlay = _imageOverlays[overlayId];
    if (overlay) {
      [overlay removeFromMapView];
      [_imageOverlays removeObjectForKey:overlayId];
    }
  }
}

@end
