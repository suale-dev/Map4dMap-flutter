//
//  FMFBuilding.h
//  Pods
//
//  Created by Huy Dang on 14/05/2021.
//

#ifndef FMFBuilding_h
#define FMFBuilding_h

#import <Map4dMap/Map4dMap.h>
#import <Flutter/Flutter.h>

@protocol FMFBuildingOptionsSink
- (void)setConsumeTapEvents:(BOOL)consume;
- (void)setVisible:(BOOL)visible;
- (void)setName:(NSString*)name;
- (void)setPosition:(CLLocationCoordinate2D)position;
- (void)setModel:(NSString*)model;
- (void)setTexture:(NSString*)texture;
- (void)setCoordinates:(NSArray<CLLocation*>*)coordinates;
- (void)setHeight:(double)height;
- (void)setScale:(double)scale;
- (void)setBearing:(CGFloat)bearing;
- (void)setElevation:(double)elevation;
- (void)setSelected:(bool)selected;
@end

@interface FMFBuilding : NSObject<FMFBuildingOptionsSink>

@property(atomic, readonly) NSString* buildingId;

- (instancetype)initBuildingWithId:(NSString*)buildingId;
- (void)setMap:(MFMapView*)mapView;
- (void)removeBuilding;
- (void)interpretBuildingOptions:(NSDictionary*)data;

@end

#endif /* FMFBuilding_h */
