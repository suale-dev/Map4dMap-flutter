import 'dart:ui' show Color;
import '../location.dart';
import '../utils/bitmap.dart';

class MFDirectionsPOIOptions {

  const MFDirectionsPOIOptions({
    this.position,
    this.icon,
    this.title,
    this.titleColor,
    this.visible = true,
  });

  /// Geographical location of the directions poi.
  final MFLatLng? position;

  /// A description of the bitmap used to draw the directions icon.
  final MFBitmap? icon;

  /// Title of the directions poi.
  final String? title;

  /// Title color in ARGB format, the same format used by Color. The default value is black (0xff000000).
  final Color? titleColor;

  /// True if the directions poi is visible. The default is true.
  final bool visible;

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    if (position != null) {
      json['position'] = position!.toJson();
    }

    if (icon != null) {
      json['icon'] = icon!.toJson();
    }
    
    if (title != null) {
      json['title'] = title!;
    }

    if (titleColor != null) {
      json['titleColor'] = titleColor!.value;
    }

    json['visible'] = visible;

    return json;
  }
}