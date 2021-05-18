
abstract class MFTileUrlProvider {
  /// Returns the tile to be used for this tile coordinate.
  String? getTileUrl(int x, int y, int zoom, bool is3dMode);
}