
import 'dart:io';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme/DummyData.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePageNew.dart';
import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/thankyou.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chat.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/EventsSeeAll.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Screens/GeneralUsers/Home/NearbyArtisansSeeAll.dart';
import 'package:fixme/Screens/GeneralUsers/Home/NearbyShopsSeeAll.dart';
import 'package:fixme/Screens/GeneralUsers/Home/PopularServices.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Screens/GeneralUsers/Market/CategoryItem.dart';
import 'package:fixme/Screens/GeneralUsers/Notification/Notification.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/icons.dart';
import 'package:fixme/Widgets/GeneralGuild.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

class Home extends StatefulWidget {
  final scafoldKey;
  var search;
  final data;
  final controller;

  Home(this.scafoldKey, this.data, this.controller);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  var publicKey = 'pk_live_624bc595811d2051eead2a9baae6fe3f77f7746f';
  final plugin = PaystackPlugin();


  FirebaseMessaging messaging = FirebaseMessaging.instance;


  String getDistance({String rawDistance}) {
    String distance;

    distance = '$rawDistance' + 'km';

    return distance;
  }

@override
 void initState(){
   super.initState();
   plugin.initialize(publicKey: publicKey);
   var network = Provider.of<WebServices>(context, listen: false);
   var data = Provider.of<Utils>(context, listen: false);
   network.updateFCMToken(network.userId, data.fcmToken);
 }






  note()async{
    var locationStatus = await Permission.location.status;
    var notificationStatus = await Permission.notification.status;
    if(locationStatus.isDenied){
    AppSettings.openLocationSettings();
    }else if(notificationStatus.isDenied){
      AppSettings.openNotificationSettings();
    }
  }

  @override
  dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    var network = Provider.of<WebServices>(context, listen: false);
    List<Notify> notify;
    var location = Provider.of<LocationService>(context);

    var data = Provider.of<DataProvider>(context);


