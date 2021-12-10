#import <Flutter/Flutter.h>

@interface Map4dMapPlugin : NSObject<FlutterPlugin>
@property(class, nonnull, readonly) Map4dMapPlugin* instance;

- (id<FlutterPlatformView> _Nullable)getFlutterMapViewById:(int64_t)viewId;
@end
