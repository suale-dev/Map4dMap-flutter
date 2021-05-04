
import 'dart:async';

import 'package:flutter/services.dart';

class Map4dMap {
  static const MethodChannel _channel =
      const MethodChannel('map4d_map');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
