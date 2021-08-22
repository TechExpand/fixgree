import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chat.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Utils/utils.dart';
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




  TabController _tabController;
  int index = 0 ;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: ScaffoldState());
    getCataloguePhotos(context);
    getProducts(context);
  }


  var first;




  List<Services> result = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<dynamic> cataloguePhotos;
  Future<dynamic> products;

  getCataloguePhotos(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final artisanProvider =
    Provider.of<ArtisanProvider>(context, listen: false);
    cataloguePhotos =
        network.getServiceImage(network.userId, widget.data.bidder_id);
    cataloguePhotos.then((data) {
      int catalogueCount = data.length;
      artisanProvider.setCatalogueCount = catalogueCount;
    });
  }


  getProducts(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final artisanProvider =
    Provider.of<ArtisanProvider>(context, listen: false);
    products = network.getProductImage(network.userId, widget.data.bidder_id);
    products.then((data) {
      int productCount = data.length;
      artisanProvider.setProductCount = productCount;
    });
  }


  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);

    List services = [];

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
        backgroundColor:  Color(0xFF9B049B),
        leading: IconButton(
        onPressed: () {
      Navigator.of(context).pop();
    },
    icon: Icon(FeatherIcons.arrowLeft, color: Colors.white),
    )),
      body: WillPopScope(
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
                      ? Builder(
                        builder: (context) {
                       var   userdata = snapshot.data;
                          return Container(
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
                                                  ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                                  : 'https://uploads.fixme.ng/thumbnails/${snapshot.data['profile_pic_file_name']}',
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
                                                  StatefulBuilder(
                                                    builder: (context, setState) {
                                                      var count =  0;
                                                      address() async {
                                                        count++;
                                                        //   var location = Provider.of<LocationService>(context);
                                                        final coordinates =
                                                        new Coordinates(snapshot.data['latitude'], snapshot.data['longitude']);
                                                        var addresses =
                                                        await Geocoder.local.findAddressesFromCoordinates(coordinates);
                                                        setState(() {
                                                          first = addresses.first;

                                                        });
                                                      }

                                                      //
                                                      count>=1?null:address();
                                                      return Container(
                                                          width: 150,
                                                          child: Text(
                                                            '${first == null ? 'Location' : first.addressLine}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight.w500),
                                                          ));
                                                    }
                                                  ),
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
                                             var data = Provider.of<Utils>(context, listen: false);
                                            FirebaseApi.addUserBidChat(
                                              token2: data.fcmToken ,
                                  token:snapshot.data['mobile_device_token'],
                                              bidData: widget.data,
                                              recieveruserId2: network.userId,
                                              recieveruserId:  snapshot.data['id'],
                                              serviceId: snapshot.data['service_id'],
                                serviceId2: network.serviceId,
                                              urlAvatar2:
                                                  'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
                                              name2: network.firstName,
                                              idArtisan: network.mobileDeviceToken,
                                              artisanMobile: network.phoneNum,
                                              userMobile: snapshot.data['fullNumber'],
                                              idUser: snapshot.data['firebase_id'],
                                              urlAvatar:
                                                  'https://uploads.fixme.ng/thumbnails/${snapshot.data['profile_pic_file_name']}',
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
                                            label: Text(entry.value.toString(),style: TextStyle(color: Colors.white),),
                                          ),
                                        );
                                        return w;
                                      }).toList(),
                                    );
                                  }),

                                  // snapshot.data['role'] == 'artisan'
                                  //     ? FutureBuilder(
                                  //         future: network.getServiceImage(
                                  //             network.userId, snapshot.data['id']),
                                  //         builder: (context, snapshot) {
                                  //           return Column(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               Padding(
                                  //                 padding: const EdgeInsets.only(
                                  //                     top: 13.0,
                                  //                     bottom: 7,
                                  //                     left: 18,
                                  //                     right: 18),
                                  //                 child: Row(children: [
                                  //                   Text(
                                  //                     'Catalogues(${snapshot.data == null ? 0 : snapshot.data.length})',
                                  //                     style: TextStyle(
                                  //                         fontWeight: FontWeight.w500,
                                  //                         fontSize: 19),
                                  //                   ),
                                  //                 ]),
                                  //               ),
                                  //               Container(
                                  //                   margin: const EdgeInsets.only(
                                  //                       bottom: 30.0,
                                  //                       left: 8,
                                  //                       right: 8),
                                  //                   child: GridView.builder(
                                  //                     reverse: true,
                                  //                     shrinkWrap: true,
                                  //                     physics: ScrollPhysics(),
                                  //                     itemCount: snapshot.data == null
                                  //                         ? 0
                                  //                         : snapshot.data.length,
                                  //                     gridDelegate:
                                  //                         SliverGridDelegateWithFixedCrossAxisCount(
                                  //                       crossAxisCount: 2,
                                  //                       crossAxisSpacing: 10,
                                  //                       mainAxisSpacing: 10,
                                  //                     ),
                                  //                     itemBuilder:
                                  //                         (BuildContext context,
                                  //                             int index) {
                                  //                       return InkWell(
                                  //                         onTap: () {
                                  //                           Navigator.push(
                                  //                             context,
                                  //                             PageRouteBuilder(
                                  //                               pageBuilder: (context,
                                  //                                   animation,
                                  //                                   secondaryAnimation) {
                                  //                                 return PhotoView(
                                  //                                   'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['imageFileName']}',
                                  //                                   snapshot.data[
                                  //                                           index][
                                  //                                       'imageFileName'],
                                  //                                 );
                                  //                               },
                                  //                               transitionsBuilder:
                                  //                                   (context,
                                  //                                       animation,
                                  //                                       secondaryAnimation,
                                  //                                       child) {
                                  //                                 return FadeTransition(
                                  //                                   opacity:
                                  //                                       animation,
                                  //                                   child: child,
                                  //                                 );
                                  //                               },
                                  //                             ),
                                  //                           );
                                  //                         },
                                  //                         child: Hero(
                                  //                           tag: snapshot.data[index]
                                  //                               ['imageFileName'],
                                  //                           child: ClipRRect(
                                  //                             borderRadius:
                                  //                                 BorderRadius
                                  //                                     .circular(10),
                                  //                             child: Container(
                                  //                                 width: 200,
                                  //                                 child:
                                  //                                     Image.network(
                                  //                                   'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['imageFileName']}',
                                  //                                   fit: BoxFit.cover,
                                  //                                 )),
                                  //                           ),
                                  //                         ),
                                  //                       );
                                  //                     },
                                  //                   )),
                                  //             ],
                                  //           );
                                  //         })
                                  //     : FutureBuilder(
                                  //         future: network.getProductImage(
                                  //             network.userId, snapshot.data['id']),
                                  //         builder: (context, snapshots) {
                                  //           return Column(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               Row(children: [
                                  //                 Padding(
                                  //                   padding: const EdgeInsets.only(
                                  //                       top: 13.0,
                                  //                       bottom: 7,
                                  //                       left: 18,
                                  //                       right: 18),
                                  //                   child: Text(
                                  //                     'Products (${snapshots.data == null ? 0 : snapshots.data.length})',
                                  //                     style: TextStyle(
                                  //                         fontWeight: FontWeight.w500,
                                  //                         fontSize: 19),
                                  //                   ),
                                  //                 ),
                                  //               ]),
                                  //               Container(
                                  //                   margin: const EdgeInsets.only(
                                  //                       bottom: 30.0,
                                  //                       left: 8,
                                  //                       right: 8),
                                  //                   child: ListView.builder(
                                  //                     shrinkWrap: true,
                                  //                     reverse: true,
                                  //                     physics: ScrollPhysics(),
                                  //                     itemCount:
                                  //                     snapshots.data == null
                                  //                             ? 0
                                  //                             : snapshots.data.length,
                                  //                     itemBuilder:
                                  //                         (BuildContext context,
                                  //                             int index) {
                                  //                       return ClipRRect(
                                  //                         borderRadius:
                                  //                         BorderRadius.circular(
                                  //                             10),
                                  //                         child: Container(
                                  //                           child: ListTile(
                                  //
                                  //                             contentPadding:
                                  //                             const EdgeInsets
                                  //                                 .only(
                                  //                                 left: 0),
                                  //                             leading: CircleAvatar(
                                  //                               child: Text(''),
                                  //                               radius: 40,
                                  //                               backgroundImage:
                                  //                               NetworkImage(
                                  //                                 snapshot.data[index]['productImages'].isNotEmpty?
                                  //                                 'https://uploads.fixme.ng/thumbnails/${snapshots.data[index]['productImages'][0]['imageFileName']}':'',
                                  //                               ),
                                  //                               foregroundColor:
                                  //                               Colors.white,
                                  //                               backgroundColor:
                                  //                               Colors.white,
                                  //                             ),
                                  //                             title: Text(
                                  //                                 "${snapshots.data[index]['product_name']}"
                                  //                                     ,
                                  //                                 style: TextStyle(
                                  //                                     color: Colors
                                  //                                         .black)),
                                  //                             subtitle: RichText(
                                  //                               text: TextSpan(
                                  //                                 text: '\u{20A6} ',
                                  //                                 style: TextStyle(
                                  //                                     fontFamily:
                                  //                                     'Roboto',
                                  //                                     color: Colors
                                  //                                         .green,
                                  //                                     fontWeight:
                                  //                                     FontWeight
                                  //                                         .bold),
                                  //                                 children: <
                                  //                                     TextSpan>[
                                  //                                   TextSpan(
                                  //                                       text:
                                  //                                       "${snapshots.data[index]['price']}",
                                  //                                       style: GoogleFonts.poppins(
                                  //                                           color: Colors
                                  //                                               .green,
                                  //                                           fontWeight:
                                  //                                           FontWeight.bold)),
                                  //                                 ],
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //                         ),
                                  //                       );
                                  //                     },
                                  //                   )),
                                  //             ],
                                  //           );
                                  //         }),










