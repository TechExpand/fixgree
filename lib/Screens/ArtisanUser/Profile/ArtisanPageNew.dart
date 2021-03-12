import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chat.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ArtisanPageNew extends StatefulWidget {
  final userData;
  ArtisanPageNew([this.userData]);
  @override
  _ArtisanPageNewState createState() => _ArtisanPageNewState();
}

class _ArtisanPageNewState extends State<ArtisanPageNew> {
  var first;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: ScaffoldState());
    address();
  }

  TabController _tabController;

  address() async {
    final coordinates =
        new Coordinates(widget.userData.longitude, widget.userData.latitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      first = addresses.first;
    });
  }

  Future<void> executeAfterBuild(ArtisanProvider model, int count) async {
    setState(() {});
    // model.setCatalogueCount = count == null ? 0 : count;
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen: false);
    var location = Provider.of<LocationService>(context);
    var network = Provider.of<WebServices>(context, listen: false);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ArtisanProvider>(
            create: (_) => ArtisanProvider(),
          ),
        ],
        builder: (context, _) {
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
                  PopupMenuButton(
                    icon: Icon(FeatherIcons.moreHorizontal,
                        color: Color(0xFF9B049B)),
                    onSelected: (value) {
                      data.makeOpenUrl(
                          'https://www.google.com/maps?saddr=${location.locationLatitude},${location.locationLongitude}&daddr= ${widget.userData.latitude}, ${widget.userData.longitude}');
                    },
                    elevation: 0.1,
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
                                style: GoogleFonts.openSans(
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
                  )
                ],
                elevation: 0,
              ),
              body: Column(
                children: [
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
                              widget.userData == 'no_picture_upload' ||
                                      widget.userData == null
                                  ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                  : 'https://uploads.fixme.ng/originals/${widget.userData.urlAvatar}',
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
                                      '${widget.userData.name} ${widget.userData.userLastName}'
                                          .capitalizeFirstOfEach,
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      '${first == null ? '${widget.userData.userAddress}' : first.addressLine}',
                                      softWrap: true,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18, right: 18, top: 18),
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${widget.userData.serviceArea}'.toUpperCase(),
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
                                  widget.userData.userRating.toString()),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),

                        widget.userData.bio == null || widget.userData.bio == ''
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
                                          '${widget.userData.bio == null ? '' : widget.userData.bio}',
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
                        widget.userData.subServices == null ||
                                widget.userData.subServices.isEmpty
                            ? SizedBox()
                            : AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: !data.isExpanded1 ? 60 : 0,
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
                                            '${widget.userData.subServices.isEmpty ? '' : widget.userData.subServices[0]['subservice']}',
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
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: !data.isExpanded1 ? 75 : 0,
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
                                      '${widget.userData.businessAddress.toString().isEmpty || widget.userData.businessAddress == null ? widget.userData.userAddress : widget.userData.businessAddress}',
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 5),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            onPressed: () {
                              FirebaseApi.addUserChat(
                                urlAvatar2:
                                    'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                                name2: network.firstName,
                                idArtisan: network.mobileDeviceToken,
                                artisanMobile: network.phoneNum,
                                userMobile: widget.userData.userMobile,
                                idUser: widget.userData.idUser,
                                urlAvatar:
                                    'https://uploads.fixme.ng/originals/${widget.userData.urlAvatar}',
                                name: widget.userData.name,
                              );

                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return ChatPage(user: widget.userData);
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
                            onPressed: () {
                              UrlLauncher.launch(
                                  "tel://${widget.userData.fullNumber}");
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
                            onPressed: data.isExpanded1
                                ? () {
                                    setState(() {
                                      data.onExpansionChanged1(false);
                                    });
                                  }
                                : () {
                                    setState(() {
                                      data.onExpansionChanged1(true);
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
                                  constraints: BoxConstraints(minHeight: 35.0),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    !data.isExpanded1
                                        ? FeatherIcons.chevronUp
                                        : FeatherIcons.chevronDown,
                                    size: 15,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Color(0xFFEFEFEF)),
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFEFEFEF))),
                    ),
                    child: Consumer<ArtisanProvider>(
                        builder: (context, model, widget) {
                      return TabBar(
                        controller: _tabController,
                        unselectedLabelColor: Colors.black26,
                        labelColor: Colors.black54,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.black54,
                        tabs: [
                          Tab(
                              child: Text(
                                  'Catalogue(${model.getCatalogueCount == 0 ? 0 : model.getCatalogueCount})',
                                  style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                          Tab(
                              child: Text(
                                  'Reviews(${model.getCommentsCount == 0 ? 0 : model.getCommentsCount})',
                                  style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                        ],
                      );
                    }),
                  ),
                  Expanded(
                    child:
                        Consumer<ArtisanProvider>(builder: (context, model, _) {
                      return Container(
                        width: double.infinity,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            //Catalogue Widget
                            Container(
                              child: widget.userData.userRole == 'artisan'
                                  ? FutureBuilder(
                                      future: network.getServiceImage(
                                          network.userId, widget.userData.id),
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
                                            if (mounted) {
                                              executeAfterBuild(
                                                  model, snapshot.data.length);
                                            }
                                            // WidgetsBinding.instance
                                            //     .addPostFrameCallback((_) {

                                            // });
                                            // Future.delayed(Duration.zero,
                                            //     () async {

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
                                                              'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
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
                                          network.userId, widget.userData.id),
                                      builder: (context, snapshot) {
                                        print('The data ${snapshot.data}');
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.data == null) {
                                          } else {
                                            model.setCatalogueCount =
                                                snapshot.data == null
                                                    ? 0
                                                    : snapshot.data.length;
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
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    child: ListTile(
                                                      title: Text(
                                                          "${snapshot.data[index]['product_name']}"
                                                              .capitalizeFirstOfEach,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      subtitle: Text(
                                                          "#${snapshot.data[index]['price']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
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
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setStates) {
                              return FutureBuilder(
                                  future: network
                                      .getArtisanReviews(widget.userData.id),
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
                                                      color: Color(0xFF333333),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                        );
                                      } else {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          model.setCommentsCount =
                                              snapshot.data == null
                                                  ? 0
                                                  : snapshot.data.length;
                                        });

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
                      );
                    }),
                  )
                ],
              ));
        });
  }
}
