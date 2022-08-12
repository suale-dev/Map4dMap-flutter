//
//  FMFMapView.m
//  map4d_map
//
//  Created by Sua Le on 05/05/2021.
//


#import "FMFMapView.h"
#import "Map4dFLTConvert.h"
#import "Map4dFLTMethod.h"
#import "Map4dAnnotationManager.h"
#import "Map4dOverlayManager.h"
#import "Map4dDirectionsRendererManager.h"

#define kMFMinZoomLevel 2
#define kMFMaxZoomLevel 22

#pragma mark - FMFMapView Extension

@interface FMFMapView()
@property(nonatomic, strong) Map4dOverlayManager* overlayManager;
@property(nonatomic, strong) Map4dAnnotationManager* annotationManager;
@property(nonatomic, strong) Map4dDirectionsRendererManager* directionsRendererManager;
@property(nonatomic, assign) int64_t viewId;
@end

#pragma mark - FMFMapViewFactory

@implementation FMFMapViewFactory {
  NSObject<FlutterPluginRegistrar>* _registrar;
  NSMutableArray<FMFMapView*>* _flutterMapViews;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  if (self = [super init]) {
    _registrar = registrar;
    _flutterMapViews = [NSMutableArray arrayWithCapacity:1];
  }
  return self;
}

- (id<FlutterPlatformView>)getFlutterMapViewById:(int64_t)viewId {
  for (FMFMapView* view in _flutterMapViews) {
    if (view.viewId == viewId) {
      return view;
    }
  }
  return  nil;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  FMFMapView* view = [[FMFMapView alloc] initWithFrame:frame
                                        viewIdentifier:viewId
                                             arguments:args
                                             registrar:_registrar];
  [_flutterMapViews addObject:view];
  return view;
}
@end

#pragma mark - Event tracking configurations

@interface FMFEventTracking : NSObject
@property (nonatomic) BOOL cameraPosition;
@end
@implementation FMFEventTracking
- (instancetype)init {
  self = [super init];
  if (self) {
    _cameraPosition = NO;
  }
  return self;
}
@end


#pragma mark - FMFMapView

