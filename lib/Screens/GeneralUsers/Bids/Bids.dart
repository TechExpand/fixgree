import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/GeneralUsers/Bids/Bidders.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/Rejection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BidPage extends StatefulWidget {
  @override
  _BidPageState createState() => _BidPageState();
}

class _BidPageState extends State<BidPage> {
  var publicKey = 'pk_live_624bc595811d2051eead2a9baae6fe3f77f7746f';
  final plugin = PaystackPlugin();
  initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  List<Bidify> notify;
  PageController myPage =
  PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var conData = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      body: WillPopScope(
        onWillPop: (){

        },
        child: SingleChildScrollView(
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
                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (context, animation, secondaryAnimation) {
                                                                  return RejectionList(users[index],users[index].id); //SignUpAddress();
                                                                },
                                                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                  return FadeTransition(
                                                                    opacity: animation,
                                                                    child: child,
                                                                  );
                                                                },
                                                              ),

                                                            );



                                                            // showDialog(
                                                            //   barrierDismissible:
                                                            //   false,
                                                            //   context:
                                                            //   context,
                                                            //   builder: (context) =>
                                                            //       dialogReject(users[index],users[index].id),
                                                            // );
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
                                              ):users[index].bidder_name=='cost'?Center(
                                                child: Container(
                                                  margin: EdgeInsets.only(top: 240),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('COMPLETED TASK AND PAYMENT REQUEST',   style: TextStyle(
                                                            color: Colors
                                                                .black, fontWeight: FontWeight.bold)),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${ users[index]
                                                            .message}',   style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                            color: Colors
                                                                .black), textAlign: TextAlign.center,),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          dialogConfirm(users[index]);
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
                                                                  'CONFIRM',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold))),
                                                        ),
                                                      ),



                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            FirebaseApi.updateNotificationInvoice(users[index].invoice_id.toString(), 'initiate_bid', 'rejectbids');
                                                            FirebaseApi.deleteNotificationInvoice(
                                                                users[index].bid_id.toString(),
                                                                users[index].invoice_id.toString());
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
                                                                    'DECLINE COST',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.bold))),
                                                          ),
                                                        ),
                                                      ),




                                                      users[index].bidder_name=='' ||users[index].bidder_name=='cost' ?Container(): InkWell(
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
                                           return  user.bidder_name==''|| user.bidder_name=='cost'?Container():Container(
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
      ),
    );
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

    paymentMethod(context, amount, email) async {
      Charge charge = Charge()
        ..amount = amount
//        ..putMetaData('is_refund', is_refund)
//        ..putMetaData('artisan_id', signController.currentUser.user.id)
//        ..putMetaData('start_date', DateTime.now().toString())
        ..reference = _getReference()
      // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = email;
      CheckoutResponse response = await plugin.checkout(
        context,
        logo: Image.asset(
          'assets/images/fixme.png',
          scale: 5,
        ),
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
      );
      if (response.status) {
        network.validatePayment(response.reference);
        Utils().storeData('paymentToken', 'active');
        print(response.reference);
      }
    }



    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) =>  AlertDialog(
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

                network.confirmBudget(
                    context: context,
                    bidderUserId: data.bidder_id,
                    bidId: data.bid_id,
                    invoceId: data.invoice_id,
                    paymentMethod: 'wallet',
                    data: data,
                    state: true,
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
              onTap: ()async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var status = prefs.getString('paymentToken');
                if (status == null || status == 'null' || status == '' || status == 'in_active') {
                  Navigator.pop(context);
                  paymentMethod(context, 5000, network.email);
                }else {
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

                  network.confirmBudget(
                    context: context,
                    bidderUserId: data.bidder_id,
                    bidId: data.bid_id,
                    invoceId: data.invoice_id,
                    paymentMethod: 'card',
                    data: data,
                    state: true,
                  );
                } },
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
