#import "Map4dMapPlugin.h"
#if __has_include(<map4d_map/map4d_map-Swift.h>)
#import <map4d_map/map4d_map-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "map4d_map-Swift.h"
#endif

@implementation Map4dMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMap4dMapPlugin registerWithRegistrar:registrar];
}
@end
