import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Widgets/photoView.dart';
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
      child: Material(
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
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Row(
                        children: [
                          Stack(children: <Widget>[
                            CircleAvatar(
                              child: Text(''),
                              radius: 40,
                              backgroundImage: NetworkImage(
                                snapshot.data.urlAvatar ==
                                    'no_picture_upload' ||
                                    snapshot.data.urlAvatar == null
                                    ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                    : 'https://uploads.fixme.ng/originals/${snapshot.data.urlAvatar}',
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(''),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    bottom: 6,
                                  ),
                                  child: Text(
                                    '${snapshot.data.name} ${snapshot.data.userLastName}',
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
                              snapshot.data.verification == 'un-verified'
                                  ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 6),
                                child: Text('Unverified',
                                    style: TextStyle(
                                      color: Color(0xFFFF0000)
                                          .withOpacity(0.75),
                                    )),
                              )
                                  : Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 6),
                                child: Text('Verified',
                                    style: TextStyle(
                                      color: Color(0xFF27AE60)
                                          .withOpacity(0.9),
                                    )),
                              ),
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
                          '${snapshot.data.serviceArea}'.toUpperCase(),
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
                          Text('Wholesales Channel'),
                          SizedBox(
                            width: 10,
                          ),
                          StarRating(
                            rating: double.parse(
                                snapshot.data.userRating.toString()),

                            /// onRatingChanged: (rating) => setState(() => this.rating = rating),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          onPressed: () {
                            FirebaseApi.addUserChat(
                              bidData: widget.data,
                              urlAvatar2:
                              'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                              name2: network.firstName,
                              idArtisan: network.mobileDeviceToken,
                              artisanMobile: network.phoneNum,
                              userMobile: snapshot.data.userMobile,
                              idUser: snapshot.data.idUser,
                              urlAvatar:
                              'https://uploads.fixme.ng/originals/${snapshot.data.urlAvatar}',
                              name: snapshot.data.name,
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
                          color: Color(0xFF9B049B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 125, minHeight: 45.0),
                              alignment: Alignment.center,
                              child: Text(
                                "MESSAGE",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Wrap(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 5, left: 18, right: 18),
                        child: Text(
                          'About',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 19),
                        ),
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 18, bottom: 15, right: 18),
                      child: ExpandableText(
                        '${snapshot.data.bio}',
                      ),
                    ),
                    Material(
                      elevation: 1.8,
                      child: Container(
                        width: double.infinity,
                        color: Color(0xFF666666).withOpacity(0.5),
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 13.0, bottom: 5, left: 18, right: 18),
                      child: Text(
                        'Business Address',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 19),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 15, left: 18, right: 18),
                      child: Text(
                        '${snapshot.data.businessAddress.toString().isEmpty ? snapshot.data.address : snapshot.data.businessAddress}',
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                    Material(
                      elevation: 1.8,
                      child: Container(
                        width: double.infinity,
                        color: Color(0xFF666666).withOpacity(0.5),
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 13.0, bottom: 5, left: 18, right: 18),
                      child: Text(
                        'SubServices',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 19),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 15, left: 18, right: 18),
                      child: Text(
                        '${snapshot.data.subServices[0]['subservice']}',
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                    Material(
                      elevation: 1.8,
                      child: Container(
                        width: double.infinity,
                        color: Color(0xFF666666).withOpacity(0.5),
                        height: 1,
                      ),
                    ),
                    snapshot.data.userRole == 'artisan'
                        ? FutureBuilder(
                        future: network.getServiceImage(
                            network.userId, snapshot.data.id),
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
                                                  snapshot.data[index]
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
                                                  opacity: animation,
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
                                            BorderRadius.circular(
                                                10),
                                            child: Container(
                                                width: 200,
                                                child: Image.network(
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
                            network.userId, snapshot.data.id),
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
                                    itemCount: snapshots.data == null
                                        ? 0
                                        : snapshots.data.length,
                                    itemBuilder:
                                        (BuildContext context,
                                        int index) {
                                      return ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        child: Container(
                                          child: ListTile(
                                            title: Text(
                                                "${snapshots.data[index]['product_name']}",
                                                style: TextStyle(
                                                    color: Colors
                                                        .black)),
                                            subtitle: Text(
                                                "${snapshots.data[index]['price']}",
                                                style: TextStyle(
                                                    color:
                                                    Colors.green,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                            trailing: Text(
                                                '${snapshots.data[index]['status']}'),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ],
                          );
                        }),
                    StatefulBuilder(builder:
                        (BuildContext context, StateSetter setStates) {
                      return FutureBuilder(
                          future:
                          network.getArtisanReviews(snapshot.data.id),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 13.0,
                                      bottom: 10,
                                      left: 18,
                                      right: 18),
                                  child: Row(children: [
                                    Text(
                                      'Comments',
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.w500,
                                          fontSize: 19),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1, left: 10),
                                      child: Text(
                                        '(${snapshot.data.length})',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 17,
                                            color:
                                            Color(0xFF444444)),
                                      ),
                                    )
                                  ]),
                                ),
                                Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width,
                                  child: ListView.separated(
                                      separatorBuilder:
                                          (BuildContext context,
                                          int index) =>
                                          Material(
                                            elevation: 1.8,
                                            child: Container(
                                              width: double
                                                  .infinity,
                                              color: Color(
                                                  0xFF666666)
                                                  .withOpacity(
                                                  0.5),
                                              height: 1,
                                            ),
                                          ),
                                      shrinkWrap: true,
                                      itemCount:
                                      snapshot.data.length,
                                      physics: ScrollPhysics(),
                                      itemBuilder:
                                          (context, index) {
                                        return Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              top: 13.0,
                                              bottom: 7,
                                              left: 18,
                                              right: 18),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
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
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(''),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left:
                                                        6.8,
                                                        bottom:
                                                        6),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            '${snapshot.data[index]['reviewed_by'].toString()}'),
                                                        Container(
                                                          margin: const EdgeInsets
                                                              .only(
                                                              left:
                                                              5,
                                                              right:
                                                              5),
                                                          height: 5,
                                                          width: 5,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xFF444444),
                                                              shape:
                                                              BoxShape.circle),
                                                          child: Text(
                                                              ''),
                                                        ),
                                                        Text(
                                                            '${snapshot.data[index]['dateAdded'].toString()}'),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left: 6.8,
                                                          bottom:
                                                          4),
                                                      child: Text(
                                                          '${snapshot.data[index]['review'].toString()}')),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left:
                                                        6.8,
                                                        bottom:
                                                        4),
                                                    child:
                                                    StarRating(
                                                      rating: double
                                                          .parse(
                                                          '${snapshot.data[index]['rating']}'),

                                                      /// onRatingChanged: (rating) => setState(() => this.rating = rating),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
//                           ]
//                       )
//                     );
                                      }),
                                ),
                              ],
                            )
                                : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<
                                          Color>(
                                          Color(0xFF9B049B)))),
                            );
                          });
                    })
                  ],
                ),
              )
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF9B049B))));
            }),
      ),
    );
  }
}
