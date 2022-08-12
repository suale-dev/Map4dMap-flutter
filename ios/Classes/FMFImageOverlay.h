//
//  FMFImageOverlay.h
//  map4d_map
//
//  Created by Huy Dang on 12/08/2022.
//

#ifndef FMFImageOverlay_h
#define FMFImageOverlay_h

#import <Map4dMap/Map4dMap.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMFImageOverlay : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithImage:(UIImage *)image bounds:(nonnull MFCoordinateBounds *)bounds;

- (void)interpretOptions:(NSDictionary*)options;

- (void)addToMapView:(MFMapView *)mapView;
- (void)removeFromMapView;

@end

NS_ASSUME_NONNULL_END

#endif /* FMFImageOverlay_h */
