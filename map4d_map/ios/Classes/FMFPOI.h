//
//  FMFPOI.h
//  Pods
//
//  Created by Huy Dang on 13/05/2021.
//

#ifndef FMFPOI_h
#define FMFPOI_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@protocol FMFPOIOptionsSink
- (void)setPosition:(CLLocationCoordinate2D)position;
- (void)setTitle:(NSString*)title;
- (void)setTitleColor:(UIColor*)color;
- (void)setSubtitle:(NSString*)subtitle;
- (void)setIcon:(UIImage*)icon;
- (void)setType:(NSString*)type;
- (void)setZIndex:(int)zIndex;
- (void)setVisible:(BOOL)visible;
- (void)setConsumeTapEvents:(BOOL)consume;
@end

@interface FMFPOI : NSObject<FMFPOIOptionsSink>
@property(atomic, readonly) NSString* poiId;
- (instancetype)initPOIWithId:(NSString*)poiId;
- (void)removePOI;
@end

#pragma mark - FMFPOIsController

@interface FMFPOIsController : NSObject
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MFMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addPOIs:(NSArray*)poisToAdd;
- (void)changePOIs:(NSArray*)poisToChange;
- (void)removePOIIds:(NSArray*)poiIdsToRemove;
- (void)onPOITap:(NSString*)poiId;
@end

#endif /* FMFPOI_h */
