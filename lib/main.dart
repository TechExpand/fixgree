import 'package:flutter/material.dart';
import 'package:location/location.dart' as locator;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/LoginSignup/Login.dart';
import 'Screens/LoginSignup/selectauth.dart';
import 'Screens/Splash.dart';
import 'Screens/Wallet/Providers/BankProvider.dart';
import 'Screens/Wallet/Providers/PinProvider.dart';
import 'Screens/Wallet/Providers/WalletProvider.dart';
import 'Services/call_service.dart';
import 'Services/location_service.dart';
import 'Services/network_service.dart';
import 'Services/postrequest_service.dart';
import 'Services/pending_service.dart';
import 'Utils/Provider.dart';
import 'Utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future getCurrentLocation() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('Bearer');
    var user_id = prefs.getString('user_id');
    print('initialtoken is $token');
    if (token == null || token == 'null' || token == '') {
    } else {
      print('not null');
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      var location_latitude = position.latitude;
      var location_longitude = position.longitude;
      print(location_longitude);
      print(location_longitude);
      try {
        print('sending request');
        var response =
            await http.post(Uri.parse('https://manager.fixme.ng/gpsl'), body: {
          'user_id': user_id,
          'longitude': location_longitude.toString(),
          'latitude': location_latitude.toString(),
        }, headers: {
          // "Content-type": "application/json",
          //"Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer $token',
        });
        var statusCode = response.statusCode;
        print(statusCode);
        print('startedd');
        var body1 = json.decode(response.body);
        print(body1);
      } catch (e) {
        // Login_SetState();
        print(e);
        print('na error b tat');
      }
    }
  } catch (e) {
    print(e);
  }
}

void main() async {
  Future onlocation() async {
    var _serviceEnabled;
    locator.Location location_met = locator.Location();
    try {
      _serviceEnabled = await location_met.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location_met.requestService();
      }
    } catch (e) {
      print(e);
    }
    getCurrentLocation();
    const oneSec = const Duration(minutes: 8);
    new Timer.periodic(oneSec, (Timer t) => getCurrentLocation());
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  onlocation();
  // Widget widget = await decideFirstWidget();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DataProvider>(
      create: (context) => DataProvider(),
    ),
    ChangeNotifierProvider<CallApi>(
      create: (context) => CallApi(),
    ),
    ChangeNotifierProvider<WebServices>(
      create: (context) => WebServices(),
    ),
    ChangeNotifierProvider<LocationService>(
      create: (context) => LocationService(),
    ),
    ChangeNotifierProvider<Utils>(
      create: (context) => Utils(),
    ),
    ChangeNotifierProvider<PostRequestProvider>(
      create: (context) => PostRequestProvider(),
    ),
    ChangeNotifierProvider<PendingProvider>(
      create: (context) => PendingProvider(),
    ),
    ChangeNotifierProvider<BankProvider>(
      create: (context) => BankProvider(),
    ),
    ChangeNotifierProvider<BankProvider2>(
      create: (context) => BankProvider2(),
    ),
    ChangeNotifierProvider<PinProvider>(
      create: (context) => PinProvider(),
    ),
    ChangeNotifierProvider<WalletProvider>(
      create: (context) => WalletProvider(),
    ),
  ], child: MyApp())); // MyApp(widget)));
}

class MyApp extends StatefulWidget {
  final Widget widget;
  MyApp({this.widget});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          SplashScreen(), //widget.widget//ListenIncoming(), // SplashScreen(),
    );
  }
}

//
//Future<Widget> decideFirstWidget() async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
//  var token = prefs.getString('Bearer');
//  print('initialtoken is $token');
//  if (token == null || token == 'null'|| token == ''){
//    return Login();
//  } else {
//  return SplashScreen();}
//}
