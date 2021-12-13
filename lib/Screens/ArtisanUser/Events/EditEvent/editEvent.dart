import 'dart:io';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fixme/DummyData.dart';
import 'package:fixme/Model/service.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:fixme/Screens/ArtisanUser/Events/EditEvent/editEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditEventPage extends StatefulWidget {
  var data;
  EditEventPage(this.data);
  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  List<Services> result = [];
  Future<dynamic> eventinfo;
  Future<dynamic> managerInfo;
  XFile selectedImage;
  String  selectedCountry = '';




  updateManager(BuildContext context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    setState(() {
      managerInfo = network.getEventManagers(
          context,
          eventId,
          'owner'
      );
    });
  }



  var _currentSelectedValue = 'Admin';
  var _currencies = [
    "Admin",
    "Event Manager",
    "Sales Manager",
    "Crowd Controller",
  ];


  update(BuildContext context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    setState(() {
      eventinfo = network.getEnvetInfo(eventId);
    });
  }

  void pickImageAdd({@required ImageSource source, context}) async {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    final picker = ImagePicker();
    var image = await picker.pickImage(source: source);
    setState(() => selectedImage = image);

    String imageName = await network.uploadUpdateCoverImage(
      path: selectedImage.path,
      eventName: widget.data.eventName,
      eventId: eventId,
      status: 'cover',
    );
    update(context);
  }


  void pickImage({@required ImageSource source, context}) async {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    final picker = ImagePicker();
    var image = await picker.pickImage(source: source);
    setState(() => selectedImage = image);

    String imageName = await network.uploadUpdateCoverImage(
      path: selectedImage.path,
      eventName: widget.data.eventName,
      eventId: eventId,
      status: 'not_cover',
    );
    update(context);
  }
