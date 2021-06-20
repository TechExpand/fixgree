import 'dart:async';
import 'dart:convert';
import 'package:fixme/Model/UserSearch.dart';
import 'package:fixme/Model/info.dart';
import 'package:fixme/Model/Project.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePage.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebServices extends ChangeNotifier {
  var loginState = false;
  var loginStateSecond = false;
  var loginPopState = false;
  var bearer = '';
  var userId = 0;
  var role = '';
  var phoneNum = '';
  var mobileDeviceToken = '';
  var profilePicFileName = '';
  var firstName = '';
  var lastName = '';
  var bio = '';
  var email = '';

  void loginSetState() {
    if (loginState == false) {
      loginState = true;
    } else {
      loginState = false;
    }
    notifyListeners();
  }

  void loginPopSetState() {
    if (loginPopState == false) {
      loginPopState = true;
    } else {
      loginPopState = false;
    }
    notifyListeners();
  }

  void loginSetStateSecond() {
    if (loginStateSecond = false) {
      loginStateSecond = true;
    } else {
      loginStateSecond = false;
    }
    notifyListeners();
  }

  Future<dynamic> register({context, scaffoldKey}) async {
    var data = Provider.of<DataProvider>(context, listen: false);
    var datas = Provider.of<Utils>(context, listen: false);
    try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/create-user'), body: {
        'mobile': data.number.toString().substring(
            data.number.dialCode.length, data.number.toString().length),
        'firstName': data.firstName.toString(),
        'lastName': data.lastName.toString(),
        'device_token': data.firebaseUserId.toString() ?? '',
        'device_os': 'Andriod',
        'device_type': 'phone',
        'firebaseId': data.firebaseUserId.toString(),
        'email':
            data.emails.toString() == null || data.emails.toString().isEmpty
                ? data.firstName + '@Fixme.com'
                : data.emails.toString(),
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization':
            'Bearer FIXME_1nsjui2SHDS9823HBCDHN2389HDNSJH23NDI3N132n9jc92h3nj_FIXME_APP_23nujujNHU3JNUN42NJK2N39mjni2jn3nk3n8JNN2NJ9jnkjnjkn23jmIOJ23NJ',
      });
      var body = json.decode(response.body);
      print(body);
      print(body);
      print(body);
      userId = body['id'];
      mobileDeviceToken = body['firebaseId'];
      profilePicFileName = body['profile_pic_file_name'];
      firstName = body['firstName'];
      phoneNum = body['fullNumber'];
      role = body['role'];
      bearer = response.headers['bearer'];
      if (body['reqRes'] == 'true') {
        datas.storeData('Bearer', bearer);
        datas.storeData('mobile_device_token', mobileDeviceToken);
        datas.storeData('user_id', userId.toString());
        datas.storeData('profile_pic_file_name', profilePicFileName);
        datas.storeData('firstName', firstName);
        datas.storeData('phoneNum', phoneNum);
        datas.storeData('role', role);

        loginSetState();
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
        loginSetState();
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(body['message'])));
      }
      notifyListeners();
    } catch (e) {
      loginSetState();
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e)));
    }
  }

  Future<dynamic> login({context, scaffoldKey}) async {
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
            'Bearer FIXME_1nsjui2SHDS9823HBCDHN2389HDNSJH23NDI3N132n9jc92h3nj_FIXME_APP_23nujujNHU3JNUN42NJK2N39mjni2jn3nk3n8JNN2NJ9jnkjnjkn23jmIOJ23NJ',
      });
      var body = json.decode(response.body);
      bearer = response.headers['bearer'];

      userId = body['id'];
      profilePicFileName = body['profile_pic_file_name'];
      firstName = body['firstName'];
      lastName = body['lastName'];
      role = body['role'];
      phoneNum = body['fullNumber'];
      email = body['email'];

      var response2 = await http.post(
          Uri.parse('https://manager.fixme.ng/user-info?user_id=$userId'),
          headers: {
            "Content-type": "application/json",
            'Authorization': 'Bearer $bearer',
          });
      var body2 = json.decode(response2.body);
      bio = body2['bio'];
      mobileDeviceToken = body['firebase_id'];
      if (body['reqRes'] == 'true') {
        datas.storeData('Bearer', bearer);
        datas.storeData('mobile_device_token', mobileDeviceToken);
        datas.storeData('user_id', userId.toString());
        datas.storeData('profile_pic_file_name', profilePicFileName);
        datas.storeData('firstName', firstName);
        datas.storeData('lastName', lastName);
        datas.storeData('phoneNum', phoneNum);
        datas.storeData('email', email);
        datas.storeData('role', role);
        datas.storeData('about', bio);
        loginSetState();
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
      } else if (body['message'] == "Invalid Credentials!") {
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(body['message'])));
        loginSetState();
      } else if (body['reqRes'] == 'false') {
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(body['message'])));
        loginSetState();
      }
      notifyListeners();
    } catch (e) {
      loginSetState();
      print(e);
    }
  }

  initializeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = int.parse(prefs.getString('user_id'));
    bearer = prefs.getString('Bearer');
    mobileDeviceToken = prefs.getString('mobile_device_token');
    profilePicFileName = prefs.getString('profile_pic_file_name');
    firstName = prefs.getString('firstName');
    phoneNum = prefs.getString('phoneNum');
    bio = prefs.getString('about');
    email = prefs.getString('email');
    role = prefs.getString('role');
    lastName = prefs.getString('lastName');
    notifyListeners();
  }

  Future<dynamic> initiateProject(projectOwnerUserId, bidId, projectId,
      serviceId, budget, context, setStates) async {
    try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/save-send-budget'), body: {
        'user_id': userId.toString(),
        'project_owner_user_id': '$projectOwnerUserId',
        'bid_id': '$bidId',
        'project_id': '$projectId',
        'service_id': '$serviceId',
        'budget': '$budget',
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $bearer',
      });
      var body = json.decode(response.body);
      notifyListeners();
      if (body['reqRes'] == 'true') {
        setStates(() {});
        loginPopSetState();
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("JOB INITIATED")));

        return body;
      } else if (body['reqRes'] == 'false') {
        setStates(() {});
        loginPopSetState();
        Navigator.pop(context);
//      scaffoldKey.showSnackBar(
//          new SnackBar(content: new Text("JOB INITIATION FAILED")));
        print(body);
      }
    } catch (e) {
      setStates(() {});
      loginPopSetState();
      print(e);
//      scaffoldKey.showSnackBar(
//          new SnackBar(content: new Text("Failed")));
    }
  }

  Future<dynamic> becomeArtisanOrBusiness({context, scaffoldKey}) async {
    var data = Provider.of<DataProvider>(context, listen: false);
    var datas = Provider.of<Utils>(context, listen: false);
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/business-account'), body: {
        'identification_number': data.bvn ?? '',
        'business_address': data.officeAddress ?? '',
        'house_address': data.homeAddress ?? '',
        'business_name': data.businessName ?? '',
        'sub_services':
            '${data.subcat}'.replaceAll('[', '').replaceAll(']', ''),
        'bio': data.overview ?? '',
        'role': data.artisanVendorChoice,
        'service_id': '${postRequestProvider.selecteService.sn}',
        'user_id': '$userId',
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $bearer',
      });
      var body = json.decode(response.body);
      print(body);
      if (body['reqRes'] == 'true') {
        datas.storeData('role', data.artisanVendorChoice);
        loginSetState();
        role = prefs.getString('role');
        data.subcat.clear();
        return Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ProfilePage();
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
      } else if (body['message'] == 'Duplicate Sub-Service Entry' &&
          body['reqRes'] == 'false') {
        scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Duplicate Sub-Service Entry')));
        loginSetState();
      } else if (body['reqRes'] == 'false') {
        scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('There was a Problem. Working on it.')));
        loginSetState();
      }
      notifyListeners();
    } catch (e) {
      print(e);
      loginSetState();
      scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('There was a Problem. Working on it.')));
    }
  }

  Future<dynamic> getServiceProviderByServiceID(
      {longitude, latitude, serviceID}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/service-area-business-artisans?user_id=$userId&service_id=$serviceID&longitude=$longitude&latitude=$latitude'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    List result = body['sortedUsers'];
    List<UserSearch> serviceProviders = result.map((data) {
      return UserSearch.fromJson(data);
    }).toList();
    if (body['reqRes'] == 'true') {
      return serviceProviders;
    } else if (body['reqRes'] == 'false') {
      return body['message'];
    }
  }

  Future<dynamic> getArtisanReviews([userId]) async {
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/get-reviews'), body: {
      'user_id': this.userId.toString(),
      'artisan_id': userId.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    print(body);
    print(body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body['reviews'];
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  Future<dynamic> confirmBudget([bidderUserId, bidId, scaffoldKey]) async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/approve-bid'
            ''),
        body: {
          'user_id': userId.toString(),
          'bidder_user_id': bidderUserId.toString(),
          'bid_id': bidId.toString(),
        },
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body['reqRes']);
      scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Project Confirmed Successfully')));
      return body['reviews'];
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  Future<dynamic> confirmPaymentAndReview(
      [rating, jobid, comment, scafoldKey, artisanId, userId, context]) async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/confirm-project-completion-rating'
            ''),
        body: {
          'reviewing_user_id': userId.toString(),
          'reviewed_user_id': artisanId.toString(),
          'job_id': jobid.toString(),
          'rating': rating.toString(),
          'review': comment.toString(),
        },
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: new Text("Review Successfully Submited")));
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future<dynamic> bidProject([userId, jobId, scaffoldKey]) async {
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/bid-project'), body: {
      'user_id': userId.toString(),
      'job_id': jobId.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body);
      print(body);
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Project Bid Successfully')));
      return body['reviews'];
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  Future<dynamic> getUserInfo([userId]) async {
    var response =
        await http.post(Uri.parse('https://manager.fixme.ng/user-info'), body: {
      'user_id': userId.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  // getUserJobInfo

  Future<dynamic> getUserJobInfo([userId, artisanId]) async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/get-artisan-business-profile'),
        body: {
          'requesting_user_id': 286.toString(),
          'artisan_user_id': 286.toString(),
        },
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    Map map = json.decode(response.body.toString());
//    Info info = Info.fromJson(map);
//print(info.fullNumber);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  Future<dynamic> getServiceImage([userId, requestedId]) async {
    print(userId);
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/service-images'), body: {
      'user_id': userId.toString(),
      'requested_user_id': requestedId.toString()
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body['servicePictures'];
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  Future<dynamic> getProductImage([userId, requestedId]) async {
    print(userId);
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/get-catalog-products'),
        body: {
          'user_id': userId.toString(),
          'requested_user_id': requestedId.toString(),
        },
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body['productCatalog'];
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  Future uploadProductCatalog(
      {bio, productName, price, scaffoldKey, path, context}) async {
    try {
      var res = await http.post(
          Uri.parse('https://manager.fixme.ng/save-catlog-product'),
          body: {
            'product_name': productName.toString() ?? '',
            'price': price.toString() ?? '',
            'bio': bio.toString() ?? '',
            'user_id': '$userId',
          },
          headers: {
            "Content-type": "application/x-www-form-urlencoded",
            'Authorization': 'Bearer $bearer',
          });

      var body = jsonDecode(res.body);
      notifyListeners();
      if (body['reqRes'] == 'true') {
        var upload = http.MultipartRequest(
            'POST', Uri.parse('https://uploads.fixme.ng/product-image-upload'));
        var file = await http.MultipartFile.fromPath('file', path);
        upload.files.add(file);
        upload.fields['product_id'] = body['productId'].toString();
        upload.fields['product_name'] = productName.toString();
        upload.fields['user_id'] = userId.toString();
        upload.headers['authorization'] = 'Bearer $bearer';

        final stream = await upload.send();
        var resp = await http.Response.fromStream(stream);
        var bodys = jsonDecode(resp.body);

        if (bodys['upldRes'] == 'true') {
          loginSetState();
          showDialog(
              barrierDismissible: false,
              builder: (ctx) {
                return WillPopScope(
                  onWillPop: () {},
                  child: AlertDialog(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    content: Container(
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            width: 250,
                            child: Text(
                              'Product Successfully Added to Catalog. Add Another Product?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              !loginState
                                  ? Material(
                                      borderRadius: BorderRadius.circular(26),
                                      elevation: 2,
                                      child: Container(
                                        height: 40,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFFE60016)),
                                            borderRadius:
                                                BorderRadius.circular(26)),
                                        child: FlatButton(
                                          onPressed: () {
                                            loginSetState();
                                            becomeArtisanOrBusiness(
                                              context: context,
                                              scaffoldKey: scaffoldKey,
                                            );
                                            Navigator.pop(context);
                                          },
                                          color: Color(0xFFE60016),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(26)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(26)),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 190.0,
                                                  minHeight: 53.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "No Please!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF9B049B))),
                              SizedBox(width: 5),
                              Material(
                                borderRadius: BorderRadius.circular(26),
                                elevation: 2,
                                child: Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.circular(26)),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 190.0, minHeight: 53.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Yes Please!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              context: context);
          return bodys;
        } else if (bodys['upldRes'] == 'false') {
          loginSetState();
          showDialog(
              builder: (ctx) {
                return AlertDialog(
                  title: Center(
                    child: Text('There was a Problem Working on it!',
                        style: TextStyle(color: Colors.blue)),
                  ),
                );
              },
              context: context);
        }
      } else if (body['reqRes'] == 'false') {
        loginSetState();
        showDialog(
            builder: (ctx) {
              return AlertDialog(
                title: Center(
                  child: Text('There was a Problem Working on it!',
                      style: TextStyle(color: Colors.blue)),
                ),
              );
            },
            context: context);
      }
    } catch (e) {
      showDialog(
          builder: (ctx) {
            return AlertDialog(
              title: Center(
                child: Text('$e', style: TextStyle(color: Colors.blue)),
              ),
            );
          },
          context: context);
      loginSetState();
    }
  }

  Future validatePayment(refId) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/verify-payment?payment_reference_id=$refId&user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    print(body['message']);
    return body['message'];
  }

  Future addProductCatalog(
      {bio, productName, price, scaffoldKey, path, context}) async {
    var res = await http
        .post(Uri.parse('https://manager.fixme.ng/save-catlog-product'), body: {
      'product_name': productName.toString() ?? '',
      'price': price.toString() ?? '',
      'bio': bio.toString() ?? '',
      'user_id': '$userId',
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });

    var body = jsonDecode(res.body);
    print(body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      var upload = http.MultipartRequest(
          'POST', Uri.parse('https://uploads.fixme.ng/product-image-upload'));
      var file = await http.MultipartFile.fromPath('file', path);
      upload.files.add(file);
      upload.fields['product_id'] = body['productId'].toString();
      upload.fields['product_name'] = productName.toString();
      upload.fields['user_id'] = userId.toString();
      upload.headers['authorization'] = 'Bearer $bearer';

      final stream = await upload.send();
      var resp = await http.Response.fromStream(stream);
      var bodys = jsonDecode(resp.body);

      if (bodys['upldRes'] == 'true') {
        SnackBar(
          content:
              Text(bodys.toString(), style: TextStyle(color: Colors.white)),
        );
        return 'success';
      } else if (bodys['upldRes'] == 'false') {
        SnackBar(
          content: Text('There was a Problem Working on it!',
              style: TextStyle(color: Colors.white)),
        );
      }
    } else if (body['reqRes'] == 'false') {
      SnackBar(
        content: Text('There was a Problem Working on it!',
            style: TextStyle(color: Colors.white)),
      );
    }
  }

  Future addSerPic({path, uploadType, scaffoldKey, context}) async {
    try {
      var upload = http.MultipartRequest(
          'POST', Uri.parse('https://uploads.fixme.ng/uploads-processing'));
      var file = await http.MultipartFile.fromPath('file', path);
      upload.files.add(file);
      upload.fields['uploadType'] = uploadType.toString();
      upload.fields['firstName'] = firstName.toString();
      upload.fields['user_id'] = userId.toString();
      upload.headers['authorization'] = 'Bearer $bearer';

      final stream = await upload.send();
      var res = await http.Response.fromStream(stream);

      var body = jsonDecode(res.body);
      notifyListeners();
      if (body['upldRes'] == 'true') {
        return body;
      } else if (body['upldRes'] == 'false') {
        showDialog(
            builder: (ctx) {
              return AlertDialog(
                title: Center(
                  child: Text('There was a Problem Working on it!',
                      style: TextStyle(color: Colors.blue)),
                ),
              );
            },
            context: context);
      }
    } catch (e) {
      showDialog(
          builder: (ctx) {
            return AlertDialog(
              title: Center(
                child: Text('There was a Problem Working on it!',
                    style: TextStyle(color: Colors.blue)),
              ),
            );
          },
          context: context);
      print(e);
    }
  }

  Future uploadCatalog({path, uploadType, scaffoldKey, context}) async {
    try {
      var upload = http.MultipartRequest(
          'POST', Uri.parse('https://uploads.fixme.ng/uploads-processing'));
      var file = await http.MultipartFile.fromPath('file', path);
      upload.files.add(file);
      upload.fields['uploadType'] = uploadType.toString();
      upload.fields['firstName'] = firstName.toString();
      upload.fields['user_id'] = userId.toString();
      upload.headers['authorization'] = 'Bearer $bearer';

      final stream = await upload.send();
      var res = await http.Response.fromStream(stream);

      var body = jsonDecode(res.body);
      notifyListeners();
      if (body['upldRes'] == 'true') {
        loginSetState();
        showDialog(
            barrierDismissible: false,
            builder: (ctx) {
              return WillPopScope(
                onWillPop: () {},
                child: AlertDialog(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  content: Container(
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          width: 250,
                          child: Text(
                            'Photo Successfully Added to Catalog. Add Another Photo?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            !loginState
                                ? Material(
                                    borderRadius: BorderRadius.circular(26),
                                    elevation: 2,
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFFE60016)),
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      child: FlatButton(
                                        onPressed: () {
                                          loginSetState();
                                          becomeArtisanOrBusiness(
                                            context: context,
                                            scaffoldKey: scaffoldKey,
                                          );
                                          Navigator.pop(context);
                                        },
                                        color: Color(0xFFE60016),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(26)),
                                        padding: EdgeInsets.all(0.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(26)),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 190.0,
                                                minHeight: 53.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Please!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF9B049B))),
                            SizedBox(width: 5),
                            Material(
                              borderRadius: BorderRadius.circular(26),
                              elevation: 2,
                              child: Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(26)),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 190.0, minHeight: 53.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Yes Please!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            context: context);
        return body;
      } else if (body['upldRes'] == 'false') {
        loginSetState();
        showDialog(
            builder: (ctx) {
              return AlertDialog(
                title: Center(
                  child: Text('There was a Problem Working on it!',
                      style: TextStyle(color: Colors.blue)),
                ),
              );
            },
            context: context);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadProfilePhoto({path}) async {
    String imageName;
    try {
      var upload = http.MultipartRequest(
          'POST', Uri.parse('https://uploads.fixme.ng/uploads-processing'));
      upload.headers['Authorization'] = 'Bearer $bearer';
      upload.headers['Content-type'] = 'application/json';
      var file = await http.MultipartFile.fromPath('file', path);

      upload.fields['user_id'] = userId.toString();
      upload.fields['firstName'] = firstName.toString();
      upload.fields['uploadType'] = 'profilePicture';
      upload.files.add(file);

      final stream = await upload.send();
      var res = await http.Response.fromStream(stream);
      var body = jsonDecode(res.body);
      notifyListeners();

      if (body['upldRes'] == 'true') {
        imageName = body['imageFileName'];
      } else if (body['upldRes'] == 'false') {}
    } catch (e) {
      print(e);
    }
    return imageName;
  }

  Future<bool> editUserName({firstname, lastname}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/e-f-n?user_id=$userId&firstName=$firstname&lastName=$lastname'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    var res;
    if (body['reqRes'] == 'true') {
      res = true;
    } else if (body['reqRes'] == 'false') {
      res = false;
    }
    return res;
  }

  Future<bool> editUserBio({status}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/update-bio?user_id=$userId&bio=$status'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    var res;
    if (body['reqRes'] == 'true') {
      res = true;
    } else if (body['reqRes'] == 'false') {
      res = false;
    }
    return res;
  }

  Future uploadPhoto({path, uploadType, navigate, context}) async {
    try {
      var upload = http.MultipartRequest(
          'POST', Uri.parse('https://uploads.fixme.ng/uploads-processing'));
      upload.headers['Authorization'] = 'Bearer $bearer';
      upload.headers['Content-type'] = 'application/json';
      var file = await http.MultipartFile.fromPath('file', path);

      upload.fields['user_id'] = userId.toString();
      upload.fields['firstName'] = firstName.toString();
      upload.fields['uploadType'] = uploadType.toString();
      upload.files.add(file);

      final stream = await upload.send();
      var res = await http.Response.fromStream(stream);
      var body = jsonDecode(res.body);
      notifyListeners();
      if (body['upldRes'] == 'true') {
        loginSetState();
        navigate.jumpToPage(3);
        print(body['upldRes']);
        return body;
      } else if (body['upldRes'] == 'false') {
        loginSetState();
        showDialog(
            builder: (ctx) {
              return AlertDialog(
                title: Center(
                  child: Text('There was a Problem Working on it!',
                      style: TextStyle(color: Colors.blue)),
                ),
              );
            },
            context: context);
      }
    } catch (e) {
      showDialog(
          builder: (ctx) {
            return AlertDialog(
              title: Center(
                child: Text('There was a Problem Working on it!',
                    style: TextStyle(color: Colors.blue)),
              ),
            );
          },
          context: context);
      loginSetState();
      print(e);
    }
  }

  Future<dynamic> updateFCMToken(userId, fcmToken) async {
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/mtk-details-update'), body: {
      'user_id': userId.toString(),
      'device_token': fcmToken.toString(),
      'device_os': 'andriod',
      'device_type': 'techno',
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future<dynamic> updateBio(bio) async {
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/update-bio'), body: {
      'user_id': userId.toString(),
      'bio': '$bio',
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body['reqRes']);
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future<dynamic> updateService(sn) async {
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/change-service'), body: {
      'user_id': userId.toString(),
      'service_id': '$sn',
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body['reqRes']);
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future<dynamic> updateFullName(firstName, lastName) async {
    var response =
        await http.post(Uri.parse('https://manager.fixme.ng/e-f-n'), body: {
      'user_id': userId.toString(),
      'firstName': '$firstName',
      'lastName': '$lastName',
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body['reqRes']);
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future<dynamic> requestPayment(project_owner_user_id, bid_id) async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/completed-project-and-payment'),
        body: {
          'bidder_user_id': userId.toString(),
          'project_id': bid_id.toString(),
        },
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body);
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future<dynamic> getUndoneProject(context) async {
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/user-projects'), body: {
      'user_id': userId.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    if (response.statusCode == 500) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return SnackBar(content: Center(child: Text('Connection TimeOut')));
        },
      );
      return response.statusCode;
    } else {
      var body1 = json.decode(response.body);
      List body = body1['projects'];
      List<Project> projects = body
          .map((data) {
            return Project.fromJson(data);
          })
          .toSet()
          .toList();

      notifyListeners();
      if (body1['reqRes'] == 'true') {
        return projects;
      } else if (body1['reqRes'] == 'false') {}
    }
  }

  Future<dynamic> getBiddedJobs(context) async {
    print(userId);
    print(bearer);
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/all-my-bids-projects'),
        body: {
          'user_id': userId.toString(),
        },
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $bearer',
        });
    if (response.statusCode == 500) {
    } else {
      var body1 = json.decode(response.body);
      List body = body1['projects'];
      List<Project> projects = body
          .map((data) {
            return Project.fromJson(data);
          })
          .toSet()
          .toList();

      notifyListeners();
      if (body1['reqRes'] == 'true') {
        print(body1);
        return projects;
      } else if (body1['reqRes'] == 'false') {}
    }
  }

  Future postViewed(artisanId) async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/profile-views-update?viewing_user_id=$userId&viewed_user_id=$artisanId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    print( body['reqRes']+'ree');
    return body['reqRes'];
  }



  Future<dynamic> nearbyArtisans({longitude, latitude, context}) async {
    try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/near-artisans'), body: {
        'user_id': userId.toString(),
   'latitude':  '5.001190',
   'longitude' :'8.334840'

        // 'longitude': longitude.toString(),
        // 'latitude': latitude.toString(),
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $bearer',
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        print('nnnnnn');
        throw TimeoutException('The connection has timed out, Please check your'
            ' internet connection and try again!');
      });
      print(response.statusCode);
      if (response.statusCode == 500) {
        print("You are not connected to internet");
      } else {
        var body = json.decode(response.body);
        print(body.toString());
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
    } on TimeoutException catch (err) {
      print('nnnnnn');
      // artisanRegStatus = Status.timeOut;
      Get.snackbar('nnncc', 'jjdjjd');

      return err.message;
    }
  }

  Future<dynamic> nearbyShop({longitude, latitude, context}) async {
    var response = await http
        .post(Uri.parse('https://manager.fixme.ng/near-shops-business'), body: {
      'user_id': userId.toString(),
     'latitude':  '5.001190',
     'longitude' :'8.334840',
//       'longitude': longitude.toString(),
//       'latitude': latitude.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    if (response.statusCode == 500) {
      print("You are not connected to internet");
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Connection TimeOut')),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(child: Text('Retry or Login Again')),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'exit',
                  style: TextStyle(color: Color(0xFF9B049B)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      var body = json.decode(response.body);
      List result = body['sortedUsers'];
      List<UserSearch> nearebyList = result.map((data) {
        return UserSearch.fromJson(data);
      }).toList();
      notifyListeners();

      if (body['reqRes'] == 'true') {
        return nearebyList;
      } else if (body['reqRes'] == 'false') {}
    }
  }

  Future search({longitude, latitude, searchquery}) async {
    try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/search-artisans'), body: {
        'user_id': userId.toString(),
        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
        'search-query': searchquery.toString(),
      }, headers: {
        // "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $bearer',
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
        Uri.parse('https://manager.fixme.ng/g-b-info?user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    return body['bankInfo'];
  }

  Future<Map> getUserWalletInfo(context) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/get-user-bank-info?user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    if (response.statusCode == 500) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Connection TimeOut')),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(child: Text('Retry or Login Again')),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'exit',
                  style: TextStyle(color: Color(0xFF9B049B)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      var body = json.decode(response.body);
      return body['accountInfo'];
    }
  }

  Future<Map> getUserBankInfo(userId) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/get-user-bank-info?user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    return body['accountInfo'];
  }

  Future<List> getUserTransactions() async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/my-transactions?user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    return body['transactionDetails'];
  }

  Future<dynamic> validateUserAccountName({bankCode, accountNumber}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/validate-acount-number?user_id=$userId&bankCode=$bankCode&accountNumber=$accountNumber'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    if (body['reqRes'] == 'true') {
      return body['account_name'];
    } else if (body['reqRes'] == 'false') {
      return body['message'];
    }
  }

  Future getCardDetails() async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/get-payment-details?user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    print(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body['cardInfo'];
    } else if (body['message'] == 'No Available Card') {
      return 'No Available Card';
    } else if (body['reqRes'] == 'false') {
      print('failed');
    }
  }

  Future<dynamic> checkSecurePin() async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/has-security-pin?user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    return body['reqRes'];
  }

  Future<String> setSecurePin({secPin}) async {
    String encoded = "ApiKey:$secPin";
    var bytes = utf8.encode(encoded);
    var base64Str = base64.encode(bytes);
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/save-security-pin?user_id=$userId&secPin=Basic $base64Str'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    return body['reqRes'];
  }

  Future<List> getBeneficiaries() async {
    var response = await http.post(
        Uri.parse('https://manager.fixme.ng/all-beneficiaries?user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    return body['userBeneficiaries'];
    // print('The result: '+result.toString());
    // notifyListeners();
    // if (body['reqRes'] == 'true') {
    //   return result;
    // } else if (body['reqRes'] == 'false') {
    //   print('failed');
    // }
  }

  Future addCatalog({path, uploadType}) async {
    try {
      var upload = http.MultipartRequest(
          'POST', Uri.parse('https://uploads.fixme.ng/uploads-processing'));
      var file = await http.MultipartFile.fromPath('file', path);
      upload.files.add(file);
      upload.fields['uploadType'] = uploadType.toString();
      upload.fields['firstName'] = firstName.toString();
      upload.fields['user_id'] = userId.toString();
      upload.headers['authorization'] = 'Bearer $bearer';

      final stream = await upload.send();
      var res = await http.Response.fromStream(stream);

      var body = jsonDecode(res.body);
      notifyListeners();
      if (body['upldRes'] == 'true') {
        SnackBar(content: Text('Image uploaded succesfully'));
        return 'succesful';
      } else if (body['upldRes'] == 'false') {
        SnackBar(content: Text('Image upload was unsuccesful'));
        return 'failed';
      }
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
  }

  Future<Map> initiateTransfer(
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
            'https://manager.fixme.ng/initiate-transfer?user_id=$userId&bankCode=$bankCode&accountNumber=$accountNumber&accountName=$accountName&amount=$amount&secPin=Basic $base64Str&naration=$naration&isBeneficiary=$isBeneficiary'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    Map<String, String> result = {
      'reqRes': body['reqRes'],
      'message': body['message'] == null ? null : body['message']
    };
    return result;
  }

  Future<bool> sendSupportRequest({String topic, String message}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/support-request?user_id=264&topic=$topic&message=$message'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    bool res;
    if (body['reqRes'] == 'true') {
      res = true;
    } else if (body['reqRes'] == 'false') {
      res = false;
    }
    return res;
  }

  Future<bool> deleteServiceCatalogueImage({imageFileName}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/del-svc-img?user_id=$userId&image_id=$imageFileName'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    print('The response: ' + body.toString());
    bool res;
    if (body['reqRes'] == 'true') {
      res = true;
    } else if (body['reqRes'] == 'false') {
      res = false;
    }
    return res;
  }

  Future<bool> deleteCatalogueProducts({productId}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/delete-product-catalog?user_id=$userId&product_id=$productId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    bool res;
    if (body['reqRes'] == 'true') {
      res = true;
    } else if (body['reqRes'] == 'false') {
      res = false;
    }
    return res;
  }

  Future<bool> deleteCatalogueProductImage({productImageId}) async {
    var response = await http.post(
        Uri.parse(
            'https://manager.fixme.ng/delete-product-catalog-image?user_id=$userId&product_image_id=$productImageId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    bool res;
    if (body['reqRes'] == 'true') {
      res = true;
    } else if (body['reqRes'] == 'false') {
      res = false;
    }
    return res;
  }
}
