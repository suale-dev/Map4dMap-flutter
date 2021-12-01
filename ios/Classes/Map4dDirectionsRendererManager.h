//
//  Map4dDirectionsRendererManager.h
//  Map4dMap Flutter
//
//  Created by Huy Dang on 12/1/21.
//

#ifndef Map4dDirectionsRendererManager_h
#define Map4dDirectionsRendererManager_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@interface Map4dDirectionsRendererManager : NSObject

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

- (void)addDirectionsRenderers:(NSArray*)directionsRenderers;
- (void)changeDirectionsRenderers:(NSArray*)directionsRenderers;
- (void)removeDirectionsRendererIds:(NSArray*)ids;
- (NSString*)getDirectionsRendererId:(MFDirectionsRenderer*)renderer;

@end

#endif /* Map4dDirectionsRendererManager_h */
