import 'package:flutter/material.dart';

class VideoControlProvider with ChangeNotifier {
  double _opacity = 1;

  double get opacity => _opacity;
  bool _isHideControl = false;

  void setHideVideoControl(bool hide) {
    _isHideControl = hide;
    debugPrint('araya setHideVideoControl $hide');
    if (!hide) {
      _opacity = 1;
    } else {
      _autoHideVideoControl();
    }
    notifyListeners();
  }

  void onTapVideoArea() {
    if (_opacity != 1) {
      _opacity = 1;
      notifyListeners();
      _autoHideVideoControl();
    }
  }

  void _autoHideVideoControl() {
    if (_opacity == 1) {
      Future.delayed(const Duration(milliseconds: 2000)).then((_) {
        if (_isHideControl) {
          _opacity = 0;
          notifyListeners();
        }
      });
    }
  }
}
