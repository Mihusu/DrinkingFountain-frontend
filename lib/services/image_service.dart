// PATH: lib/services/image_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Import for base64Decode

class ImageService {
  static Image? decodeBase64ToImage(String? base64String) {
    if (base64String == null) return null;
    try {
      return Image.memory(base64Decode(base64String));
    } catch (e) {
      if (kDebugMode) {
        print("Failed to decode base64 image: $e");
      }
      return null;
    }
  }
}