@implementation FMFMapView {
  MFMapView* _mapView;
  FlutterMethodChannel* _channel;
  NSObject<FlutterPluginRegistrar>* _registrar;
  FMFEventTracking* _track;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  if (self = [super init]) {
    _viewId = viewId;
    _registrar = registrar;
    _track = [[FMFEventTracking alloc] init];
    
    // setup MFMapView
    _mapView = [[MFMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    [self setupMapViewWithArguments:args];
    
    // flutter channel
    NSString* channelName = [NSString stringWithFormat:@"plugin:map4d-map-view-type_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName
                                           binaryMessenger:registrar.messenger];
    __weak __typeof__(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall * call, FlutterResult result) {
      if (weakSelf) {
        [weakSelf onMethodCall:call result:result];
      }
    }];
    
    // setup annotation manger & init annotations
    [self setupAnnotationWithArguments:args];
    
    // setup annotation manger & init overlays
    [self setupOverlayWithArguments:args];
    
    // setup directions renderer & init
    [self setupDirectionsRendererWithArguments:args];
  }
  return self;
}

- (void)setupMapViewWithArguments:(id _Nullable)args {
  // initial map options
  [self interpretMapOptions:args[@"options"]];
  
  // initial camera position
  MFCameraPosition* camera = [Map4dFLTConvert toCameraPosition:args[@"initialCameraPosition"]];
  if (camera != nil) {
    _mapView.camera = camera;
  }
}

- (void)setupAnnotationWithArguments:(id _Nullable)args {
  _annotationManager = [[Map4dAnnotationManager alloc] init:_channel
                                                    mapView:_mapView
                                                  registrar:_registrar];
  
  id markersToAdd = args[@"markersToAdd"];
  if ([markersToAdd isKindOfClass:[NSArray class]]) {
    [_annotationManager addMarkers:markersToAdd];
  }
  
  id circlesToAdd = args[@"circlesToAdd"];
  if ([circlesToAdd isKindOfClass:[NSArray class]]) {
    [_annotationManager addCircles:circlesToAdd];
  }
  
  id polylinesToAdd = args[@"polylinesToAdd"];
  if ([polylinesToAdd isKindOfClass:[NSArray class]]) {
    [_annotationManager addPolylines:polylinesToAdd];
  }
  
  id polygonsToAdd = args[@"polygonsToAdd"];
  if ([polygonsToAdd isKindOfClass:[NSArray class]]) {
    [_annotationManager addPolygons:polygonsToAdd];
  }
  
  id poisToAdd = args[@"poisToAdd"];
  if ([poisToAdd isKindOfClass:[NSArray class]]) {
    [_annotationManager addPOIs:poisToAdd];
  }
  
  id buildingsToAdd = args[@"buildingsToAdd"];
  if ([buildingsToAdd isKindOfClass:[NSArray class]]) {
    [_annotationManager addBuildings:buildingsToAdd];
  }
}

- (void)setupOverlayWithArguments:(id _Nullable)args {
  _overlayManager = [[Map4dOverlayManager alloc] init:_channel
                                              mapView:_mapView
                                            registrar:_registrar];
  {
    id tileOverlaysToAdd = args[@"tileOverlaysToAdd"];
    if ([tileOverlaysToAdd isKindOfClass:[NSArray class]]) {
      [_overlayManager addTileOverlays:tileOverlaysToAdd];
    }
  }
  
  {
    id imageOverlaysToAdd = args[@"imageOverlaysToAdd"];
    if ([imageOverlaysToAdd isKindOfClass:[NSArray class]]) {
      [_overlayManager addImageOverlays:imageOverlaysToAdd];
    }
  }
}

- (void)setupDirectionsRendererWithArguments:(id _Nullable)args {
  _directionsRendererManager = [[Map4dDirectionsRendererManager alloc] init:_channel
                                                                    mapView:_mapView
                                                                  registrar:_registrar];
  
  id directionsRenderersToAdd = args[@"directionsRenderersToAdd"];
  if ([directionsRenderersToAdd isKindOfClass:[NSArray class]]) {
    [_directionsRendererManager addDirectionsRenderers:directionsRenderersToAdd];
  }
}

- (UIView*)view {
  return _mapView;
}

// Method call handler
- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  FMFMethodID methodID = [[Map4dFLTMethod shared] getIdByName:call.method];
  switch (methodID) {
    /* map # update **/
    case FMFMethodMapUpdate:
      [self interpretMapOptions:call.arguments[@"options"]];
      result(nil);
      break;

    /* map # get zoom level **/
    case FMFMethodGetZoomLevel:
      result(@(_mapView.camera.zoom));
      break;

    /* map # get camera for bounds **/
    case FMFMethodCameraForBounds: {
      MFCoordinateBounds* bounds = [Map4dFLTConvert toCoordinateBounds:call.arguments[@"bounds"]];
      double padding = [Map4dFLTConvert toDouble:call.arguments[@"padding"]];
      UIEdgeInsets insets = UIEdgeInsetsMake(padding, padding, padding, padding);
      MFCameraPosition* camera = [_mapView cameraForBounds:bounds insets:insets];
      result([Map4dFLTConvert positionToJson:camera]);
      break;
    }

    /* map # fit bounds **/
    case FMFMethodFitBounds: {
      MFCoordinateBounds* bounds = [Map4dFLTConvert toCoordinateBounds:call.arguments[@"bounds"]];
      double padding = [Map4dFLTConvert toDouble:call.arguments[@"padding"]];
      UIEdgeInsets insets = UIEdgeInsetsMake(padding, padding, padding, padding);
      [_mapView moveCamera:[MFCameraUpdate fitBounds:bounds withEdgeInsets:insets]];
      result(nil);
      break;
    }
      
    /* map # get camera position **/
    case FMFMethodGetCameraPosition: {
      if (_mapView != nil) {
        result([Map4dFLTConvert positionToJson:_mapView.camera]);
      } else {
        result([FlutterError errorWithCode:@"MFMapView uninitialized"
                                   message:@"getCameraPosition called prior to map initialization"
                                   details:nil]);
      }
      break;
    }
      
    /* map # get bounds */
    case FMFMethodGetBounds: {
      MFCoordinateBounds* bounds = [_mapView getBounds];
      if (bounds == nil) {
        result(@{});
      }
      result(@{
        @"southwest" : [Map4dFLTConvert locationToJson:bounds.southWest],
        @"northeast" : [Map4dFLTConvert locationToJson:bounds.northEast],
      });
      break;
    }

    /* map # set 3D mode **/
    case FMFMethodEnable3DMode: {
      BOOL isEnable = [Map4dFLTConvert toBool:call.arguments[@"enable3DMode"]];
      if (isEnable) {
        _mapView.mapType = MFMapTypeMap3D;
      }
      else if (_mapView.mapType == MFMapTypeMap3D) {
        _mapView.mapType = MFMapTypeRoadmap;
      }
      result(nil);
      break;
    }
      
    /* map # waitForMap */
    case FMFMethodWaitForMap: {
      result(nil);
      break;
    }
    
    /* map # convert latlng to screen coordinate */
    case FMFMethodGetScreenCoordinate: {
      CLLocationCoordinate2D coordinate = [Map4dFLTConvert toLocation:call.arguments[@"latLng"]];
      CGPoint point = [_mapView.projection pointForCoordinate:coordinate];
      result(@{
        @"x": @((int)round(point.x)),
        @"y": @((int)round(point.y))
      });
      break;
    }
      
    /* map # convert screen coordinate to latlng */
    case FMFMethodGetLatLng: {
      CGPoint point = [Map4dFLTConvert pointFromJson:call.arguments[@"coordinate"]];
      CLLocationCoordinate2D coordinate = [_mapView.projection coordinateForPoint:point];
      result([Map4dFLTConvert locationToJson:coordinate]);
      break;
    }

    /* camera # move **/
    case FMFMethodMoveCamera: {
      MFCameraUpdate* cameraUpdate = [Map4dFLTConvert toCameraUpdate:call.arguments[@"cameraUpdate"]];
      [_mapView moveCamera:cameraUpdate];
      result(nil);
      break;
    }

    /* camera # animate **/
    case FMFMethodAnimateCamera: {
      MFCameraUpdate* cameraUpdate = [Map4dFLTConvert toCameraUpdate:call.arguments[@"cameraUpdate"]];
      [_mapView animateCamera:cameraUpdate];
      result(nil);
      break;
    }

    /* marker # update **/
    case FMFMethodMarkersUpdate: {
      id markersToAdd = call.arguments[@"markersToAdd"];
      if ([markersToAdd isKindOfClass: [NSArray class]]) {
        [_annotationManager addMarkers: markersToAdd];
      }
      id markerToChange = call.arguments[@"markersToChange"];
      if ([markerToChange isKindOfClass:[NSArray class]]) {
        [_annotationManager changeMarkers:markerToChange];
      }
      id markerIdsToRemove = call.arguments[@"markerIdsToRemove"];
      if ([markerIdsToRemove isKindOfClass:[NSArray class]]) {
        [_annotationManager removeMarkerIds:markerIdsToRemove];
      }
      break;
    }

    /* circle # update **/
    case FMFMethodCirclesUpdate: {
      id circlesToAdd = call.arguments[@"circlesToAdd"];
      if ([circlesToAdd isKindOfClass:[NSArray class]]) {
        [_annotationManager addCircles:circlesToAdd];
      }
      id circlesToChange = call.arguments[@"circlesToChange"];
      if ([circlesToChange isKindOfClass:[NSArray class]]) {
        [_annotationManager changeCircles:circlesToChange];
      }
      id circleIdsToRemove = call.arguments[@"circleIdsToRemove"];
      if ([circleIdsToRemove isKindOfClass:[NSArray class]]) {
        [_annotationManager removeCircleIds:circleIdsToRemove];
      }
      break;
    }

    /* polyline # update **/
    case FMFMethodPolylineUpdate: {
      id polylinesToAdd = call.arguments[@"polylinesToAdd"];
      if ([polylinesToAdd isKindOfClass:[NSArray class]]) {
        [_annotationManager addPolylines:polylinesToAdd];
      }
      id polylinesToChange = call.arguments[@"polylinesToChange"];
      if ([polylinesToChange isKindOfClass:[NSArray class]]) {
        [_annotationManager changePolylines:polylinesToChange];
      }
      id polylineIdsToRemove = call.arguments[@"polylineIdsToRemove"];
      if ([polylineIdsToRemove isKindOfClass:[NSArray class]]) {
        [_annotationManager removePolylineIds:polylineIdsToRemove];
      }
      result(nil);
      break;
    }

    /* polygon # update **/
    case FMFMethodPolygonUpdate: {
      id polygonsToAdd = call.arguments[@"polygonsToAdd"];
      if ([polygonsToAdd isKindOfClass:[NSArray class]]) {
        [_annotationManager addPolygons:polygonsToAdd];
      }
      id polygonsToChange = call.arguments[@"polygonsToChange"];
      if ([polygonsToChange isKindOfClass:[NSArray class]]) {
        [_annotationManager changePolygons:polygonsToChange];
      }
      id polygonIdsToRemove = call.arguments[@"polygonIdsToRemove"];
      if ([polygonIdsToRemove isKindOfClass:[NSArray class]]) {
        [_annotationManager removePolygonIds:polygonIdsToRemove];
      }
      result(nil);
      break;
    }

    /* user poi # update **/
    case FMFMethodPOIUpdate: {
      id poisToAdd = call.arguments[@"poisToAdd"];
      if ([poisToAdd isKindOfClass:[NSArray class]]) {
        [_annotationManager addPOIs:poisToAdd];
      }
      id poisToChange = call.arguments[@"poisToChange"];
      if ([poisToChange isKindOfClass:[NSArray class]]) {
        [_annotationManager changePOIs:poisToChange];
      }
      id poiIdsToRemove = call.arguments[@"poiIdsToRemove"];
      if ([poiIdsToRemove isKindOfClass:[NSArray class]]) {
        [_annotationManager removePOIIds:poiIdsToRemove];
      }
      result(nil);
      break;
    }

    /* user building # update **/
    case FMFMethodBuildingUpdate: {
      id buildingsToAdd = call.arguments[@"buildingsToAdd"];
      if ([buildingsToAdd isKindOfClass:[NSArray class]]) {
        [_annotationManager addBuildings:buildingsToAdd];
      }
      id buildingsToChange = call.arguments[@"buildingsToChange"];
      if ([buildingsToChange isKindOfClass:[NSArray class]]) {
        [_annotationManager changeBuildings:buildingsToChange];
      }
      id buildingIdsToRemove = call.arguments[@"buildingIdsToRemove"];
      if ([buildingIdsToRemove isKindOfClass:[NSArray class]]) {
        [_annotationManager removeBuildingIds:buildingIdsToRemove];
      }
      result(nil);
      break;
    }

    /* tile overlay # update **/
    case FMFMethodTileOverlaysUpdate: {
      id tileOverlaysToAdd = call.arguments[@"tileOverlaysToAdd"];
      if ([tileOverlaysToAdd isKindOfClass:[NSArray class]]) {
        [_overlayManager addTileOverlays:tileOverlaysToAdd];
      }
      id tileOverlaysToChange = call.arguments[@"tileOverlaysToChange"];
      if ([tileOverlaysToChange isKindOfClass:[NSArray class]]) {
        [_overlayManager changeTileOverlays:tileOverlaysToChange];
      }
      id tileOverlayIdsToRemove = call.arguments[@"tileOverlayIdsToRemove"];
      if ([tileOverlayIdsToRemove isKindOfClass:[NSArray class]]) {
        [_overlayManager removeTileOverlayIds:tileOverlayIdsToRemove];
      }
      result(nil);
      break;
    }

    /* tile overlay # clear cache **/
    case FMFMethodTileOverlaysClearTileCache: {
      id rawTileOverlayId = call.arguments[@"tileOverlayId"];
      [_overlayManager clearTileOverlayCache:rawTileOverlayId];
      result(nil);
      break;
    }

    /* image overlay # update **/
    case FMFMethodImageOverlaysUpdate: {
      id imageOverlaysToAdd = call.arguments[@"imageOverlaysToAdd"];
      if ([imageOverlaysToAdd isKindOfClass:[NSArray class]]) {
        [_overlayManager addImageOverlays:imageOverlaysToAdd];
      }
      id imageOverlaysToChange = call.arguments[@"imageOverlaysToChange"];
      if ([imageOverlaysToChange isKindOfClass:[NSArray class]]) {
        [_overlayManager changeImageOverlays:imageOverlaysToChange];
      }
      id imageOverlayIdsToRemove = call.arguments[@"imageOverlayIdsToRemove"];
      if ([imageOverlayIdsToRemove isKindOfClass:[NSArray class]]) {
        [_overlayManager removeImageOverlayIds:imageOverlayIdsToRemove];
      }
      result(nil);
      break;
    }
      
    /* directions renderer # update **/
    case FMFMethodDirectionsRenderersUpdate: {
      id directionsRenderersToAdd = call.arguments[@"directionsRenderersToAdd"];
      if ([directionsRenderersToAdd isKindOfClass:[NSArray class]]) {
        [_directionsRendererManager addDirectionsRenderers:directionsRenderersToAdd];
      }
      id directionsRenderersToChange = call.arguments[@"directionsRenderersToChange"];
      if ([directionsRenderersToChange isKindOfClass:[NSArray class]]) {
        [_directionsRendererManager changeDirectionsRenderers:directionsRenderersToChange];
      }
      id directionsRendererIdsToRemove = call.arguments[@"directionsRendererIdsToRemove"];
      if ([directionsRendererIdsToRemove isKindOfClass:[NSArray class]]) {
        [_directionsRendererManager removeDirectionsRendererIds:directionsRendererIdsToRemove];
      }
      result(nil);
      break;
    }

    /* default **/
    default:
      NSLog(@"Unknow call method: %@", call.method);
      result(nil);
      break;
  }
}

