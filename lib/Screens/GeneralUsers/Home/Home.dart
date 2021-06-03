import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/DummyData.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePageNew.dart';
import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/thankyou.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/NearbyArtisansSeeAll.dart';
import 'package:fixme/Screens/GeneralUsers/Home/NearbyShopsSeeAll.dart';
import 'package:fixme/Screens/GeneralUsers/Home/PopularServices.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPage.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';

class Home extends StatelessWidget {
  final scafoldKey;
  var search;
  final data;
  final controller;

  Home(this.scafoldKey, this.data, this.controller);

  String getDistance({String rawDistance}) {
    String distance;

    distance = '$rawDistance' + 'km';

    return distance;
  }

  @override
  Widget build(BuildContext context) {
    // showOverLay() async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var overlay = prefs.getString('overlay');
    //   var data = Provider.of<DataProvider>(context, listen: false);
    //   if (overlay == null || overlay == 'null' || overlay == '') {

        // var numberDialog = Container(
        //   margin: const EdgeInsets.all(3.0),
        //   child: Align(
        //     alignment: Alignment(-0.8, -0.9),
        //     child: Material(
        //       color: Colors.black87,
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10.0)),
        //       child: Container(
        //         padding: const EdgeInsets.all(4.0),
        //         width: 140,
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: <Widget>[
        //             Text(
        //               'Welcome!!',
        //               style: TextStyle(color: Colors.white),
        //               textAlign: TextAlign.center,
        //             ),
        //             Text(
        //               'You can  change to business account by clicking this picture',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                   color: Colors.white, fontWeight: FontWeight.bold),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // );
    //     showDialog(
    //       barrierColor: Colors.transparent,
    //       context: context,
    //       builder: (BuildContext context) {
    //         return numberDialog;
    //       },
    //     ).whenComplete(() {
    //       prefs.setString('overlay', 'overlay');
    //     });
    //   } else {}
    // }

    // showOverLay();
    var network = Provider.of<WebServices>(context, listen: false);
    List<Notify> notify;
    var location = Provider.of<LocationService>(context);
    var data = Provider.of<DataProvider>(context);
    return Stack(
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
                  InkWell(
                    onTap: () {
                      scafoldKey.currentState.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Stack(children: <Widget>[
                        CircleAvatar(
                          child: Text(''),
                          radius: 19,
                          backgroundImage: NetworkImage(
                            network.profilePicFileName == 'no_picture_upload' ||
                                    network.profilePicFileName == null
                                ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                : 'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white,
                        ),
                        Positioned(
                          left: 25,
                          top: 24,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFDB5B04),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Image.asset(
                    'assets/images/fixme1.png',
                    height: 70,
                    width: 70,
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

                      FirebaseApi.clearCheckNotify(
                        network.userId.toString(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.chat,
                            color: Color(0xFF9B049B),
                            size: 25,
                          ),
                          StreamBuilder(
                              stream: FirebaseApi.userCheckChatStream(
                                  network.userId.toString()),
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
                                          left: 12, child: Container());
                                    default:
                                      if (snapshot.hasError) {
                                        return Positioned(
                                            left: 12, child: Container());
                                      } else {
                                        final users = notify;
                                        if (users.isEmpty || users == null) {
                                          return Positioned(
                                              left: 12, child: Container());
                                        } else {
                                          return Positioned(
                                              right: 14.4,
                                              child: Icon(
                                                Icons.circle,
                                                color: Color(0xFF9B049B),
                                                size: 12,
                                              ));
                                        }
                                      }
                                  }
                                } else {
                                  return Positioned(
                                      left: 12, child: Container());
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
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Featured Services',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w600, fontSize: 16),
                    //       ),
                    //       Text('See all',
                    //           style: TextStyle(
                    //               color: Color(0xFF9B049B), fontSize: 15))
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.only(top: 12.0, left: 10),
                    //   height: 210,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: featuredServices.length,
                    //     padding: const EdgeInsets.only(bottom: 10),
                    //     itemBuilder: (context, index) {
                    //       return Container(
                    //         width: 110,
                    //         margin: const EdgeInsets.only(right: 7),
                    //         decoration: BoxDecoration(
                    //             color: Color(0xFFFFFFFF),
                    //             border: Border.all(color: Color(0xFFF1F1FD)),
                    //             boxShadow: [
                    //               BoxShadow(
                    //                   color: Color(0xFFF1F1F6),
                    //                   blurRadius: 10.0,
                    //                   offset: Offset(0.3, 4.0))
                    //             ],
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(7))),
                    //         child: Column(
                    //           children: [
                    //             Padding(
                    //                 padding: const EdgeInsets.only(bottom: 4.0),
                    //                 child: Container(
                    //                   height: 90,
                    //                   width: 115,
                    //                   clipBehavior: Clip.antiAliasWithSaveLayer,
                    //                   decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.only(
                    //                           topLeft: Radius.circular(7),
                    //                           topRight: Radius.circular(7))),
                    //                   child: Image.asset(
                    //                     '${featuredServices[index]['image']}',
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //                 )),
                    //             Row(
                    //               children: [
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(left: 5.0),
                    //                   child: Icon(
                    //                     Icons.star,
                    //                     color: Colors.amber,
                    //                     size: 15,
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding:
                    //                       const EdgeInsets.only(right: 5.0),
                    //                   child: Text(
                    //                     '5.0',
                    //                     style: TextStyle(fontSize: 12),
                    //                   ),
                    //                 ),
                    //                 Text(
                    //                   '(9)',
                    //                   style: TextStyle(fontSize: 12),
                    //                 ),
                    //                 Spacer(),
                    //                 Padding(
                    //                   padding:
                    //                       const EdgeInsets.only(right: 7.0),
                    //                   child: Icon(
                    //                     Icons.favorite,
                    //                     color: Colors.red,
                    //                     size: 14,
                    //                   ),
                    //                 )
                    //               ],
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(
                    //                   top: 4.0, left: 8, right: 8),
                    //               child: Container(
                    //                 child: Text(
                    //                   '${featuredServices[index]['text']}',
                    //                   style: TextStyle(fontSize: 13),
                    //                   maxLines: 3,
                    //                   softWrap: true,
                    //                   overflow: TextOverflow.ellipsis,
                    //                 ),
                    //               ),
                    //             ),
                    //             Spacer(),
                    //             Align(
                    //                 alignment: Alignment.bottomRight,
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.only(
                    //                       right: 5.0, bottom: 8),
                    //                   child: Text(
                    //                     'From \₦${featuredServices[index]['price']}',
                    //                     style: TextStyle(
                    //                         fontSize: 11,
                    //                         color: Color(0xFF27AE60)),
                    //                   ),
                    //                 )),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby Shops',
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
                                    return NearbyShopsSeeAll(
                                        longitude: location.locationLatitude,
                                        latitude: location.locationLatitude);
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
                        future: network.nearbyShop(
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
                                                accentColor: Color(0xFF9B049B)),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Loading shops',
                                            style: TextStyle(
                                                color: Color(0xFF333333),
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ))
                              : snapshot.hasData && !snapshot.data.isEmpty
                                  ? Container(
                                      height: 200,
                                      margin: const EdgeInsets.only(bottom: 6),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length > 10
                                            ? 10
                                            : snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          String distance = getDistance(
                                              rawDistance:
                                                  '${snapshot.data[index].distance}');
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                      animation,
                                                      secondaryAnimation) {
                                                    return ArtisanPageNew(
                                                        snapshot.data[index]);
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
                                            child: Container(
                                              width: 130,
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                                top: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFFFFFF),
                                                  border: Border.all(
                                                      color: Color(0xFFF1F1FD)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            Color(0xFFF1F1F6),
                                                        blurRadius: 10.0,
                                                        offset:
                                                            Offset(0.3, 4.0))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 4.0),
                                                          child: Container(
                                                            height: 85,
                                                            width: 130,
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            7),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            7))),
                                                            child:
                                                                Image.network(
                                                              snapshot.data[index].urlAvatar ==
                                                                          'no_picture_upload' ||
                                                                      snapshot.data[index]
                                                                              .urlAvatar ==
                                                                          null
                                                                  ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                                  : 'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )),
                                                      Positioned(
                                                        bottom: 4,
                                                        child: Container(
                                                          height: 20,
                                                          width: 130,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                color: Colors
                                                                    .amber,
                                                                size: 14,
                                                              ),
                                                              Text(
                                                                '$distance away',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Wrap(
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                          .data[
                                                                              index]
                                                                          .businessName
                                                                          .isEmpty ||
                                                                      snapshot.data[index].businessName ==
                                                                          ''
                                                                  ? '${snapshot.data[index].name}\'s shop '
                                                                      .capitalizeFirstOfEach
                                                                  : '${snapshot.data[index].businessName}'
                                                                      .capitalizeFirstOfEach,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Wrap(
                                                        children: [
                                                          Text(
                                                            '${snapshot.data[index].serviceArea}',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8, bottom: 6),
                                                    child: StarRating(
                                                        rating: double.parse(
                                                            snapshot.data[index]
                                                                .userRating
                                                                .toString())),
                                                  ),
                                                ],
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
                                              'No Nearby Shops',
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
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby Artisans',
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
                                    return NearbyArtisansSeeAll(
                                        longitude: location.locationLatitude,
                                        latitude: location.locationLatitude);
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
                        future: network.nearbyArtisans(
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
                                                accentColor: Color(0xFF9B049B)),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Loading artisans',
                                            style: TextStyle(
                                                color: Color(0xFF333333),
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ))
                              : snapshot.hasData && !snapshot.data.isEmpty
                                  ? Container(
                                      height: 200,
                                      margin: const EdgeInsets.only(bottom: 6),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length > 10
                                            ? 10
                                            : snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          String distance = getDistance(
                                              rawDistance:
                                                  '${snapshot.data[index].distance}');
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                      animation,
                                                      secondaryAnimation) {
                                                    return ArtisanPageNew(
                                                        snapshot.data[index]);
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
                                            child: Container(
                                              width: 130,
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                                top: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFFFFFF),
                                                  border: Border.all(
                                                      color: Color(0xFFF1F1FD)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            Color(0xFFF1F1F6),
                                                        blurRadius: 10.0,
                                                        offset:
                                                            Offset(0.3, 4.0))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 4.0),
                                                          child: Container(
                                                            height: 85,
                                                            width: 130,
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            7),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            7))),
                                                            child:
                                                                Image.network(
                                                              snapshot.data[index].urlAvatar ==
                                                                          'no_picture_upload' ||
                                                                      snapshot.data[index]
                                                                              .urlAvatar ==
                                                                          null
                                                                  ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                                  : 'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )),
                                                      Positioned(
                                                        bottom: 4,
                                                        child: Container(
                                                          height: 20,
                                                          width: 130,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                color: Colors
                                                                    .amber,
                                                                size: 14,
                                                              ),
                                                              Text(
                                                                '$distance away',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Wrap(
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[index].name} ${snapshot.data[index].userLastName}'
                                                                  .capitalizeFirstOfEach,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Wrap(
                                                        children: [
                                                          Text(
                                                            '${snapshot.data[index].serviceArea}',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8, bottom: 6),
                                                    child: StarRating(
                                                        rating: double.parse(
                                                            snapshot.data[index]
                                                                .userRating
                                                                .toString())),
                                                  ),
                                                ],
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
                                              'No Nearby Artisans',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
                                      : Container();
                        }),
                    Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 10),
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
                                      MediaQuery.of(context).size.width / 1.3,
                                  minHeight: 45.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Change to Business Account',
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
                    ),
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
                              controller.jumpToPage(2);
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
    );
  }
}
