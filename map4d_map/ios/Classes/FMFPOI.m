//
//  FMFPOI.m
//  map4d_map
//
//  Created by Huy Dang on 13/05/2021.
//

#import "FMFPOI.h"
#import "FMFInterpretation.h"

@implementation FMFPOI {
  MFPOI* _poi;
}

- (instancetype)initPOIWithId:(NSString *)poiId {
  self = [super init];
  if (self) {
    _poi = [[MFPOI alloc] init];
    _poi.userData = @[ poiId ];
    _poiId = poiId;
  }
  return self;
}

- (void)removePOI {
  _poi.map = nil;
}

- (void)addToMap:(MFMapView*)mapView {
  _poi.map = mapView;
}

/*
 FMFPOIOptionsSink
 */
- (void)setPosition:(CLLocationCoordinate2D)position {
  _poi.position = position;
}

- (void)setTitle:(NSString*)title {
  _poi.title = title;
}

- (void)setTitleColor:(UIColor*)color {
  _poi.titleColor = color;
}

- (void)setSubtitle:(NSString*)subtitle {
  _poi.subtitle = subtitle;
}

- (void)setIcon:(UIImage*)icon {
  _poi.icon = icon;
}

- (void)setType:(NSString*)type {
  _poi.type = type;
}

- (void)setZIndex:(int)zIndex {
  _poi.zIndex = zIndex;
}

- (void)setVisible:(BOOL)visible {
  _poi.isHidden = !visible;
}

- (void)setConsumeTapEvents:(BOOL)consume {
  _poi.userInteractionEnabled = consume;
}

@end


#pragma mark - FMFPOIsController

@implementation FMFPOIsController {
  NSMutableDictionary<NSString*, FMFPOI*>* _pois;
  MFMapView* _mapView;
  FlutterMethodChannel* _channel;
  NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  self = [super init];
  if (self) {
    _channel = methodChannel;
    _mapView = mapView;
    _pois = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addPOIs:(NSArray*)poisToAdd {
  for (NSDictionary* poi in poisToAdd) {
    NSString* poiId = poi[@"poiId"];
    FMFPOI* fPOI = [[FMFPOI alloc] initPOIWithId:poiId];
    [FMFInterpretation interpretPOIOptions:poi sink:fPOI];
    [fPOI addToMap:_mapView];
    _pois[poiId] = fPOI;
  }
}

- (void)changePOIs:(NSArray*)poisToChange {
  for (NSDictionary* poi in poisToChange) {
    NSString* poiId = poi[@"poiId"];
    FMFPOI* fPOI = _pois[poiId];
    if (fPOI != nil) {
      [FMFInterpretation interpretPOIOptions:poi sink:fPOI];
    }
  }
}

- (void)removePOIIds:(NSArray*)poiIdsToRemove {
  for (NSString* poiId in poiIdsToRemove) {
    if (!poiId) {
      continue;
    }
    FMFPOI* fPOI = _pois[poiId];
    if (fPOI != nil) {
      [fPOI removePOI];
      [_pois removeObjectForKey:poiId];
    }
  }
}
- (void)onPOITap:(NSString*)poiId {
  if (!poiId) return;
  FMFPOI* fPOI = _pois[poiId];
  if (fPOI != nil) {
    [_channel invokeMethod:@"poi#onTap" arguments:@{@"poiId" : poiId}];
  }
}

@end
