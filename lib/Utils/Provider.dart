import 'dart:async';
import 'dart:io';
import 'package:fixme/Services/call_service.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DataProvider extends ChangeNotifier {
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  String password = '';
  var count = 10;
  var firebase_user_id = '';
  var focus_value = false;
  var focus_value1 = false;
  var focus_value2 = false;
  var focus_value3 = false;
  var focus_value4 = false;
  var focus_value5 = false;
  bool isWriting = false;
  var selectedPage = 0;
  var emails = '';
  var otp = '';
  var firstName = '';
  var lastName = '';
  var password_obscure = true;

  //change password obcure text
  setSelectedBottomNavBar(value) {
    selectedPage = value;
    notifyListeners();
  }

  //change password obcure text
  setPassWordObscure(value) {
    password_obscure = value;
    notifyListeners();
  }

// combine all otp textfield as one
  setCombineOtpValue({cont1, cont2, cont3, cont4, cont5, cont6}) {
    otp =
        "${cont1.text}${cont2.text}${cont3.text}${cont4.text}${cont5.text}${cont6.text}";
    notifyListeners();
  }

  // check if  textfield firstNAme is empty or not
  setFirstName(value) {
    firstName = value;
    notifyListeners();
  }

  // check if  textfield lastName is empty or not
  setLastName(value) {
    lastName = value;
    notifyListeners();
  }

  // check if  textfield email is empty or not
  setEmail(value) {
    emails = value;
    notifyListeners();
  }

  // check if  textfield password is empty or not
  setPassword(value) {
    password = value;
    notifyListeners();
  }

// check if  textfield number is empty or not
  setNumber(value) {
    number = value;
    notifyListeners();
  }

//change textfield number on focus of otp textfield
  setOTPfocus_value({focus1, focus2, focus3, focus4, focus5, focus6}) {
    focus_value = focus1;
    focus_value1 = focus2;
    focus_value2 = focus3;
    focus_value3 = focus4;
    focus_value4 = focus5;
    focus_value5 = focus6;
    notifyListeners();
  }

//end of **of otp textfield** function

//otp count down

  void setUserID(id) {
    firebase_user_id = id;
    notifyListeners();
  }

  Future<void> onJoin(
      {channelID, context, reciever, userID, myusername, myavater, calltype}) async {
    // update input validation
    var data = Provider.of<CallApi>(context, listen: false);
    if (channelID.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await data.uploadMessage(
        context: context,
        channelId: channelID,
        idUser: userID,
        calltype: calltype,
        urlAvatar: myavater,
        urlAvatar2: reciever,
        username: myusername,
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  setWritingTo(bool val) {
    isWriting = val;
    notifyListeners();
  }

  String categorizeUrl(String s) {
    if (s.contains('https://firebasestorage.googleapis.com')) {
      var pos = s.lastIndexOf('.');
      String result = s.substring(pos + 1, s.length).toString().toLowerCase();
      if (result.contains('jpg') ||
          result.contains('jpeg') ||
          result.contains('png') ||
          result.contains('gif')) {
        return 'image';
      } else if (result.contains('pdf') ||
          result.contains('doc') ||
          result.contains('docx') ||
          result.contains('xls') ||
          result.contains('xlsx') ||
          result.contains('ods') ||
          result.contains('txt') ||
           result.contains('csv') ||
          result.contains('html')) {
        return 'doc';
      }else if (result.contains('wav') ||
          result.contains('mp3')) {
        return 'audio';
      }
    } else {
      return 'link';
    }
  }
}
