import 'package:flutter/material.dart';
import 'package:fixme/Model/BankInfo.dart';

class BankProvider extends ChangeNotifier {
  bool _isAccountNoEmpty = false;
  bool get getAccountNoStatus => _isAccountNoEmpty;
  set setAccountNoStatus(bool newStatus) {
    _isAccountNoEmpty = newStatus;
    notifyListeners();
  }

  bool _isBankNameEmpty = false;
  bool get getBankNameStatus => _isBankNameEmpty;
  set setBankNameStatus(bool newStatus) {
    _isBankNameEmpty = newStatus;
    notifyListeners();
  }

  bool _isValidated = true;
  bool get getIsValidated => _isValidated;
  set setIsValidated(bool newInfo) {
    _isValidated = newInfo;
    notifyListeners();
  }

  String _accountName;
  String get getAccountName => _accountName;
  set setAccountName(String newInfo) {
    _accountName = newInfo;
    notifyListeners();
    if (newInfo.isNotEmpty) _isValidated = true;
    notifyListeners();
  }

  String _accountNumber = '';
  String get getAccountNumber => _accountNumber;
  set setAccountNumber(String newInfo) {
    _accountNumber = newInfo;
    if (newInfo.isNotEmpty) _isAccountNoEmpty = false;
    notifyListeners();
  }

  BankInfo _bankInfo;
  BankInfo get getUserBankInfo => _bankInfo;
  set setUserBankInfo(BankInfo newInfo) {
    _bankInfo = newInfo;
    notifyListeners();
  }
}

class BankProvider2 extends ChangeNotifier {
  bool _isAccountNoEmpty = false;
  bool get getAccountNoStatus => _isAccountNoEmpty;
  set setAccountNoStatus(bool newStatus) {
    _isAccountNoEmpty = newStatus;
    notifyListeners();
  }

  bool _isValidated = true;
  bool get getIsValidated => _isValidated;
  set setIsValidated(bool newInfo) {
    _isValidated = newInfo;
    notifyListeners();
  }

  String _accountName;
  String get getAccountName => _accountName;
  set setAccountName(String newInfo) {
    _accountName = newInfo;
    notifyListeners();
    if (newInfo.isNotEmpty) _isValidated = true;
    notifyListeners();
  }

  String _accountNumber = '';
  String get getAccountNumber => _accountNumber;
  set setAccountNumber(String newInfo) {
    _accountNumber = newInfo;
    if (newInfo.isNotEmpty) _isAccountNoEmpty = false;
    notifyListeners();
  }

  BankInfo _bankInfo;
  BankInfo get getUserBankInfo => _bankInfo;
  set setUserBankInfo(BankInfo newInfo) {
    _bankInfo = newInfo;
    notifyListeners();
  }
}
