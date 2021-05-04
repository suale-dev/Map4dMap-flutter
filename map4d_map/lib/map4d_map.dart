library map4d_map_flutter;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/widget.dart';

class Map4dMap extends StatefulWidget {
  @override
  State createState() => _Map4dMapState();
}

class _Map4dMapState extends State<Map4dMap> {
  @override
  Widget build(BuildContext context) {    
    // This is used in the platform side to register the view.
    final String viewType = 'plugin:map4d-map-view-type';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: viewType,    
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
