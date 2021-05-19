//
//  FMFConvert.m
//  map4d_map
//
//  Created by Huy Dang on 07/05/2021.
//

#import "FMFConvert.h"
#import <Map4dMap/Map4dMap.h>

@implementation FMFConvert

+ (bool)toBool:(NSNumber*)data {
  return data.boolValue;
}

+ (int)toInt:(NSNumber*)data {
  return data.intValue;
}

+ (double)toDouble:(NSNumber*)data {
  return data.doubleValue;
}

+ (float)toFloat:(NSNumber*)data {
  return data.floatValue;
}

+ (CLLocationCoordinate2D)toLocation:(NSArray*)data {
  return CLLocationCoordinate2DMake([FMFConvert toDouble:data[0]], [FMFConvert toDouble:data[1]]);
}

+ (CGPoint)toPoint:(NSArray*)data {
  return CGPointMake([FMFConvert toDouble:data[0]], [FMFConvert toDouble:data[1]]);
}

+ (MFPolylineStyle)toPolylineStyle:(NSNumber*)data {
  switch (data.intValue) {
    case 1:
      return MFPolylineStyleDotted;
      break;
    default:
      return MFPolylineStyleSolid;
      break;
  }
}

+ (UIColor*)toColor:(NSNumber*)numberColor {
  unsigned long value = [numberColor unsignedLongValue];
  return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)) / 255.0
                         green:((float)((value & 0xFF00) >> 8)) / 255.0
                          blue:((float)(value & 0xFF)) / 255.0
                         alpha:((float)((value & 0xFF000000) >> 24)) / 255.0];
}

+ (NSArray<CLLocation*>*)toPoints:(NSArray*)data {
  NSMutableArray* points = [[NSMutableArray alloc] init];
  for (unsigned i = 0; i < [data count]; i++) {
    NSNumber* latitude = data[i][0];
    NSNumber* longitude = data[i][1];
    CLLocation* point = [[CLLocation alloc] initWithLatitude:[FMFConvert toDouble:latitude]
                                                   longitude:[FMFConvert toDouble:longitude]];
    [points addObject:point];
  }

  return points;
}

+ (NSArray<NSArray<CLLocation*>*>*)toHoles:(NSArray*)data {
  NSMutableArray<NSArray<CLLocation*>*>* holes = [[[NSMutableArray alloc] init] init];
  for (unsigned i = 0; i < [data count]; i++) {
    NSArray<CLLocation*>* points = [FMFConvert toPoints:data[i]];
    [holes addObject:points];
  }

  return holes;
}

+ (MFCoordinateBounds*) toCoordinateBounds:(NSArray*)data {
  CLLocationCoordinate2D loc0 = [FMFConvert toLocation:data[0]];
  CLLocationCoordinate2D loc1 = [FMFConvert toLocation:data[1]];
  return [[MFCoordinateBounds alloc] initWithCoordinate:loc0 coordinate1:loc1];
}

+ (MFCameraPosition*)toCameraPosition:(NSDictionary*)data {
  if (data == nil || [data isEqual:[NSNull null]]) {
    return nil;
  }

  CLLocationCoordinate2D target = [FMFConvert toLocation:data[@"target"]];
  float zoom = [FMFConvert toFloat:data[@"zoom"]];
  double bearing = [FMFConvert toDouble:data[@"bearing"]];
  double tilt = [FMFConvert toDouble:data[@"tilt"]];
  return [[MFCameraPosition alloc] initWithTarget:target zoom:zoom tilt:tilt bearing:bearing];
}

