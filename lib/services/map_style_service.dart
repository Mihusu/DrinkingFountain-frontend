// PATH: lib/services/map_style_service.dart

import 'package:flutter/services.dart';

class MapStyleService {
  Future<String> loadMapStyle(String path) async {
    return await rootBundle.loadString(path);
  }
}
