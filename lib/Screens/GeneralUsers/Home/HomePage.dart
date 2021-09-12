import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/GeneralUsers/Market/market.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/listen_incoming_call.dart';
import 'package:fixme/Screens/GeneralUsers/Notification/Notification.dart';
import 'package:fixme/Screens/GeneralUsers/Wallet/Wallet.dart';
import 'package:fixme/Screens/GeneralUsers/pending/pendingpage.dart';
import 'package:fixme/Screens/GeneralUsers/postrequest/postrequest.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/icons.dart';
import 'package:fixme/Utils/service_locator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';


var userid = getIt<WebServices>();





class  HomePage extends StatefulWidget {
  final  firstUser;
  HomePage({this.firstUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _myPage;
  var search;
  final scafoldKey = GlobalKey<ScaffoldState>();





  /// Create a [AndroidNotificationChannel] for heads up notifications
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('sound'),
    playSound: true,

  );


  static const AndroidNotificationChannel channel2 = AndroidNotificationChannel(
    'high_importance_channel 2', // id
    'High Importance Notifications 2', // title
    'This channel is used for important notifications 2.', // description
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('normal'),
    playSound: true,

  );

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();




  initChannel()async{
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);



  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel2);


  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  alert: true,
  badge: true,
  sound: true,
  );


  }

  showNotification(notification){
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'logo',
          ),
        ));
  }


  showNotification2(notification){
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel2.id,
            channel2.name,
            channel2.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'logo',
          ),
        ));
  }


  @override
  void initState() {
    var network = Provider.of<WebServices>(context, listen: false);
    super.initState();
    userid.newid = network.userId;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    var datas = Provider.of<DataProvider>(context, listen: false);
    Provider.of<WebServices>(context, listen: false).initializeValues();
    datas.setSelectedBottomNavBar(0);

    Provider.of<LocationService>(context, listen: false).getCurrentLocation();
    // _myPage =
    //     PageController(initialPage: widget.firstUser=='first'?1:0, viewportFraction: 1, keepPage: true);
    _myPage =
        PageController(initialPage: 1, viewportFraction: 1, keepPage: true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PostRequestProvider postRequestProvider =
          Provider.of<PostRequestProvider>(context, listen: false);
      postRequestProvider.getAllServices();
    });



    initChannel();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {

      if (message != null) {

      }
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
    //  AndroidNotification android = message.notification?.android;
    //  AppleNotification ios = message.notification?.apple;
     // notification != null && android != null
      if (notification != null) {
        print(message.data);
        print(message.data);
        print(message.data);

        message.data["notification_type"].toString()=='new_project'?showNotification(notification):
        showNotification2(notification);

        message.notification.title=='You Have a Message'?null:FirebaseApi.uploadNotification(
            network.userId.toString(),
            message.notification.title,
            message.data["notification_type"],
            '${message.data["lastName"]} ${message.data["firstName"]}',
            '${message.data["jobId"]}',
            '${message.data["bidId"]}',
            '${message.data["bidderId"]}',
            '${message.data["artisanId"]}',
            '${message.data['budget']}',
            '${message.data['invoiceId']}',
            '${message.data['service_id']}'
        );
        FirebaseApi.uploadCheckNotify(
          network.userId.toString(),
        );
      }
      //else if(notification != null && ios != null){
      //   print(message.data);
      //   print(message.data);
      //   print(message.data);
      //
      //   message.data["notification_type"].toString()=='new_project'?showNotification(notification):
      //   showNotification2(notification);
      //
      //   FirebaseApi.uploadNotification(
      //       network.userId.toString(),
      //       message.notification.title,
      //       message.data["notification_type"],
      //       '${message.data["lastName"]} ${message.data["firstName"]}',
      //       '${message.data["jobId"]}',
      //       '${message.data["bidId"]}',
      //       '${message.data["bidderId"]}',
      //       '${message.data["artisanId"]}',
      //       '${message.data['budget']}',
      //       '${message.data['invoiceId']}',
      //       '${message.data['service_id']}'
      //   );
      //   FirebaseApi.uploadCheckNotify(
      //     network.userId.toString(),
      //   );
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {


    });

    var datan = Provider.of<DataProvider>(context, listen: false);
    // widget.firstUser=='first'?datan.setSelectedBottomNavBar(1):null;
   datan.setSelectedBottomNavBar(1);
  }



  @override
  void dispose() {
    _myPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var data = Provider.of<DataProvider>(context, listen: false);
    WebServices network = Provider.of<WebServices>(context, listen: false);
    List<Notify> notify;
    // FirebaseApi.updateUsertoOnline(datas.mobile_device_token);



    var widget = Scaffold(
      key: scafoldKey,
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          child: DrawerWidget(context, _myPage),
        ),
      ),
      bottomNavigationBar: Consumer<DataProvider>(
          builder: (context, conData, child) {

            return Container(
        height: 60,
        child: BottomNavigationBar(
            onTap: (index) {
              if (index == conData.selectedPage) {
              } else {
                setState(() {
                  _myPage.jumpToPage(index);
                  conData.setSelectedBottomNavBar(index);
                });

              }
            },
            elevation: 20,
            type: BottomNavigationBarType.fixed,
            currentIndex: conData.selectedPage,
            unselectedItemColor: Color(0xFF555555),
            selectedItemColor: Color(0xFFA40C85),
            selectedLabelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Icon(
                    conData.selectedPage==0?MyFlutterApp.home:MyFlutterApp.vector_1,
                    size: 20,
                  ),
                ),
                label: 'Home',
              ),

              BottomNavigationBarItem(
                icon: Icon(
                    conData.selectedPage==1?Icons.shopping_bag:Icons.shopping_bag_outlined,
                    size: 23,
                  ),
                label: 'Market',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Icon(conData.selectedPage==2?MyFlutterApp.vector_3:MyFlutterApp.vector,
                    size:20, ),
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Icon(
                    conData.selectedPage==3?MyFlutterApp.vector_5:MyFlutterApp.wallet,
                    size: 20,
                  ),
                ),
                label: 'Wallet',
              ),

              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Icon(conData.selectedPage==4?MyFlutterApp.wallet2:FeatherIcons.clock),
                ),
                label: 'Tasks',
              )
            ]),
      );}),


      body: WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (ctx) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                          Text(
                            'Oops!!',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF9B049B),
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Center(
                                  child: Text(
                                    'DO YOU WANT TO EXIT THIS APP?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 2,
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF9B049B)),
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    child: FlatButton(
                                      onPressed: () {
                                        return exit(0);
                                      },
                                      color: Color(0xFF9B049B),
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
                                            "Yes",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 2,
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF9B049B)),
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color: Color(0xFF9B049B),
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
                                            "No",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: Builder(
          builder: (context) {
            return PageView(
              controller: _myPage,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Home(scafoldKey, data, _myPage),
                MarketPage(scafoldKey,_myPage),
               // Wallet(),
                PostScreen(),
                Wallet(),
               // NotificationPage(scafoldKey,  _myPage),
                PendingScreen(scafoldKey:scafoldKey, control: _myPage,),
              ],
            );
          }
        ),
      ),
    );

    return PickupLayout(scaffold: widget);
  }
}




handlebackgrundMessage(message)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('user_id');
  userid.newid = int.parse(id);
  FirebaseApi.uploadCheckNotify(
    userid.newid.toString(),
  );
  FirebaseApi.uploadNotification(
      userid.newid.toString(),
      message.notification.title,
      message.data["notification_type"],
      '${message.data["lastName"]} ${message.data["firstName"]}',
      '${message.data["jobId"]}',
      '${message.data["bidId"]}',
      '${message.data["bidderId"]}',
      '${message.data["artisanId"]}',
      '${message.data['budget']}',
      '${message.data['invoiceId']}',
      '${message.data['service_id']}'

  );

}


bool count = true;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  count?setup():null;
  count = false;
  await Firebase.initializeApp();
  handlebackgrundMessage(message);
}
