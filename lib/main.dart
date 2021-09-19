import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as locator;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_experior/user_experior.dart';
import 'DummyData.dart';
import 'Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'Screens/GeneralUsers/Home/HomePage.dart';
import 'Screens/GeneralUsers/Wallet/Providers/PinProvider.dart';
import 'Screens/GeneralUsers/Wallet/Providers/WalletProvider.dart';
import 'Screens/Splash.dart';
import 'Services/Firebase_service.dart';
import 'Services/call_service.dart';
import 'Services/location_service.dart';
import 'Services/network_service.dart';
import 'Services/postrequest_service.dart';
import 'Services/pending_service.dart';
import 'Utils/Provider.dart';
import 'Utils/service_locator.dart';
import 'Utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


FirebaseMessaging messaging = FirebaseMessaging.instance;



Future getCurrentLocation() async{

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('Bearer');
    var userId = prefs.getString('user_id');

    if (token == null || token == 'null' || token == '') {
    } else {
      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
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
        // print(statusCode);
        // print('startedd');
        var body1 = json.decode(response.body);
       // print(body1);
      } catch (e) {
        // Login_SetState();
     //   print(e);
        print('na error b tat');
      }
    }
  } catch (e) {
    print(e);
  }
}





void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  Future onlocation() async {
    var _serviceEnabled;
    locator.Location locationMet = locator.Location();
    try {
      _serviceEnabled = await locationMet.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationMet.requestService();

      }
    } catch (e) {
    //  print(e);
    }
   // print('start sending initiasllll');
    getCurrentLocation();
     await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // print('ebnd sending initiasllll');
    const oneSec = const Duration(minutes: 8);
    new Timer.periodic(oneSec, (Timer t) => getCurrentLocation());
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  onlocation();


  GestureBinding.instance.resamplingEnabled = true;

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
    ChangeNotifierProvider<LgaProvider>(
      create: (context) => LgaProvider(),
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
  setup();
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
    UserExperior.startRecording("996996bf-f383-453d-8803-40dea8592e49");
    return MaterialApp(
      theme: ThemeData(
        accentColor: Color(0xFF9B049B).withOpacity(0.8),
        textTheme: GoogleFonts.poppinsTextTheme (
          Theme.of(context).textTheme,
        ),
      ),
      color: Color(0xFF9B049B),
      home:
      SplashScreen(),
    );
  }
}






