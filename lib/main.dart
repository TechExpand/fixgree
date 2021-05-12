import 'package:flutter/material.dart';
import 'package:location/location.dart' as locator;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'Screens/GeneralUsers/Wallet/Providers/PinProvider.dart';
import 'Screens/GeneralUsers/Wallet/Providers/WalletProvider.dart';
import 'Screens/Splash.dart';
import 'Services/call_service.dart';
import 'Services/location_service.dart';
import 'Services/network_service.dart';
//import 'package:user_experior/user_experior.dart';
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
    var userId = prefs.getString('user_id');

    if (token == null || token == 'null' || token == '') {
    } else {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      var locationLatitude = position.latitude;
      var locationLongitude = position.longitude;

      try {
        print('sending request');
        var response =
            await http.post(Uri.parse('https://manager.fixme.ng/gpsl'), body: {
          'user_id': userId,
          'longitude': locationLongitude.toString(),
          'latitude': locationLatitude.toString(),
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
    locator.Location locationMet = locator.Location();
    try {
      _serviceEnabled = await locationMet.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationMet.requestService();
      }
    } catch (e) {
      print(e);
    }
    print('start sending initiasllll');
    getCurrentLocation();
    print('ebnd sending initiasllll');
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
    ChangeNotifierProvider<PinProvider>(
      create: (context) => PinProvider(),
    ),
    ChangeNotifierProvider<WalletProvider>(
      create: (context) => WalletProvider(),
    ),
    ChangeNotifierProvider<ArtisanProvider>(
      create: (_) => ArtisanProvider(),
    ),
  ], child: MyApp())); // MyApp(widget)));
}

class MyApp extends StatefulWidget {
  //UserExperior.startRecording("996996bf-f383-453d-8803-40dea8592e49");
  final Widget widget;
  MyApp({this.widget});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.white10,
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      color: Color(0xFF9B049B),
      home:
          SplashScreen(), //widget.widget//ListenIncoming(), // SplashScreen(),
    );
  }
}
