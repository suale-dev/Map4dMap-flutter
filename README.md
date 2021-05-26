# Map4d Map for Flutter

[![pub package](https://img.shields.io/pub/v/map4d_map.svg)](https://pub.dev/packages/map4d_map)
[![platform flutter](https://img.shields.io/badge/platform-flutter-9cf.svg)](https://flutter.dev/)
[![license](https://img.shields.io/github/license/map4d/map4d-map-flutter)](https://github.com/map4d/map4d-map-flutter)

A Flutter plugin that provides a [Map4d Map](https://map4d.vn/) widget.

## Usage

To use this plugin, add `map4d_map` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  map4d_map: ^1.0.0
```

## Minium Android/iOS SDK version support

### Android

Required Android SDK 21 or higher

Set `minSdkVersion` in `android/app/build.gradle`

```
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

### iOS

Required iOS 9.0 or higher

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

See `example` directory for more examples