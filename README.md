# Map4dMap for Flutter
[![map4d](https://img.shields.io/badge/map4d-map-orange)](https://map4d.vn/)
[![platform](https://img.shields.io/badge/platform-flutter-45d2fd.svg)](https://flutter.dev/)
[![pub package](https://img.shields.io/pub/v/map4d_map.svg)](https://pub.dev/packages/map4d_map)
[![github issues](https://img.shields.io/github/issues/map4d/map4d-map-flutter)](https://github.com/map4d/map4d-map-flutter/issues)

A Flutter plugin that provides a [Map4dMap](https://map4d.vn/) widget.

## Usage

To use this plugin, add `map4d_map` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  map4d_map: ^2.1.1
```

## Minium Android/iOS SDK version support

### Android

Required Android SDK 21 or higher

Set `minSdkVersion` in `android/app/build.gradle`

```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

### iOS

Required iOS 9.3 or higher

## Setup API key

The API key is a unique identifier that authenticates requests associated with your project for usage and billing purposes. You must have at least one API key associated with your project.

Get an API key at <https://map.map4d.vn/user/access-key/>

### Android

Provide access key from `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application>
        <meta-data
            android:name="vn.map4d.map.ACCESS_KEY"
            android:value="YOUR_KEY_HERE"/>
    </application>
</manifest>
```

### iOS

Provide access key from `ios/Runner/Info.plist`

```xml
<key>Map4dMapAccessKey</key>
<string>YOUR_KEY_HERE</string>
```

## Simple Usage

```dart
import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map4D Map',
      home: MFMapView(),
    );
  }
}
```

See [example](https://github.com/map4d/map4d-map-flutter/tree/master/example) directory for more examples

## Documents

- Guides: <https://docs.map4d.vn/map4d-map/flutter/>
- API Reference: <https://pub.dev/documentation/map4d_map/latest/>