#pragma mark - Interpret Map options
- (void)interpretMapOptions:(NSDictionary*)data {
  //  NSArray* cameraTargetBounds = data[@"cameraTargetBounds"];
  //  if (cameraTargetBounds) {
  //    [sink setCameraTargetBounds:ToOptionalBounds(cameraTargetBounds)];
  //  }
  
  id mapType = data[@"mapType"];
  if (mapType) {
    int type = [Map4dFLTConvert toInt:mapType];
    switch (type) {
      case 1:
        [self setMapType:MFMapTypeRaster];
        break;
      case 2:
        [self setMapType:MFMapTypeSatellite];
        break;
      case 3:
        [self setMapType:MFMapTypeMap3D];
        break;
      default:
        [self setMapType:MFMapTypeRoadmap];
        break;
    }
  }
  
  id buildingsEnabled = data[@"buildingsEnabled"];
  if (buildingsEnabled) {
    [self setBuildingsEnabled:[Map4dFLTConvert toBool:buildingsEnabled]];
  }
  
  id poisEnabled = data[@"poisEnabled"];
  if (poisEnabled) {
    [self setPOIsEnabled:[Map4dFLTConvert toBool:poisEnabled]];
  }
  
  NSArray* zoomData = data[@"minMaxZoomPreference"];
  if (zoomData) {
    float minZoom = (zoomData[0] == [NSNull null]) ? kMFMinZoomLevel : [Map4dFLTConvert toFloat:zoomData[0]];
    float maxZoom = (zoomData[1] == [NSNull null]) ? kMFMaxZoomLevel : [Map4dFLTConvert toFloat:zoomData[1]];
    [self setMinZoom:minZoom maxZoom:maxZoom];
  }
  
  NSNumber* rotateGesturesEnabled = data[@"rotateGesturesEnabled"];
  if (rotateGesturesEnabled != nil) {
    [self setRotateGesturesEnabled:[Map4dFLTConvert toBool:rotateGesturesEnabled]];
  }
  NSNumber* scrollGesturesEnabled = data[@"scrollGesturesEnabled"];
  if (scrollGesturesEnabled != nil) {
    [self setScrollGesturesEnabled:[Map4dFLTConvert toBool:scrollGesturesEnabled]];
  }
  NSNumber* tiltGesturesEnabled = data[@"tiltGesturesEnabled"];
  if (tiltGesturesEnabled != nil) {
    [self setTiltGesturesEnabled:[Map4dFLTConvert toBool:tiltGesturesEnabled]];
  }
  NSNumber* trackCameraPosition = data[@"trackCameraPosition"];
  if (trackCameraPosition != nil) {
    [self setTrackCameraPosition:[Map4dFLTConvert toBool:trackCameraPosition]];
  }
  NSNumber* zoomGesturesEnabled = data[@"zoomGesturesEnabled"];
  if (zoomGesturesEnabled != nil) {
    [self setZoomGesturesEnabled:[Map4dFLTConvert toBool:zoomGesturesEnabled]];
  }
  NSNumber* myLocationEnabled = data[@"myLocationEnabled"];
  if (myLocationEnabled != nil) {
    [self setMyLocationEnabled:[Map4dFLTConvert toBool:myLocationEnabled]];
  }
  NSNumber* myLocationButtonEnabled = data[@"myLocationButtonEnabled"];
  if (myLocationButtonEnabled != nil) {
    [self setMyLocationButtonEnabled:[Map4dFLTConvert toBool:myLocationButtonEnabled]];
  }
  NSNumber* waterEffectEnabled = data[@"waterEffectEnabled"];
  if (waterEffectEnabled != nil) {
    [self setWaterEffectEnabled:[Map4dFLTConvert toBool:waterEffectEnabled]];
  }
}

