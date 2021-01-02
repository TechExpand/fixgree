import 'package:flutter/material.dart';

class PinProvider extends ChangeNotifier {
  @override
  void dispose() {
    _isPinEmpty = null;
    _isPinSet = null;
    _pin = null;
    _transactionStatus = null;
    super.dispose();
  }

  bool _isPinEmpty = false;

  bool get getPinStatus => _isPinEmpty;
  set setPinStatus(bool newStatus) {
    _isPinEmpty = newStatus;
    notifyListeners();
  }

  bool _isPinSet = true;
  bool get getIsValidated => _isPinSet;
  set setIsValidated(bool newInfo) {
    _isPinSet = newInfo;
    notifyListeners();
  }

  String _pin = '';
  String get getPin => _pin;
  set setPin(String newInfo) {
    _pin = newInfo;
    notifyListeners();
    if (newInfo.isNotEmpty) _isPinEmpty = false;
    notifyListeners();
  }

  bool _transactionStatus = true;
  bool get getTransactionStatus => _transactionStatus;
  set setTransactionStatus(bool newInfo) {
    _transactionStatus = newInfo;
    notifyListeners();
  }
}
