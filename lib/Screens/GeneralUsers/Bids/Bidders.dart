import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Model/service.dart';
import 'package:fixme/Widgets/ExpandedText.dart';
import 'package:fixme/Widgets/Rating.dart';

class BidderPage extends StatefulWidget {
  final data;

  BidderPage([this.data]);

  @override
  _BidderPageState createState() => _BidderPageState();
}

class _BidderPageState extends State<BidderPage> {
  var first;

  @override
  void initState() {
    super.initState();
    address();
  }

  address() async {
    var location = Provider.of<LocationService>(context);
    final coordinates =
        new Coordinates(location.locationLongitude, location.locationLatitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      first = addresses.first;
    });
  }

  List<Services> result = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);

    List services = List();

    return WillPopScope(
      onWillPop: () {
        return Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return HomePage();
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
      child: Consumer<ArtisanProvider>(builder: (context, model, _) {
        return Material(
          child: FutureBuilder(
              future: network.getUserJobInfo(
                  widget.data.project_owner_user_id, widget.data.bidder_id),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .02),
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18, right: 18),
                              child: Row(
                                children: [
                                  Stack(children: <Widget>[
                                    CircleAvatar(
                                      child: Text(''),
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        snapshot.data['profile_pic_file_name'] ==
                                                    'no_picture_upload' ||
                                                snapshot.data[
                                                        'profile_pic_file_name'] ==
                                                    null
                                            ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                            : 'https://uploads.fixme.ng/originals/${snapshot.data['profile_pic_file_name']}',
                                      ),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.white,
                                    ),
                                    Positioned(
                                      left: 65,
                                      top: 55,
                                      child: Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFDB5B04),
                                            shape: BoxShape.circle),
                                        child: Text(''),
                                      ),
                                    ),
                                  ]),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(''),
                                      Row(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            bottom: 6,
                                          ),
                                          child: Text(
                                            '${snapshot.data['firstName']} ${snapshot.data['lastName']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17),
                                          ),
                                        ),
                                        SizedBox(width: 80),
                                      ]),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.8, bottom: 6),
                                        child: Row(
                                          children: [
                                            Icon(Icons.pin_drop,
                                                color: Color(0xFF9B049B)),
                                            Container(
                                                width: 150,
                                                child: Text(
                                                  '${first == null ? 'Location' : first.addressLine}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                          ],
                                        ),
                                      ),
//                                      snapshot.data['identificationStatus'] ==
//                                              'un-verified'
//                                          ? Padding(
//                                              padding: const EdgeInsets.only(
//                                                  left: 10.0, bottom: 6),
//                                              child: Text('Unverified',
//                                                  style: TextStyle(
//                                                    color: Color(0xFFFF0000)
//                                                        .withOpacity(0.75),
//                                                  )),
//                                            )
//                                          : Padding(
//                                              padding: const EdgeInsets.only(
//                                                  left: 10.0, bottom: 6),
//                                              child: Text('Verified',
//                                                  style: TextStyle(
//                                                    color: Color(0xFF27AE60)
//                                                        .withOpacity(0.9),
//                                                  )),
//                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Wrap(children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18.0, left: 18, right: 18),
                                child: Text(
                                  '${snapshot.data['serviceArea']}'
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19.5),
                                ),
                              ),
                            ]),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 13, left: 18, right: 18),
                              child: Row(
                                children: [
                                  Text('Expertise Level:'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  StarRating(
                                    rating: double.parse(snapshot
                                        .data['user_rating']
                                        .toString()),

                                    /// onRatingChanged: (rating) => setState(() => this.rating = rating),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Wrap(children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, bottom: 5, left: 18, right: 18),
                                child: Text(
                                  'ABOUT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19),
                                ),
                              ),
                            ]),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0.0, left: 18, bottom: 15, right: 18),
                              child: ExpandableText(
                                '${snapshot.data['bio']}',
                              ),
                            ),

                            Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 18, right: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    onPressed: (){
                                      FirebaseApi.addUserBidChat(
                                        bidData: widget.data,
                                        urlAvatar2:
                                            'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                                        name2: network.firstName,
                                        idArtisan: network.mobileDeviceToken,
                                        artisanMobile: network.phoneNum,
                                        userMobile: snapshot.data['fullNumber'],
                                        idUser: snapshot.data['firebase_id'],
                                        urlAvatar:
                                            'https://uploads.fixme.ng/originals/${snapshot.data['profile_pic_file_name']}',
                                        name: snapshot.data['firstName'],
                                      );

                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            FirebaseApi.clearJobBids(
                                              widget.data.project_owner_user_id,
                                            );
                                            //user: snapshot.data, pop_data: widget.data
                                            return ListenIncoming();
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
                                            maxWidth: 120, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Message",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE9E9E9), width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    disabledColor: Color(0x909B049B),
                                    onPressed: () async {
                                      await UrlLauncher.canLaunch(
                                          'tel://${snapshot.data['fullNumber']}');
                                    },
                                    // full_number
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 100, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Call",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 35,
                                  width: 33,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE9E9E9), width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    disabledColor: Color(0x909B049B),
                                    onPressed: () {
                                      model.setExpandedStatus =
                                          !model.getExpandedStatus;
                                    },
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Container(
                                          constraints:
                                              BoxConstraints(minHeight: 35.0),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            model.getExpandedStatus
                                                ? FeatherIcons.chevronUp
                                                : FeatherIcons.chevronDown,
                                            size: 15,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 500),
                                  child: model.getExpandedStatus
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13.0,
                                              bottom: 5,
                                              left: 18,
                                              right: 18),
                                          child: Text(
                                            'Business Address',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 19),
                                          ),
                                        )
                                      : Container()),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 500),
                                  child: model.getExpandedStatus
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0,
                                              bottom: 15,
                                              left: 18,
                                              right: 18),
                                          child: Text(
                                            '${snapshot.data['businessAddress'].toString().isEmpty ? snapshot.data['address'] : snapshot.data['businessAddress']}',
                                            style: TextStyle(height: 1.5),
                                          ),
                                        )
                                      : Container()),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 13.0, bottom: 5, left: 18, right: 18),
                              child: Text(
                                'SubServices',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 19),
                              ),
                            ),
                            Builder(builder: (BuildContext context) {
                              for (var i in snapshot.data['subServices']) {
                                services.add(i['subservice']);
                              }
                              return Wrap(
                                children: services
                                    .toSet()
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  var w = Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Chip(
                                      backgroundColor:
                                          Color(0xFF9B049B).withOpacity(0.5),
                                      label: Text(entry.value.toString()),
                                    ),
                                  );
                                  return w;
                                }).toList(),
                              );
                            }),

                            snapshot.data['role'] == 'artisan'
                                ? FutureBuilder(
                                    future: network.getServiceImage(
                                        network.userId, snapshot.data['id']),
                                    builder: (context, snapshot) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 13.0,
                                                bottom: 7,
                                                left: 18,
                                                right: 18),
                                            child: Row(children: [
                                              Text(
                                                'Catalogues(${snapshot.data == null ? 0 : snapshot.data.length})',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19),
                                              ),
                                            ]),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 30.0,
                                                  left: 8,
                                                  right: 8),
                                              child: GridView.builder(
                                                reverse: true,
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: snapshot.data == null
                                                    ? 0
                                                    : snapshot.data.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                ),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) {
                                                            return PhotoView(
                                                              'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                                                              snapshot.data[
                                                                      index][
                                                                  'imageFileName'],
                                                            );
                                                          },
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  secondaryAnimation,
                                                                  child) {
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: child,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Hero(
                                                      tag: snapshot.data[index]
                                                          ['imageFileName'],
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Container(
                                                            width: 200,
                                                            child:
                                                                Image.network(
                                                              'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                                                              fit: BoxFit.cover,
                                                            )),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )),
                                        ],
                                      );
                                    })
                                : FutureBuilder(
                                    future: network.getProductImage(
                                        network.userId, snapshot.data['id']),
                                    builder: (context, snapshots) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 13.0,
                                                  bottom: 7,
                                                  left: 18,
                                                  right: 18),
                                              child: Text(
                                                'Catalogues(${snapshots.data == null ? 0 : snapshots.data.length})',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19),
                                              ),
                                            ),
                                          ]),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 30.0,
                                                  left: 8,
                                                  right: 8),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                reverse: true,
                                                physics: ScrollPhysics(),
                                                itemCount:
                                                    snapshots.data == null
                                                        ? 0
                                                        : snapshots.data.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    child: Container(
                                                      child: ListTile(

                                                        contentPadding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 0),
                                                        leading: CircleAvatar(
                                                          child: Text(''),
                                                          radius: 40,
                                                          backgroundImage:
                                                          NetworkImage(
                                                            'https://uploads.fixme.ng/originals/${snapshot.data[index]['productImages'][0]['imageFileName']}',
                                                          ),
                                                          foregroundColor:
                                                          Colors.white,
                                                          backgroundColor:
                                                          Colors.white,
                                                        ),
                                                        title: Text(
                                                            "${snapshot.data[index]['product_name']}"
                                                                ,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        subtitle: RichText(
                                                          text: TextSpan(
                                                            text: '\u{20A6} ',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Roboto',
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                  "${snapshot.data[index]['price']}",
                                                                  style: GoogleFonts.openSans(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                      FontWeight.bold)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )),
                                        ],
                                      );
                                    }),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Reviews',
                                  style: GoogleFonts.openSans(
                                      fontSize:
                                      19,
                                      fontWeight:
                                      FontWeight
                                          .w500)),
                            ),
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setStates) {
                              return FutureBuilder(
                                  future: network
                                      .getArtisanReviews(snapshot.data['id']),
                                  builder: (context, snapshot) {
                                    Widget mainWidget;
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.data == null ||
                                          snapshot.data.length == 0) {
                                        mainWidget = Center(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text('No reviews',
                                                  style: TextStyle(
                                                    // letterSpacing: 4,
                                                      color: Color(0xFF333333),
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w600)),
                                            ],
                                          ),
                                        );
                                      } else {
                                        if (snapshot.data.length == 0) {
                                          print('empty');
                                        }
                                        mainWidget = Container(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          child: ListView.separated(
                                              separatorBuilder:
                                                  (BuildContext context,
                                                  int index) =>
                                                  Divider(),
                                              shrinkWrap: true,
                                              itemCount: snapshot.data.length,
                                              physics: ScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                DateTime dateOfReview =
                                                DateTime.parse(snapshot
                                                    .data[index]
                                                ['dateAdded']
                                                    .toString());
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          top: 12,
                                                          left: 15,
                                                          right: 15,
                                                          bottom: 2),
                                                      child: Wrap(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                '${snapshot.data[index]['reviewer']['user_first_name'].toString()} ${snapshot.data[index]['reviewer']['user_last_name'].toString()}',
                                                                style: GoogleFonts.openSans(
                                                                    fontSize:
                                                                    17,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                '${snapshot.data[index]['review'].toString()}',
                                                                style: GoogleFonts.openSans(
                                                                    fontSize:
                                                                    16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: CircleAvatar(
                                                        child: Text(''),
                                                        radius: 22,
                                                        backgroundImage:
                                                        NetworkImage(
                                                          network.profilePicFileName ==
                                                              'no_picture_upload' ||
                                                              network.profilePicFileName ==
                                                                  null
                                                              ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                              : 'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                                                        ),
                                                        foregroundColor:
                                                        Colors.white,
                                                        backgroundColor:
                                                        Colors.white,
                                                      ),
                                                      title: Text(
                                                          '${DateFormat('MMM dd, y').format(dateOfReview)}',
                                                          style: GoogleFonts
                                                              .openSans(
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600)),
                                                      subtitle: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(top: 5),
                                                        child: StarRating(
                                                          rating: double.parse(
                                                              '${snapshot.data[index]['rating']}'),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                        );
                                      }
                                    } else {
                                      mainWidget = Center(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                    accentColor:
                                                    Color(0xFF9B049B)),
                                                child:
                                                CircularProgressIndicator()),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text('Loading',
                                                style: TextStyle(
                                                  // letterSpacing: 4,
                                                    color: Color(0xFF333333),
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w600)),
                                          ],
                                        ),
                                      );
                                    }

                                    return mainWidget;
                                  });
                            }),
                          ],
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF9B049B))));
              }),
        );
      }),
    );
  }
}