#pragma mark - FMFMapViewOptionsSink methods

- (void)setCamera:(MFCameraPosition*)camera {
  _mapView.camera = camera;
}

- (void)setCameraTargetBounds:(MFCoordinateBounds*)bounds {
  //TODO
  //  _mapView.cameraTargetBounds = bounds;
}

- (void)setBuildingsEnabled:(BOOL)enabled {
  [_mapView setBuildingsEnabled:enabled];
}

- (void)setPOIsEnabled:(BOOL)enabled {
  [_mapView setPOIsEnabled:enabled];
}

- (void)setMapType:(MFMapType)type {
  [_mapView setMapType:type];
}

- (void)setMinZoom:(float)minZoom maxZoom:(float)maxZoom {
  [_mapView setMinZoom:minZoom maxZoom:maxZoom];
}

- (void)setRotateGesturesEnabled:(BOOL)enabled {
  _mapView.settings.rotateGestures = enabled;
}

- (void)setScrollGesturesEnabled:(BOOL)enabled {
  _mapView.settings.scrollGestures = enabled;
}

- (void)setTiltGesturesEnabled:(BOOL)enabled {
  _mapView.settings.tiltGestures = enabled;
}

- (void)setZoomGesturesEnabled:(BOOL)enabled {
  _mapView.settings.zoomGestures = enabled;
}

