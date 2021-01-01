import 'package:flutter/material.dart';
import 'package:fixme/Model/UserBankInfo.dart';

class WalletProvider extends ChangeNotifier {
  UserBankInfo userBankInfo;

  UserBankInfo get getUserBankInfo => userBankInfo;
  set setUserBankInfo(UserBankInfo newInfo) {
    userBankInfo = newInfo;
  }
}