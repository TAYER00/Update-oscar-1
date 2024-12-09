import 'package:flutter/material.dart';

class CodeNotifier extends ChangeNotifier {
  String _code = '';
  bool _isValid = false;
  bool _isCodeValid = false;

  String get code => _code;
  bool get isValid => _isValid;
  bool get isCodeValid => _isCodeValid;

  // Set the entered code and validate it
  void setCode(String newCode) {
    _code = newCode;
    _isValid = _validateCode(newCode);
    notifyListeners();
  }

  bool _validateCode(String code) {
    return code.length == 4 && int.tryParse(code) != null;
  }

  void submitCode() {
    if (_isValid && _code == '6666') {
      _isCodeValid = true;
    } else {
      _isCodeValid = false;
    }
    notifyListeners();
  }

  void reset() {
    _code = '';
    _isValid = false;
    _isCodeValid = false;
    notifyListeners();
  }
}
