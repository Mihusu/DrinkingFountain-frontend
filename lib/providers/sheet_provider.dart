/*
// file: lib/providers/sheet_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toerst/config/draggable_sheet_constants.dart';

class SheetProvider extends ChangeNotifier {
  double _sheetPosition = initialSheetPosition;

  double get sheetPosition => _sheetPosition;

  void updateSheetPosition(double newPosition) {
    _sheetPosition = newPosition;
    notifyListeners();
  }

  void snapSheet(double targetPosition) {
        _animation = Tween<double>(begin: _sheetPosition, end: targetPosition)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _sheetPosition = _animation.value;
        });
      });

    _controller.reset();
    _controller.forward();
    notifyListeners();
  }
}

*/
