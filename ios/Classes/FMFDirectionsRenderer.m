//
//  FMFDirectionsRenderer.m
//  Map4dMap Flutter
//
//  Created by Huy Dang on 12/1/21.
//

#import "FMFDirectionsRenderer.h"
#import "Map4dFLTConvert.h"

@implementation FMFDirectionsRenderer

- (instancetype)initWithId:(NSString *)rendererId {
  if (self = [super init]) {
    _rendererId = rendererId;
  }
  return self;
}

- (void)interpretOptions:(NSDictionary *)data registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  
  NSArray* routes = data[@"routes"];
  if (routes != nil) {
    self.routes = [Map4dFLTConvert toPaths:routes];
  }
  
  NSString* directions = data[@"directions"];
  if (self.routes.count == 0 && directions != nil) {
    [self setRoutesWithJson:directions];
  }
  
  NSNumber* activedIndex = data[@"activedIndex"];
  if (activedIndex != nil) {
    int index = [Map4dFLTConvert toInt:activedIndex];
    self.activedIndex = index > 0 ? index : 0;
  }
  
  NSNumber* activeStrokeWidth = data[@"activeStrokeWidth"];
  if (activeStrokeWidth != nil) {
    int width = [Map4dFLTConvert toInt:activeStrokeWidth];
    if (width < 0) {
      width = 0;
    }
    if ((int)self.activeStrokeWidth != width) {
      self.activeStrokeWidth = width;
    }
  }
  
  NSNumber* activeStrokeColor = data[@"activeStrokeColor"];
  if (activeStrokeColor != nil) {
    self.activeStrokeColor = [Map4dFLTConvert toColor:activeStrokeColor];
  }
  
  NSNumber* activeOutlineWidth = data[@"activeOutlineWidth"];
  if (activeOutlineWidth != nil) {
    int width = [Map4dFLTConvert toInt:activeOutlineWidth];
    if (width < 0) {
      width = 0;
    }
    if ((int)self.activeOutlineWidth != width) {
      self.activeOutlineWidth = width;
    }
  }
  
  NSNumber* activeOutlineColor = data[@"activeOutlineColor"];
  if (activeOutlineColor != nil) {
    self.activeOutlineColor = [Map4dFLTConvert toColor:activeOutlineColor];
  }
  
  NSNumber* inactiveStrokeWidth = data[@"inactiveStrokeWidth"];
  if (inactiveStrokeWidth != nil) {
    int width = [Map4dFLTConvert toInt:inactiveStrokeWidth];
    if (width < 0) {
      width = 0;
    }
    if ((int)self.inactiveStrokeWidth != width) {
      self.inactiveStrokeWidth = width;
    }
  }
  
  NSNumber* inactiveStrokeColor = data[@"inactiveStrokeColor"];
  if (inactiveStrokeColor != nil) {
    self.inactiveStrokeColor = [Map4dFLTConvert toColor:inactiveStrokeColor];
  }
  
  NSNumber* inactiveOutlineWidth = data[@"inactiveOutlineWidth"];
  if (inactiveOutlineWidth != nil) {
    int width = [Map4dFLTConvert toInt:inactiveOutlineWidth];
    if (width < 0) {
      width = 0;
    }
    if ((int)self.inactiveOutlineWidth != width) {
      self.inactiveOutlineWidth = width;
    }
  }
  
  NSNumber* inactiveOutlineColor = data[@"inactiveOutlineColor"];
  if (inactiveOutlineColor != nil) {
    self.inactiveOutlineColor = [Map4dFLTConvert toColor:inactiveOutlineColor];
  }
  
  NSDictionary* originPOIOptions = data[@"originPOIOptions"];
  if (originPOIOptions != nil) {
    NSArray* position = originPOIOptions[@"position"];
    if (position) {
      self.originPosition = [Map4dFLTConvert toLocation:position];
    }
    
    NSArray* icon = originPOIOptions[@"icon"];
    if (icon) {
      self.originIcon = [Map4dFLTConvert extractIcon:icon registrar:registrar];
    }
    
    NSString* title = originPOIOptions[@"title"];
    if (title != nil) {
      self.originTitle = title;
    }
    
    NSNumber* titleColor = originPOIOptions[@"titleColor"];
    if (titleColor != nil) {
      self.originTitleColor = [Map4dFLTConvert toColor:titleColor];
    }
    
    NSNumber* visible = originPOIOptions[@"visible"];
    if (visible != nil) {
      self.hideOriginPOI = ![Map4dFLTConvert toBool:visible];
    }
  }
  
  NSDictionary* destinationPOIOptions = data[@"destinationPOIOptions"];
  if (destinationPOIOptions != nil) {
    NSArray* position = destinationPOIOptions[@"position"];
    if (position) {
      self.destinationPosition = [Map4dFLTConvert toLocation:position];
    }
    
    NSArray* icon = destinationPOIOptions[@"icon"];
    if (icon) {
      self.destinationIcon = [Map4dFLTConvert extractIcon:icon registrar:registrar];
    }
    
    NSString* title = destinationPOIOptions[@"title"];
    if (title != nil) {
      self.destinationTitle = title;
    }
    
    NSNumber* titleColor = destinationPOIOptions[@"titleColor"];
    if (titleColor != nil) {
      self.destinationTitleColor = [Map4dFLTConvert toColor:titleColor];
    }
    
    NSNumber* visible = destinationPOIOptions[@"visible"];
    if (visible != nil) {
      self.hideDestinationPOI = ![Map4dFLTConvert toBool:visible];
    }
  }
}

@end
