import 'package:flutter/material.dart';
import 'package:fixme/Model/BankInfo.dart';

class BankProvider extends ChangeNotifier {
  String _accountName;
  String get getAccountName => _accountName;
  set setAccountName(String newInfo) {
    _accountName = newInfo;
  }

  String _accountNumber;
  String get getAccountNumber => _accountNumber;
  set setAccountNumber(String newInfo) {
    _accountNumber = newInfo;
  }

  BankInfo _bankInfo;
  BankInfo get getUserBankInfo => _bankInfo;
  set setUserBankInfo(BankInfo newInfo) {
    _bankInfo = newInfo;
  }
}