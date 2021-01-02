import 'dart:convert';

import 'package:fixme/Model/UserSearch.dart';
import 'package:fixme/Screens/Home/HomePage.dart';
import 'package:fixme/Screens/Home/Search.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebServices extends ChangeNotifier {
  var login_state = false;
  var login_state_second = false;
  var Bearer = 'MuYpeP3yqJrVmTZ8B5XpFC';
  var user_id = 264;
  var phoneNum = '';
  var mobile_device_token = '';
  var profile_pic_file_name = '';
  var firstName = '';

  void Login_SetState() {
    if (login_state == false) {
      login_state = true;
    } else {
      login_state = false;
    }
    notifyListeners();
  }

  void Login_SetState_Second() {
    if (login_state_second = false) {
      login_state_second = true;
    } else {
      login_state_second = false;
    }
    notifyListeners();
  }

  Future<dynamic> Register({context, scaffoldKey}) async {
    var data = Provider.of<DataProvider>(context, listen: false);
    var datas = Provider.of<Utils>(context, listen: false);
    try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/create-user'), body: {
        'mobile': data.number.toString().substring(
            data.number.dialCode.length, data.number.toString().length),
        'firstName': data.firstName.toString(),
        'lastName': data.lastName.toString(),
        'device_token': data.firebase_user_id.toString() ?? '',
        'device_os': 'Andriod',
        'device_type': 'phone',
        'email':
            data.emails.toString() == null || data.emails.toString().isEmpty
                ? data.firstName + '@Fixme.com'
                : data.emails.toString(),
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization':
            'Bearer FIXME_1U90P3444ANdroidAPP4HUisallOkayBY_FIXME_APP_UIONSISJGJANKKI3445fv',
      });
      var body = json.decode(response.body);
      user_id = body['user_id'];
      mobile_device_token = body['mobile_device_token'];
      profile_pic_file_name = body['profile_pic_file_name'];
      firstName = body['firstName'];
      phoneNum = body['fullNumber'];
      Bearer = response.headers['bearer'];
      if (body['reqRes'] == 'true') {
        datas.storeData('Bearer', Bearer);
        datas.storeData('mobile_device_token', mobile_device_token);
        datas.storeData('user_id', user_id.toString());
        datas.storeData('profile_pic_file_name', profile_pic_file_name);
        datas.storeData('firstName', firstName);
        datas.storeData('phoneNum', phoneNum);
        Login_SetState();
        return Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return HomePage();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      } else if (body['reqRes'] == 'false') {
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(body['message'])));
        Login_SetState();
      }
      notifyListeners();
    } catch (e) {
      Login_SetState();
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e)));
    }
  }

  Future<dynamic> Login({context, scaffoldKey}) async {
    var data = Provider.of<DataProvider>(context, listen: false);
    var datas = Provider.of<Utils>(context, listen: false);
    try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/user-auth'), body: {
        'phoneNumber': data.number.toString().substring(
            data.number.dialCode.length, data.number.toString().length),
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization':
            'Bearer FIXME_1U90P3444ANdroidAPP4HUisallOkayBY_FIXME_APP_UIONSISJGJANKKI3445fv',
      });
      var body = json.decode(response.body);
      user_id = body['id'];
      mobile_device_token = body['mobile_device_token'];
      profile_pic_file_name = body['profile_pic_file_name'];
      firstName = body['firstName'];
      phoneNum = body['fullNumber'];
      Bearer = response.headers['bearer'];
      datas.storeData('Bearer', Bearer);
      datas.storeData('user_id', user_id.toString());
      if (body['reqRes'] == 'true') {
        Login_SetState();
        return Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return HomePage();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      } else if (body['reqRes'] == 'false') {
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(body['message'])));
        Login_SetState();
      }
      notifyListeners();
    } catch (e) {
      Login_SetState();
      print(e);
    }
  }

  Future<dynamic> NearbyArtisans({longitude, latitude}) async {
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/near-artisans'), body: {
      'user_id': user_id.toString(),
      'longitude': 5.579340.toString(),
      'latitude': 6.327310.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $Bearer',
    });
    var body = json.decode(response.body);
    List result = body['sortedUsers'];
    List<UserSearch> nearebyList = result.map((data) {
      return UserSearch.fromJson(data);
    }).toList();
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return nearebyList;
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  Future Search({longitude, latitude, searchquery}) async {
    try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/search-artisans'), body: {
        'user_id': user_id.toString(),
        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
        'search-query': searchquery.toString(),
      }, headers: {
        // "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $Bearer',
      });
      var body = json.decode(response.body);
      List result = body['users'];
      List<UserSearch> serviceList = result.map((data) {
        return UserSearch.fromJson(data);
      }).toList();
      notifyListeners();
      if (body['reqRes'] == 'true') {
        return serviceList;
      } else if (body['reqRes'] == 'false') {
        print('failed');
      }
    } catch (e) {}
  }

  Future<List> getAvailableBanks() async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/g-b-info?user_id=$user_id'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $Bearer',
        });
    var body = json.decode(response.body);
    return body['bankInfo'];
    // print('The result: '+result.toString());
    // notifyListeners();
    // if (body['reqRes'] == 'true') {
    //   return result;
    // } else if (body['reqRes'] == 'false') {
    //   print('failed');
    // }
  }

  Future<Map> getUserWalletInfo() async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/get-user-bank-info?user_id=$user_id'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $Bearer',
        });
    var body = json.decode(response.body);
    return body['accountInfo'];
    // notifyListeners();
    // print('The result: '+result.toString());
    // if (body['reqRes'] == 'true') {
    //  return result;
    // } else if (body['reqRes'] == 'false') {
    //   return null;
    // }
    // return result;
  }

  Future<List> getUserTransactions() async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/my-transactions?user_id=$user_id'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $Bearer',
        });
    var body = json.decode(response.body);
    return body['transactionDetails'];
  }

  Future<dynamic> validateUserAccountName({bankCode, accountNumber}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/validate-acount-number?user_id=$user_id&bankCode=$bankCode&accountNumber=$accountNumber'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $Bearer',
        });
    var body = json.decode(response.body);
    return body['account_name'];
    // notifyListeners();
    // if (body['reqRes'] == 'true') {
    //   return result;
    // } else if (body['reqRes'] == 'false') {
    //   print('failed');
    // }
  }

  Future<dynamic> checkSecurePin() async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/has-security-pin?user_id=$user_id'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $Bearer',
        });
    var body = json.decode(response.body);
    return body['reqRes'];
  }

  //MjU0NA==

  Future<String> setSecurePin({secPin}) async {
    String encoded = "ApiKey:$secPin";
    var bytes = utf8.encode(encoded);
    var base64Str = base64.encode(bytes);
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/save-security-pin?user_id=$user_id&secPin=Basic $base64Str'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $Bearer',
        });
    var body = json.decode(response.body);
    return body['reqRes'];
  }

  Future<bool> initiateTransfer(
      {bankCode,
      accountNumber,
      accountName,
      amount,
      secPin,
      naration,
      isBeneficiary}) async {
    String encoded = "ApiKey:$secPin";
    var bytes = utf8.encode(encoded);
    var base64Str = base64.encode(bytes);

    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/initiate-transfer?user_id=$user_id&bankCode=$bankCode&accountNumber=$bankCode&accountName=$accountName&amount=100&secPin=Basic $base64Str=&naration=$naration&isBeneficiary=$isBeneficiary'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $Bearer',
        });
    var body = json.decode(response.body);
    bool result;
    if (body['reqRes'] == 'true') {
      result = true;
    } else if (body['reqRes'] == 'false') {
      result = false;
    }
    return result;
  }
}
