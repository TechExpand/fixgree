
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:speedcv/pages/auth/model/auth_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';




class PendingProvider with ChangeNotifier {
  
  bool _loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String baseUrl = 'https://manager.fixme.ng/new-project';

  bool get loading => _loading;
  bool login = false;

  isLoading(loading) {
    _loading = loading;
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