int eventId = 0;

  @override
  void initState() {
    super.initState();
    for(var value in widget.data.eventTicket){
      eventId = value['event_id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    LgaProvider state =  Provider.of<LgaProvider>(context, listen: false);

    results = state.allLgaList;
    updateManager(context);
    update(context);
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9B049B),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(() {
              setState(() {});
            });
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Colors.white),
        ),
        title: Text('Edit Event',
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600)),
        elevation: 3,
      ),
      body: FutureBuilder(
          future: eventinfo,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView(children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 18, right: 18, top: 18),
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      child: Stack(children: <Widget>[
                        Builder(
                          builder: (context) {
                            for(var result in snapshot.data.eventImages){
                              return CircleAvatar(
                                child: Text(''),
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  network.profilePicFileName ==
                                      'no_picture_upload' ||
                                      network.profilePicFileName == null
                                      ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                      : 'https://uploads.fixme.ng/thumbnails/${result['imageFileName']}',
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,
                              );
                            }
                          }
                        ),
                        Positioned(
                          left: 55,
                          top: 50,
                          child: InkWell(
                            onTap: () async {
                              pickImage(
                                  source: ImageSource.gallery,
                                  context: context);
                            },
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  color: Color(0xFFA40C85),
                                  shape: BoxShape.circle),
                              child: Icon(
                                FeatherIcons.camera,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.only(left: 25, right: 25, top: 25),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Edit Event Info',
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width / 1.5,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    '${snapshot.data.eventName}',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                _eventInfo(snapshot.data.eventName, snapshot.data.eventDescription);
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFFA40C85),
                                    ),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  FeatherIcons.edit3,
                                  size: 14,
                                  color: Color(0xFFA40C85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Text(
                                'Description',
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width / 1.5,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    '${snapshot.data.eventDescription}',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),

                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Edit Event Location',
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text(
                                      'Country',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 1.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          '${snapshot.data.eventCountry}',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      _eventLocation(snapshot.data.eventCountry,snapshot.data.eventState , snapshot.data.eventCity );
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Color(0xFFA40C85),
                                          ),
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        FeatherIcons.edit3,
                                        size: 14,
                                        color: Color(0xFFA40C85),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text(
                                      'State',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 1.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          '${snapshot.data.eventState}',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),

                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text(
                                      'City',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 1.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          '${snapshot.data.eventCity}',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Edit Venuue/Duration',
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.5,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(top: 10),
                                    child: Text('${snapshot.data.venueAddress}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  _editVenue(
                                      snapshot.data.venueAddress,
                                      snapshot.data.eventDuration,
                                      snapshot.data.eventName);
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xFFA40C85),
                                      ),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    FeatherIcons.edit3,
                                    size: 14,
                                    color: Color(0xFFA40C85),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.5,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(top: 10),
                                    child: Text('${snapshot.data.eventDuration} Days',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                             Text('')
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Edit Event Tiemline',
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Start Time',
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.5,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${snapshot.data.eventStartTime}',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  _editEventTimeline(
                                      snapshot.data.eventStartTime,
                                      snapshot.data.eventEndTime,
                                      snapshot.data.eventStartDate,
                                      snapshot.data.eventEndDate);

                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xFFA40C85),
                                      ),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    FeatherIcons.edit3,
                                    size: 14,
                                    color: Color(0xFFA40C85),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  'End Time',
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.5,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${snapshot.data.eventEndTime}',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text('')
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  'Start Date',
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.5,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${snapshot.data.eventStartDate}',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text('')
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  'End Date',
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    1.5,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${snapshot.data.eventEndDate}',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text('')
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Event Tickets',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _AddTicket();
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xFFA40C85),
                                ),
                                shape: BoxShape.circle),
                            child: Icon(
                              FeatherIcons.plus,
                              size: 16,
                              color: Color(0xFFA40C85),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        List<Map> data = [];
                        for(var value in snapshot.data.eventTicket){
                          data.add(value);
                        }
                        return Container(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 30.0,
                                    left: 8,
                                    right: 8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: data == null
                                      ? 0
                                      : data.length,
                                  itemBuilder:
                                      (BuildContext context,
                                      int index) {
                                    return ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                          10),
                                      child: Container(
                                        child: ListTile(
                                          trailing: Container(
                                            height: 32,
                                            width: 32,
                                            margin:
                                            const EdgeInsets
                                                .only(
                                                top: 10),
                                            decoration:
                                            BoxDecoration(
                                                border: Border
                                                    .all(
                                                  width: 1,
                                                  color: Color(
                                                      0xFFA40C85),
                                                ),
                                                shape: BoxShape
                                                    .circle),
                                            child: IconButton(
                                                onPressed: () {
                                                  _editTicketInfo(
                                                      data[index]['id'],
                                                      data[index]['ticket_category'],
                                                      data[index]['ticket_price'],
                                                  );
                                                },
                                                icon: Icon(
                                                  FeatherIcons
                                                      .edit3,
                                                  size: 14,
                                                  color: Color(
                                                      0xFFA40C85),
                                                )),
                                          ),
                                          contentPadding:
                                          const EdgeInsets
                                              .only(left: 0),

                                          title: Text(
                                              "${data[index]['ticket_category']}"
                                                  .capitalizeFirstOfEach,
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
                                                    "${data[index]['ticket_price']}",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors
                                                            .green,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                        );
                      }
                    ),
                    Divider(),
                    widget.data.managerRole =='owner'||widget.data.managerRole=='admin'?Align(
                    alignment: Alignment.bottomLeft,
                      child: Text('Event Managers',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ):Container(),
                    widget.data.managerRole =='owner'||widget.data.managerRole=='admin'?  Builder(
                        builder: (context) {
                          return FutureBuilder(
                            future: managerInfo,
                            builder: (context, snapshot) {
                              return  snapshot.hasData
                                  ?Container(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 30.0,
                                        left: 8,
                                        right: 8),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: data == null
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
                                              leading: Container(
                                                height: 32,
                                                width: 32,
                                                margin:
                                                const EdgeInsets
                                                    .only(
                                                    top: 10),
                                                decoration:
                                                BoxDecoration(
                                                    border: Border
                                                        .all(
                                                      width: 1,
                                                      color: Color(
                                                          0xFFA40C85),
                                                    ),
                                                    shape: BoxShape
                                                        .circle),
                                                child: IconButton(
                                                    onPressed: () async{
                                                    await  network.deleteManager(
                                                         snapshot.data[index]['userInfo']['id'],
                                                          // snapshot.data[index]['user_role']
                                                      widget.data.managerRole.toString(),
                                                      );

                                                        Future.delayed(Duration(seconds: 4), (){
                                                      setState((){
                                                        update(context);
                                                      });
                                                    });

                                                    },
                                                    icon: Icon(
                                                      FeatherIcons
                                                          .trash,
                                                      size: 14,
                                                      color: Color(
                                                          0xFFA40C85),
                                                    )),
                                              ),
                                              trailing: Container(
                                                height: 32,
                                                width: 32,
                                                margin:
                                                const EdgeInsets
                                                    .only(
                                                    top: 10),
                                                decoration:
                                                BoxDecoration(
                                                    border: Border
                                                        .all(
                                                      width: 1,
                                                      color: Color(
                                                          0xFFA40C85),
                                                    ),
                                                    shape: BoxShape
                                                        .circle),
                                                child: IconButton(
                                                    onPressed: () {
                                                      // network.getEventManagers(
                                                      //     context,
                                                      //     eventId,
                                                      //     widget.data.managerRole,
                                                      // );
                                                      _editManger(
                                                        eventId,
                                                        eventId,
                                                        eventId,
                                                      );
                                                    },
                                                    icon: Icon(
                                                      FeatherIcons
                                                          .edit3,
                                                      size: 14,
                                                      color: Color(
                                                          0xFFA40C85),
                                                    )),
                                              ),
                                              contentPadding:
                                              const EdgeInsets
                                                  .only(left: 0),

                                              title: Text(
           "${snapshot.data[index]['userInfo']['user_last_name']
                                                      .toString()} ${snapshot.data[index]['userInfo']['user_first_name']
                                                  .toString()}",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black)),
                                              subtitle: RichText(
                                                text: TextSpan(
                                                  text: '',
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
                                                        "${snapshot.data[index]['user_role']}",
                                                        style: GoogleFonts.poppins(
                                                            color: Colors
                                                                .green,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                              ):Center(
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
                          );
                        }
                    ):Container(),
                  ],
                ),
              ),
            ])
                : Center(
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
          }),
    );
  }




  _editManger(id, cat, price) {
    final _controller = TextEditingController();
    final _controller2 = TextEditingController();
    _controller.text = price.toString();
    _controller2.text = cat;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
                height: 220.0,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.transparent,
                child: ListView(
                  children: [
                    Text(
                      "Edit Role",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    SizedBox(
                      height: 7,
                    ),

                    Container(
                      height: 55,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    enabledBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.3,color: Color(0xFF9B049B)),
                                        borderRadius: BorderRadius.circular(12.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.3,color: Color(0xFF9B049B)),
                                        borderRadius: BorderRadius.circular(12.0)),
                                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.3,color: Color(0xFF9B049B)),
                                        borderRadius: BorderRadius.circular(12.0))),
                                isEmpty: _currentSelectedValue == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _currentSelectedValue,
                                    iconEnabledColor: Color(0xFF9B049B),
                                    iconDisabledColor: Color(0xFF9B049B),
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _currentSelectedValue = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: _currencies.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold),),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      ),
                    ),

                      SizedBox(
                        width: 20,
                      ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 34,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
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
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          disabledColor: Color(0x909B049B),
                          onPressed: () async {
                            await network.updateEventTicket(
                              eventID: eventId,
                              ticketPrice: _controller.text,
                              ticketCat: _controller2.text,
                              ticketId: id,
                            );

                            Future.delayed(Duration(seconds: 4), (){
                              setState((){
                                update(context);
                              });
                            });

                            Navigator.pop(context);
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
                                textAlign: TextAlign.
                                center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])
                    ])
                ),
          );
        });
  }




  _editTicketInfo(id, cat, price) {
    final _controller = TextEditingController();
    final _controller2 = TextEditingController();
    _controller.text = price.toString();
    _controller2.text = cat;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
                height: 220.0,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.transparent,
                child: ListView(
                  children: [
                    Text(
                      "Edit fullname",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          border: Border.all(color: Color(0xFFF1F1FD)),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: TextField(
                        controller: _controller2,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Event Category',
                          hintStyle:
                          TextStyle(fontSize: 16, color: Colors.black38),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          border: Border.all(color: Color(0xFFF1F1FD)),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        decoration: InputDecoration.collapsed(
                          hintText: 'Ticket Price',
                          hintStyle:
                          TextStyle(fontSize: 16, color: Colors.black38),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 34,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
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
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          disabledColor: Color(0x909B049B),
                          onPressed: () async {
                            await network.updateEventTicket(
                            eventID: eventId,
                            ticketPrice: _controller.text,
                            ticketCat: _controller2.text,
                            ticketId: id,
                            );

                               Future.delayed(Duration(seconds: 4), (){
                              setState((){
                                update(context);
                              });
                            });

                            Navigator.pop(context);
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
                )),
          );
        });
  }




  void _eventInfo(name, description) {
    final _controller = TextEditingController();
    _controller.text = name;
    final _controlle2r = TextEditingController();
    _controlle2r.text = description;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
              ),
                height: 260.0,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: ListView(
                  children: [
                    Text(
                      "Edit Event Info",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          border: Border.all(color: Color(0xFFF1F1FD)),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Event Name',
                          hintStyle:
                          TextStyle(fontSize: 16, color: Colors.black38),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          border: Border.all(color: Color(0xFFF1F1FD)),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: TextField(
                        controller: _controlle2r,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Event Description',
                          hintStyle:
                          TextStyle(fontSize: 16, color: Colors.black38),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 34,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
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
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          disabledColor: Color(0x909B049B),
                          onPressed: () async {
                            await network.updateEventInfo(
                                _controller.text,
                              eventId,
                              _controlle2r.text,
                            );
                              Future.delayed(Duration(seconds: 4), (){
                            setState((){
                              update(context);
                            });
                          });


                            Navigator.pop(context);
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
                )),
          );
        });
  }







  void _eventLocation(country, select_state, select_city) {
    LgaProvider state =  Provider.of<LgaProvider>(context, listen: false);
    final city = TextEditingController();
    city.text = select_city;
    selectedCountry = country;
    // state.seletedinfo.name = select_state;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setStates){
              return AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    height: 360.0,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: ListView(
                      children: [
                        Text(
                          "Edit Event Location",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0, left: 8),
                          child: Text(
                            'Country',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              border: Border.all(color: Color(0xFFF1F1FD)),
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                            child: TextButton(
                              onPressed: (){
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: false, // optional. Shows phone code before the country name.
                                  onSelect: (Country country) {
                                    setStates(() {
                                      selectedCountry = country.name;
                                    });
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(" ${selectedCountry==''?'Country ':selectedCountry}". toUpperCase(), style: TextStyle(color: Colors.black38))),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child:Icon(Icons.arrow_drop_down, color:  Color(0xFF9B049B),))
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 7,
                        ),


                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0, left: 8),
                          child: Text(
                            'State',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              border: Border.all(color: Color(0xFFF1F1FD)),
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                            child: TextButton(
                              onPressed: (){
                                bankDialog(context, setStates);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(" ${state.seletedinfo==null?'State ':state.seletedinfo.name}". toUpperCase(), style: TextStyle(color: Colors.black38))),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child:Icon(Icons.arrow_drop_down, color:  Color(0xFF9B049B),))
                                ],
                              ),
                            ),
                        ),
                        SizedBox(
                          height: 7,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0, left: 8),
                          child: Text(
                            'City',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
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
                              controller: city,
                              decoration: InputDecoration.collapsed(
                                hintText: 'City',
                                hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black38),
                              ),
                            ),
                          ),

                        SizedBox(
                          height: 7,
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Container(
                            height: 34,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFE9E9E9), width: 1),
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
                                border: Border.all(
                                    color: Color(0xFFE9E9E9), width: 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: FlatButton(
                              disabledColor: Color(0x909B049B),
                              onPressed: () async {
                                await network.updateEventLocation(
                                  selectedCountry,
                                  eventId,
                                  state.seletedinfo.name,
                                  city.text
                                );
                                     Future.delayed(Duration(seconds: 4), (){
                                  setState((){
                                    update(context);
                                  });
                                });
                                Navigator.pop(context);
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
                    )),
              );
            }
          );
        });
  }








  _editVenue(venue, duration, name) {
    final _controller = TextEditingController();
    final _controller2 = TextEditingController();
    _controller.text = venue;
    _controller2.text = duration.toString();
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
                height: 250.0,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.transparent,
                child: ListView(
                  children: [
                    Text(
                      "Edit Venue",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
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
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Venue',
                          hintStyle:
                          TextStyle(fontSize: 16, color: Colors.black38),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              border: Border.all(color: Color(0xFFF1F1FD)),
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                          child: TextField(
                            controller: _controller2,
                            textCapitalization:
                            TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            autocorrect: true,
                            enableSuggestions: true,
                            maxLines: null,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Duration',
                              hintStyle:
                              TextStyle(fontSize: 16, color: Colors.black38),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            child: Center(
                              child: Text('days'),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(7),
                                  bottomRight: Radius.circular(7),
                                ),

                            ),
                            width: 70,
                            height: 47.4,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 34,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
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
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          disabledColor: Color(0x909B049B),
                          onPressed: () async {
                          await  network.updateEventVenue(
                              venue: _controller.text,
                              duration: _controller2.text,
                              name: name,
                              eventID: eventId,

                            );
                               Future.delayed(Duration(seconds: 4), (){
                              setState((){
                                update(context);
                              });
                            });
                            Navigator.pop(context);
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
                )),
          );
        });
  }

  void _AddTicket() {
    DataProvider datas = Provider.of<DataProvider>(context, listen: false);
    Utils data = Provider.of<Utils>(context, listen: false);
    final _controller = TextEditingController();
    final _controller1 = TextEditingController();
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
                height: 320,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      Text(
                        "Ticket Category",
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
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Product Category',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Ticket Price",
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
                        child: TextField(
                          controller: _controller1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Ticket Price',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
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
                            onPressed: ()async {

                          await    network
                                  .uploadEventCategory(
                              eventId: eventId,
                                ticketCat: _controller.text,
                                ticketPrice: _controller1.text,
                                context: context,
                              );
                              Future.delayed(Duration(seconds: 4), (){
                                setState((){
                                  update(context);
                                });
                              });
                              Navigator.pop(context);
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




  void _editEventTimeline(startTime, endTime, startDate, endDate) {
    var datas = Provider.of<Utils>(context, listen: false);
    DataProvider data = Provider.of<DataProvider>(context, listen: false);
    final _controller = TextEditingController();
    final _controller1 = TextEditingController();
    final _controller2 = TextEditingController();
    final _controller3 = TextEditingController();
    _controller.text = startTime;
    _controller1.text = endTime;
    _controller2.text = startDate;
    _controller3.text = endDate;
    var network = Provider.of<WebServices>(context, listen: false);


    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: new StatefulBuilder(builder: (context, setStat) {
                  return Container(
                    height: 460,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      color: Colors.transparent,
                      child: ListView(
                        children: [
                          Text(
                            "Start Time",
                            style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: (){
                              BottomPicker.time(
                                  title:  "Set Start Time",
                                  titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                                  onSubmit: (index) {
                                    setState(() {
                                      var time = DateTime.parse(index.toString());
                                      _controller.text = datas.formatTime(time).toString() ;
                                    });

                                  },
                                  onClose: () {
                                    print("Picker closed");
                                  },
                                  use24hFormat:  false)
                                  .show(context);

                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  border: Border.all(color: Color(0xFFF1F1FD)),
                                  borderRadius: BorderRadius.all(Radius.circular(7))),
                              child: TextField(
                                controller: _controller,
                                enabled: false,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Start Time',
                                  hintStyle:
                                  TextStyle(fontSize: 16, color: Colors.black38),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "End Time",
                            style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  border: Border.all(color: Color(0xFFF1F1FD)),
                                  borderRadius: BorderRadius.all(Radius.circular(7))),
                              child: TextField(
                                enabled: false,
                                controller: _controller1,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'End Time',
                                  hintStyle:
                                  TextStyle(fontSize: 16, color: Colors.black38),
                                ),
                              ),
                            ),
                            onTap: (){
                              BottomPicker.time(
                                  title:  "Set End Time",
                                  titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                                  onSubmit: (index) {
                                    setState(() {
                                      var time = DateTime.parse(index.toString());
                                      _controller1.text = datas.formatTime(time).toString() ;
                                    });

                                  },
                                  onClose: () {
                                    print("Picker closed");
                                  },
                                  use24hFormat:  false)
                                  .show(context);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Start Date",
                            style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  border: Border.all(color: Color(0xFFF1F1FD)),
                                  borderRadius: BorderRadius.all(Radius.circular(7))),
                              child: TextField(
                                enabled: false,
                                controller: _controller2,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Start Date',
                                  hintStyle:
                                  TextStyle(fontSize: 16, color: Colors.black38),
                                ),
                              ),
                            ),
                            onTap: (){
                              BottomPicker.date(
                                title:  "Set Start Date",
                                titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                                onSubmit: (index) {
                                  setState(() {
                                    var time = DateTime.parse(index.toString());
                                    _controller2.text = datas.formatYear2(time).toString() ;
                                  });

                                },
                                onClose: (){
                                  print("Picker closed");
                                },
                              )
                                  .show(context);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "End Date",
                            style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  border: Border.all(color: Color(0xFFF1F1FD)),
                                  borderRadius: BorderRadius.all(Radius.circular(7))),
                              child: TextField(
                                enabled: false,
                                controller: _controller3,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'End Date',
                                  hintStyle:
                                  TextStyle(fontSize: 16, color: Colors.black38),
                                ),
                              ),
                            ),
                            onTap: (){
                              BottomPicker.date(
                                title:  "Set End Date",
                                titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                                onSubmit: (index) {
                                  setState(() {
                                    var time = DateTime.parse(index.toString());
                                    _controller3.text = datas.formatYear2(time).toString() ;
                                  });

                                },
                                onClose: (){
                                  print("Picker closed");
                                },
                              )
                                  .show(context);
                            },
                          ),
                          SizedBox(
                            height: 10,
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
                               await   network
                                      .updateEventTimeline(
                                   eventID: eventId,
                                    startDay: _controller2.text,
                                    startTime: _controller.text,
                                    endDay: _controller3.text,
                                    endTime:_controller1.text,
                                  );
                                    Future.delayed(Duration(seconds: 4), (){
                                    setState((){
                                      update(context);
                                    });
                                  });
                                  Navigator.pop(context);
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
            }
          );
        });
  }







  List<StateInfo> results = [];

  void searchLga(userInputValue) {
    LgaProvider postRequestProvider =
    Provider.of<LgaProvider>(context, listen: false);
    results = postRequestProvider.allLgaList
        .where((lga) => lga.name.toString()
        .toLowerCase()
        .contains(userInputValue.toLowerCase()))
        .toList();
  }


  bankDialog(ctx, set) {
    LgaProvider postRequestProvider =
    Provider.of<LgaProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {


              return AlertDialog(
                title: TextFormField(
                  onChanged: (value) {
                    setStates(() {
                      searchLga(value);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Search State',
                    labelStyle: TextStyle(color: Colors.black),
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                  ),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 500,
                          child: ListView.builder(
                            itemCount:  results.length,
                            itemBuilder: (context, index) {
                              results.sort((a, b) {
                                var ad = a.name;
                                var bd = b.name;
                                var s = ad.compareTo(bd);
                                return s;
                              });

                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  postRequestProvider.changeSelectedLGA(results[index]);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFF270F33)
                                        .withOpacity(0.6),
                                    child: Text(
                                        results[index]
                                            .name.toString()
                                            .substring(0, 2),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  title: Text('${results[index].name}',  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).then((v) {
      set(() {});
    });
  }


  dialogPage(ctx) {
    PostRequestProvider postRequestProvider =
    Provider.of<PostRequestProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return AlertDialog(
                title: TextFormField(
                  onChanged: (value) {
                    setStates(() {
                      searchServices(value);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Search Services',
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                  ),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 500,
                          child: ListView.builder(
                            itemCount: result == null ? 0 : result.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  postRequestProvider
                                      .changeSelectedService(result[index]);
                                },
                                child: ListTile(
                                  title: Text('${result[index].service}'),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  _viewProduct({data}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
              height: 335.0,
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
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      'https://uploads.fixme.ng/thumbnails/${item['imageFileName']}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("${data['description']}", style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
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
            ),
          );
        });
  }

  void searchServices(userInputValue) {
    PostRequestProvider postRequestProvider =
    Provider.of<PostRequestProvider>(context, listen: false);
    result = postRequestProvider.allservicesList
        .where((service) => service.service
        .toLowerCase()
        .contains(userInputValue.toLowerCase()))
        .toList();
  }
}