//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                     'Reviews',
//                                     style: GoogleFonts.poppins(
//                                         fontSize:
//                                         19,
//                                         fontWeight:
//                                         FontWeight
//                                             .w500)),
//                               ),
//                               StatefulBuilder(builder:
//                                   (BuildContext context, StateSetter setStates) {
//                                 return FutureBuilder(
//                                     future: network
//                                         .getArtisanReviews(snapshot.data['id']),
//                                     builder: (context, snapshot) {
//                                       Widget mainWidget;
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.done) {
//                                         if (snapshot.data == null ||
//                                             snapshot.data.length == 0) {
//                                           mainWidget = Center(
//                                             child: Column(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                               children: [
//                                                 Text('No reviews',
//                                                     style: TextStyle(
//                                                       // letterSpacing: 4,
//                                                         color: Color(0xFF333333),
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                         FontWeight.w600)),
//                                               ],
//                                             ),
//                                           );
//                                         } else {
//                                           if (snapshot.data.length == 0) {
//                                             print('empty');
//                                           }
//                                           mainWidget = Container(
//                                             width:
//                                             MediaQuery.of(context).size.width,
//                                             child: ListView.separated(
//                                                 separatorBuilder:
//                                                     (BuildContext context,
//                                                     int index) =>
//                                                     Divider(),
//                                                 shrinkWrap: true,
//                                                 itemCount: snapshot.data.length,
//                                                 physics: ScrollPhysics(),
//                                                 itemBuilder: (context, index) {
//                                                   DateTime dateOfReview =
//                                                   DateTime.parse(snapshot
//                                                       .data[index]
//                                                   ['dateAdded']
//                                                       .toString());
//                                                   return Column(
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                         const EdgeInsets.only(
//                                                             top: 12,
//                                                             left: 15,
//                                                             right: 15,
//                                                             bottom: 2),
//                                                         child: Wrap(
//                                                           children: [
//                                                             Align(
//                                                               alignment: Alignment
//                                                                   .centerLeft,
//                                                               child: Text(
//                                                                   '${snapshot.data[index]['reviewer']['user_first_name'].toString()} ${snapshot.data[index]['reviewer']['user_last_name'].toString()}',
//                                                                   style: GoogleFonts.poppins(
//                                                                       fontSize:
//                                                                       17,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .w600)),
//                                                             ),
//                                                             Align(
//                                                               alignment: Alignment
//                                                                   .centerLeft,
//                                                               child: Text(
//                                                                   '${snapshot.data[index]['review'].toString()}',
//                                                                   style: GoogleFonts.poppins(
//                                                                       fontSize:
//                                                                       16,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .w500)),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       ListTile(
//                                                         leading: CircleAvatar(
//                                                           child: Text(''),
//                                                           radius: 22,
//                                                           backgroundImage:
//                                                           NetworkImage(
//                                                             network.profilePicFileName ==
//                                                                 'no_picture_upload' ||
//                                                                 network.profilePicFileName ==
//                                                                     null
//                                                                 ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
//                                                                 : 'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
//                                                           ),
//                                                           foregroundColor:
//                                                           Colors.white,
//                                                           backgroundColor:
//                                                           Colors.white,
//                                                         ),
//                                                         title: Text(
//                                                             '${DateFormat('MMM dd, y').format(dateOfReview)}',
//                                                             style: GoogleFonts
//                                                                 .openSans(
//                                                                 fontSize: 17,
//                                                                 fontWeight:
//                                                                 FontWeight
//                                                                     .w600)),
//                                                         subtitle: Padding(
//                                                           padding:
//                                                           const EdgeInsets
//                                                               .only(top: 5),
//                                                           child: StarRating(
//                                                             rating: double.parse(
//                                                                 '${snapshot.data[index]['rating']}'),
//                                                           ),
//                                                         ),
//                                                       )
//                                                     ],
//                                                   );
//                                                 }),
//                                           );
//                                         }
//                                       } else {
//                                         mainWidget = Center(
//                                           child: Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             children: [
//                                               Theme(
//                                                   data: Theme.of(context)
//                                                       .copyWith(
//                                                       accentColor:
//                                                       Color(0xFF9B049B)),
//                                                   child:
//                                                   CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//                                                      strokeWidth: 2,
//                                               backgroundColor: Colors.white,
//
// )),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Text('Loading',
//                                                   style: TextStyle(
//                                                     // letterSpacing: 4,
//                                                       color: Color(0xFF333333),
//                                                       fontSize: 18,
//                                                       fontWeight:
//                                                       FontWeight.w600)),
//                                             ],
//                                           ),
//                                         );
//                                       }
//
//                                       return mainWidget;
//                                     });
//                               }),







                                  StatefulBuilder(
                                      builder:(context, setState){
                                        return Wrap(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(width: 1, color: Color(0xFFEFEFEF)),
                                                    bottom:
                                                    BorderSide(width: 1, color: Color(0xFFEFEFEF))),
                                              ),
                                              child: TabBar(
                                                controller: _tabController,
                                                unselectedLabelColor: Colors.black26,
                                                labelColor: Colors.black54,
                                                indicatorSize: TabBarIndicatorSize.tab,
                                                indicatorColor: Colors.black54,
                                                onTap: (value){
                                                  setState((){
                                                    index = value;
                                                  });
                                                },
                                                tabs: [
                                                  Tab(
                                                      child: Text(
                                                          snapshot.data['role'] == 'artisan'
                                                              ? 'Catalogue(${model.getCatalogueCount == 0 ? 0 : model.getCatalogueCount})'
                                                              : 'Products(${model.getProductCount == 0 ? 0 : model.getProductCount})',
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600))),
                                                  Tab(
                                                      child: Text(
                                                          'Reviews(${snapshot.data['reviews']})',
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600))),
                                                ],
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(top:20),
                                              child: AnimatedCrossFade(
                                                duration: const Duration(milliseconds: 500),
                                                firstChild:  ListView(
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  children: [
                                                    Container(
                                                      child:  snapshot.data['role'] == 'artisan'
                                                          ? FutureBuilder(
                                                          future: cataloguePhotos,
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
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text('No images',
                                                                            style: TextStyle(
                                                                              // letterSpacing: 4,
                                                                                color:
                                                                                Color(0xFF333333),
                                                                                fontSize: 18,
                                                                                fontWeight:
                                                                                FontWeight.w600)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              } else {
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
                                                                                    'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['imageFileName']}',
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
                                                                            tag: snapshot
                                                                                .data[index]
                                                                            ['imageFileName'],
                                                                            child: Container(
                                                                                width: 200,
                                                                                child:
                                                                                Image.network(
                                                                                  'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['imageFileName']}',
                                                                                  fit: BoxFit.cover,
                                                                                )),
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
                                                                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),

                                                                          strokeWidth: 2,
                                                                          backgroundColor: Colors.white,
                                                                        )),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text('Loading',
                                                                          style: TextStyle(
                                                                            // letterSpacing: 4,
                                                                              color:
                                                                              Color(0xFF333333),
                                                                              fontSize: 18,
                                                                              fontWeight:
                                                                              FontWeight.w600)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                            return mainWidget;
                                                          })
                                                          : FutureBuilder(
                                                          future: products,
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
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text('No products',
                                                                            style: TextStyle(
                                                                              // letterSpacing: 4,
                                                                                color:
                                                                                Color(0xFF333333),
                                                                                fontSize: 18,
                                                                                fontWeight:
                                                                                FontWeight.w600)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              } else {
                                                                mainWidget = Container(
                                                                    margin: const EdgeInsets.only(
                                                                        bottom: 30.0,
                                                                        left: 8,
                                                                        right: 8),
                                                                    child: GridView.builder(
                                                                      gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount: 2,
                                                                        crossAxisSpacing: 5,
                                                                        mainAxisSpacing: 5,
                                                                      ),
                                                                      shrinkWrap: true,
                                                                      physics: ScrollPhysics(),
                                                                      itemCount: snapshot.data ==
                                                                          null
                                                                          ? 0
                                                                          : snapshot.data.length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                          int index) {
                                                                        return

                                                                          InkWell(
                                                                            onTap: (){
                                                                              var location = Provider.of<Utils>(context, listen: false);
                                                                              _viewProduct(location,data: snapshot.data[index], userdata: userdata);
                                                                            },
                                                                            child: Container(
                                                                              decoration:  BoxDecoration(
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
                                                                              child: GridTile(
                                                                                footer: Column(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    Container(
                                                                                      width: 150,
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Align(
                                                                                            alignment:
                                                                                            Alignment.center,
                                                                                            child: Padding(
                                                                                              padding:
                                                                                              const EdgeInsets.only(
                                                                                                  left: 8.0,
                                                                                                  right: 8.0, top:0),
                                                                                              child: Wrap(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    "${snapshot.data[index]['product_name']}"
                                                                                                        .capitalizeFirstOfEach,
                                                                                                    style: TextStyle(
                                                                                                        fontSize: 13,
                                                                                                        fontWeight:
                                                                                                        FontWeight
                                                                                                            .w500),
                                                                                                    textAlign: TextAlign.center,
                                                                                                    maxLines: 1,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),

                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Align(
                                                                                        alignment:
                                                                                        Alignment.center,
                                                                                        child: Padding(
                                                                                          padding:
                                                                                          const EdgeInsets
                                                                                              .only(
                                                                                              left: 0.0,
                                                                                              right: 0.0),
                                                                                          child: Wrap(
                                                                                            children: [
                                                                                              Container(
                                                                                                // width:140,
                                                                                                margin: const EdgeInsets.only(top:5.0),
                                                                                                child: Text(
                                                                                                    '\u{20A6}'+"${snapshot.data[index]['price']}",
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'Roboto',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    )),

                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )),
                                                                                    SizedBox(
                                                                                      height: 20,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                header:  Container(
                                                                                  decoration:  BoxDecoration(
                                                                                      color: Color(0xFFFFFFFF),
                                                                                      border: Border.all(
                                                                                          color: Color(0xFFF1F1FD)),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                            color:
                                                                                            Colors.black26,
                                                                                            blurRadius: 3.0,
                                                                                            offset:
                                                                                            Offset(0.3, 0.3))
                                                                                      ],
                                                                                      borderRadius:
                                                                                      BorderRadius.all(
                                                                                          Radius.circular(7))),
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Padding(
                                                                                          padding:
                                                                                          const EdgeInsets
                                                                                              .only(
                                                                                              bottom: 0.0),
                                                                                          child: Container(
                                                                                            height: 110,
                                                                                            width: 180,
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
                                                                                              'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['productImages'][0]['imageFileName']}',
                                                                                              fit: BoxFit.cover,
                                                                                            ),
                                                                                          )),

                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                child: Text(''),
                                                                              ),
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
                                                                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),

                                                                          strokeWidth: 2,
                                                                          backgroundColor: Colors.white,
                                                                        )),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text('Loading',
                                                                          style: TextStyle(
                                                                            // letterSpacing: 4,
                                                                              color:
                                                                              Color(0xFF333333),
                                                                              fontSize: 18,
                                                                              fontWeight:
                                                                              FontWeight.w600)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                            return mainWidget;
                                                          }),
                                                    ),

                                                  ],
                                                ),
                                                secondChild:  ListView(
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  children: [
                                                    StatefulBuilder(builder:
                                                        (BuildContext context, StateSetter setStates) {
                                                      return FutureBuilder(
                                                          future: network
                                                              .getArtisanReviews(widget.data.bidder_id),
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
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text('No reviews',
                                                                            style: TextStyle(
                                                                              // letterSpacing: 4,
                                                                                color: Color(0xFF333333),
                                                                                fontSize: 18,
                                                                                fontWeight:
                                                                                FontWeight.w600)),
                                                                      ),
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
                                                                                        style: GoogleFonts.poppins(
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
                                                                                        style: GoogleFonts.poppins(
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
                                                                                      ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                                                                      : 'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
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
                                                                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),

                                                                          strokeWidth: 2,
                                                                          backgroundColor: Colors.white,
                                                                        )),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text('Loading',
                                                                          style: TextStyle(
                                                                            // letterSpacing: 4,
                                                                              color: Color(0xFF333333),
                                                                              fontSize: 18,
                                                                              fontWeight:
                                                                              FontWeight.w600)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }

                                                            return mainWidget;
                                                          });
                                                    }),
                                                  ],
                                                ),
                                                crossFadeState: index==0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                              ),
                                            ),
                                          ],
                                        );}
                                  )
                                ],
                              ),
                            );
                        }
                      )
                      : Center(
                          child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            accentColor: Color(
                                                                0xFF9B049B)),
                                                    child:
                                                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                       strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                                    )),);
                }),
          );
        }),
      ),
    );
  }





  _viewProduct(location,{data, userdata}) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return  Scaffold(
            appBar:  PreferredSize(
              preferredSize: Size(double.infinity, 80),
              child: Container(
                height: 80,
                child: Stack(
                  children: [
                    AppBar(
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(top:40.0),
                          child: PopupMenuButton(
                            icon: Icon(FeatherIcons.moreHorizontal,
                                color: Colors.white),
                            onSelected: (value) {
                              var datas = Provider.of<Utils>(context, listen: false);
                              datas.makeOpenUrl(
                                  'https://www.google.com/maps?saddr=${location.locationLatitude},${location.locationLongitude}&daddr= ${data['latitude']}, ${data['longitude']}');
                            },
                            elevation: 0.1,
                            padding: EdgeInsets.all(0),
                            color: Color(0xFFF6F6F6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              PopupMenuItem(
                                height: 30,
                                value: "get direction",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      padding: const EdgeInsets.only(top:30.0),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white,),
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
                          for (dynamic item in data['productImages'])
                            Hero(
                              tag:  'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context,
                                          animation,
                                          secondaryAnimation) {
                                        return PhotoView(
                                          'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                                          'https://uploads.fixme.ng/originals/${item['imageFileName']}',
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
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 200,
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
                            "${data['product_name']}".capitalizeFirstOfEach,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Align(
                        alignment:Alignment.bottomLeft,
                        child: Text(
                          "Description:",
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                            "${data['description']}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Divider(),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'NGN ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "${data['price']}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Divider(),









                    Container(
                      padding: EdgeInsets.only( left:  80, right: 80),
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        onPressed: () {
                          var network = Provider.of<WebServices>(context, listen: false);
                          var datas = Provider.of<Utils>(context, listen: false);
                          FirebaseApi.addUserChat(
                            token2: datas.fcmToken ,
                            token: userdata['mobile_device_token'],
                            recieveruserId2: network.userId,
                            recieveruserId:  userdata['id'],
                            serviceId: userdata['service_id'],
                            serviceId2: network.serviceId,
                            urlAvatar2:
                            'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
                            name2: network.firstName,
                            idArtisan: network.mobileDeviceToken,
                            artisanMobile: network.phoneNum,
                            userMobile: userdata['full_number'],
                            idUser: userdata['firebase_id'],
                            urlAvatar:
                            'https://uploads.fixme.ng/thumbnails/${userdata['profile_pic_file_name']}',
                            name: userdata['user_first_name'],
                          );

                          FirebaseApi.clearJobBids(
                            widget.data.project_owner_user_id,
                          );

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) {
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
                                maxWidth: 200, minHeight: 36.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Get this Product",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),

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
                                userdata == 'no_picture_upload' ||
                                    userdata == null
                                    ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                    : 'https://uploads.fixme.ng/thumbnails/${userdata['profile_pic_file_name']}',
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
                                      child: Expanded(
                                        child: Text(
                                          '${userdata['firstName']} ${userdata['lastName']}'
                                              .capitalizeFirstOfEach,
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${userdata['serviceArea']}'
                                        .toUpperCase(),
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
                                      '${double.parse(userdata['user_rating'].toString())}',
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
                                      '(${userdata['reviews']} reviews)',
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
                      margin: EdgeInsets.only(left: 120, right :120, top:30,bottom: 30),
                      height: 35,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFFE9E9E9), width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed: () async {
                          Navigator.pop(context);
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
                            constraints: BoxConstraints(
                                maxWidth: 100, minHeight: 35.0),
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
                )
            ),
          );
        });
  }
}
