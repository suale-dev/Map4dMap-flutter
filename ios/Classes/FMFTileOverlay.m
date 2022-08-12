//
//  FMFTileOverlay.m
//  map4d_map
//
//  Created by Huy Dang on 17/05/2021.
//

#import "FMFTileOverlay.h"
#import "Map4dFLTConvert.h"

@implementation FMFTileOverlay {
  MFURLTileLayer* _overlay;
}

- (instancetype)initWithTileURLConstructor:(FMFTileURLConstructor*)constructor tileOverlayId:(NSString*)tileOverlayId {
  self = [super init];
  if (self) {
    _overlay = [MFURLTileLayer tileLayerWithURLConstructor:constructor];
    _overlay.userData = @[ tileOverlayId ];
    _tileOverlayId = tileOverlayId;
  }
  return self;
}

- (void)removeTileOverlay {
  _overlay.map = nil;
}

- (void)clearTileCache {
  [_overlay clearTileCache];
}

- (void)addToMap:(MFMapView*)mapView {
  _overlay.map = mapView;
}

- (void)setZIndex:(int)zIndex {
  _overlay.zIndex = zIndex;
}

- (void)setVisible:(BOOL)visible {
  _overlay.isHidden = !visible;
}

//
- (void)interpretTileOverlayOptions:(NSDictionary *)data {
  NSNumber *transparency = data[@"transparency"];
  if (transparency) {
    _overlay.opacity = 1.0 - transparency.doubleValue;
  }
  
  NSNumber *visible = data[@"visible"];
  if (visible != nil) {
    [self setVisible:[Map4dFLTConvert toBool:visible]];
  }
  
  NSNumber *zIndex = data[@"zIndex"];
  if (zIndex != nil) {
    [self setZIndex:[Map4dFLTConvert toInt:zIndex]];
  }
}

@end


@implementation FMFTileURLConstructor

- (instancetype)initWithUrlPattern:(NSString *)urlPattern {
  self = [super init];
  if (self) {
    _urlPattern = urlPattern;
  }
  return self;
}

- (NSURL * _Nullable)getTileUrlWithX:(NSUInteger)x y:(NSUInteger)y zoom:(NSUInteger)zoom is3dMode:(bool)is3dMode {
  if (_urlPattern == nil) {
    return nil;
  }

  NSString* url = [_urlPattern stringByReplacingOccurrencesOfString:@"{zoom}" withString:[@(zoom) stringValue]];
  url = [url stringByReplacingOccurrencesOfString:@"{x}" withString:[@(x) stringValue]];
  url = [url stringByReplacingOccurrencesOfString:@"{y}" withString:[@(y) stringValue]];
  return [NSURL URLWithString:url];
}


//- (NSURL * _Nullable)getTileUrlWithX:(NSUInteger)x y:(NSUInteger)y zoom:(NSUInteger)zoom is3dMode:(bool)is3dMode {
//  NSDictionary* arguments = @{
//    @"tileOverlayId": _tileOverlayId,
//    @"x": @(x),
//    @"y": @(y),
//    @"zoom": @(zoom),
//    @"is3dMode": @(is3dMode)
//  };
//
//  __block NSString* url = nil;
//  [_channel invokeMethod:@"tileOverlay#getTileUrl" arguments:arguments result:^(id  _Nullable result) {
//    NSLog(@"invokeMethod:@'tileOverlay#getTile' | result: %@", result);
//    if ([result isKindOfClass:[NSString class]]) {
//      url = (NSString*) result;
//      NSLog(@"Tile url: %@", url);
//    }
//    else {
//      if ([result isKindOfClass:[FlutterError class]]) {
//        FlutterError* error = (FlutterError*)result;
//        NSLog(@"Can't get tile: errorCode = %@, errorMessage = %@, details = %@", [error code], [error message], [error details]);
//      }
//      if ([result isKindOfClass:[FlutterMethodNotImplemented class]]) {
//        NSLog(@"Can't get tile: notImplemented");
//      }
//    }
//  }];
//
//  //wait ......
//  return [NSURL URLWithString:url];
//}

@end