- (void)setMyLocationEnabled:(BOOL)enabled {
  [_mapView setMyLocationEnabled:enabled];
}

- (void)setMyLocationButtonEnabled:(BOOL)enabled {
  _mapView.settings.myLocationButton = enabled;
}

- (void)setWaterEffectEnabled:(BOOL)enabled {
  [_mapView enableWaterEffect:enabled];
}

- (void)setTrackCameraPosition:(BOOL)enabled {
  _track.cameraPosition = enabled;
}

#pragma mark - MFMapViewDelegate

- (BOOL)mapview: (MFMapView*) mapView didTapMarker: (MFMarker*) marker {
  if ([marker.userData isKindOfClass:[NSArray class]]) {
    NSArray* userData = (NSArray*) marker.userData;
    NSString* markerId = userData[0];
    if ([_annotationManager hasMarker:markerId]) {
      [_channel invokeMethod:@"marker#onTap" arguments:@{@"markerId" : markerId}];
    }
  }
  return false;
}

//- (void)mapview: (MFMapView*)  mapView didBeginDraggingMarker: (MFMarker*) marker;

- (void)mapview: (MFMapView*) mapView didEndDraggingMarker: (MFMarker*) marker {
  if ([marker.userData isKindOfClass:[NSArray class]]) {
    NSArray* userData = (NSArray*) marker.userData;
    NSString* markerId = userData[0];
    if ([_annotationManager hasMarker:markerId]) {
      NSArray* position = [Map4dFLTConvert locationToJson:marker.position];
      [_channel invokeMethod:@"marker#onDragEnd"
                   arguments:@{@"markerId": markerId, @"position": position}];
    }
  }
}