+ (MFCameraUpdate*)toCameraUpdate:(NSArray*)data {
  if (data == nil || [data isEqual:[NSNull null]]) {
    return nil;
  }

  NSString* update = data[0];
  if ([update isEqualToString:@"newCameraPosition"]) {
    MFCameraPosition* position = [FMFConvert toCameraPosition:data[1]];
    return [MFCameraUpdate setCamera:position];
  } else if ([update isEqualToString:@"newLatLng"]) {
    CLLocationCoordinate2D location = [FMFConvert toLocation:data[1]];
    return [MFCameraUpdate setTarget:location];
  } else if ([update isEqualToString:@"newLatLngBounds"]) {
    MFCoordinateBounds* bounds = [FMFConvert toCoordinateBounds:data[1]];
    return [MFCameraUpdate fitBounds:bounds];
  } else if ([update isEqualToString:@"newLatLngZoom"]) {
    CLLocationCoordinate2D target = [FMFConvert toLocation:data[1]];
    float zoom = [FMFConvert toFloat:data[2]];
    return [MFCameraUpdate setTarget:target zoom:zoom];
//  } else if ([update isEqualToString:@"scrollBy"]) {
//    return [MFCameraUpdate scrollByX:ToDouble(data[1]) Y:ToDouble(data[2])];
//  } else if ([update isEqualToString:@"zoomBy"]) {
//    if (data.count == 2) {
//      return [MFCameraUpdate zoomBy:ToFloat(data[1])];
//    } else {
//      return [MFCameraUpdate zoomBy:ToFloat(data[1]) atPoint:ToPoint(data[2])];
//    }
//  } else if ([update isEqualToString:@"zoomIn"]) {
//    return [MFCameraUpdate zoomIn];
//  } else if ([update isEqualToString:@"zoomOut"]) {
//    return [MFCameraUpdate zoomOut];
//  } else if ([update isEqualToString:@"zoomTo"]) {
//    return [MFCameraUpdate zoomTo:ToFloat(data[1])];
  }
  return nil;
}

+ (NSArray*) locationToJson:(CLLocationCoordinate2D)location {
  return @[ @(location.latitude), @(location.longitude) ];
}

+ (NSDictionary*) positionToJson:(MFCameraPosition*)position {
  if (!position) {
    return nil;
  }
  return @{
    @"target" : [FMFConvert locationToJson:position.target],
    @"zoom" : @(position.zoom),
    @"bearing" : @(position.bearing),
    @"tilt" : @(position.tilt),
  };
}

+ (UIImage*)scaleImage:(UIImage*)image scale:(NSNumber*)scaleParam {
  double scale = 1.0;
  if ([scaleParam isKindOfClass:[NSNumber class]]) {
    scale = scaleParam.doubleValue;
  }

  if (fabs(scale - 1) > 1e-3) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * scale)
                         orientation:(image.imageOrientation)];
  }
  return image;
}

+ (UIImage*)extractIcon:(NSArray*)iconData registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  UIImage* image = nil;
  
  if ([iconData.firstObject isEqualToString:@"defaultMarker"]) {
    image = nil;
  } else if ([iconData.firstObject isEqualToString:@"fromAsset"]) {
    if (iconData.count == 2) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
    } else {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1] fromPackage:iconData[2]]];
    }
  } else if ([iconData.firstObject isEqualToString:@"fromAssetImage"]) {
    if (iconData.count == 3) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
      NSNumber* scaleParam = iconData[2];
      image = [FMFConvert scaleImage:image scale:scaleParam];
    } else {
      NSLog(@"InvalidBitmapDescriptor | 'fromAssetImage' should have exactly 3 arguments. Got: %lu",
            (unsigned long)iconData.count);
    }
  } else if ([iconData[0] isEqualToString:@"fromBytes"]) {
    if (iconData.count == 2) {
      @try {
        FlutterStandardTypedData* byteData = iconData[1];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        image = [UIImage imageWithData:[byteData data] scale:screenScale];
      } @catch (NSException* exception) {
        NSLog(@"InvalidBitmapDescriptor | Unable to interpret bytes as a valid image.");
      }
    } else {
      NSLog(@"InvalidByteDescriptor | 'fromBytes' should have exactly 2 arguments, the bytes. Got: %lu",
            (unsigned long)iconData.count);
    }
  }
  
  return image;
}

@end
