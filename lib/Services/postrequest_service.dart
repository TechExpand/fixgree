import 'dart:convert';
import 'package:fixme/Model/service.dart';
import 'package:fixme/Widgets/popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math';




class PostRequestProvider with ChangeNotifier {
  PostRequestProvider() {
    getServices();
  }
  bool gotit = true;
  changeGotit(){
    gotit = false;
    notifyListeners();
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
  List<Services> allservicesList = [];
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
        String theresponse = body1['reqRes'].toString();
        if (theresponse == 'true') {
          isLoading(false);
          popDialog(context, 'Successfully Posted', 'assets/images/go.png');
        } else {
          isLoading(false);
          popDialog(context, 'Unable To Post', 'assets/images/fail.jpg');
        }
        
      } else {
        isLoading(false);
        popDialog(context, 'Unable To Post', 'assets/images/fail.jpg');
      }
      print(body1);
      isLoading(false);
    } catch (e) {
      
      print(e);
      print('na error b tat');
      isLoading(false);
      popDialog(context, 'Unable To Post', 'assets/images/fail.jpg');
    }
    isLoading(false);

    }
  Future<dynamic> getServices() async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer = prefs.getString('Bearer');
    String user_id = prefs.getString('user_id');
    //var data = Provider.of<DataProvider>(context, listen: false);
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
      var body1 = json.decode(response.body);
      List body = body1['services'];
      // user_id = body['id'];
      print('final responssssssssssssssssssssssse');
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



 Future<dynamic> getAllServices() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer = prefs.getString('Bearer');
    String user_id = prefs.getString('user_id');
    //var data = Provider.of<DataProvider>(context, listen: false);
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
      var body1 = json.decode(response.body);
      List body = body1['services'];
      // user_id = body['id'];
      print('final responssssssssssssssssssssssse');
      List<Services> serviceList = body.map((data) {
        return Services.fromJson(data);
      }).toList();
      allservicesList = serviceList;
      print(allservicesList);
      notifyListeners();
    } catch (e) {
      // Login_SetState();
      print(e);
      print('na error b tat');
    }
   
  }

  changeService(Services services) {  
    selectedService = services;
    print(selectedService.service);
    notifyListeners();

  }

}