//- (void)mapview: (MFMapView*)  mapView didDragMarker: (MFMarker*) marker;

- (void)mapview: (MFMapView*) mapView didTapInfoWindowOfMarker: (MFMarker*) marker{
  if ([marker.userData isKindOfClass:[NSArray class]]) {
    NSArray* userData = (NSArray*) marker.userData;
    NSString* markerId = userData[0];
    if ([_annotationManager hasMarker:markerId]) {
      [_channel invokeMethod:@"infoWindow#onTap" arguments:@{@"markerId" : markerId}];
    }
  }
}

- (void)mapview: (MFMapView*)  mapView didTapPolyline: (MFPolyline*) polyline {
  if ([polyline.userData isKindOfClass:[NSArray class]]) {
    NSArray* userData = (NSArray*) polyline.userData;
    NSString* polylineId = userData[0];
    if ([_annotationManager hasPolyline:polylineId]) {
      [_channel invokeMethod:@"polyline#onTap" arguments:@{@"polylineId" : polylineId}];
    }
  }
}

- (void)mapview: (MFMapView*)  mapView didTapPolygon: (MFPolygon*) polygon {
  if ([polygon.userData isKindOfClass:[NSArray class]]) {
    NSArray* userData = (NSArray*) polygon.userData;
    NSString* polygonId = userData[0];
    if ([_annotationManager hasPolygon:polygonId]) {
      [_channel invokeMethod:@"polygon#onTap" arguments:@{@"polygonId" : polygonId}];
    }
  }
}

