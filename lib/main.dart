import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as locator;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_experior/user_experior.dart';
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
   // print('ebnd sending initiasllll');
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
        accentColor: Colors.white10,
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











//
//
//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
// /// Define a top-level named handler which background/terminated messages will
// /// call.
// ///
// /// To verify things are working, check out the native platform logs.
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//   print('Handling a background message ooooooooooooooooooo ${message.messageId}');
// }
//
// /// Create a [AndroidNotificationChannel] for heads up notifications
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.max,
//   sound: RawResourceAndroidNotificationSound('sound'),
//   playSound: true,
//
// );
//
//
// const AndroidNotificationChannel channel2 = AndroidNotificationChannel(
//   'high_importance_channel 2', // id
//   'High Importance Notifications 2', // title
//   'This channel is used for important notifications 2.', // description
//   importance: Importance.max,
//   sound: RawResourceAndroidNotificationSound('normal'),
//   playSound: true,
//
// );
//
// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // Set the background messaging handler early on, as a named top-level function
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   /// Create an Android Notification Channel.
//   ///
//   /// We use this channel in the `AndroidManifest.xml` file to override the
//   /// default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel2);
//
//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   runApp(MessagingExampleApp());
// }
//
// /// Entry point for the example application.
// class MessagingExampleApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Messaging Example App',
//       theme: ThemeData.dark(),
//       routes: {
//         '/': (context) => Application(),
//       },
//     );
//   }
// }
//
//
//
// /// Renders the example application.
// class Application extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _Application();
// }
//
// class _Application extends State<Application> {
//   String _token;
//
//   @override
//   void initState() {
//     super.initState();
//     FirebaseMessaging.instance.getToken().then((value){
//       _token = value;
//       print(_token);
//       print(_token);
//     });
//
//
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage message) {
//       print('A new initiallllllll event was published!');
//       if (message != null) {
//        print('jjjj');
//       }
//     });
//
//     String good = 'good';
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         good=='good'?flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channel.description,
//                 // TODO add a proper drawable resource to android, for now using
//                 //      one that already exists in example app.
//                 icon: 'launch_background',
//               ),
//             )):flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//       android: AndroidNotificationDetails(
//       channel2.id,
//       channel2.name,
//       channel2.description,
//       // TODO add a proper drawable resource to android, for now using
//       //      one that already exists in example app.
//       icon: 'launch_background',
//       ),
//       ));
//         print('A new onmessagggggggggggge event was published!');
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//
//     });
//   }
//
//   Future<void> sendPushMessage() async {
//     if (_token == null) {
//       print('Unable to send FCM message, no token exists.');
//       return;
//     }
//     final String serverToken =
//         'AAAA2lAKGZU:APA91bFmok2miRE6jWBUgfmu5jhvxQGJ5ITwrcwrHMghkPOZCIYYxLu-rIs-ub6HQ5YdiEGx3jG2tMvmiEjq-KW4rEgGrckHNkGdFrO2iUDoidvmh867VQj0FKx-_cxbi8AQpR1S3cCu';
//
//     await http.post(
//               Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: <String, String>{
//                 'Content-Type': 'application/json',
//                 'Authorization': 'key=$serverToken',
//               },
//               body: jsonEncode(
//                 <String, dynamic>{
//                   'notification': <String, dynamic>{
//                     'body': 'play',
//                     'title': 'You Have a Message',
//                   },
//                   'priority': 'high',
//                   'data': <String, dynamic>{
//                     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//                     'id': '1',
//                     'notification_type': 'chat',
//                     'status': 'done'
//                   },
//                   'to': _token,
//                 },
//               ),
//             );
//
//   }
//
//   Future<void> onActionSelected(String value) async {
//     switch (value) {
//       case 'subscribe':
//         {
//           print(
//               'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
//           await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
//           print(
//               'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
//         }
//         break;
//       case 'unsubscribe':
//         {
//           print(
//               'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
//           await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
//           print(
//               'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
//         }
//         break;
//       case 'get_apns_token':
//         {
//           if (defaultTargetPlatform == TargetPlatform.iOS ||
//               defaultTargetPlatform == TargetPlatform.macOS) {
//             print('FlutterFire Messaging Example: Getting APNs token...');
//             String token = await FirebaseMessaging.instance.getAPNSToken();
//             print('FlutterFire Messaging Example: Got APNs token: $token');
//           } else {
//             print(
//                 'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
//           }
//         }
//         break;
//       default:
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cloud Messaging'),
//         actions: <Widget>[
//           PopupMenuButton(
//             onSelected: onActionSelected,
//             itemBuilder: (BuildContext context) {
//               return [
//                 const PopupMenuItem(
//                   value: 'subscribe',
//                   child: Text('Subscribe to topic'),
//                 ),
//                 const PopupMenuItem(
//                   value: 'unsubscribe',
//                   child: Text('Unsubscribe to topic'),
//                 ),
//                 const PopupMenuItem(
//                   value: 'get_apns_token',
//                   child: Text('Get APNs token (Apple only)'),
//                 ),
//               ];
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: Builder(
//         builder: (context) => FloatingActionButton(
//           onPressed: sendPushMessage,
//           backgroundColor: Colors.white,
//           child: const Icon(Icons.send),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: [
//           MetaCard('Permissions', Text('permision')),
//           MetaCard('FCM Token', Text('token')),
//           MetaCard('Message Stream', Text('message')),
//         ]),
//       ),
//     );
//   }
// }
//
// /// UI Widget for displaying metadata.
// class MetaCard extends StatelessWidget {
//   final String _title;
//   final Widget _children;
//
//   // ignore: public_member_api_docs
//   MetaCard(this._title, this._children);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: double.infinity,
//         margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
//         child: Card(
//             child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(children: [
//                   Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child:
//                       Text(_title, style: const TextStyle(fontSize: 18))),
//                   _children,
//                 ]))));
//   }
// }