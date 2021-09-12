import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/GeneralUsers/Bids/Bidders.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

class BidPage extends StatefulWidget {
  @override
  _BidPageState createState() => _BidPageState();
}

class _BidPageState extends State<BidPage> {
  List<Bidify> notify;
  PageController myPage =
  PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var conData = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream:
                    FirebaseApi.userBidStream(network.userId.toString()),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        notify = snapshot.data.docs
                            .map((doc) => Bidify.fromMap(doc.data(), doc.id))
                            .toList();

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
      return Center(child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            accentColor: Color(
                                                                0xFF9B049B)),
                                                    child:
                                                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                       strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                                    )),);
                          default:
                            if (snapshot.hasError) {
                              return buildText(
                                  'Something Went Wrong Try later');
                            } else {
                              final users = notify;
                              if (users.isEmpty) {
                                return buildText('No Notification Found');
                              } else
                                return Stack(
                                  children: [
                                    Container(
                                      child: PageView.builder(
                                        controller: myPage,
                                        itemBuilder: (context, index) {
                                          return Material(
                                            color: Colors.white,
                                            elevation: 1,
                                            child: users[index].bidder_name==''?Center(
                                              child: Container(
                                                margin: EdgeInsets.only(top: 180),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text('COMPLETED TASK AND PAYMENT REQUEST',   style: TextStyle(
                                                          color: Colors
                                                              .black, fontWeight: FontWeight.bold)),
                                                    ),
                                                    Text('${ users[index]
                                                    .message}',   style: TextStyle(
                                                        color: Colors
                                                            .black), textAlign: TextAlign.center,),
                                                    InkWell(
                                                      onTap: () {
                                                        // dialog

                                                        showDialog(
                                                          barrierDismissible:
                                                          false,
                                                          context:
                                                          context,
                                                          builder: (context) =>
                                                              dialog(users[index],users[index].id),
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                            width: 180,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.black),
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            ),
                                                            alignment:
                                                            Alignment
                                                                .center,
                                                            child: Text(
                                                                'CONFIRM COMPLETION',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold))),
                                                      ),
                                                    ),



                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: InkWell(
                                                        onTap: () {

                                                          // dialog

                                                          showDialog(
                                                            barrierDismissible:
                                                            false,
                                                            context:
                                                            context,
                                                            builder: (context) =>
                                                                dialogReject(users[index],users[index].id),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Container(
                                                              width: 180,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.black),
                                                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              ),
                                                              alignment:
                                                              Alignment
                                                                  .center,
                                                              child: Text(
                                                                  'REJECT COMPLETION',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold))),
                                                        ),
                                                      ),
                                                    ),




                                                    users[index].bidder_name==''?Container(): InkWell(
                                                        onTap: () {
                                                         // dialog
                                                          conData.setSelectedBottomNavBar(1);
                                                          FirebaseApi
                                                              .clearJobBids(
                                                            users[index]
                                                                .project_owner_user_id,
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.black),
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            ),
                                                              alignment:
                                                              Alignment
                                                                  .center,
                                                              child: Text(
                                                                  'CANCEL ALL',
                                                                  style: TextStyle(
                                                                      fontStyle:
                                                                      FontStyle.italic))),
                                                        ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ):

                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.7,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                      '${users[index].bidder_name} ',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                          Colors.black)),
                                                                  TextSpan(
                                                                    text:
                                                                    'Accepted Your Project',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ]),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation) {
                                                                    return BidderPage(
                                                                        users[
                                                                        index]); //SignUpAddress();
                                                                  },
                                                                  transitionsBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation,
                                                                      child) {
                                                                    return FadeTransition(
                                                                      opacity:
                                                                      animation,
                                                                      child:
                                                                      child,
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  top: 15,
                                                                  bottom:
                                                                  12),
                                                              width: 105,
                                                              height: 28,
                                                              child: Center(
                                                                  child: Text(
                                                                      'VIEW PROFILE',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          13,
                                                                          color: Color(
                                                                              0xFFA40C85),
                                                                          fontWeight:
                                                                          FontWeight.w500))),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Color(
                                                                          0xFFA40C85)),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      4)),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              conData.setSelectedBottomNavBar(1);
                                                              FirebaseApi
                                                                  .clearJobBids(
                                                                users[index]
                                                                    .project_owner_user_id,
                                                              );
                                                            },
                                                            child: Container(
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                    'CANCEL ALL',
                                                                    style: TextStyle(
                                                                        fontStyle:
                                                                        FontStyle.italic))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                          );

//
                                        },
                                        itemCount: users.length,
                                      ),
                                    ),
                                   Column(
                                    children: users.map((user){
                                         return  user.bidder_name==''?Container():Container(
                                             alignment: Alignment.center,
                                             margin: EdgeInsets.only(
                                                 top: MediaQuery.of(context)
                                                     .size
                                                     .height /
                                                     1.2),
                                             child: Text('Slide Through To See All',
                                                 style: TextStyle(
                                                     fontStyle: FontStyle.italic)));
                                       }).toList()
                                   ),


                                    Container(
                                      margin: const EdgeInsets.only(top:40.0),
                                      child: Align(
                                        alignment:Alignment.topCenter,
                                        child: Image.asset(
                                          "assets/images/accept.gif",
                                          height: 250,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                            }
                        }
                      } else {
                        return Center(child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),);
                      }
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }






  dialogReject(index, docid) {
    var conData = Provider.of<DataProvider>(context, listen: false);
    WebServices network = Provider.of<WebServices>(context, listen: false);
    final _commentController = TextEditingController();
    return AlertDialog(
        content: Container(
          width: 250,
          height: 100,
          child: ListView(
            children: [
              TextField(
                controller: _commentController,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Comment',
                ),
              ),
             TextButton(onPressed: (){
               Navigator.pop(context);
               conData.setSelectedBottomNavBar(1);
               FirebaseApi.clearSingleJobBids(docid);
               FirebaseApi.updateNotificationBid(index.bid_id, 'bid_completed', 'reject');
             }, child: Text('Submit'))
            ],
          ),
        ),
        title: Text('Reason For Rejection'),
       );
  }






  dialog(index, docid) {
    var conData = Provider.of<DataProvider>(context, listen: false);
    WebServices network = Provider.of<WebServices>(context, listen: false);
    return RatingDialog(
      title: 'RATE THIS SERVICE',
      message:
      'Tap a star to set your rating. Write review on this service(optional).',
      image: Container(
          width: 120,
          height: 120,
          child: Image.asset('assets/images/fixme.png')),
      submitButton: 'Submit',
      onSubmitted: (response) {
       FirebaseApi.updateNotificationBid(index.bid_id, 'bid_completed', 'confirm');
        network.confirmPaymentAndReview(
          rating: response.rating,
          jobid: index.job_id,
          comment: response.comment,
          artisanId: index.bidder_id,
          userId: network.userId,
          bidid: index.bid_id,
          serviceId: index.service_id,
          context: context,
        ).then((value) {
          FirebaseApi.updateNotificationBid(index.bid_id, 'bid_completed', 'confirm');
          conData.setSelectedBottomNavBar(1);
          FirebaseApi.clearSingleJobBids(docid);
        });
          });

  }

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 15, color: Colors.black),
    ),
  );
}