- (void)mapview: (MFMapView*)  mapView didTapCircle: (MFCircle*) circle {
  if ([circle.userData isKindOfClass:[NSArray class]]) {
    NSArray* userData = (NSArray*) circle.userData;
    NSString* circleId = userData[0];
    if ([_annotationManager hasCircle:circleId]) {
      [_channel invokeMethod:@"circle#onTap" arguments:@{@"circleId" : circleId}];
    }
  }
}

- (void)mapView: (MFMapView*)  mapView willMove: (BOOL) gesture {
  [_channel invokeMethod:@"camera#onMoveStarted" arguments:@{@"isGesture" : @(gesture)}];
}

- (void)mapView: (MFMapView*)  mapView movingCameraPosition: (MFCameraPosition*) position {
  if (_track.cameraPosition) {
    NSDictionary* response = [Map4dFLTConvert positionToJson:position];
    [_channel invokeMethod:@"camera#onMove" arguments:@{@"position" : response}];
  }
}

//- (void)mapView: (MFMapView*)  mapView didChangeCameraPosition:(MFCameraPosition*) position {}

- (void)mapView: (MFMapView*)  mapView idleAtCameraPosition: (MFCameraPosition *) position {
  [_channel invokeMethod:@"camera#onIdle" arguments:@{}];
}

