import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chat.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:transparent_image/transparent_image.dart';
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

class _ArtisanPageNewState extends State<ArtisanPageNew> with SingleTickerProviderStateMixin{
  var first;
  int index = 0 ;





  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: ScaffoldState());
    address();
  }

  TabController _tabController;

  address() async {
    final coordinates =
        new Coordinates(widget.userData.user.latitude, widget.userData.user.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      first = addresses.first;
    });
  }

  Future<dynamic> cataloguePhotos;
  Future<dynamic> products;

  getCataloguePhotos(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final artisanProvider =
        Provider.of<ArtisanProvider>(context, listen: false);
    cataloguePhotos =
        network.getServiceImage(network.userId, widget.userData.user.id);
    cataloguePhotos.then((data) {
      int catalogueCount = data.length;
      artisanProvider.setCatalogueCount = catalogueCount;
    });
  }

  getProducts(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final artisanProvider =
        Provider.of<ArtisanProvider>(context, listen: false);
    products = network.getProductImage(network.userId, widget.userData.user.id);
    products.then((data) {
      int productCount = data.length;
      artisanProvider.setProductCount = productCount;
    });
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
          getCataloguePhotos(context);
          getProducts(context);
          return Scaffold(
            backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Color(0xFF9B049B),
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(FeatherIcons.arrowLeft, color: Colors.white),
                ),
                actions: [
                  PopupMenuButton(
                    icon: Icon(FeatherIcons.moreHorizontal,
                        color: Colors.white),
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
                  )
                ],
                elevation: 3,
              ),
              body: Consumer<ArtisanProvider>(builder: (context, model, _) {
                return DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
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
                                  widget.userData.user.urlAvatar == 'no_picture_upload' ||
                                      widget.userData.user.urlAvatar == null
                                      ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                      : 'https://uploads.fixme.ng/thumbnails/${widget.userData.user.urlAvatar}',
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,
                              ),
                              Positioned(
                                left: 78,
                                top: 10,
                                child: Container(
                                  height: 17,
                                  width: 17,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF0FB800),
                                      shape: BoxShape.circle),
                                  child: widget.userData.user.verification ==
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
                                          '${widget.userData.user.name} ${widget.userData.user.userLastName}'
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
                                          '${widget.userData.user.serviceArea}'
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
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Color(0xFF9B049B),
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          '${first == null ? '${widget.userData.user.userAddress}' : first.addressLine}',
                                          softWrap: true,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),


                                  Row(
                                    children: [
                                      Text(
                                        '${double.parse(widget.userData.user.userRating.toString())}',
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
                                        '(${this.widget.userData.user.reviews} reviews)',
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
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 18, right: 18, top: 18),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),

                            widget.userData.user.bio == null ||
                                    widget.userData.user.bio == ''
                                ? SizedBox()
                                : Column(
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 400),
                                        child: Column(
                                          children: [
                                            Divider(),

                                            Row(
                                              children: [
                                                Text(
                                                  'About',
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
                                                    '${widget.userData.user.bio == null ? '' : widget.userData.user.bio}',
                                                    style: TextStyle(
                                                        color: Color(0xFF333333),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height:10),

                                            Row(
                                              children: [
                                                Text(
                                                  'Business Address',
                                                  style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            Wrap(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '${widget.userData.user.businessAddress.toString().isEmpty || widget.userData.user.businessAddress == null ? widget.userData.user.userAddress : widget.userData.user.businessAddress}',
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

                                    ],
                                  ),
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              child: model.getExpandedStatus
                                  ? Column(children: [
                                      widget.userData.user.subServices == null ||
                                              widget.userData.user.subServices.isEmpty
                                          ? SizedBox()
                                          : AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              child: Column(
                                                children: [
                                                  SizedBox(height:10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Sub-Services',
                                                        style: TextStyle(
                                                            color:
                                                                Color(0xFF333333),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600),
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
                                                            in widget.userData.user
                                                                .subServices)
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

                                    ])
                                  : SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 18, right: 18, top: 5),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: FlatButton(
                                onPressed: () {
                                  FirebaseApi.addUserChat(
                                    token2: data.fcmToken ,
                              token: widget.userData.user.fcmToken,
                              recieveruserId2: network.userId,
                               recieveruserId:  widget.userData.user.id,
                               serviceId: widget.userData.user.serviceId,
                              serviceId2: network.serviceId,
                                    urlAvatar2:
                                        'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
                                    name2: network.firstName,
                                    idArtisan: network.mobileDeviceToken,
                                    artisanMobile: network.phoneNum,
                                    userMobile: widget.userData.userMobile,
                                    idUser: widget.userData.idUser,
                                    urlAvatar:
                                        'https://uploads.fixme.ng/thumbnails/${widget.userData.user.urlAvatar}',
                                    name: widget.userData.user.name,
                                  );

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return ChatPage(user: widget.userData.user);
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
                                onPressed: () async {
                                  await UrlLauncher.launch(
                                      "tel://${widget.userData.user.fullNumber}");
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
                                      borderRadius: BorderRadius.circular(5)),
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
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
                                          widget.userData.user.userRole == 'artisan'
                                              ? 'Catalogue(${model.getCatalogueCount == 0 ? 0 : model.getCatalogueCount})'
                                              : 'Products(${model.getProductCount == 0 ? 0 : model.getProductCount})',
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))),
                                  Tab(
                                      child: Text(
                                          'Reviews(${this.widget.userData.user.reviews})',
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
                                      child: widget.userData.user.userRole == 'artisan'
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
                                                                  _viewProduct(
                                                                      location,
                                                                      data: snapshot
                                                                          .data[
                                                                      index]);
                                                            },
                                                            child: Container(
                                                              // height: 100,
                                                              decoration: BoxDecoration(
                                                                  color: Colors.transparent,
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(18))
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(18)),
                                                                child: Card(
                                                                  child: GridTile(
                                                                    child: FadeInImage.memoryNetwork(
                                                                      placeholder: kTransparentImage,
                                                                      image: 'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['productImages'][0]['imageFileName']}',fit: BoxFit.cover,),
                                                                    footer: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.black38,
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(3.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Text( "${snapshot.data[index]['product_name']}".capitalizeFirstOfEach,
                                                                              style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.bold),
                                                                              maxLines: 2,
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            Text('\u{20A6}'+"${snapshot.data[index]['price']}", style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontFamily: 'Roboto',
                                                                                fontSize: 17,
                                                                                fontWeight: FontWeight.bold),
                                                                              maxLines: 1,
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
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
                                                  .getArtisanReviews(widget.userData.user.id),
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
                                                                          : 'https://uploads.fixme.ng/thumbnails/${snapshot.data[index]['reviewer']['profile_pic_file_name'].toString()}',
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
                                                                  onTap: (){
                                                                    print(snapshot.data[index]);
                                                                  },
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
              }));
        });
  }

  _viewProduct(location,{data}) {
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
                                        'https://www.google.com/maps?saddr=${location.locationLatitude},${location.locationLongitude}&daddr= ${widget.userData.user.latitude}, ${widget.userData.user.longitude}');
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
                                tag: 'https://uploads.fixme.ng/originals/${item['imageFileName']}',
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
                                    height: 300,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
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
                                  token: widget.userData.user.fcmToken,
                                  recieveruserId2: network.userId,
                                   recieveruserId:  widget.userData.user.id,
                                   serviceId: widget.userData.user.serviceId,
                                  serviceId2: network.serviceId,
                                  urlAvatar2:
                                  'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
                                  name2: network.firstName,
                                  idArtisan: network.mobileDeviceToken,
                                  artisanMobile: network.phoneNum,
                                  userMobile: widget.userData.user.userMobile,
                                  idUser: widget.userData.user.idUser,
                                  urlAvatar:
                                  'https://uploads.fixme.ng/thumbnails/${widget.userData.user.urlAvatar}',
                                  name: widget.userData.user.name,
                                );
                                network.sendSms(product_name:data['product_name'], price: data['price'] ,phone:widget.userData.user.userMobile.toString(),context: context);
                                network.sendRoboco(product_name:data['product_name'], price: data['price'] ,phone:widget.userData.user.userMobile.toString(),context: context);
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return ChatPage(user: widget.userData.user, productData: data, productSend: 'send', instantChat: '',);
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
                                  widget.userData.urlAvatar == 'no_picture_upload' ||
                                      widget.userData.urlAvatar == null
                                      ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                      : 'https://uploads.fixme.ng/thumbnails/${widget.userData.urlAvatar}',
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
                                        widget.userData.user.businessName==null||widget.userData.user.businessName.toString()==''?'${widget.userData.user.name} ${widget.userData.user.userLastName}':widget.userData.user.businessName.toString()
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
                                      '${widget.userData.user.serviceArea}'
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
                                        '${double.parse(widget.userData.user.userRating.toString())}',
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
                                        '(${this.widget.userData.user.reviews} reviews)',
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