    return UpgradeAlert(
      canDismissDialog: false,
      showLater: false,
      showIgnore: false,
      dialogStyle: UpgradeDialogStyle.cupertino,
      child: Stack(
        children: [
          CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                forceElevated: true,
                backgroundColor: Colors.white,
                titleSpacing: 0.0,
                elevation: 2.5,
                shadowColor: Color(0xFFF1F1FD).withOpacity(0.5),
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top:4.0, bottom: 4, left:10),
                        child: IconButton(
                          onPressed: (){
                            widget.scafoldKey.currentState.openDrawer();
                          },
                          icon: Icon(MyFlutterApp.hamburger,
                            size: 17, color: Colors.black),
                        ),
                      ),
                    Spacer(),
                    Image.asset(
                      'assets/images/fixme1.png',
                      height: 70,
                      width: 70,
                    ),
                 Spacer(),
                 InkWell(
                   onTap: (){
                     Navigator.push(
                       context,
                       PageRouteBuilder(
                         pageBuilder:
                             (context, animation, secondaryAnimation) {
                           return NotificationPage(widget.scafoldKey, widget.controller);
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
                   },
                   child: Padding(
                          padding: const EdgeInsets.only(top: 5,right: 10, left:5),
                          child: Stack(
                            children: [
                              Icon(
                                MyFlutterApp.vector_4,
                                color:  Color(0xF0A40C85),
                                size: 24,),
                              StreamBuilder(
                                  stream: FirebaseApi.userCheckNotifyStream(
                                      network.userId.toString()),
                                  builder:
                                      (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      notify = snapshot.data.docs
                                          .map((doc) =>
                                              Notify.fromMap(doc.data(), doc.id))
                                          .toList();

                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Positioned(
                                              left: 12,
                                              child: Container());
                                        default:
                                          if (snapshot.hasError) {
                                            return Positioned(
                                                left: 12,
                                                child: Container());
                                          } else {
                                            final users = notify;
                                            if (users.isEmpty || users == null) {
                                              return Positioned(
                                                  left: 12,
                                                  child: Container());
                                            } else {
                                              return Positioned(
                                                left: 12,
                                                  child: Icon(
                                                Icons.circle,
                                                color: Colors.red,
                                                    size: 12,
                                              ));
                                            }
                                          }
                                      }
                                    } else {
                                      return Positioned(
                                          left: 12,
                                          child: Container());
                                    }
                                  }),

                            ],
                          ),
                        ),
                 ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return ListenIncoming();
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

                        FirebaseApi.clearCheckChat(
                          network.mobileDeviceToken
                              .toString(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top:8.0, bottom: 8, right: 16, left: 16),
                        child:  Stack(
                              children: [
                                Icon(
                                    MyFlutterApp.fill_1,
                                    size: 23, color: Color(0xF0A40C85)),
                                Icon(Icons.more_horiz, size: 23, color: Colors.white,),
                                StreamBuilder(
                                    stream: FirebaseApi.userCheckChatStream(
                                        network.mobileDeviceToken.toString()),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        notify = snapshot.data.docs
                                            .map((doc) =>
                                            Notify.fromMap(doc.data(), doc.id))
                                            .toList();

                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Positioned(
                                                right: 12, child: Container());
                                          default:
                                            if (snapshot.hasError) {
                                              return Positioned(
                                                  right: 12, child: Container());
                                            } else {
                                              final users = notify;
                                              if (users.isEmpty || users == null) {
                                                return Positioned(
                                                    left: 12, child: Container());
                                              } else {
                                                return Container(
                                                  margin: EdgeInsets.only(left: 12),
                                                      height: 12,
                                                        width: 12,
                                                     decoration: BoxDecoration(
                                                       color: Colors.red,
                                                       borderRadius: BorderRadius.circular(100)
                                                     ),
                                                    );
                                              }
                                            }
                                        }
                                      } else {
                                        return Positioned(
                                            right: 12, child: Container());
                                      }
                                    }),
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                        width: MediaQuery.of(context).size.width / 0.2,
                        height: 60,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return SearchPage();
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'searchButton',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  border: Border.all(color: Colors.black12),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFFF1F1FD).withOpacity(0.7),
                                        blurRadius: 10.0,
                                        offset: Offset(0.3, 4.0))
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, right: 5),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.black38,
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                        enabled: false,
                                        obscureText: true,
                                        style: TextStyle(color: Colors.black),
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration.collapsed(
                                          enabled: false,
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 15),
                                          hintText: 'What are you looking for?',
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 8, bottom: 10,right: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7)),
                            child: FlatButton(
                              onPressed: () {
                                network.role == 'artisan' || network.role == 'business'
                                    ? Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
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
                                )
                                    : Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return SignThankyou();
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
                              },
                              color: Color(0xFF9B049B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                      MediaQuery.of(context).size.width / 2.25,
                                      minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text('${network.role == 'artisan' || network.role == 'business'
                                      ? 'Business Profile':'Sell on Fixme'}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 52,
                            child: Card(
                                 child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 10, left:4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7)),
                                child: FlatButton(
                                  onPressed: () {
                                    network.role == 'artisan' || network.role == 'business'
                                        ? Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation, secondaryAnimation) {
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
                                    )
                                        : Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation, secondaryAnimation) {
                                          return SignThankyou();
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
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                          MediaQuery.of(context).size.width / 2.25,
                                          minHeight: 45.0),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Help    ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF9B049B),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                          Icon(Icons.help, color: Color(0xFF9B049B),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Popular Services',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),

                            // InkWell(
                            //   onTap: () {
                            //     //TODO: here
                            //   },
                            //   child: Text('See all',
                            //       style: TextStyle(
                            //           color: Color(0xFF9B049B), fontSize: 14)),
                            // )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          left: 10,
                        ),
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(bottom: 10),
                          itemCount: popularServices.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 105,
                              margin: const EdgeInsets.only(right: 7),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  border: Border.all(color: Color(0xFFF1F1FD)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFFF1F1F6),
                                        blurRadius: 10.0,
                                        offset: Offset(0.3, 4.0))
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return PopularServices(
                                          serviceName: popularServices[index]
                                              ['text'],
                                          serviceId: popularServices[index]['id'],
                                          latitude: location.locationLatitude,
                                          longitude: location.locationLongitude,
                                        );
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: Container(
                                          height: 90,
                                          width: 115,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(7),
                                                  topRight: Radius.circular(7))),
                                          child: Image.asset(
                                            '${popularServices[index]['image']}',
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    Text(
                                      '${popularServices[index]['text']}',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nearby Events',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return EventSeeAllPage(
                                          widget.scafoldKey,
                                        widget.controller,
                                      );
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text('See all',
                                  style: TextStyle(
                                      color: Color(0xFF9B049B), fontSize: 14)),
                            )
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: network.nearbyEvents(
                              latitude: location.locationLatitude,
                              longitude: location.locationLongitude,
                              context: context),
                          builder: (context, snapshot) {
                            return !snapshot.hasData
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Theme(
                                              data: Theme.of(context).copyWith(
                                                  //accentColor: Color(0xFF9B049B)
                                        ),
                                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                strokeWidth: 2,
                                                backgroundColor: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('Loading Events',
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ))
                                : snapshot.hasData && !snapshot.data.isEmpty
                                    ? Container(
                                        height: 180,
                                        margin: const EdgeInsets.only(bottom: 6, top: 15),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.length > 10
                                              ? 10
                                              : snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                _viewProduct(snapshot.data[index].user,
                                                    data:snapshot.data[index]);
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Container(
                                                  padding: EdgeInsets.only(right: 4, left: 4),
                                                  height: 150,
                                                  width: 150,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.network('https://uploads.fixme.ng/thumbnails/'+snapshot.data[index].eventImages[0]['imageFileName'].toString(),
                                                        fit: BoxFit.cover,))
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : snapshot.data.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Container(
                                              color: Color(0xFFBBBBBB),
                                              padding: const EdgeInsets.all(4),
                                              child: Text(
                                                'No Nearby Events',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        : Container();
                          }),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Other Services',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation, secondaryAnimation) {
                                //       return NearbyArtisansSeeAll(
                                //           longitude: location.locationLatitude,
                                //           latitude: location.locationLatitude);
                                //     },
                                //     transitionsBuilder: (context, animation,
                                //         secondaryAnimation, child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
                              },
                              child: Text('See all',
                                  style: TextStyle(
                                      color: Color(0xFF9B049B), fontSize: 14)),
                            )
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: network.getCategory(
                              latitude: location.locationLatitude,
                              longitude: location.locationLongitude,
                              context:context
                          ),
                          builder: (context, snapshot) {
                            return !snapshot.hasData
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Theme(
                                              data: Theme.of(context).copyWith(
                                                 accentColor: Color(0xFF9B049B)
                                        ),
                                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),

                                                strokeWidth: 2,
                                                backgroundColor: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('Loading Other Services',
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ))
                                : snapshot.hasData && !snapshot.data.isEmpty
                                    ?

                            Container(
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 3.0,
                                    mainAxisSpacing: 3.0
                                ),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      // network.postViewed(snapshot.data[index].id);
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context,
                                              animation,
                                              secondaryAnimation) {
                                            return CategoryPage(
                                              control: widget.controller,
                                              scafoldKey: widget.scafoldKey,
                                                id:snapshot.data[index]['sn'],
                                            );
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Tab(
                                      icon: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: Color(0xFF9B049B),
                                        ),
                                        child:Center(child: Container(
                                            height: 40,
                                            width: 40,
                                            child: Image.network("https://uploads.fixme.ng/icons/${snapshot.data[index]['imageFileName']}",
                                            fit: BoxFit.contain,))),
                                      ),
                                      child: Text(snapshot.data[index]['category'],
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(fontSize: 10),),
                                    )
                                  );
                                },
                              ),
                            )

                                    : snapshot.data.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Container(
                                              color: Color(0xFFBBBBBB),
                                              padding: const EdgeInsets.all(4),
                                              child: Text(
                                                'No Nearby Service Provider',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        : Container();
                          }),
                      Container(
                        child:Text(''),
                        height:80,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
         Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 10.0,
                              offset: Offset(5, 4.0))
                        ],
                        border: Border.all(color: Color(0xFFD0D0D0)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 14,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7)),
                            child: FlatButton(
                              onPressed: () {
                                data.setCallToActionStatus = false;
                                widget.controller.jumpToPage(2);
                                data.setSelectedBottomNavBar(2);
                              },
                              color: Color(0xFF9B049B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width / 1.1,
                                      minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Get a job done",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )

        ],
      ),
    );
  }








  _viewProduct(userData, {data}) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 80),
              child: Container(
                height: 80,
                child: Stack(
                  children: [
                    AppBar(
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: PopupMenuButton(
                            icon: Icon(FeatherIcons.moreHorizontal,
                                color: Colors.white),
                            onSelected: (value) {
                              var datas =
                              Provider.of<Utils>(context, listen: false);
                              var location = Provider.of<LocationService>(
                                  context,
                                  listen: false);
                              datas.makeOpenUrl(
                                  'https://www.google.com/maps?saddr=${location.locationLatitude},${location.locationLongitude}&daddr= ${userData.latitude}, ${userData.longitude}');
                            },
                            elevation: 0.1,
                            padding: EdgeInsets.all(0),
                            color: Color(0xFFF6F6F6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry>[
                              PopupMenuItem(
                                height: 30,
                                value: "get direction",
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Get direction",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            height: 1.4,
                                            fontWeight: FontWeight.w600)),
                                    Icon(
                                      FeatherIcons.map,
                                      color: Color(0xFF9B049B),
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                      backgroundColor: Color(0xFF9B049B),
                      leading: Text(''),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  children: [
                    Container(
                      color: Color(0xFFF0F0F0),
                      child: Row(
                        children: [
                          for (dynamic item in data.eventImages)
                            Hero(
                              tag:
                              'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return PhotoView(
                                          'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                                          'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                                        );
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          height: 300,
                                          child: Image.network(
                                            'https://uploads.fixme.ng/thumbnails/${item['imageFileName']}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "${data.eventName}".capitalizeFirstOfEach,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Icon(FeatherIcons.calendar,
                            size: 15, color: Color(0xFF9B049B)),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "${data.eventStartDate}".capitalizeFirstOfEach,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Icon(Icons.access_time,
                            size: 17, color: Color(0xFF9B049B)),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "${data.eventStartTime}".capitalizeFirstOfEach,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.location_on,
                          size: 17,
                          color: Color(0xFF9B049B),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "${data.venueAddress}".capitalizeFirstOfEach,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Description:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "${data.eventDescription}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Builder(builder: (context) {
                          List<Widget> tickerWidget = [];
                          for (var value in data.eventTicket) {
                            print(value);
                            tickerWidget.add(Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("${value['ticket_category']}: ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.black,
                                    )),
                                SizedBox(
                                  width: 7,
                                ),
                                Text("N${value['ticket_price']}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.black,
                                    )),
                                SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    onPressed: () {
                                      dialogConfirm(value);
                                    },
                                    color: Color(0xFF9B049B),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 130, minHeight: 36.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Get this Ticket",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: tickerWidget,
                          );
                        }),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 18, right: 18, top: 18),
                      child: Row(
                        children: [
                          Stack(children: <Widget>[
                            CircleAvatar(
                              child: Text(''),
                              radius: 50,
                              backgroundImage: NetworkImage(
                                userData == 'no_picture_upload' ||
                                    userData == null
                                    ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                    : 'https://uploads.fixme.ng/thumbnails/${userData.urlAvatar}',
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.white,
                            ),
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        userData.businessName == null ||
                                            userData.businessName
                                                .toString() ==
                                                ''
                                            ? '${userData.name} ${userData.userLastName}'
                                            : userData.businessName
                                            .toString()
                                            .capitalizeFirstOfEach,
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${userData.serviceArea}'.toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.5,
                                        color: Color(0xFFBCBCBC)),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      '${double.parse(userData.userRating.toString())}',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Color(0xFFFC5302),
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '(${userData.reviews} reviews)',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    // StarRating(
                                    //   rating: double.parse(
                                    //       widget.userData.userRating.toString()),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 120, right: 120, top: 30, bottom: 30),
                      height: 35,
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Color(0xFFE9E9E9), width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return ArtisanPageNew(data);
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        // full_number
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints:
                            BoxConstraints(maxWidth: 100, minHeight: 35.0),
                            alignment: Alignment.center,
                            child: Text(
                              "View Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  dialogConfirm(data) {
    WebServices network = Provider.of<WebServices>(context, listen: false);
    String _getReference() {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }
      return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
    }



    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Payment Method'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return WillPopScope(
                        onWillPop: () {},
                        child: Dialog(
                          elevation: 0,
                          child: CupertinoActivityIndicator(
                            radius: 15,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    });

                network.recureEventPay(
                  context: context,
                  eventId: data['event_id'],
                  ticketCategory: data['ticket_category'],
                  ticketCost: data['ticket_price'],
                  method: 'wallet',
                );
              },
              child: Tab(
                child: Text('Wallet'),
                icon: Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var status = prefs.getString('paymentToken');
                if (status == null ||
                    status == 'null' ||
                    status == '' ||
                    status == 'in_active') {
                  Charge charge = Charge()
                    ..amount = 5000
                    ..reference = _getReference()
                    ..email = network.email;
                  CheckoutResponse response = await plugin.checkout(
                    context,
                    logo: Image.asset(
                      'assets/images/fixme.png',
                      scale: 5,
                    ),
                    method: CheckoutMethod.card,
                    // Defaults to CheckoutMethod.selectable
                    charge: charge,
                  );
                  if (response.status) {
                    network.validatePayment(response.reference);
                    Utils().storeData('paymentToken', 'active');
                    network.firstEventPay(
                      context: context,
                      eventId: data['event_id'],
                      ticketCategory: data['ticket_category'],
                      ticketCost: data['ticket_price'],
                      ref: response.reference,
                    );
                  }
                } else {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return WillPopScope(
                          onWillPop: () {},
                          child: Dialog(
                            elevation: 0,
                            child: CupertinoActivityIndicator(
                              radius: 15,
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        );
                      });

                  network.recureEventPay(
                    context: context,
                    eventId: data['event_id'],
                    ticketCategory: data['ticket_category'],
                    ticketCost: data['ticket_price'],
                    method: 'card',
                  );
                }
              },
              child: Tab(
                child: Text('Card'),
                icon: Icon(Icons.credit_card),
              ),
            )
          ],
        ),
      ),
    );
  }

}









//
// import 'dart:ui';
// import 'package:app_settings/app_settings.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fixme/DummyData.dart';
// import 'package:fixme/Model/Notify.dart';
// import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
// import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePageNew.dart';
// import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/thankyou.dart';
// import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
// import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
// import 'package:fixme/Screens/GeneralUsers/Home/NearbyArtisansSeeAll.dart';
// import 'package:fixme/Screens/GeneralUsers/Home/NearbyShopsSeeAll.dart';
// import 'package:fixme/Screens/GeneralUsers/Home/PopularServices.dart';
// import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
// import 'package:fixme/Screens/GeneralUsers/Notification/Notification.dart';
// import 'package:fixme/Services/Firebase_service.dart';
// import 'package:fixme/Services/location_service.dart';
// import 'package:fixme/Services/network_service.dart';
// import 'package:fixme/Utils/Provider.dart';
// import 'package:fixme/Utils/icons.dart';
// import 'package:fixme/Widgets/GeneralGuild.dart';
// import 'package:fixme/Widgets/Rating.dart';
// import 'package:flutter/material.dart';
// import 'package:fixme/Utils/utils.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:upgrader/upgrader.dart';
//
// class Home extends StatefulWidget {
//   final scafoldKey;
//   var search;
//   final data;
//   final controller;
//
//   Home(this.scafoldKey, this.data, this.controller);
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
//
// class _HomeState extends State<Home> {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//
//   String getDistance({String rawDistance}) {
//     String distance;
//
//     distance = '$rawDistance' + 'km';
//
//     return distance;
//   }
//
//   @override
//   void initState(){
//     super.initState();
//     var network = Provider.of<WebServices>(context, listen: false);
//     var data = Provider.of<Utils>(context, listen: false);
//     network.updateFCMToken(network.userId, data.fcmToken);
//   }
//
//
//
//
//
//
//   note()async{
//     var locationStatus = await Permission.location.status;
//     var notificationStatus = await Permission.notification.status;
//     if(locationStatus.isDenied){
//       AppSettings.openLocationSettings();
//     }else if(notificationStatus.isDenied){
//       AppSettings.openNotificationSettings();
//     }
//   }
//
//   @override
//   dispose() {
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     var network = Provider.of<WebServices>(context, listen: false);
//     List<Notify> notify;
//     var location = Provider.of<LocationService>(context);
//
//     var data = Provider.of<DataProvider>(context);
//
//
//     return UpgradeAlert(
//       canDismissDialog: false,
//       showLater: false,
//       showIgnore: false,
//       dialogStyle: UpgradeDialogStyle.cupertino,
//       child: Stack(
//         children: [
//           CustomScrollView(
//             physics: NeverScrollableScrollPhysics(),
//             slivers: [
//               SliverAppBar(
//                 forceElevated: true,
//                 backgroundColor: Colors.white,
//                 titleSpacing: 0.0,
//                 elevation: 2.5,
//                 shadowColor: Color(0xFFF1F1FD).withOpacity(0.5),
//                 automaticallyImplyLeading: false,
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top:4.0, bottom: 4, left:10),
//                       child: IconButton(
//                         onPressed: (){
//                           widget.scafoldKey.currentState.openDrawer();
//                         },
//                         icon: Icon(MyFlutterApp.hamburger,
//                             size: 17, color: Colors.black),
//                       ),
//                     ),
//                     Spacer(),
//                     Image.asset(
//                       'assets/images/fixme1.png',
//                       height: 70,
//                       width: 70,
//                     ),
//                     Spacer(),
//                     InkWell(
//                       onTap: (){
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation, secondaryAnimation) {
//                               return NotificationPage(widget.scafoldKey, widget.controller);
//                             },
//                             transitionsBuilder:
//                                 (context, animation, secondaryAnimation, child) {
//                               return FadeTransition(
//                                 opacity: animation,
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 5,right: 10, left:5),
//                         child: Stack(
//                           children: [
//                             Icon(
//                               MyFlutterApp.vector_4,
//                               color:  Color(0xF0A40C85),
//                               size: 24,),
//                             StreamBuilder(
//                                 stream: FirebaseApi.userCheckNotifyStream(
//                                     network.userId.toString()),
//                                 builder:
//                                     (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                   if (snapshot.hasData) {
//                                     notify = snapshot.data.docs
//                                         .map((doc) =>
//                                         Notify.fromMap(doc.data(), doc.id))
//                                         .toList();
//
//                                     switch (snapshot.connectionState) {
//                                       case ConnectionState.waiting:
//                                         return Positioned(
//                                             left: 12,
//                                             child: Container());
//                                       default:
//                                         if (snapshot.hasError) {
//                                           return Positioned(
//                                               left: 12,
//                                               child: Container());
//                                         } else {
//                                           final users = notify;
//                                           if (users.isEmpty || users == null) {
//                                             return Positioned(
//                                                 left: 12,
//                                                 child: Container());
//                                           } else {
//                                             return Positioned(
//                                                 left: 12,
//                                                 child: Icon(
//                                                   Icons.circle,
//                                                   color: Colors.red,
//                                                   size: 12,
//                                                 ));
//                                           }
//                                         }
//                                     }
//                                   } else {
//                                     return Positioned(
//                                         left: 12,
//                                         child: Container());
//                                   }
//                                 }),
//
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation, secondaryAnimation) {
//                               return ListenIncoming();
//                             },
//                             transitionsBuilder:
//                                 (context, animation, secondaryAnimation, child) {
//                               return FadeTransition(
//                                 opacity: animation,
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//
//                         FirebaseApi.clearCheckChat(
//                           network.mobileDeviceToken
//                               .toString(),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(top:8.0, bottom: 8, right: 16, left: 16),
//                         child:  Stack(
//                           children: [
//                             Icon(
//                                 MyFlutterApp.fill_1,
//                                 size: 23, color: Color(0xF0A40C85)),
//                             Icon(Icons.more_horiz, size: 23, color: Colors.white,),
//                             StreamBuilder(
//                                 stream: FirebaseApi.userCheckChatStream(
//                                     network.mobileDeviceToken.toString()),
//                                 builder: (context,
//                                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                                   if (snapshot.hasData) {
//                                     notify = snapshot.data.docs
//                                         .map((doc) =>
//                                         Notify.fromMap(doc.data(), doc.id))
//                                         .toList();
//
//                                     switch (snapshot.connectionState) {
//                                       case ConnectionState.waiting:
//                                         return Positioned(
//                                             right: 12, child: Container());
//                                       default:
//                                         if (snapshot.hasError) {
//                                           return Positioned(
//                                               right: 12, child: Container());
//                                         } else {
//                                           final users = notify;
//                                           if (users.isEmpty || users == null) {
//                                             return Positioned(
//                                                 left: 12, child: Container());
//                                           } else {
//                                             return Container(
//                                               margin: EdgeInsets.only(left: 12),
//                                               height: 12,
//                                               width: 12,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.red,
//                                                   borderRadius: BorderRadius.circular(100)
//                                               ),
//                                             );
//                                           }
//                                         }
//                                     }
//                                   } else {
//                                     return Positioned(
//                                         right: 12, child: Container());
//                                   }
//                                 }),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SliverFillRemaining(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding:
//                         const EdgeInsets.only(top: 16.0, left: 10, right: 10),
//                         width: MediaQuery.of(context).size.width / 0.2,
//                         height: 60,
//                         child: InkWell(
//                           splashColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           focusColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               PageRouteBuilder(
//                                 pageBuilder:
//                                     (context, animation, secondaryAnimation) {
//                                   return SearchPage();
//                                 },
//                                 transitionsBuilder: (context, animation,
//                                     secondaryAnimation, child) {
//                                   return FadeTransition(
//                                     opacity: animation,
//                                     child: child,
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                           child: Hero(
//                             tag: 'searchButton',
//                             child: AnimatedContainer(
//                               duration: Duration(milliseconds: 500),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFFFFFFF),
//                                   border: Border.all(color: Colors.black12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Color(0xFFF1F1FD).withOpacity(0.7),
//                                         blurRadius: 10.0,
//                                         offset: Offset(0.3, 4.0))
//                                   ],
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(7))),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.only(left: 10, right: 5),
//                                     child: Icon(
//                                       Icons.search,
//                                       color: Colors.black38,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: TextField(
//                                         enabled: false,
//                                         obscureText: true,
//                                         style: TextStyle(color: Colors.black),
//                                         cursorColor: Colors.black,
//                                         decoration: InputDecoration.collapsed(
//                                           enabled: false,
//                                           hintStyle: TextStyle(
//                                               color: Colors.black38,
//                                               fontSize: 15),
//                                           hintText: 'What are you looking for?',
//                                         )),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                         const EdgeInsets.only(top: 16.0, left: 10, right: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Popular Services',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 15),
//                             ),
//
//                             // InkWell(
//                             //   onTap: () {
//                             //     //TODO: here
//                             //   },
//                             //   child: Text('See all',
//                             //       style: TextStyle(
//                             //           color: Color(0xFF9B049B), fontSize: 14)),
//                             // )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(
//                           top: 12.0,
//                           left: 10,
//                         ),
//                         height: 160,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           padding: const EdgeInsets.only(bottom: 10),
//                           itemCount: popularServices.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               width: 105,
//                               margin: const EdgeInsets.only(right: 7),
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFFFFFFF),
//                                   border: Border.all(color: Color(0xFFF1F1FD)),
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Color(0xFFF1F1F6),
//                                         blurRadius: 10.0,
//                                         offset: Offset(0.3, 4.0))
//                                   ],
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(7))),
//                               child: InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     PageRouteBuilder(
//                                       pageBuilder: (context, animation,
//                                           secondaryAnimation) {
//                                         return PopularServices(
//                                           serviceName: popularServices[index]
//                                           ['text'],
//                                           serviceId: popularServices[index]['id'],
//                                           latitude: location.locationLatitude,
//                                           longitude: location.locationLongitude,
//                                         );
//                                       },
//                                       transitionsBuilder: (context, animation,
//                                           secondaryAnimation, child) {
//                                         return FadeTransition(
//                                           opacity: animation,
//                                           child: child,
//                                         );
//                                       },
//                                     ),
//                                   );
//                                 },
//                                 child: Column(
//                                   children: [
//                                     Padding(
//                                         padding:
//                                         const EdgeInsets.only(bottom: 15.0),
//                                         child: Container(
//                                           height: 90,
//                                           width: 115,
//                                           clipBehavior:
//                                           Clip.antiAliasWithSaveLayer,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(7),
//                                                   topRight: Radius.circular(7))),
//                                           child: Image.asset(
//                                             '${popularServices[index]['image']}',
//                                             fit: BoxFit.cover,
//                                           ),
//                                         )),
//                                     Text(
//                                       '${popularServices[index]['text']}',
//                                       style: TextStyle(fontSize: 13),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//
//                       Padding(
//                         padding:
//                         const EdgeInsets.only(top: 16.0, left: 10, right: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Nearby Shops',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 15),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   PageRouteBuilder(
//                                     pageBuilder:
//                                         (context, animation, secondaryAnimation) {
//                                       return NearbyShopsSeeAll(
//                                           longitude: location.locationLatitude,
//                                           latitude: location.locationLatitude);
//                                     },
//                                     transitionsBuilder: (context, animation,
//                                         secondaryAnimation, child) {
//                                       return FadeTransition(
//                                         opacity: animation,
//                                         child: child,
//                                       );
//                                     },
//                                   ),
//                                 );
//                               },
//                               child: Text('See all',
//                                   style: TextStyle(
//                                       color: Color(0xFF9B049B), fontSize: 14)),
//                             )
//                           ],
//                         ),
//                       ),
//                       FutureBuilder(
//                           future: network.nearbyShop(
//                               latitude: location.locationLatitude,
//                               longitude: location.locationLongitude,
//                               context: context),
//                           builder: (context, snapshot) {
//                             return !snapshot.hasData
//                                 ? Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Center(
//                                   child: Column(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.center,
//                                     children: [
//                                       Theme(
//                                           data: Theme.of(context).copyWith(
//                                             //accentColor: Color(0xFF9B049B)
//                                           ),
//                                           child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//                                             strokeWidth: 2,
//                                             backgroundColor: Colors.white,
//                                           )),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text('Loading shops',
//                                           style: TextStyle(
//                                               color: Color(0xFF333333),
//                                               fontWeight: FontWeight.w500)),
//                                     ],
//                                   ),
//                                 ))
//                                 : snapshot.hasData && !snapshot.data.isEmpty
//                                 ? Container(
//                               height: 222,
//                               margin: const EdgeInsets.only(bottom: 6),
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: snapshot.data.length > 10
//                                     ? 10
//                                     : snapshot.data.length,
//                                 itemBuilder: (context, index) {
//                                   String distance = getDistance(
//                                       rawDistance:
//                                       '${snapshot.data[index].distance}');
//                                   return InkWell(
//                                     onTap: () {
//                                       network.postViewed(snapshot.data[index].id);
//                                       Navigator.push(
//                                         context,
//                                         PageRouteBuilder(
//                                           pageBuilder: (context,
//                                               animation,
//                                               secondaryAnimation) {
//                                             return ArtisanPageNew(
//                                                 snapshot.data[index]);
//                                           },
//                                           transitionsBuilder: (context,
//                                               animation,
//                                               secondaryAnimation,
//                                               child) {
//                                             return FadeTransition(
//                                               opacity: animation,
//                                               child: child,
//                                             );
//                                           },
//                                         ),
//                                       );
//                                     },
//                                     child: GridTile(
//                                       child: Container(
//                                         // width: 150,
//                                         margin: const EdgeInsets.only(
//                                           left: 10,
//                                           top: 12,
//                                         ),
//                                         decoration: BoxDecoration(
//                                             color: Color(0xFFFFFFFF),
//                                             border: Border.all(
//                                                 color: Color(0xFFF1F1FD)),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                   color:
//                                                   Color(0xFFF1F1F6),
//                                                   blurRadius: 10.0,
//                                                   offset:
//                                                   Offset(0.3, 4.0))
//                                             ],
//                                             borderRadius:
//                                             BorderRadius.all(
//                                                 Radius.circular(7))),
//                                         child: Column(
//                                           children: [
//                                             Stack(
//                                               children: [
//                                                 Padding(
//                                                     padding:
//                                                     const EdgeInsets
//                                                         .only(
//                                                         bottom: 4.0),
//                                                     child: Container(
//                                                       height: 90,
//                                                       width: 150,
//                                                       clipBehavior: Clip
//                                                           .antiAliasWithSaveLayer,
//                                                       decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.only(
//                                                               topLeft: Radius
//                                                                   .circular(
//                                                                   7),
//                                                               topRight: Radius
//                                                                   .circular(
//                                                                   7))),
//                                                       child:
//                                                       Image.network(
//                                                         snapshot.data[index].urlAvatar ==
//                                                             'no_picture_upload' ||
//                                                             snapshot.data[index]
//                                                                 .urlAvatar ==
//                                                                 null
//                                                             ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
//                                                             : 'https://uploads.fixme.ng/thumbnails/${snapshot.data[index].urlAvatar}',
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     )),
//                                                 Positioned(
//                                                   bottom: 4,
//                                                   child: Container(
//                                                     height: 20,
//                                                     width: 150,
//                                                     padding:
//                                                     const EdgeInsets
//                                                         .only(
//                                                         left: 5),
//                                                     color: Colors.black
//                                                         .withOpacity(0.5),
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.center,
//                                                       children: [
//                                                         Icon(
//                                                           Icons
//                                                               .location_on,
//                                                           color: Colors
//                                                               .white,
//                                                           size: 14,
//                                                         ),
//                                                         Text(
//                                                           '$distance away',
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .white,
//                                                               fontSize:
//                                                               12,
//                                                               fontWeight:
//                                                               FontWeight
//                                                                   .w500),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Align(
//                                                 alignment:
//                                                 Alignment.bottomLeft,
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets
//                                                       .only(
//                                                       left: 0.0,
//                                                       right: 0.0),
//                                                   child: Wrap(
//                                                     children: [
//                                                       Container(
//                                                         // width:140,
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.only(top:8.0),
//                                                           child: Text(
//                                                             snapshot
//                                                                 .data[
//                                                             index]
//                                                                 .businessName
//                                                                 .isEmpty ||
//                                                                 snapshot.data[index].businessName ==
//                                                                     ''
//                                                                 ? '${snapshot.data[index].name}\'s shop '
//                                                                 .capitalizeFirstOfEach
//                                                                 : '${snapshot.data[index].businessName}'
//                                                                 .capitalizeFirstOfEach,
//                                                             style: TextStyle(
//                                                               fontSize: 13,
//                                                             ),
//                                                             maxLines: 1,
//                                                             textAlign: TextAlign.center,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )),
//                                             Container(
//                                               width: 150,
//                                               child: Column(
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   Align(
//                                                     alignment:
//                                                     Alignment.center,
//                                                     child: Padding(
//                                                       padding:
//                                                       const EdgeInsets.only(
//                                                           left: 8.0,
//                                                           right: 8.0, top:2),
//                                                       child: Wrap(
//                                                         children: [
//                                                           Text(
//                                                             '${snapshot.data[index].serviceArea}',
//                                                             style: TextStyle(
//                                                                 fontSize: 13,
//                                                                 fontWeight:
//                                                                 FontWeight
//                                                                     .w600),
//                                                             textAlign: TextAlign.center,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                         const EdgeInsets.only(
//                                                             bottom: 2, top:4),
//                                                         child: Center(
//                                                           child: StarRating(
//                                                               rating: double.parse(
//                                                                   snapshot.data[index]
//                                                                       .userRating
//                                                                       .toString())),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             )
//                                 : snapshot.data.isEmpty
//                                 ? Padding(
//                               padding: const EdgeInsets.all(18.0),
//                               child: Container(
//                                 color: Color(0xFFBBBBBB),
//                                 padding: const EdgeInsets.all(4),
//                                 child: Text(
//                                   'No Nearby Shops',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             )
//                                 : Container();
//                           }),
//                       Padding(
//                         padding:
//                         const EdgeInsets.only(left: 10, right: 10, top: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Nearby Service Provider',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 15),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   PageRouteBuilder(
//                                     pageBuilder:
//                                         (context, animation, secondaryAnimation) {
//                                       return NearbyArtisansSeeAll(
//                                           longitude: location.locationLatitude,
//                                           latitude: location.locationLatitude);
//                                     },
//                                     transitionsBuilder: (context, animation,
//                                         secondaryAnimation, child) {
//                                       return FadeTransition(
//                                         opacity: animation,
//                                         child: child,
//                                       );
//                                     },
//                                   ),
//                                 );
//                               },
//                               child: Text('See all',
//                                   style: TextStyle(
//                                       color: Color(0xFF9B049B), fontSize: 14)),
//                             )
//                           ],
//                         ),
//                       ),
//                       FutureBuilder(
//                           future: network.nearbyArtisans(
//                               latitude: location.locationLatitude,
//                               longitude: location.locationLongitude,
//                               context:context
//                           ),
//                           builder: (context, snapshot) {
//                             return !snapshot.hasData
//                                 ? Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Center(
//                                   child: Column(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.center,
//                                     children: [
//                                       Theme(
//                                           data: Theme.of(context).copyWith(
//                                               accentColor: Color(0xFF9B049B)
//                                           ),
//                                           child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//
//                                             strokeWidth: 2,
//                                             backgroundColor: Colors.white,
//                                           )),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text('Loading Service Provider',
//                                           style: TextStyle(
//                                               color: Color(0xFF333333),
//                                               fontWeight: FontWeight.w500)),
//                                     ],
//                                   ),
//                                 ))
//                                 : snapshot.hasData && !snapshot.data.isEmpty
//                                 ?
//
//                             Container(
//                               height: 222,
//                               margin: const EdgeInsets.only(bottom: 6),
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: snapshot.data.length > 10
//                                     ? 10
//                                     : snapshot.data.length,
//                                 itemBuilder: (context, index) {
//                                   String distance = getDistance(
//                                       rawDistance:
//                                       '${snapshot.data[index].distance}');
//                                   return InkWell(
//                                     onTap: () {
//                                       network.postViewed(snapshot.data[index].id);
//                                       Navigator.push(
//                                         context,
//                                         PageRouteBuilder(
//                                           pageBuilder: (context,
//                                               animation,
//                                               secondaryAnimation) {
//                                             return ArtisanPageNew(
//                                                 snapshot.data[index]);
//                                           },
//                                           transitionsBuilder: (context,
//                                               animation,
//                                               secondaryAnimation,
//                                               child) {
//                                             return FadeTransition(
//                                               opacity: animation,
//                                               child: child,
//                                             );
//                                           },
//                                         ),
//                                       );
//                                     },
//                                     child: GridTile(
//                                       child: Container(
//                                         // width: 150,
//                                         margin: const EdgeInsets.only(
//                                           left: 10,
//                                           top: 12,
//                                         ),
//                                         decoration: BoxDecoration(
//                                             color: Color(0xFFFFFFFF),
//                                             border: Border.all(
//                                                 color: Color(0xFFF1F1FD)),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                   color:
//                                                   Color(0xFFF1F1F6),
//                                                   blurRadius: 10.0,
//                                                   offset:
//                                                   Offset(0.3, 4.0))
//                                             ],
//                                             borderRadius:
//                                             BorderRadius.all(
//                                                 Radius.circular(7))),
//                                         child: Column(
//                                           children: [
//                                             Stack(
//                                               children: [
//                                                 Padding(
//                                                     padding:
//                                                     const EdgeInsets
//                                                         .only(
//                                                         bottom: 4.0),
//                                                     child: Container(
//                                                       height: 90,
//                                                       width: 150,
//                                                       clipBehavior: Clip
//                                                           .antiAliasWithSaveLayer,
//                                                       decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.only(
//                                                               topLeft: Radius
//                                                                   .circular(
//                                                                   7),
//                                                               topRight: Radius
//                                                                   .circular(
//                                                                   7))),
//                                                       child:
//                                                       Image.network(
//                                                         snapshot.data[index].urlAvatar ==
//                                                             'no_picture_upload' ||
//                                                             snapshot.data[index]
//                                                                 .urlAvatar ==
//                                                                 null
//                                                             ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
//                                                             : 'https://uploads.fixme.ng/thumbnails/${snapshot.data[index].urlAvatar}',
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     )),
//                                                 Positioned(
//                                                   bottom: 4,
//                                                   child: Container(
//                                                     height: 20,
//                                                     width: 150,
//                                                     padding:
//                                                     const EdgeInsets
//                                                         .only(
//                                                         left: 5),
//                                                     color: Colors.black
//                                                         .withOpacity(0.5),
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.center,
//                                                       children: [
//                                                         Icon(
//                                                           Icons
//                                                               .location_on,
//                                                           color: Colors
//                                                               .white,
//                                                           size: 14,
//                                                         ),
//                                                         Text(
//                                                           '$distance away',
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .white,
//                                                               fontSize:
//                                                               12,
//                                                               fontWeight:
//                                                               FontWeight
//                                                                   .w500),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Align(
//                                                 alignment:
//                                                 Alignment.bottomLeft,
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets
//                                                       .only(
//                                                       left: 0.0,
//                                                       right: 0.0),
//                                                   child: Wrap(
//                                                     children: [
//                                                       Container(
//                                                         // width:140,
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.only(top:8.0),
//                                                           child: Text(
//                                                             snapshot
//                                                                 .data[
//                                                             index]
//                                                                 .businessName
//                                                                 .isEmpty ||
//                                                                 snapshot.data[index].businessName ==
//                                                                     ''
//                                                                 ? '${snapshot.data[index].name}\'s shop '
//                                                                 .capitalizeFirstOfEach
//                                                                 : '${snapshot.data[index].businessName}'
//                                                                 .capitalizeFirstOfEach,
//                                                             style: TextStyle(
//                                                               fontSize: 13,
//                                                             ),
//                                                             maxLines: 1,
//                                                             textAlign: TextAlign.center,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )),
//                                             Container(
//                                               width: 150,
//                                               child: Column(
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   Align(
//                                                     alignment:
//                                                     Alignment.center,
//                                                     child: Padding(
//                                                       padding:
//                                                       const EdgeInsets.only(
//                                                           left: 8.0,
//                                                           right: 8.0, top:2),
//                                                       child: Wrap(
//                                                         children: [
//                                                           Text(
//                                                             '${snapshot.data[index].serviceArea}',
//                                                             style: TextStyle(
//                                                                 fontSize: 13,
//                                                                 fontWeight:
//                                                                 FontWeight
//                                                                     .w600),
//                                                             textAlign: TextAlign.center,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                         const EdgeInsets.only(
//                                                             bottom: 2, top:4),
//                                                         child: Center(
//                                                           child: StarRating(
//                                                               rating: double.parse(
//                                                                   snapshot.data[index]
//                                                                       .userRating
//                                                                       .toString())),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             )
//
//                                 : snapshot.data.isEmpty
//                                 ? Padding(
//                               padding: const EdgeInsets.all(18.0),
//                               child: Container(
//                                 color: Color(0xFFBBBBBB),
//                                 padding: const EdgeInsets.all(4),
//                                 child: Text(
//                                   'No Nearby Service Provider',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             )
//                                 : Container();
//                           }),
//                       Divider(),
//                       Align(
//                         alignment: Alignment.center,
//                         child: Container(
//                           padding: EdgeInsets.only(top: 8, bottom: 10),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(7)),
//                           child: FlatButton(
//                             onPressed: () {
//                               network.role == 'artisan' || network.role == 'business'
//                                   ? Navigator.push(
//                                 context,
//                                 PageRouteBuilder(
//                                   pageBuilder:
//                                       (context, animation, secondaryAnimation) {
//                                     return ProfilePageNew();
//                                   },
//                                   transitionsBuilder:
//                                       (context, animation, secondaryAnimation, child) {
//                                     return FadeTransition(
//                                       opacity: animation,
//                                       child: child,
//                                     );
//                                   },
//                                 ),
//                               )
//                                   : Navigator.push(
//                                 context,
//                                 PageRouteBuilder(
//                                   pageBuilder:
//                                       (context, animation, secondaryAnimation) {
//                                     return SignThankyou();
//                                   },
//                                   transitionsBuilder:
//                                       (context, animation, secondaryAnimation, child) {
//                                     return FadeTransition(
//                                       opacity: animation,
//                                       child: child,
//                                     );
//                                   },
//                                 ),
//                               );
//                             },
//                             color: Color(0xFF9B049B),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(7)),
//                             padding: EdgeInsets.all(0.0),
//                             child: Ink(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(7)),
//                               child: Container(
//                                 constraints: BoxConstraints(
//                                     maxWidth:
//                                     MediaQuery.of(context).size.width / 1.3,
//                                     minHeight: 45.0),
//                                 alignment: Alignment.center,
//                                 child: Text('${network.role == 'artisan' || network.role == 'business'
//                                     ? 'View Business Profile':'Change to Business Account'}',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         child:Text(''),
//                         height:80,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 80,
//               decoration: BoxDecoration(
//                   color: Color(0xFFFFFFFF),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black38,
//                         blurRadius: 10.0,
//                         offset: Offset(5, 4.0))
//                   ],
//                   border: Border.all(color: Color(0xFFD0D0D0)),
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(15),
//                       topRight: Radius.circular(15))),
//               child: Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.center,
//                     child: Container(
//                       padding: EdgeInsets.only(
//                         top: 14,
//                       ),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(7)),
//                       child: FlatButton(
//                         onPressed: () {
//                           data.setCallToActionStatus = false;
//                           widget.controller.jumpToPage(2);
//                           data.setSelectedBottomNavBar(2);
//                         },
//                         color: Color(0xFF9B049B),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         padding: EdgeInsets.all(0.0),
//                         child: Ink(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(7)),
//                           child: Container(
//                             constraints: BoxConstraints(
//                                 maxWidth:
//                                 MediaQuery.of(context).size.width / 1.1,
//                                 minHeight: 45.0),
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Get a job done",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 18),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//
//         ],
//       ),
//     );
//   }
// }