- (void)mapView: (MFMapView*) mapView didTapAtCoordinate: (CLLocationCoordinate2D) coordinate {
  NSArray* response = [Map4dFLTConvert locationToJson:coordinate];
  [_channel invokeMethod:@"map#didTapAtCoordinate" arguments:@{@"coordinate": response}];
}

///* Called after a building annotation has been tapped */
- (void)mapView: (MFMapView*)  mapView didTapBuilding: (MFBuilding*) building {
  if ([building.userData isKindOfClass:[NSArray class]]) {
    NSArray* userData = (NSArray*) building.userData;
    NSString* buildingId = userData[0];
    if ([_annotationManager hasBuilding:buildingId]) {
      [_channel invokeMethod:@"building#onTap" arguments:@{@"buildingId" : buildingId}];
    }
  }
}

///* Called after a base map building has been tapped */
- (void)mapView:(MFMapView*)mapView didTapBuildingWithBuildingID:(NSString*)buildingID name:(NSString*)name location:(CLLocationCoordinate2D)location {
  NSDictionary* arguments = @{
    @"buildingId": buildingID,
    @"name": name,
    @"location": [Map4dFLTConvert locationToJson:location]
  };
  [_channel invokeMethod:@"map#onTapBuilding" arguments:arguments];
}

- (void)mapView: (MFMapView*)  mapView didTapPOI: (MFPOI*) poi {
  if ([poi.userData isKindOfClass:[NSArray class]]) {
    NSArray* userData = (NSArray*) poi.userData;
    NSString* poiId = userData[0];
    if ([_annotationManager hasPOI:poiId]) {
      [_channel invokeMethod:@"poi#onTap" arguments:@{@"poiId" : poiId}];
    }
  }
}

///* Called after a base map POI has been tapped */
- (void)mapView: (MFMapView*)  mapView didTapPOIWithPlaceID: (NSString*) placeID name: (NSString*) name location: (CLLocationCoordinate2D) location {
  NSDictionary* arguments = @{
    @"placeId": placeID,
    @"name": name,
    @"location": [Map4dFLTConvert locationToJson:location]
  };
  [_channel invokeMethod:@"map#onTapPOI" arguments:arguments];
}

///* Called after a base map Place has been tapped */
- (void)mapView:(MFMapView *)mapView didTapPlaceWithName:(NSString *)name location:(CLLocationCoordinate2D)location {
  NSDictionary* arguments = @{
    @"name": name,
    @"location": [Map4dFLTConvert locationToJson:location]
  };
  [_channel invokeMethod:@"map#onTapPlace" arguments:arguments];
}

- (void)mapView:(MFMapView *)mapView didTapDirectionsRenderer:(MFDirectionsRenderer *)renderer routeIndex:(NSUInteger)routeIndex {
  NSString* rendererId = [_directionsRendererManager getDirectionsRendererId:renderer];
  if (rendererId != nil) {
    NSDictionary* arguments = @{
      @"rendererId": rendererId,
      @"routeIndex": @(routeIndex)
    };
    [_channel invokeMethod:@"directionsRenderer#onRouteTap" arguments:arguments];
  }
}

//- (void)mapView: (MFMapView*)  mapView didTapMyLocation: (CLLocationCoordinate2D) location;
//- (BOOL)didTapMyLocationButtonForMapView: (MFMapView*) mapView;
//- (UIView *) mapView: (MFMapView *) mapView markerInfoWindow: (MFMarker *) marker;

@end
