#import "Map4dMapPlugin.h"
#import "FMFMapView.h"

@implementation Map4dMapPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FMFMapViewFactory* mapFactory = [[FMFMapViewFactory alloc] initWithRegistrar:registrar];
  
  [registrar registerViewFactory:mapFactory
                          withId:@"plugin:map4d-map-view-type"
gestureRecognizersBlockingPolicy:
   FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];
  
}

@end
