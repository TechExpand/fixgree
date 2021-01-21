import 'package:flutter/material.dart';
import 'package:fixme/Model/BankInfo.dart';

class BankProvider extends ChangeNotifier {
  int _selectValue = 0;
  int get getSelectValue => _selectValue;
  set setSelectValue(int newValue) {
    _selectValue = newValue;
    notifyListeners();
  }

  TextEditingController bankName = new TextEditingController();

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
  bool _isAmountEmpty = false;
  bool get getAmountStatus => _isAmountEmpty;
  set setAmountStatus(bool newStatus) {
    _isAmountEmpty = newStatus;
    notifyListeners();
  }

  bool _isNarrationEmpty = false;
  bool get getNarrationStatus => _isNarrationEmpty;
  set setNarrationStatus(bool newInfo) {
    _isNarrationEmpty = newInfo;
    notifyListeners();
  }

  String _amount = '';
  String get getAmount => _amount;
  set setAmount(String newInfo) {
    _amount = newInfo;
    notifyListeners();
    if (newInfo.isNotEmpty) _isAmountEmpty = false;
    notifyListeners();
  }

  String _narration = '';
  String get getNarration => _narration;
  set setNarration(String newInfo) {
    _narration = newInfo;
    if (newInfo.isNotEmpty) _isNarrationEmpty = false;
    notifyListeners();
  }

  bool _isValidated = true;
  bool get getIsValidated => _isValidated;
  set setIsValidated(bool newInfo) {
    _isValidated = newInfo;
    notifyListeners();
  }

  bool _saveBeneficiary = false;
  bool get getSaveBeneficiary => _saveBeneficiary;
  set setSaveBeneficiary(bool newInfo) {
    _saveBeneficiary = newInfo;
    notifyListeners();
  }
}
