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
- (void)setMap:(MFMapView*)mapView;
- (void)removePOI;
- (void)interpretPOIOptions:(NSDictionary*)data registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
@end

#endif /* FMFPOI_h */
