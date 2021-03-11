import 'dart:io';

import 'package:fixme/Screens/ArtisanUser/Profile/EditProfilePage.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePageNew extends StatefulWidget {
  @override
  _ProfilePageNewState createState() => _ProfilePageNewState();
}

class _ProfilePageNewState extends State<ProfilePageNew> {
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: ScaffoldState());
  }

  TabController _tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen: false);
    // var location = Provider.of<LocationService>(context);
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(FeatherIcons.moreHorizontal, color: Color(0xFF9B049B)),
            ),
          ],
          elevation: 0,
        ),
        body: FutureBuilder(
            future: network.getUserInfo(network.userId),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Column(children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 18, right: 18, top: 18),
                        child: Row(
                          children: [
                            Stack(children: <Widget>[
                              CircleAvatar(
                                child: Text(''),
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  network.profilePicFileName ==
                                              'no_picture_upload' ||
                                          network.profilePicFileName == null
                                      ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                      : 'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,
                              ),
                              Positioned(
                                left: 63,
                                top: 55,
                                child: Container(
                                  height: 17,
                                  width: 17,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFB8333),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.check,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                ),
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
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(
                                          '${snapshot.data['firstName']} ${snapshot.data['lastName']}'
                                              .capitalizeFirstOfEach,
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFFE9E9E9), width: 1),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: FlatButton(
                                      disabledColor: Color(0x909B049B),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return EditProfilePage();
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
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                            "Edit profile",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, top: 18),
                          child: Column(children: [
                            Wrap(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data['serviceArea']}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19.5,
                                        color: Color(0xFFBCBCBC)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Expertise level: '.capitalizeFirstOfEach,
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                StarRating(
                                  rating: double.parse(
                                      snapshot.data['user_rating'].toString()),
                                ),
                              ],
                            ),
                            snapshot.data['bio'] == null ||
                                    snapshot.data['bio'] == ''
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Divider(),
                                      Row(
                                        children: [
                                          Text(
                                            'ABOUT',
                                            style: TextStyle(
                                                color: Color(0xFF333333),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${snapshot.data['bio']}',
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                            snapshot.data['subServices'][0]['subservice'] ==
                                        null ||
                                    snapshot.data['subServices'][0]
                                            ['subservice'] ==
                                        ''
                                ? SizedBox()
                                : Container(
                                    child: Column(
                                      children: [
                                        Divider(),
                                        Row(
                                          children: [
                                            Text(
                                              'SUBSERVICES',
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Wrap(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${snapshot.data['subServices'][0]['subservice']}',
                                                style: TextStyle(
                                                    color: Color(0xFF333333),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                            Container(
                              child: Column(
                                children: [
                                  Divider(),
                                  Row(
                                    children: [
                                      Text(
                                        'Business Address',
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${snapshot.data['businessAddress'].toString().isEmpty ? snapshot.data['address'] : snapshot.data['businessAddress']}',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1, color: Color(0xFFEFEFEF)),
                              bottom: BorderSide(
                                  width: 1, color: Color(0xFFEFEFEF))),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          unselectedLabelColor: Colors.black26,
                          labelColor: Colors.black54,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: Colors.black54,
                          tabs: [
                            Tab(
                                child: Text('Catalogue(0)',
                                    style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                            Tab(
                                child: Text('Reviews(0)',
                                    style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              //Catalogue Widget
                              Container(
                                child: snapshot.data['role'] == 'artisan'
                                    ? FutureBuilder(
                                        future: network.getServiceImage(
                                            network.userId, network.userId),
                                        builder: (context, snapshot) {
                                          Widget mainWidget;
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.data == null) {
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
                                                                accentColor: Color(
                                                                    0xFF9B049B)),
                                                        child:
                                                            CircularProgressIndicator()),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text('No Network',
                                                        style: TextStyle(
                                                            // letterSpacing: 4,
                                                            color: Color(
                                                                0xFF333333),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              // Future.delayed(Duration.zero,
                                              //     () async {
                                              //   model.setCatalogueCount =
                                              //       snapshot.data == null
                                              //           ? 0
                                              //           : snapshot.data.length;
                                              // });

                                              mainWidget = Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 5,
                                                      left: 5,
                                                      right: 5,
                                                      top: 5),
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    itemCount: snapshot.data ==
                                                            null
                                                        ? 0
                                                        : snapshot.data.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 5,
                                                      mainAxisSpacing: 5,
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
                                                                          index]
                                                                      [
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
                                                        child: Stack(
                                                          children: [
                                                            Hero(
                                                              tag: snapshot
                                                                          .data[
                                                                      index][
                                                                  'imageFileName'],
                                                              child: Container(
                                                                  width: 200,
                                                                  child: Image
                                                                      .network(
                                                                    'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                            ),
                                                            Positioned(
                                                              bottom: 0,
                                                              right: 0,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(6),
                                                                color: Color(
                                                                        0xFF333333)
                                                                    .withOpacity(
                                                                        0.8),
                                                                child: Icon(
                                                                  FeatherIcons
                                                                      .trash2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ));
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
                                                              accentColor: Color(
                                                                  0xFF9B049B)),
                                                      child:
                                                          CircularProgressIndicator()),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text('Loading',
                                                      style: TextStyle(
                                                          // letterSpacing: 4,
                                                          color:
                                                              Color(0xFF333333),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ],
                                              ),
                                            );
                                          }
                                          return mainWidget;
                                        })
                                    : FutureBuilder(
                                        future: network.getProductImage(
                                            network.userId, network.userId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.data == null) {
                                            } else {
                                              // model.setCatalogueCount =
                                              //     snapshot.data == null
                                              //         ? 0
                                              //         : snapshot.data.length;
                                            }
                                          }
                                          return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 30.0,
                                                  left: 8,
                                                  right: 8),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: snapshot.data == null
                                                    ? 0
                                                    : snapshot.data.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      child: ListTile(
                                                        title: Text(
                                                            "${snapshot.data[index]['product_name']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        subtitle: Text(
                                                            "${snapshot.data[index]['price']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        trailing: Text(
                                                            '${snapshot.data[index]['status']}'),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ));
                                        }),
                              ),
                              //Comments Widget
                              StatefulBuilder(builder: (BuildContext context,
                                  StateSetter setStates) {
                                return FutureBuilder(
                                    future: network
                                        .getArtisanReviews(network.userId),
                                    builder: (context, snapshot) {
                                      Widget mainWidget;
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.data == null) {
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
                                                            accentColor: Color(
                                                                0xFF9B049B)),
                                                    child:
                                                        CircularProgressIndicator()),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text('No Network',
                                                    style: TextStyle(
                                                        // letterSpacing: 4,
                                                        color:
                                                            Color(0xFF333333),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          );
                                        } else {
                                          mainWidget = Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                            const EdgeInsets
                                                                .only(
                                                          top: 12,
                                                          left: 15,
                                                          right: 15,
                                                        ),
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
                                                                    fontSize:
                                                                        17,
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

                                                            /// onRatingChanged: (rating) => setState(() => this.rating = rating),
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
                                                          accentColor: Color(
                                                              0xFF9B049B)),
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

                                      // return mainWidget;
                                      return mainWidget;
                                    });
                              }),
                            ],
                          ),
                        ),
                      )
                    ])
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Theme(
                              data: Theme.of(context)
                                  .copyWith(accentColor: Color(0xFF9B049B)),
                              child: CircularProgressIndicator()),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Loading',
                              style: TextStyle(
                                  // letterSpacing: 4,
                                  color: Color(0xFF333333),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
            }));
  }

  _addService(value) {
    Utils data = Provider.of<Utils>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new StatefulBuilder(builder: (context, setStat) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    height: 1000.0,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    color: Colors.transparent,
                    child: ListView(
                      children: [
                        Text(
                          "$value",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        SizedBox(
                            child: Center(
                              child: SizedBox(
                                height: 200, // card height
                                child: data.selectedImage2 == null
                                    ? Text('')
                                    : Container(
                                        width: 200,
                                        child: Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Image.file(
                                              File(
                                                data.selectedImage2.path,
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 3),
                        Material(
                          elevation: 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(26)),
                              child: FlatButton(
                                disabledColor: Colors.white,
                                onPressed: () {
                                  data.selectimage2(
                                      source: ImageSource.gallery);
                                },
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26)),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        minHeight: 45.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Select Catalog Photo",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Text(
                                  "CANCEL",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color(0xFFA40C85)),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                child: Text(
                                  "SAVE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color(0xFFA40C85)),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  network
                                      .addSerPic(
                                    scaffoldKey: scaffoldKey,
                                    path: data.selectedImage2.path,
                                    context: context,
                                    uploadType: 'servicePicture',
                                  )
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                              )
                            ])
                      ],
                    )));
          });
        });
  }
}
