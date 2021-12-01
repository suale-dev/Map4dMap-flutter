//
//  Map4dDirectionsRendererManager.m
//  Map4dMap Flutter
//
//  Created by Huy Dang on 12/1/21.
//

#import "Map4dDirectionsRendererManager.h"
#import "FMFDirectionsRenderer.h"

@interface Map4dDirectionsRendererManager()

@property(nonatomic, weak) MFMapView* mapView;
@property(nonatomic, weak) FlutterMethodChannel* channel;
@property(nonatomic, weak) NSObject<FlutterPluginRegistrar>* registrar;
@property(nonatomic, strong) NSMutableDictionary* renderers;

@end

@implementation Map4dDirectionsRendererManager

- (instancetype)init:(FlutterMethodChannel *)methodChannel
             mapView:(MFMapView *)mapView
           registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  if (self = [super init]) {
    _channel = methodChannel;
    _registrar = registrar;
    _mapView = mapView;
    _renderers = [NSMutableDictionary dictionaryWithCapacity:1];
  }
  return self;
}

- (void)addDirectionsRenderers:(NSArray *)directionsRenderers {
  for (NSDictionary* data in directionsRenderers) {
    NSString* rendererId = data[@"rendererId"];
    FMFDirectionsRenderer* renderer = [[FMFDirectionsRenderer alloc] initWithId:rendererId];
    [renderer interpretOptions:data registrar:_registrar];
    [renderer setMap:_mapView];
    _renderers[rendererId] = renderer;
  }
}

- (void)changeDirectionsRenderers:(NSArray *)directionsRenderers {
  for (NSDictionary* data in directionsRenderers) {
    NSString* rendererId = data[@"rendererId"];
    FMFDirectionsRenderer* renderer = _renderers[rendererId];
    if (renderer != nil) {
      [renderer interpretOptions:data registrar:_registrar];
    }
  }
}

- (void)removeDirectionsRendererIds:(NSArray *)ids {
  for (NSString* rendererId in ids) {
    if (!rendererId) continue;
    FMFDirectionsRenderer* renderer = _renderers[rendererId];
    if (renderer != nil) {
      [renderer setMap:nil];
      [_renderers removeObjectForKey:rendererId];
    }
  }
}

- (NSString *)getDirectionsRendererId:(MFDirectionsRenderer *)renderer {
  FMFDirectionsRenderer* fRenderer = (FMFDirectionsRenderer*)renderer;
  return fRenderer.rendererId;
}

@end
