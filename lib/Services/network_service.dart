import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:fixme/Model/Product.dart';
import 'package:fixme/Model/UserSearch.dart';
import 'package:device_info/device_info.dart';
import 'package:fixme/Model/Project.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePageNew.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Screens/GeneralUsers/Notification/Pay.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:dio/dio.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_encoder/url_encoder.dart';
import '../DummyData.dart';
import 'Firebase_service.dart';

class WebServices extends ChangeNotifier {
  var loginState = false;
  var loginStateSecond = false;
  var loginPopState = false;
  var bearer = '';
  var userId = 0;
  var role = '';
  var phoneNum = '';
  var mobileDeviceToken = '';
  var paymentToken = '';
  var profilePicFileName = '';
  var firstName = '';
  var newid = 0;
  var serviceId = 0;
  var lastName = '';
  var bio = '';
  var email = '';
  String mainUrl = 'https://manager.fixme.ng';
  String mainBearer =
      'FIXME_1nsjui2SHDS9823HBCDHN2389HDNSJH23NDI3N132n9jc92h3nj_FIXME_APP_23nujujNHU3JNUN42NJK2N39mjni2jn3nk3n8JNN2NJ9jnkjnjkn23jmIOJ23NJ';

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

  String os = '';
  String info = '';

  checkDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      info = androidInfo.model;
      os = 'Android';
      print('Running on ${androidInfo.device}'); //

    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      info = iosInfo.model.toString()+" "+iosInfo.name+" "+iosInfo.systemName;
      os = 'IOS';
     // print('Running on ${iosInfo.utsname.machine}');
    }
    notifyListeners();
  }

  Future<dynamic> register({context, scaffoldKey}) async {
    var data = Provider.of<DataProvider>(context, listen: false);
    var datas = Provider.of<Utils>(context, listen: false);
    LgaProvider state =  Provider.of<LgaProvider>(context, listen: false);
    var location = Provider.of<LocationService>(context, listen: false);
    try {
      var response = await http.post(Uri.parse('$mainUrl/create-user'), body: {
        'mobile': data.number.toString().substring(
            data.number.dialCode.length, data.number.toString().length),
        'firstName': data.firstName.toString(),
        'lastName': data.lastName.toString(),
        'referral_Id': data.referalId.isEmpty ? '0' : data.referalId,
        'device_token': datas.fcmToken.toString() ?? '',
        'device_os': os.toString(),
        'state': state.seletedinfo.name.toString(),
        'city': data.city.toString(),
        'address': data.adress.toString(),
        'longitude': location.locationLongitude.toString(),
        'latitude': location.locationLatitude.toString(),
        'device_type': info.toString(),
        'password': data.password.toString(),
        'firebaseId': data.getRandomString(28).toString(),
        'email':
            data.emails.toString() == null || data.emails.toString().isEmpty
                ? data.firstName + '@Fixme.com'
                : data.emails.toString(),
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $mainBearer',
      });
      var body = json.decode(response.body);
      userId = body['user_id'];
      mobileDeviceToken = body['firebaseId'];
      profilePicFileName = body['profile_pic_file_name'];
      firstName = body['firstName'];
      lastName = body['lastName'];
      phoneNum = body['fullNumber'];
      email = body['email'];
      paymentToken = body['payment_token'];
      role = body['user_role'];
      serviceId = body['service_id'];
      bearer = response.headers['bearer'];
      if (body['reqRes'] == 'true') {
        datas.storeData('Bearer', bearer);
        datas.storeData('paymentToken', paymentToken);
        datas.storeData('mobile_device_token', mobileDeviceToken);
        datas.storeData('user_id', userId.toString());
        datas.storeData('profile_pic_file_name', profilePicFileName);
        datas.storeData('email', email);
        datas.storeData('firstName', firstName);
        datas.storeData('lastName', lastName);
        datas.storeData('service_id', serviceId.toString());
        datas.storeData('phoneNum', phoneNum);
        datas.storeData('role', role);
        loginSetState();
        return Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return HomePage(firstUser: 'first',);
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
        await showTextToast(
          text: body['message'],
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {
      loginSetState();
      await showTextToast(
        text: e.toString(),
        context: context,
      );
    }
  }

  Future<dynamic> login({context, scaffoldKey}) async {
    var data = Provider.of<DataProvider>(context, listen: false);
    var datas = Provider.of<Utils>(context, listen: false);
    try {
      var response = await http.post(Uri.parse('$mainUrl/user-auth'), body: {
        'phoneNumber': data.number.toString().substring(
            data.number.dialCode.length, data.number.toString().length),
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $mainBearer',
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
      serviceId = body['service_id'];
      paymentToken = body['payment_token'];

      if (body['reqRes'] == 'true') {
        var response2 = await http
            .post(Uri.parse('$mainUrl/user-info?user_id=$userId'), headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
        var body2 = json.decode(response2.body);
        bio = body2['bio'];
        mobileDeviceToken = body['firebase_id'];

        datas.storeData('Bearer', bearer);
        datas.storeData('mobile_device_token', mobileDeviceToken);
        datas.storeData('user_id', userId.toString());
        datas.storeData('profile_pic_file_name', profilePicFileName);
        datas.storeData('firstName', firstName);
        datas.storeData('lastName', lastName);
        datas.storeData('phoneNum', phoneNum);
        datas.storeData('paymentToken', paymentToken);
        datas.storeData('email', email);
        datas.storeData('role', role);
        datas.storeData('service_id', serviceId.toString());
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
      } else if (body['message'].toString() == "Invalid Credentials!") {
        await showTextToast(
          text: 'User Does Not Exist',
          context: context,
        );

        loginSetState();
      } else if (body['reqRes'].toString() == 'false') {
        await showTextToast(
          text: body['message'],
          context: context,
        );

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
    serviceId = int.parse(prefs.getString('service_id'));
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



  Future sendSms({product_name, price, phone,context}) async {
   String message = """Fixme: You Have a purchase request in your inbox. Product Name: ${product_name.toString()}, Product Price: ₦${price.toString()}. Quickly check your inbox to complete this sale""";
   Locale locale = Localizations.localeOf(context);
   var format = NumberFormat.simpleCurrency(locale: locale.toString());
   print(format.currencySymbol);
   String password = urlEncode(text: format.currencySymbol+"Password##");
   String phoneNumber = urlEncode(text: '+234'+phone);
   print(phoneNumber);
   print(phoneNumber);
   String url = "https://account.kudisms.net/api/?username=ayez1389@yahoo.com&password=$password&message=$message&sender=Fixme&mobiles=$phoneNumber";
    var response = await http.get(
        Uri.parse(
            url),
        headers: {
          "Content-type": "application/json",
          //'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    if (response.statusCode >= 200) {
      print(response.body);
      print(response.body);
    } else  {
      print('falseeeeee');
    }
  }



  Future<dynamic> initiateProject(mainserviceId, projectOwnerUserId, bidId,
      projectId, serviceId, budget, context, setStates) async {
    // print("userid $userId");
    // print('proid $projectOwnerUserId');
    // print('bidid ${bidId==null}');
    // print('project ${projectId==null}');
    // print('service $mainserviceId');
    // print('budget $budget');
    bool budID= (bidId==null) || (bidId == '');
    bool prodID = (projectId==null) || (projectId == '');


    try {
      var response =
          await http.post(Uri.parse('$mainUrl/save-send-budget'), body: {
        'user_id': userId.toString(),
        'project_owner_user_id': projectOwnerUserId.toString(),
            budID?'':'bid_id':bidId.toString(),
            prodID?'':'project_id': projectId.toString(),
        'service_id': mainserviceId.toString(),
        'budget': budget.toString(),
      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $bearer',
      });
      print(response.body);
    print(response.body);
    print(response.body);
      var body = json.decode(response.body);

      notifyListeners();
      if (body['reqRes'] == 'true') {
        setStates(() {});
        loginPopSetState();
        Navigator.pop(context);
        await showTextToast(
          text: 'JOB INITIATED',
          context: context,
        );
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: new Text("JOB INITIATED")));

        return body;
      } else if (body['reqRes'] == 'false') {
        setStates(() {});
        loginPopSetState();
        Navigator.pop(context);
        await showTextToast(
          text: "JOB INITIATION FAILED",
          context: context,
        );
      }
    } catch (e) {
      setStates(() {});
      loginPopSetState();
      Navigator.pop(context);
      await showTextToast(
        text: "JOB INITIATION FAILED",
        context: context,
      );
    }
  }

  Future<dynamic> becomeArtisanOrBusiness({context, scaffoldKey}) async {
    var data = Provider.of<DataProvider>(context, listen: false);
    var datas = Provider.of<Utils>(context, listen: false);
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response =
          await http.post(Uri.parse('$mainUrl/business-account'), body: {
        'identification_number': data.bvn ?? '',
        'business_address': data.officeAddress ?? '',
        'house_address': data.homeAddress ?? '',
        'business_name': data.businessName ?? '',
        'sub_services':
            "${data.subcat}".replaceAll('[', '').replaceAll(']', ''),
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
              return ProfilePageNew();
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
        await showTextToast(
          text: "Duplicate Sub-Service Entry.",
          context: context,
        );

        loginSetState();
      } else if (body['reqRes'] == 'false') {
        await showTextToast(
          text: "There was a Problem. Working on it.",
          context: context,
        );

        loginSetState();
      }
      notifyListeners();
    } catch (e) {
      loginSetState();
      await showTextToast(
        text: "There was a Problem. Working on it.",
        context: context,
      );
    }
  }

  Future<dynamic> getServiceProviderByServiceID(
      {longitude, latitude, serviceID}) async {
    var response = await http.post(
        Uri.parse(
            '$mainUrl/service-area-business-artisans?user_id=$userId&service_id=$serviceID&longitude=$longitude&latitude=$latitude'),
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
    var response = await http.post(Uri.parse('$mainUrl/get-reviews'), body: {
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

  Future<dynamic> confirmBudget({context,
  bidderUserId, bidId, invoceId,paymentMethod, data, myPage}) async {
    try{
    var response = await http.post(
        Uri.parse('$mainUrl/approve-bid'
            ''),
        body: {
          'user_id': userId.toString(),
          'bidder_user_id': bidderUserId.toString(),
          bidId==null?null:'bid_id': bidId.toString(),
          'payment_method': paymentMethod,
          'invoice_id': invoceId.toString(),
        },
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    print(response.body);
    print(response.body);
    notifyListeners();

    if (body['reqRes'] == 'true') {
      Navigator.pop(context);
      Navigator.pop(context);
       FirebaseApi.updateNotification(data.id, 'confirm');
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return Pay(
              controller: myPage,
              data: data,
            );
            //   userBankInfo: users[index]// ignUpAddress();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
      return body['reviews'];
    } else if (body['reqRes'] == 'false') {

         if(body['message'] == "Invalid Payment Details"){
           Navigator.pop(context);
           Navigator.pop(context);
           await showTextToast(
             text: "Invalid Payment Details",
             context: context,
           );
         }else if(body['message'] == "Insufficient Wallet Balance"){
           Navigator.pop(context);
           Navigator.pop(context);
           await showTextToast(
             text: "Insufficient Wallet Balance. Kindly top up your wallet or change payment method.",
             context: context,
           );
         }else if(body['message'] == "Card Payment Failed"){
           Navigator.pop(context);
           Navigator.pop(context);
           await showTextToast(
             text: "Card Payment Failed. Kindly check that you have sufficient funds in your account and try again.",
             context: context,
           );
         }
    }
  }catch(e){
      Navigator.pop(context);
      Navigator.pop(context);
      await showTextToast(
        text: "There was a Problem Encountered.",
        context: context,
      );
    }
    }

  Future<dynamic> confirmPaymentAndReview({
  rating, jobid,bidid,serviceId, comment, artisanId, userId, context}) async {
    print(rating);
    print(jobid);
    print(bidid);
    print(serviceId);
    print(artisanId);
    print(userId);
    print(comment);

    bool serID = (serviceId==null) || (serviceId == 'null');
    print(serID);
    print(serID);
    print(serID);
    print(serID);
    try{
    var response = await http.post(
        Uri.parse('$mainUrl/confirm-project-completion-rating'),
        body: {
          'reviewing_user_id': userId.toString(),
          'reviewed_user_id': artisanId.toString(),
          'bid_id': bidid.toString(),
          'jobId': jobid.toString(),
          serID?'':'service_request_id': serviceId.toString(),
          'rating': rating.toString(),
          'review': comment.toString(),
        },
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $bearer',
        });
   var body = json.decode(response.body.toString());
   print(body);
    print(body);
    print(body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body);
      await showTextToast(
        text: "Review Successfully Submited.",
        context: context,
      );

      return body;
    } else if (body['reqRes'] == 'false') {
      await showTextToast(
        text: "Payment Approved Already.",
        context: context,
      );
      print(body);
    }
  }
  catch(e){
      print(e);
      print('eeeee');
    }
  }

  Future<dynamic> bidProject(context, [userId, jobId, scaffoldKey]) async {
    var response = await http.post(Uri.parse('$mainUrl/bid-project'), body: {
      'user_id': userId.toString(),
      'job_id': jobId.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      await showTextToast(
        text: "Project Bid Successful.",
        context: context,
      );

      return body['reviews'];
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  Future<dynamic> getUserInfo([userId]) async {
    var response = await http.post(Uri.parse('$mainUrl/user-info'), body: {
      'user_id': userId.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body);
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body['message']);
    }
  }

  // getUserJobInfo

  Future<dynamic> getUserJobInfo([userId, artisanId]) async {
    var response = await http
        .post(Uri.parse('$mainUrl/get-artisan-business-profile'), body: {
      'requesting_user_id': userId.toString(),
      'artisan_user_id': artisanId.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    // Map map = json.decode(response.body.toString());
    // Info info = Info.fromJson(body);
//print(info.fullNumber);
    print(bearer);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body;
    } else if (body['reqRes'] == 'false') {
      //   print(body['message']);
    }
  }



  Future<dynamic> checkData() async {
    try{
      var response = await http
          .post(Uri.parse('$mainUrl/explore-product'), body: {
        'user_id': userId.toString(),

      }, headers: {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $bearer',
      }).timeout(Duration(seconds: 20));
      var body1 = json.decode(response.body);
      if (body1['reqRes'] == 'true') {
        return '200';
      } else {
        print('500');
        print('500');
        print('500');
        print('500');
        print('500');
      return '500';
      }}on TimeoutException catch (e) {
      print('time out Error: $e');
      return 'timeout';
    } on SocketException catch (e) {
      print('Socket Error: $e');
      return 'socket';
    } on Error catch (e) {
      print('General Error: $e');
      return 'error';
    }
  }



  Future<dynamic> getMarket() async {
    try{
    var response = await http
        .post(Uri.parse('$mainUrl/explore-product'), body: {
      'user_id': userId.toString(),

    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
     'Authorization': 'Bearer $bearer',
    }).timeout(Duration(seconds: 20));
    var body1 = json.decode(response.body);
    List body = body1['products'];
    List<Product> projects = body
        .map((data) {
      return Product.fromJson(data);
    })
        .toSet()
        .toList();
    notifyListeners();
    if (body1['reqRes'] == 'true') {
      print(projects);
      return projects;
    } else if (body1['reqRes'] == 'false') {
        print(body1);
    }}on TimeoutException catch (e) {
      List<Product> defaul = [
        Product(network: true)
      ];
      print('time out Error: $e');
      return defaul;
    } on SocketException catch (e) {
      List<Product> defaul = [
        Product(network: true)
      ];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<Product> defaul = [
        Product(network: true)
      ];
      print('General Error: $e');
      return defaul;
    }
  }








  Future<dynamic> getServiceImage([userId, requestedId]) async {
    print(userId);
    var response = await http.post(Uri.parse('$mainUrl/service-images'), body: {
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
    var response =
        await http.post(Uri.parse('$mainUrl/get-catalog-products'), body: {
      'user_id': userId.toString(),
      'requested_user_id': requestedId.toString(),
    }, headers: {
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
      {
      scaffoldKey,
      path,
      context,
      controlDes,
      controlName,
      controlPrice}) async {
    try {
        var upload = http.MultipartRequest(
            'POST', Uri.parse('https://uploads.fixme.ng/product-upload'));
        var file = await http.MultipartFile.fromPath('file', path);
        upload.files.add(file);
        upload.fields['product_description'] = controlDes.toString();
        upload.fields['product_name'] = controlName.toString();
        upload.fields['price'] = controlPrice.toString();
        upload.fields['user_id'] = userId.toString();
        upload.headers['authorization'] = 'Bearer $bearer';

        final stream = await upload.send();
        var resp = await http.Response.fromStream(stream);
        print(resp.body);
        print(resp.body);
        print(resp.body);
        var bodys = jsonDecode(resp.body);

        if (bodys['reqRes'] == 'true') {
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
                                  : Theme(
                                      data: Theme.of(context).copyWith(
                                          accentColor: Color(0xFF9B049B)),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFF9B049B)),
                                        strokeWidth: 2,
                                        backgroundColor: Colors.white,
                                      )),
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
                                      Utils data = Provider.of<Utils>(context,
                                          listen: false);
                                      data.selectedImage2toNull();
                                      Navigator.pop(context);
                                      controlDes.clear();
                                      controlName.clear();
                                      controlPrice.clear();
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
        } else if (bodys['reqRes'] == 'false') {
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
      // } else if (body['reqRes'] == 'false') {
      //   loginSetState();
      //   showDialog(
      //       builder: (ctx) {
      //         return AlertDialog(
      //           title: Center(
      //             child: Text('There was a Problem Working on it!',
      //                 style: TextStyle(color: Colors.blue)),
      //           ),
      //         );
      //       },
      //       context: context);
      // }
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
            '$mainUrl/verify-payment?payment_reference_id=$refId&user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    print(body['message']);
    return body['message'];
  }

  Future<dynamic> editProductPic({name, path, productID}) async {
    try {
      var upload = http.MultipartRequest(
          'POST', Uri.parse('https://uploads.fixme.ng/change-product-image'));
      var file = await http.MultipartFile.fromPath('file', path);
      upload.files.add(file);
      upload.fields['product_id'] = '$productID';
      upload.fields['product_name'] = name.toString();
      upload.fields['user_id'] = userId.toString();
      upload.headers['authorization'] = 'Bearer $bearer';

      final stream = await upload.send();
      var response = await http.Response.fromStream(stream);
      var body = json.decode(response.body);
      print(response.body.toString() + 'kkkkkkkkkkkkkkk');
      notifyListeners();
      if (body['upldRes'] == 'true') {
        return body;
      } else if (body['upldRes'] == 'false') {
        print(body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> editProduct({name, price, description, productID}) async {
    var response = await http.post(Uri.parse('$mainUrl/edit-prod-dtls'), body: {
      'user_id': userId.toString(),
      'product_id': '$productID',
      'price': price,
      'product_name': name,
      'product_description': description,
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    print(body.toString() + 'lllllllllllllllllllll');
    notifyListeners();
    if (body['reqRes'] == 'true') {
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future addProductCatalog(
      {bio, productName, price, scaffoldKey, path, context}) async {
    try{
    var upload = http.MultipartRequest(
        'POST', Uri.parse('https://uploads.fixme.ng/product-upload'));
    var file = await http.MultipartFile.fromPath('file', path);
    upload.files.add(file);
    upload.fields['product_description'] = bio.toString();
    upload.fields['product_name'] = productName.toString();
    upload.fields['price'] = price.toString();
    upload.fields['user_id'] = userId.toString();
    upload.headers['authorization'] = 'Bearer $bearer';
    final stream = await upload.send();
    var resp = await http.Response.fromStream(stream);
    var bodys = jsonDecode(resp.body);
      if (bodys['reqRes'] == 'true') {
        return true;
      } else if (bodys['reqRes'] == 'false') {
        return false;
      }}catch(e){
      return false;
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
                                : Theme(
                                    data: Theme.of(context).copyWith(
                                        accentColor: Color(0xFF9B049B)),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF9B049B)),
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                    )),
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
            '$mainUrl/e-f-n?user_id=$userId&firstName=$firstname&lastName=$lastname'),
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
        Uri.parse('$mainUrl/update-bio?user_id=$userId&bio=$status'),
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

  Future uploadPhoto({path, uploadType, navigate,name, context}) async {
    // var dio = Dio();
    try {
    //   var formData = FormData.fromMap({
    //     'uploadType': uploadType.toString(),
    //     'firstName': firstName.toString(),
    //     'user_id': userId.toString(),
    //     'file': await MultipartFile.fromFile(path, filename: name),
    //   });
    //
    //   var response = await dio.post('https://uploads.fixme.ng/uploads-processing', data: formData);
    //
    //   print(response.statusCode);
    //   print(response.statusCode);
    //   print(response.statusCode);
    //   print(response.statusCode);
    //



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
      print(res.statusCode);
      print(res.statusCode);
      print(res.statusCode);
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
      }else{
        showDialog(
            builder: (ctx) {
              return AlertDialog(
                title: Center(
                  child: Text('There was a Problem Working on it 00000000!',
                      style: TextStyle(color: Colors.blue)),
                ),
              );
            },
            context: context);
        loginSetState();
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





  Future<dynamic> changeAccRole(roles,context) async {
    var response =
    await http.post(Uri.parse('$mainUrl/mtk-details-update'), body: {
      'user_id': userId.toString(),
      'user_role': roles.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      var datas = Provider.of<Utils>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      datas.storeData('role', roles);
      role = prefs.getString('role');
      return true;
    } else if (body['reqRes'] == 'false') {
      print(body);
      return false;
    }
  }







  Future<dynamic> updateFCMToken(userId, fcmToken) async {
    var response =
        await http.post(Uri.parse('$mainUrl/mtk-details-update'), body: {
      'user_id': userId.toString(),
      'device_token': fcmToken.toString(),
      'device_os': os,
      'device_type': info,
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
    var response = await http.post(Uri.parse('$mainUrl/update-bio'), body: {
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

  Future<dynamic> deleteSubService(subserviceID) async {
    var response =
        await http.post(Uri.parse('$mainUrl/delete-sub-service'), body: {
      'user_id': userId.toString(),
      'subService_Id': '$subserviceID',
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body);
      print(body);
      print(body);
      return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future<dynamic> updateAddress(address) async {
    var response =
        await http.post(Uri.parse('$mainUrl/edit-biz-address'), body: {
      'user_id': userId.toString(),
      'business_address': '$address',
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
    var response = await http.post(Uri.parse('$mainUrl/change-service'), body: {
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

  Future<dynamic> addSubService(sn) async {
    var response =
        await http.post(Uri.parse('$mainUrl/add-sub-service'), body: {
      'user_id': userId.toString(),
      'subservice': '$sn',
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    notifyListeners();
    if (body['reqRes'] == 'true') {
      print(body['reqRes']);
      //return body;
    } else if (body['reqRes'] == 'false') {
      print(body);
    }
  }

  Future<dynamic> updateFullName(firstName, lastName) async {
    var response = await http.post(Uri.parse('$mainUrl/e-f-n'), body: {
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

  Future<dynamic> updateBizName(businessName) async {
    var response = await http.post(Uri.parse('$mainUrl/edit-biz-name'), body: {
      'user_id': userId.toString(),
      'business_name': '$businessName',
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

  Future<dynamic> requestPayment(projectid,bid_id) async {
    var response = await http
        .post(Uri.parse('$mainUrl/completed-project-and-payment'), body: {
      'user_id': userId.toString(),
      'project_id': projectid.toString()  ,
      'bid_id': bid_id.toString(),
    }, headers: {
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
    var response = await http.post(Uri.parse('$mainUrl/get-all-bid-task-list'), body: {
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
      print(body1);
      List body = body1['projects'];
      List<Project> projects = body
          .map((data) {
            return Project.fromJson(data);
          })
          .toSet()
          .toList();

      notifyListeners();
      if (body1['reqRes'] == 'true') {
        print(projects.length);
        print(projects.length);
        print(projects.length);
        return projects;
      } else if (body1['reqRes'] == 'false') {}
    }
  }

  Future<dynamic> getBiddedJobs(context) async {
    print(userId);
    print(bearer);
    var response =
        await http.post(Uri.parse('$mainUrl/all-my-bids-projects'), body: {
      'user_id': userId.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });

    if (response.statusCode == 500) {
    } else {
      var body1 = json.decode(response.body);
      List body = body1['projects'];
      print(body);
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
        Uri.parse(
            '$mainUrl/profile-views-update?viewing_user_id=$userId&viewed_user_id=$artisanId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    print(body['reqRes'] + 'ree');
    return body['reqRes'];
  }

  Future<dynamic> nearbyArtisans({longitude, latitude, context}) async {
    try {
      var response =
          await http.post(Uri.parse('$mainUrl/near-artisans'), body: {
        'user_id': userId.toString(),
        // 'latitude':  '5.001190',
        // 'longitude' :'8.334840'

        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
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

      return err.message;
    }
  }

  Future<dynamic> nearbyShop({longitude, latitude, context}) async {
    var response =
        await http.post(Uri.parse('$mainUrl/near-shops-business'), body: {
      'user_id': userId.toString(),
      // 'latitude':  '5.001190',
      // 'longitude' :'8.334840',
      'longitude': longitude.toString(),
      'latitude': latitude.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer $bearer',
    });
    if (response.statusCode == 500) {
      print("You are not connected to internet");

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
      var response =
          await http.post(Uri.parse('$mainUrl/search-artisans'), body: {
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
    var response = await http
        .post(Uri.parse('$mainUrl/g-b-info?user_id=$userId'), headers: {
      "Content-type": "application/json",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    return body['bankInfo'];
  }

  Future<Map> getUserWalletInfo(context) async {
    var response = await http.post(
        Uri.parse('$mainUrl/get-user-bank-info?user_id=$userId'),
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
        Uri.parse('$mainUrl/get-user-bank-info?user_id=$userId'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    return body['accountInfo'];
  }

  Future<List> getUserTransactions() async {
    var response = await http
        .post(Uri.parse('$mainUrl/my-transactions?user_id=$userId'), headers: {
      "Content-type": "application/json",
      'Authorization': 'Bearer $bearer',
    });
    var body = json.decode(response.body);
    return body['transactionDetails'];
  }

  Future<dynamic> validateUserAccountName({bankCode, accountNumber}) async {
    var response = await http.post(
        Uri.parse(
            '$mainUrl/validate-acount-number?user_id=$userId&bankCode=$bankCode&accountNumber=$accountNumber'),
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
        Uri.parse('$mainUrl/get-payment-details?user_id=$userId'),
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
    var response = await http
        .post(Uri.parse('$mainUrl/has-security-pin?user_id=$userId'), headers: {
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
            '$mainUrl/save-security-pin?user_id=$userId&secPin=Basic $base64Str'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $bearer',
        });
    var body = json.decode(response.body);
    return body['reqRes'];
  }

  Future<List> getBeneficiaries() async {
    var response = await http.post(
        Uri.parse('$mainUrl/all-beneficiaries?user_id=$userId'),
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

  Future addCatalog(context, {path, uploadType}) async {
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
        return true;
      } else if (body['upldRes'] == 'false') {

        return false;
      }
    } catch (e) {
      return false;
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
            '$mainUrl/initiate-transfer?user_id=$userId&bankCode=$bankCode&accountNumber=$accountNumber&accountName=$accountName&amount=$amount&secPin=Basic $base64Str&naration=$naration&isBeneficiary=$isBeneficiary'),
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
            '$mainUrl/support-request?user_id=264&topic=$topic&message=$message'),
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
            '$mainUrl/del-svc-img?user_id=$userId&image_id=$imageFileName'),
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
            '$mainUrl/delete-product-catalog?user_id=$userId&product_id=$productId'),
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
            '$mainUrl/delete-product-catalog-image?user_id=$userId&product_image_id=$productImageId'),
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
