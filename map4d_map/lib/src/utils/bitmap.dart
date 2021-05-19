import 'dart:async' show Future;
import 'dart:typed_data' show Uint8List;
import 'dart:ui' show Size;

import 'package:flutter/material.dart' show ImageConfiguration, AssetImage, AssetBundleImageKey;
import 'package:flutter/services.dart' show AssetBundle;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Defines a bitmap image. For a marker, this class can be used to set the
/// image of the marker icon. For a ground overlay, it can be used to set the
/// image to place on the surface of the earth.
class MFBitmap {
  const MFBitmap._(this._json);

  static const String _defaultMarker = 'defaultMarker';
  static const String _fromAssetImage = 'fromAssetImage';
  static const String _fromBytes = 'fromBytes';

  /// Creates a BitmapDescriptor that refers to the default marker image.
  static const MFBitmap defaultMarker =
      MFBitmap._(<Object>[_defaultMarker]);

  /// Creates a [MFBitmap] from an asset image.
  ///
  /// Asset images in flutter are stored per:
  /// https://flutter.dev/docs/development/ui/assets-and-images#declaring-resolution-aware-image-assets
  /// This method takes into consideration various asset resolutions
  /// and scales the images to the right resolution depending on the dpi.
  /// Set `mipmaps` to false to load the exact dpi version of the image, `mipmap` is true by default.
  static Future<MFBitmap> fromAssetImage(
    ImageConfiguration configuration,
    String assetName, {
    AssetBundle? bundle,
    String? package,
    bool mipmaps = true,
  }) async {
    double? devicePixelRatio = configuration.devicePixelRatio;
    if (!mipmaps && devicePixelRatio != null) {
      return MFBitmap._(<Object>[
        _fromAssetImage,
        assetName,
        devicePixelRatio,
      ]);
    }
    final AssetImage assetImage =
        AssetImage(assetName, package: package, bundle: bundle);
    final AssetBundleImageKey assetBundleImageKey =
        await assetImage.obtainKey(configuration);
    final Size? size = configuration.size;
    return MFBitmap._(<Object>[
      _fromAssetImage,
      assetBundleImageKey.name,
      assetBundleImageKey.scale,
      if (kIsWeb && size != null)
        [
          size.width,
          size.height,
        ],
    ]);
  }

  /// Creates a BitmapDescriptor using an array of bytes that must be encoded as PNG.
  static MFBitmap fromBytes(Uint8List byteData) {
    return MFBitmap._(<Object>[_fromBytes, byteData]);
  }

  final Object _json;

  /// Convert the object to a Json format.
  Object toJson() => _json;
}
