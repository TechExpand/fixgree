

import 'dart:convert';

import 'package:fixme/Model/service.dart';
import 'package:fixme/Widgets/popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:speedcv/pages/auth/model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math';




class PostRequestProvider with ChangeNotifier {
  PostRequestProvider() {
    getServices();
  }
  bool _loading = false;
  final jobtitleController = TextEditingController();
  final jobdescriptionController = TextEditingController();
  final jobaddressController = TextEditingController();
  final amountController = TextEditingController();
  
  String baseUrl = 'https://manager.fixme.ng/new-project';

  bool get loading => _loading;
  bool login = false;
  List<Services> servicesList = [];
  Services selectedService;

  isLoading(loading) {
    _loading = loading;
    notifyListeners();
  }

  double roundDouble(double value, int places){ 
   double mod = pow(10.0, places); 
   return ((value * mod).round().toDouble() / mod); 
}

    Future<dynamic> postJob(BuildContext context) async {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String job = jobtitleController.text;
      String description = jobdescriptionController.text;
      String address = jobaddressController.text;
      double amount = double.parse((amountController.text));
      String user_id = prefs.getString('user_id');
     
      String bearer = prefs.getString('Bearer');
      print(job);
      print(description);
      print(address);
      print(amount);
      print(user_id);
      
      try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/new-project'), body: {
        'user_id': user_id,
        'job_title': job,
        'job_description': description,
        'service_id': selectedService.sn,        
        'budget': amount.toString(),
        'job_address': address,
        }, headers: {
        'Authorization':
        'Bearer $bearer',
      });
      var statusCode = response.statusCode;
      print(statusCode);
      print('startedd');
      var body1 = json.decode(response.body);
      if (statusCode<400){
        popDialog(context, 'Successfully Posted');
      }
      print(body1);
      isLoading(false);
    } catch (e) {
      
      print(e);
      print('na error b tat');
      isLoading(false);
    }
    isLoading(false);

    }
  Future<dynamic> getServices() async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer = prefs.getString('Bearer');
    String user_id = prefs.getString('user_id');
    //var data = Provider.of<DataProvider>(context, listen: false);
      print('theid $user_id');
      print('token $bearer');
      try {
      var response = await http
          .post(Uri.parse('https://manager.fixme.ng/service-list'), body: {
        'user_id': user_id,
        }, headers: {
        // "Content-type": "application/json",
        //"Content-type": "application/x-www-form-urlencoded",
        'Authorization':
        'Bearer $bearer',
      });
      var statusCode = response.statusCode;
      print(statusCode);
      print('startedd');
      var body1 = json.decode(response.body);
      print(body1);
      List body = body1['services'];
      // user_id = body['id'];

      print(body);
      print('final response');
      List<Services> serviceList = body.map((data) {
        return Services.fromJson(data);
      }).toList();
      servicesList = serviceList;
      notifyListeners();
    } catch (e) {
      // Login_SetState();
      print(e);
      print('na error b tat');
    }
    isLoading(false);
  }

  changeService(Services services) {  
    selectedService = services;
    print(selectedService.service);
    notifyListeners();

  }
  // void showToast(themsg) {
  // Fluttertoast.showToast(
  //       msg: themsg,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.black,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  // }

  // Future storeData(String name, String data) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(name, data);
  // }
  // Future getData(String name) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String data = prefs.getString(name);
  //   return data;
  // }


// Future<bool> loginFunction() async {
//   isLoading(true);
//   AuthModel authModel = AuthModel(email: emailController.text, password: passwordController.text, apiKey: apikey, secretKey: secretkey);
//   String url = '$baseUrl/login';
//   // String token = await LocalPrefs.getString('entToken');
//   Map<String, String> headers = {
//   "Content-type": "application/json",        
//   };      
//   var body = authModel.toJson();
//   var data = jsonEncode(body);
  
//   // print(url);
//   // print(data);
//   // make POST request
//   http.Response response =
//     await http.post(url, headers: headers, body: data);
//   // // check the status code for the result
//   int statusCode = response.statusCode;
//   String result = response.body;
//   Map<String, dynamic> authResponse = jsonDecode(result);

//   int status = authResponse['status'];
  
//   if(status >= 400){        
  
//     // String message = authResponse['error'];
//     // showToast(message);        
//     isLoading(false);
//     return false; 
//   } else {
//     var data = authResponse['data'];
//     AuthModel test = AuthModel.fromJson(data);
//     String newdata = json.encode(test);
//     await storeData('userdetails', newdata);
//     String newtest = await getData('userdetails');
//     //var neww = json.decode(newtest);
//     isLoading(false);
//     return true;
//   }
  
// }


}
