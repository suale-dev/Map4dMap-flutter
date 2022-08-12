import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

class ImageOverlayPage extends Map4dMapExampleAppPage {
  ImageOverlayPage() : super(const Icon(Icons.map), 'Image overlay');

  @override
  Widget build(BuildContext context) {
    return const ImageOverlayBody();
  }
}

class ImageOverlayBody extends StatefulWidget {
  const ImageOverlayBody();

  @override
  State<StatefulWidget> createState() => ImageOverlayBodyState();
}

class ImageOverlayBodyState extends State<ImageOverlayBody> {
  ImageOverlayBodyState();

  MFMapViewController? controller;
  MFBitmap? _image;
  MFImageOverlay? _imageOverlay;

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _removeImageOverlay() {
    setState(() {
      _imageOverlay = null;
    });
  }

  void _addImageOverlay() {
    final northeast = MFLatLng(16.066154, 108.207276);
    final southwest = MFLatLng(16.020262, 108.189487);
    final bounds = MFLatLngBounds(southwest: southwest, northeast: northeast);
    final imageOverlay = MFImageOverlay(
      imageOverlayId: MFImageOverlayId('image_overlay_1'),
      image: _image!,
      bounds: bounds
    );

    setState(() {
      _imageOverlay = imageOverlay;
    });
  }

  void _changeTransparency() {
    if (_imageOverlay != null) {
      final transparency = 0.9 - _imageOverlay!.transparency;
      final overlayWithNewTransparency = _imageOverlay!.copyWith(
        transparencyParam: transparency,
      );
      setState(() {
        _imageOverlay = overlayWithNewTransparency;
      });
    }
  }

  Future<void> _createImageFromAsset(BuildContext context) async {
    if (_image == null) {
      final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context);
      _image = await MFBitmap.fromAssetImage(imageConfiguration, 'assets/image_overlay.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    _createImageFromAsset(context);
    Set<MFImageOverlay> overlays = <MFImageOverlay>{
      if (_imageOverlay != null) _imageOverlay!,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 600.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                target: MFLatLng(16.043208, 108.198382),
                zoom: 13.0,
              ),
              imageOverlays: overlays,
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        TextButton(
          child: const Text('Add image overlay'),
          onPressed: _addImageOverlay,
        ),
        TextButton(
          child: const Text('Remove image overlay'),
          onPressed: _removeImageOverlay,
        ),
        TextButton(
          child: const Text('Change transparency'),
          onPressed: _changeTransparency,
        ),
      ],
    );
  }
}
