
import 'dart:convert';

import 'package:fixme/Screens/ArtisanUser/Events/AddEvent/EventUpload.dart';
import 'package:fixme/Screens/ArtisanUser/Events/EditEvent/editEvent.dart';
import 'package:fixme/Screens/ArtisanUser/Events/ManageEvent/Scan.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'manageEventRole.dart';

class ManageEvents extends StatefulWidget {
  int id;
  var eventData;
  ManageEvents({this.id, this.eventData});
  @override
  _ManageEventsState createState() => _ManageEventsState();
}

class _ManageEventsState extends State<ManageEvents> {

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
              icon: Icon(FeatherIcons.moreHorizontal,
                  color: Color(0xFF9B049B),),
              onSelected: (value) {

              },
              elevation: 1,
              padding: EdgeInsets.all(0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  height: 30,
                  value: "Delete event",
                  child:  Text("Delete event",
                      style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 16,
                          height: 1.4,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )
        ],
        backgroundColor: Colors.white,
        title: Text('Manage Event', style: TextStyle(color: Color(0xFF9B049B)),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace, color: Color(0xFF9B049B),),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            // Text(userDetail.toString(), style: TextStyle(color: Colors.black),),
            widget.eventData.managerRole=='sales_manager'?Container():Center(
              child: Container(
                padding: EdgeInsets.only(top: 24, bottom: 10,right: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7)),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return  Scan();
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
                          minHeight: 43.0),
                      alignment: Alignment.center,
                      child:  Text('Scan QR code for entry',
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
            SizedBox(height: 12,),
            Divider(thickness: 1,),
            widget.eventData.managerRole=='crowd_control'||
                widget.eventData.managerRole=='sales_manager'?Container():   Padding(
              padding: const EdgeInsets.only(top:15.0, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 47,
                    padding: EdgeInsets.only(top: 8, bottom: 10,right: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF9B049B), width: 1.5),
                        borderRadius: BorderRadius.circular(7)),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return  EditEventPage(widget.eventData);
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Edit Event',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF9B049B),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              Icon(FeatherIcons.edit3, color: Color(0xFF9B049B))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  widget.eventData.managerRole=='event_manager'?Container():Container(
                    height: 47,
                    padding: EdgeInsets.only(top: 8, bottom: 10,right: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF9B049B), width: 1.5),
                        borderRadius: BorderRadius.circular(7)),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return  ManageEventRole(widget.eventData);
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Add Managers',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF9B049B),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              Icon(Icons.add_circle, color: Color(0xFF9B049B))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1,),
        widget.eventData.managerRole=='crowd_control'?Container():Center(
              child: Expanded(
                child: Container(
                  height: 280,
                  width: MediaQuery.of(context).size.width*0.9,
                  margin: EdgeInsets.only(top: 8,bottom: 10,),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF9B049B), width: 1.5),
                      borderRadius: BorderRadius.circular(8.4)),
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width*0.95,
                          height: 33,
                          decoration: BoxDecoration(
                            color: Color(0xFF9B049B),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(7) ,
                                  topLeft: Radius.circular(7))),
                          child: Center(child: Text('Ticket Sales',
                            style: TextStyle(color: Colors.white),))
                      ),
                     Expanded(
                       child: Padding(
                         padding: const EdgeInsets.only(top:4.0),
                         child: Scrollbar(
                           child: FutureBuilder(
                             future: network.eventPurchase(eventID: widget.id),
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
                                               //accentColor: Color(0xFF9B049B)
                                             ),
                                             child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                               strokeWidth: 2,
                                               backgroundColor: Colors.white,
                                             )),
                                         SizedBox(
                                           height: 10,
                                         ),
                                         Text('Loading Tickets',
                                             style: TextStyle(
                                                 color: Color(0xFF333333),
                                                 fontWeight: FontWeight.w500)),
                                       ],
                                     ),
                                   ))
                                   : snapshot.hasData && !snapshot.data.isEmpty
                                   ?ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index){
                                       DateTime date = DateTime.parse(snapshot.data[index]['date_purchased']);
                                    return Column(
                                      children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text("${date.day.toString()}/${date.month.toString()}/${date.year.toString()}"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 35.0),
                                              child: Text("${snapshot.data[index]['purchase_user_info']['user_last_name']} ${snapshot.data[index]['purchase_user_info']['user_first_name']}"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Text(snapshot.data[index]['ticket_category']),
                                            ),                                ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        )
                                      ],
                                    );
                                  })
                                   :snapshot.data.isEmpty
                                   ? Padding(
                                 padding: const EdgeInsets.all(18.0),
                                 child: Container(
                                   color: Colors.white,
                                   padding: const EdgeInsets.all(4),
                                   child: Text(
                                     'No Ticket Sales',
                                     style: TextStyle(
                                         color: Colors.black87,
                                         fontWeight: FontWeight.w500),
                                   ),
                                 ),
                               )
                                   : Container();
                             }
                           ),
                         ),
                       ),
                     ),
                    ],
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
