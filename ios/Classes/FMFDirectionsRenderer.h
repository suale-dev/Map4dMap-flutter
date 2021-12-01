//
//  FMFDirectionsRenderer.h
//  Map4dMap Flutter
//
//  Created by Huy Dang on 12/1/21.
//

#ifndef FMFDirectionsRenderer_h
#define FMFDirectionsRenderer_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@interface FMFDirectionsRenderer : MFDirectionsRenderer

@property(atomic, readonly) NSString* rendererId;

- (instancetype)initWithId:(NSString *)rendererId;
- (void)interpretOptions:(NSDictionary *)data registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end

#endif /* FMFDirectionsRenderer_h */
