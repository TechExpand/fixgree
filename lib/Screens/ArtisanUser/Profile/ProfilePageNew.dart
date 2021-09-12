import 'dart:io';

import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/EditProfilePage.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:fl_toast/fl_toast.dart';
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
    _tabController.addListener(_handleTabSelection);
  }

  TabController _tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<dynamic> cataloguePhotos;
  Future<dynamic> products;

  getCataloguePhotos(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final artisanProvider =
        Provider.of<ArtisanProvider>(context, listen: false);
    cataloguePhotos = network.getServiceImage(network.userId, network.userId);
    cataloguePhotos.then((data) {
      int catalogueCount = data.length;
      artisanProvider.setCatalogueCount = catalogueCount;
    });
  }

  getProducts(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final artisanProvider =
        Provider.of<ArtisanProvider>(context, listen: false);
    products = network.getProductImage(network.userId, network.userId);
    products.then((data) {
      int productCount = data.length;
      artisanProvider.setProductCount = productCount;
    });
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ArtisanProvider>(
            create: (_) => ArtisanProvider(),
          ),
        ],
        builder: (context, _) {
          getCataloguePhotos(context);
          getProducts(context);
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF9B049B),
                leading: IconButton(
                  onPressed: () {
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
                  icon: Icon(FeatherIcons.arrowLeft, color: Colors.white),
                ),
                // actions: [
                //   IconButton(
                //     onPressed: () {},
                //     icon: Icon(FeatherIcons.moreHorizontal,
                //         color: Colors.white),
                //   ),
                // ],
                elevation: 3,
              ),
              body: WillPopScope(
                onWillPop: (){
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
                  return FutureBuilder(
                      future: network.getUserInfo(network.userId),
                      builder: (context, snapshot) {
                        Widget headWidget;
                        if (!snapshot.hasData) {
                          headWidget = Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Theme(
                                    data: Theme.of(context)
                                        .copyWith(accentColor: Color(0xFF9B049B)),
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                       strokeWidth: 2,
                                              backgroundColor: Colors.white,
     //valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
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
                        } else {
                          headWidget = CustomScrollView(
                            shrinkWrap: true,
                            slivers: [
                              SliverFillRemaining(
                                child: SingleChildScrollView(
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, right: 18, top: 18),
                                      child: Row(
                                        children: [
                                          Stack(children: <Widget>[
                                            CircleAvatar(
                                              child: Text(''),
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                network.profilePicFileName ==
                                                            'no_picture_upload' ||
                                                        network.profilePicFileName ==
                                                            null
                                                    ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                                    : 'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
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
                                                    color: Colors.green,
                                                    shape: BoxShape.circle),
                                                child: snapshot.data[
                                                            'identificationStatus'] ==
                                                        'un-verified'
                                                    ? SizedBox()
                                                    : Icon(
                                                        Icons.check,
                                                        size: 11,
                                                        color: Colors.white,
                                                      ),
                                              ),
                                            ),
                                          ]),

                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4),
                                                      child: Text(
                                                        '${snapshot.data['firstName']} ${snapshot.data['lastName']}'
                                                            .capitalizeFirstOfEach,
                                                        style: TextStyle(
                                                            color:
                                                                Color(0xFF333333),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),

                                                Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                      EdgeInsets.only(left: 5),
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                              Color(0xFFE9E9E9),
                                                              width: 1),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                      child: FlatButton(
                                                        disabledColor:
                                                        Color(0x909B049B),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context,
                                                                  animation,
                                                                  secondaryAnimation) {
                                                                return EditProfilePage();
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
                                                        color: Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                5)),
                                                        padding: EdgeInsets.all(0.0),
                                                        child: Ink(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                          child: Container(
                                                            constraints:
                                                            BoxConstraints(
                                                                maxWidth: 100,
                                                                minHeight: 35.0),
                                                            alignment:
                                                            Alignment.center,
                                                            child: Text(
                                                              "Edit profile",
                                                              textAlign:
                                                              TextAlign.center,
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black87,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                                            //  Text('${snapshot.data}'),
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
                                              // Text(
                                              //   widget.userData.userRole == 'artisan'
                                              //       ? 'Expertise Level: '
                                              //       : 'Store Rating: ',
                                              //   style: TextStyle(
                                              //       color: Color(0xFF333333),
                                              //       fontSize: 16,
                                              //       fontWeight: FontWeight.w600),
                                              // ),
                                              Text(
                                                '${double.parse(snapshot.data['user_rating'].toString())}',
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
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                '(${snapshot.data['reviews']} reviews)',
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
                                          // Align(
                                          //   alignment: Alignment.topLeft,
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     child: Container(
                                          //       height: 35,
                                          //       decoration: BoxDecoration(
                                          //           border: Border.all(
                                          //               color:
                                          //               Color(0xFFE9E9E9),
                                          //               width: 1),
                                          //           borderRadius:
                                          //           BorderRadius.circular(
                                          //               5)),
                                          //       child: FlatButton(
                                          //         disabledColor:
                                          //         Color(0x909B049B),
                                          //         onPressed: () {
                                          //           var role = network.role == 'artisan'? "business": "artisan";
                                          //
                                          //           network.changeAccRole(role, context).then((value){
                                          //             network.getUserInfo(network.userId);
                                          //             if(value == true){
                                          //               Navigator.pushReplacement(
                                          //                 context,
                                          //                 PageRouteBuilder(
                                          //                   pageBuilder:
                                          //                       (context, animation, secondaryAnimation) {
                                          //                     return ProfilePageNew();
                                          //                   },
                                          //                   transitionsBuilder:
                                          //                       (context, animation, secondaryAnimation, child) {
                                          //                     return FadeTransition(
                                          //                       opacity: animation,
                                          //                       child: child,
                                          //                     );
                                          //                   },
                                          //                 ),
                                          //               );
                                          //             }
                                          //           });
                                          //         },
                                          //         color: Colors.transparent,
                                          //         shape: RoundedRectangleBorder(
                                          //             borderRadius:
                                          //             BorderRadius.circular(
                                          //                 5)),
                                          //         padding: EdgeInsets.all(0.0),
                                          //         child: Ink(
                                          //           decoration: BoxDecoration(
                                          //               borderRadius:
                                          //               BorderRadius
                                          //                   .circular(5)),
                                          //           child: Container(
                                          //             constraints:
                                          //             BoxConstraints(
                                          //                 maxWidth:200,
                                          //                 minHeight: 35.0),
                                          //             alignment:
                                          //             Alignment.center,
                                          //             child: Text(
                                          //               network.role == 'artisan'? "Change to Product Seller":"Change to Service Provider",
                                          //               textAlign:
                                          //               TextAlign.center,
                                          //               style: TextStyle(
                                          //                   color:
                                          //                   Colors.black87,
                                          //                   fontWeight:
                                          //                   FontWeight
                                          //                       .w600),
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

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
                                                              color: Color(
                                                                  0xFF333333),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                    Wrap(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '${snapshot.data['bio']}',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF333333),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ],
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
                                                    'Business Name ${snapshot.data['role']}',
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xFF333333),
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                children: [
                                                  Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      '${snapshot.data['businessName']}',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF333333),
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          snapshot.data['subServices'].isEmpty|| snapshot.data['subServices'][0]
                                                          ['subservice'] ==
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
                                                                color: Color(
                                                                    0xFF333333),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Wrap(
                                                          spacing: 5,
                                                          alignment:
                                                              WrapAlignment.start,
                                                          children: [
                                                            for (dynamic subService
                                                                in snapshot.data[
                                                                    'subServices'])
                                                              Chip(
                                                                backgroundColor:
                                                                    Color(0xFF9B049B)
                                                                        .withOpacity(
                                                                            0.5),
                                                                label: Text(
                                                                  subService[
                                                                          'subservice']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          snapshot.data['businessAddress'] ==
                                                      null ||
                                                  snapshot.data[
                                                          'businessAddress'] ==
                                                      ''
                                              ? SizedBox()
                                              : Container(
                                                  child: Column(
                                                    children: [
                                                      Divider(),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Business Address',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF333333),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              '${snapshot.data['businessAddress'].toString().isEmpty ? snapshot.data['address'] : snapshot.data['businessAddress']}',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF333333),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
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
                                                width: 1,
                                                color: Color(0xFFEFEFEF)),
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xFFEFEFEF))),
                                      ),
                                      child: TabBar(
                                        controller: _tabController,
                                        unselectedLabelColor: Colors.black26,
                                        labelColor: Colors.black54,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicatorColor: Colors.black54,
                                        tabs: [
                                          Tab(
                                              child: Text(
                                                  snapshot.data['role'] ==
                                                          'artisan'
                                                      ? 'Catalogue(${model.getCatalogueCount == 0 ? 0 : model.getCatalogueCount})'
                                                      : 'Products(${model.getProductCount == 0 ? 0 : model.getProductCount})',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Tab(
                                              child: Text(
                                                  'Reviews(${snapshot.data['reviews']})',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: [
                                        //Catalogue Widget
                                        Container(
                                          child:
                                              snapshot.data['role'] == 'artisan'
                                                  ? FutureBuilder(
                                                      future: cataloguePhotos,
                                                      builder:
                                                          (context, snapshot) {
                                                        Widget mainWidget;
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot.data ==
                                                                  null ||
                                                              snapshot.data
                                                                      .length ==
                                                                  0) {
                                                            mainWidget = Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                      height: 80),
                                                                  Text(
                                                                      'No images',
                                                                      style: TextStyle(
                                                                          // letterSpacing: 4,
                                                                          color: Color(0xFF333333),
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.w600)),
                                                                ],
                                                              ),
                                                            );
                                                          } else {
                                                            mainWidget =
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom: 5,
                                                                        left: 5,
                                                                        right: 5,
                                                                        top: 5),
                                                                    child: GridView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          ScrollPhysics(),
                                                                      itemCount: snapshot.data ==
                                                                              null
                                                                          ? 0
                                                                          : snapshot
                                                                              .data
                                                                              .length,
                                                                      gridDelegate:
                                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount:
                                                                            3,
                                                                        crossAxisSpacing:
                                                                            5,
                                                                        mainAxisSpacing:
                                                                            5,
                                                                      ),
                                                                      itemBuilder:
                                                                          (BuildContext
                                                                                  context,
                                                                              int index) {
                                                                        return Stack(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap:
                                                                                  () {
                                                                                print(network.bearer);
                                                                                print(network.userId);
                                                                                Navigator.push(
                                                                                  context,
                                                                                  PageRouteBuilder(
                                                                                    pageBuilder: (context, animation, secondaryAnimation) {
                                                                                      return PhotoView(
                                                                                        'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                                                                                        snapshot.data[index]['imageFileName'],
                                                                                      );
                                                                                    },
                                                                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                                      return FadeTransition(
                                                                                        opacity: animation,
                                                                                        child: child,
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child:
                                                                                  Hero(
                                                                                tag: snapshot.data[index]['imageFileName'],
                                                                                child: Container(
                                                                                    width: 200,
                                                                                    child: Image.network(
                                                                                      'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['imageFileName']}',
                                                                                      fit: BoxFit.cover,
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              bottom:
                                                                                  0,
                                                                              right:
                                                                                  0,
                                                                              child:
                                                                                  InkWell(
                                                                                onTap: () async {
                                                                                  bool deleteStatus = await network.deleteServiceCatalogueImage(imageFileName: snapshot.data[index]['id']);
                                                                                  if (deleteStatus) {
                                                                                     await showTextToast(
                                                                            text: 'Photo deleted successful.',
                                                                              context: context,
                                                                                             );
                                                                                
                                                                                    setState(() {});
                                                                                  } else{
                                                                                     await showTextToast(
                                                                            text: 'Photo delete failed.',
                                                                              context: context,
                                                                                             );
                                                                                  
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(6),
                                                                                  color: Color(0xFF333333).withOpacity(0.8),
                                                                                  child: Icon(
                                                                                    FeatherIcons.trash2,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ));
                                                          }
                                                        } else {
                                                          mainWidget = Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 80),
                                                                Theme(
                                                                    data: Theme.of(
                                                                            context)
                                                                        .copyWith(
                                                                            accentColor: Color(
                                                                                0xFF9B049B)),
                                                                    child:
                                                                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                                           strokeWidth: 2,
                                              backgroundColor: Colors.white,
    // valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
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
                                                        }
                                                        return mainWidget;
                                                      })
                                                  : FutureBuilder(
                                                      future: products,
                                                      builder:
                                                          (context, snapshot) {
                                                        Widget mainWidget;
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot.data ==
                                                                  null ||
                                                              snapshot.data
                                                                      .length ==
                                                                  0) {
                                                            mainWidget = Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                      height: 80),
                                                                  Text(
                                                                      'No products',
                                                                      style: TextStyle(
                                                                          // letterSpacing: 4,
                                                                          color: Color(0xFF333333),
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.w600)),
                                                                ],
                                                              ),
                                                            );
                                                          } else {
                                                            mainWidget =
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            30.0,
                                                                        left: 8,
                                                                        right: 8),
                                                                    child: ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          ScrollPhysics(),
                                                                      itemCount: snapshot.data ==
                                                                              null
                                                                          ? 0
                                                                          : snapshot
                                                                              .data
                                                                              .length,
                                                                      itemBuilder:
                                                                          (BuildContext
                                                                                  context,
                                                                              int index) {
                                                                        return ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              Container(
                                                                            child: ListTile(
                                                                                onTap: () {
                                                                                  _viewProduct(data: snapshot.data[index]);
                                                                                },
                                                                                contentPadding: const EdgeInsets.only(left: 0),
                                                                                leading: CircleAvatar(
                                                                                  child: Text(''),
                                                                                  radius: 40,
                                                                                  backgroundImage: NetworkImage(
                                                                                    snapshot.data[index]['productImages'].isNotEmpty?'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['productImages'][0]['imageFileName']}':"",
                                                                                  ),
                                                                                  foregroundColor: Colors.white,
                                                                                  backgroundColor: Colors.white,
                                                                                ),
                                                                                title: Text("${snapshot.data[index]['product_name']}", style: TextStyle(color: Colors.black)),
                                                                                subtitle: RichText(
                                                                                  text: TextSpan(
                                                                                    text: '\u{20A6} ',
                                                                                    style: TextStyle(fontFamily: 'Roboto', color: Colors.black, fontWeight: FontWeight.bold),
                                                                                    children: <TextSpan>[
                                                                                      TextSpan(text: "${snapshot.data[index]['price']}", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                trailing: IconButton(
                                                                                  onPressed: () async {
                                                                                    bool deleteStatus = await network.deleteCatalogueProducts(productId: snapshot.data[index]['sn']);
                                                                                    if (deleteStatus) {
                                                                                       await showTextToast(
                                                                            text: 'Product deleted successful.',
                                                                              context: context,
                                                                                             );
                                                                                    
                                                                                      setState(() {});
                                                                                    } else{
                                                                                       await showTextToast(
                                                                            text: 'Product delete failed.',
                                                                              context: context,
                                                                                             );
                                                                                    
                                                                                    }
                                                                                  },
                                                                                  icon: Icon(FeatherIcons.trash2),
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
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 80),
                                                                Theme(
                                                                    data: Theme.of(
                                                                            context)
                                                                        .copyWith(
                                                                            accentColor: Color(
                                                                                0xFF9B049B)),
                                                                    child:
                                                                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                                           strokeWidth: 2,
                                              backgroundColor: Colors.white,
  //   valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
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
                                                        }
                                                        return mainWidget;
                                                      }),
                                        ),
                                        //Comments Widget
                                        StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setStates) {
                                          return FutureBuilder(
                                              future: network.getArtisanReviews(
                                                  network.userId),
                                              builder: (context, snapshot) {
                                                Widget mainWidget;
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.data == null) {
                                                    mainWidget = Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(height: 80),
                                                          Theme(
                                                              data: Theme.of(
                                                                      context)
                                                                  .copyWith(
                                                                      accentColor:
                                                                          Color(
                                                                              0xFF9B049B)),
                                                              child:
                                                                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
   //  valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
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
                                                    mainWidget = Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: ListView.separated(
                                                          separatorBuilder:
                                                              (BuildContext
                                                                          context,
                                                                      int
                                                                          index) =>
                                                                  Divider(),
                                                          shrinkWrap: true,
                                                          itemCount: snapshot
                                                              .data.length,
                                                          physics:
                                                              ScrollPhysics(),
                                                          itemBuilder:
                                                              (context, index) {
                                                            DateTime
                                                                dateOfReview =
                                                                DateTime.parse(snapshot
                                                                    .data[index][
                                                                        'dateAdded']
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
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Text(
                                                                            '${snapshot.data[index]['reviewer']['user_first_name'].toString()} ${snapshot.data[index]['reviewer']['user_last_name'].toString()}',
                                                                            style: GoogleFonts.poppins(
                                                                                fontSize: 17,
                                                                                fontWeight: FontWeight.w600)),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Text(
                                                                            '${snapshot.data[index]['review'].toString()}',
                                                                            style: GoogleFonts.poppins(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                ListTile(
                                                                  leading:
                                                                      CircleAvatar(
                                                                    child:
                                                                        Text(''),
                                                                    radius: 22,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                      network.profilePicFileName ==
                                                                                  'no_picture_upload' ||
                                                                              network.profilePicFileName ==
                                                                                  null
                                                                          ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                                                          : 'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['reviewer']['profile_pic_file_name'].toString()}',
                                                                    ),
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  title: Text(
                                                                      '${DateFormat('MMM dd, y').format(dateOfReview)}',
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                  subtitle:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                    child:
                                                                        StarRating(
                                                                      rating: double
                                                                          .parse(
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
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 80),
                                                        Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                                    accentColor:
                                                                        Color(
                                                                            0xFF9B049B)),
                                                            child:
                                                                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                                   strokeWidth: 2,
                                              backgroundColor: Colors.white,
    // valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text('Loading',
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
                                                }

                                                // return mainWidget;
                                                return mainWidget;
                                              });
                                        }),
                                      ][_tabController.index],
                                    ),



                                    Container(
                                      padding: EdgeInsets.only(bottom: 20),
                                      width: 200,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5)),
                                      child: FlatButton(
                                        onPressed: snapshot.data['role'] == 'artisan'
                                            ? () {
                                          _AddCatalogue();
                                        }
                                            : () {
                                          _AddProduct();
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
                                              snapshot.data['role'] == 'artisan'? "Add Catalog":'Add Product',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),



                                  ]),
                                ),
                              ),
                            ],
                          );
                        }
                        return headWidget;
                      });
                }),
              ));
        });
  }









  void _AddProduct() {
    DataProvider datas = Provider.of<DataProvider>(context, listen: false);
    Utils data = Provider.of<Utils>(context, listen: false);
    final _controller = TextEditingController();
    final _controller1 = TextEditingController();
    final _controller2 = TextEditingController();
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new StatefulBuilder(builder: (context, setStat) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.19),
                      Text(
                        "Product Name",
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: TextFormField(
                          onFieldSubmitted: (v){
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          controller: _controller,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Product Name',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Product Price",
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: TextFormField(
                          onFieldSubmitted: (v){
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          controller: _controller1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Product Price',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Product Description",
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: TextFormField(
                          onFieldSubmitted: (v){
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          controller: _controller2,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Product Description',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: 100, // card height
                          child: data.selectedImage2 == null
                              ? Text('No Image Selected')
                              : Container(
                            width: 100,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(26)),
                            child: FlatButton(
                              disabledColor: Color(0xFF9B049B),
                              onPressed: () {
                                data
                                    .selectimage2(source: ImageSource.gallery)
                                    .then((value) {
                                  setStat(() {
                                    print('done');
                                  }
                                  );
                                });
                              },
                              color: Color(0xFF9B049B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                      MediaQuery.of(context).size.width / 1.3,
                                      minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Select/Upload Product Photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
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
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Cancel",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () async{
                              Navigator.pop(context);
                          network.addProductCatalog(
                                context: context,
                                bio: _controller2.text.toString(),
                                productName: _controller.text.toString(),
                                price: _controller1.text.toString(),
                                path: data.selectedImage2.path,
                              ).then((value) {
                            if (value == true) {
                               showTextToast(
                                  text: 'Product Added successful.',
                                  context: context,
                              );

                              setState(() {});
                            } else{
                               showTextToast(
                                  text: 'Product fail to Add.',
                                  context: context,
                              );
                            }

                          });




                            },
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])
                    ],
                  ));
            }),
          );
        });
  }















  void _AddCatalogue() {
    DataProvider datas = Provider.of<DataProvider>(context, listen: false);
    Utils data = Provider.of<Utils>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new StatefulBuilder(builder: (context, setStat) {
              return Container(
                  height: 300,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: 100, // card height
                          child: data.selectedImage2 == null
                              ? Text('No Image Selected')
                              : Container(
                            width: 100,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(26)),
                            child: FlatButton(
                              disabledColor: Color(0xFF9B049B),
                              onPressed: () {
                                data
                                    .selectimage2(source: ImageSource.gallery)
                                    .then((value) {
                                  setStat(() {});
                                });
                              },
                              color: Color(0xFF9B049B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                      MediaQuery.of(context).size.width / 1.3,
                                      minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Select/Upload Service Photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
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
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Cancel",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () {
                              Navigator.pop(context);
                              network.addCatalog(
                                context,
                                path: data.selectedImage2.path,
                                uploadType: 'servicePicture',
                              ).then((value) {
                                if (value == true) {
                                  showTextToast(
                                    text: 'Service Photo Added successful.',
                                    context: context,
                                  );

                                  setState(() {});
                                } else{
                                  showTextToast(
                                    text: 'Service Photo fail to Add.',
                                    context: context,
                                  );
                                }
                              });
                            },
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])
                    ],
                  ));
            }),
          );
        });
  }













  _viewProduct({data}) {
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: 300.0,
            padding: EdgeInsets.only(
              top: 10,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                Container(
                  color: Color(0xFFF0F0F0),
                  child: Row(
                    children: [
                      for (dynamic item in data['productImages'])
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.all(8),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  data['productImages'].isNotEmpty?
                                  'https://uploads.fixme.ng/thumbnails/${item['imageFileName']}':'',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () async {
                                    bool deleteStatus = await network
                                        .deleteCatalogueProductImage(
                                            productImageId: data['id']);
                                    if (deleteStatus) {
                                       await showTextToast(
                                                                            text: 'Photo deleted successful.',
                                                                              context: context,
                                                                                             );
                                     
                                      setState(() {});
                                    } else{
                                       await showTextToast(
                                                                            text: 'Photo delete failed.',
                                                                              context: context,
                                                                                             );
                                     
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    color: Color(0xFF333333).withOpacity(0.8),
                                    child: Icon(
                                      FeatherIcons.trash2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                    Text(
                      "Product name",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${data['product_name']}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Product amount",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        text: '\u{20A6} ',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: "${data['price']}",
                              style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
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
                                      "Select/Upload Service Photo",
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
