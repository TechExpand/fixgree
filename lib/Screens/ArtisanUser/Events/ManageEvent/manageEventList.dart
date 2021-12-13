import 'dart:io';

import 'package:fixme/Model/Event.dart';
import 'package:fixme/Screens/ArtisanUser/Events/AddEvent/EventUpload.dart';
import 'package:fixme/Screens/ArtisanUser/Events/AddEvent/steptwoEvent.dart';
import 'package:fixme/Screens/ArtisanUser/Events/ManageEvent/ManageEvent.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageEventList extends StatefulWidget {
  @override
  _ManageEventListState createState() => _ManageEventListState();
}

class _ManageEventListState extends State<ManageEventList> {
  var publicKey = 'pk_live_624bc595811d2051eead2a9baae6fe3f77f7746f';
  final plugin = PaystackPlugin();

  initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
    eventPur();
  }

  eventPur()async{
    var network = Provider.of<WebServices>(context, listen: false);
    SharedPreferences eventPurchases = await SharedPreferences.getInstance();
    network.eventPurchaseList =  eventPurchases.get('eventPurchases')==null?'l':eventPurchases.get('eventPurchases');
  }

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          'Event Manager',
          style: TextStyle(color: Color(0xFF9B049B)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Color(0xFF9B049B),
          ),
          onPressed: () {
            Navigator.push(
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
        ),
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          Navigator.push(
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
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 52,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 10, left: 4, right: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7)),
                        child: FlatButton(
                          onPressed: () {},
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
                              child: Text(
                                'All Uploaded Events',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                   network.premium=='active'? Container(
                      padding: EdgeInsets.only(top: 8, bottom: 10, right: 4),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(7)),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return EventPhotoPage();
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
                                Text(
                                  'Upload Event    ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Icon(
                                  Icons.cloud_upload,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ):Container()
                  ],
                ),
              ),

              FutureBuilder(
                  future: network.getUploadedEvent(context),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Theme(
                                      data: Theme.of(context).copyWith(
                                          //accentColor: Color(0xFF9B049B)
                                          ),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFF9B049B)),
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
                            ? Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: snapshot.data.length > 10
                                      ? 10
                                      : snapshot.data.length,
                                  itemBuilder: (context, index) {
                                   List<Event> myEvents = snapshot.data.reversed.toList();
                                    return Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: InkWell(
                                        onTap: () {
                                          _viewProduct(
                                              myEvents[index].user,
                                              data: myEvents[index]);
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 8),
                                                      padding: EdgeInsets.only(
                                                          right: 4, left: 4),
                                                      height: 110,
                                                      width: 120,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                            'https://uploads.fixme.ng/thumbnails/' +
                                                                myEvents[index]
                                                                    .eventImages[
                                                                        0][
                                                                        'imageFileName']
                                                                    .toString(),
                                                            fit: BoxFit.cover,
                                                          ))),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Text(
                                                        myEvents[index]
                                                            .eventName,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Text(
                                                          'Sold: ${myEvents[index].eventTicket.length}'),
                                                    ),
                                                    Text(myEvents[index]
                                                        .eventStartDate),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 4,
                                                          bottom: 10,
                                                          right: 4),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7)),
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          int eventID = 0;
                                                          for (var value
                                                              in myEvents[index]
                                                                  .eventTicket) {
                                                            eventID = value['event_id'];
                                                          }
                                                          Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context,
                                                                  animation,
                                                                  secondaryAnimation) {
                                                                return

                                                                  ManageEvents(
                                                                    id: eventID,
                                                                   eventData: myEvents[index],
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
                                                        color:
                                                            Color(0xFF9B049B),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7)),
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: Ink(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7)),
                                                          child: Container(
                                                            constraints: BoxConstraints(
                                                                maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2.2,
                                                                minHeight:
                                                                    35.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Manage Event',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : snapshot.data.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.28,
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                'No Event Uploaded',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          26)),
                                              child: FlatButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder:
                                                          (context, animation, secondaryAnimation) {
                                                        return EventPhotoPage();
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            26)),
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              26)),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.3,
                                                        minHeight: 45.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "upload your first event",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : Container();
                  }),
            ],
          ),
        ),
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
                                return ArtisanPageNew(userData);
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

    // paymentMethod(context, amount, email) async {
    //   Charge charge = Charge()
    //     ..amount = amount
    //     ..reference = _getReference()
    //     ..email = email;
    //   CheckoutResponse response = await plugin.checkout(
    //     context,
    //     logo: Image.asset(
    //       'assets/images/fixme.png',
    //       scale: 5,
    //     ),
    //     method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
    //     charge: charge,
    //   );
    //   if (response.status) {
    //     network.validatePayment(response.reference);
    //     Utils().storeData('paymentToken', 'active');
    //     print(response.reference);
    //   }
    // }

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
