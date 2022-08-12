//
//  FMFImageOverlay.m
//  map4d_map
//
//  Created by Huy Dang on 12/08/2022.
//

#import "FMFImageOverlay.h"

@interface FMFImageOverlay ()
@property(nonatomic, strong, nonnull) MFImageOverlay *overlay;
@end

@implementation FMFImageOverlay

- (instancetype)initWithImage:(UIImage *)image bounds:(MFCoordinateBounds *)bounds {
  self = [super init];
  if (self) {
    _overlay = [MFImageOverlay imageOverlayWithImage:image bounds:bounds];
  }
  return self;
}

- (void)interpretOptions:(NSDictionary *)options {
  NSNumber *transparency = options[@"transparency"];
  if (transparency) {
    _overlay.opacity = 1.0 - transparency.doubleValue;
  }
  
  NSNumber *visible = options[@"visible"];
  if (visible != nil) {
    _overlay.isHidden = !visible.boolValue;
  }
  
  NSNumber *zIndex = options[@"zIndex"];
  if (zIndex != nil) {
    _overlay.zIndex = visible.integerValue;
  }
}

- (void)addToMapView:(MFMapView *)mapView {
  _overlay.map = mapView;
}

- (void)removeFromMapView {
  _overlay.map = nil;
}

@end
