#import "Map4dMapPlugin.h"
#import "FMFMapView.h"

static Map4dMapPlugin *sharedInstance = nil;

@interface Map4dMapPlugin()
@property(nonatomic, strong, nonnull) NSMutableArray* mapFactories;
@end

@implementation Map4dMapPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FMFMapViewFactory* mapFactory = [[FMFMapViewFactory alloc] initWithRegistrar:registrar];
  
  [registrar registerViewFactory:mapFactory
                          withId:@"plugin:map4d-map-view-type"
gestureRecognizersBlockingPolicy:
   FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];
  
  [Map4dMapPlugin.instance.mapFactories addObject:mapFactory];
}

+ (Map4dMapPlugin *)instance {
  if (sharedInstance == nil) {
    sharedInstance = [[super allocWithZone:NULL] init];
  }
  return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [Map4dMapPlugin instance];
}

- (instancetype)init {
  if (self = [super init]) {
    _mapFactories = [NSMutableArray arrayWithCapacity:1];
  }
  return self;
}

- (id<FlutterPlatformView>)getFlutterMapViewById:(int64_t)viewId {
  for (FMFMapViewFactory* mapFactory in _mapFactories) {
    id<FlutterPlatformView> view = [mapFactory getFlutterMapViewById:viewId];
    if (view != nil) {
      return view;
    }
  }
  return nil;
}

@end
