// File: lib/config/map_style_loader.dart

import 'package:flutter/services.dart';

class MapStyleLoader {
  static Future<String> loadMapStyle(String path) async {
    return await rootBundle.loadString(path);
  }
}
