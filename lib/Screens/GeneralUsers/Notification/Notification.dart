import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Screens/GeneralUsers/Wallet/WalletPay.dart';
import 'package:fixme/Screens/GeneralUsers/Notification/Pay.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/icons.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  final scafoldKey;
  final myPage;

  NotificationPage(this.scafoldKey, this.myPage);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  var publicKey = 'pk_live_624bc595811d2051eead2a9baae6fe3f77f7746f';
  final plugin = PaystackPlugin();
  initState() {
    super.initState();
    WebServices network = Provider.of<WebServices>(context, listen: false);
    FirebaseApi.clearCheckNotify(network.userId.toString());
    plugin.initialize(publicKey: publicKey);
  }

  var search;
  List<Notify> notify;

  @override
  Widget build(BuildContext context) {
    Utils data = Provider.of<Utils>(context, listen: false);
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

    return Material(
      child: CustomScrollView(physics: NeverScrollableScrollPhysics(), slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          elevation: 2.5,
          shadowColor: Color(0xFFF1F1FD).withOpacity(0.5),
          title: Container(
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 4.0, bottom: 4, left: 0),
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.keyboard_backspace,
                              size: 17, color: Colors.black),
                        ),
                      ),

                    Container(
                      margin: EdgeInsets.only(top: 5, left: 1),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 35,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SearchPage();
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
                        child: TextFormField(
                            obscureText: true,
                            enabled: false,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              labelStyle: TextStyle(color: Colors.black38),
                              labelText: 'What are you looking for?',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return ListenIncoming();
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
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
                          FirebaseApi.clearCheckChat(
                            network.mobileDeviceToken.toString(),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Stack(
                                children: [
                                  Icon(MyFlutterApp.fill_1,
                                      size: 23, color: Color(0xF0A40C85)),
                                  Icon(
                                    Icons.more_horiz,
                                    size: 23,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              StreamBuilder(
                                  stream: FirebaseApi.userCheckChatStream(
                                      network.mobileDeviceToken.toString()),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      notify = snapshot.data.docs
                                          .map((doc) =>
                                              Notify.fromMap(doc.data(), doc.id))
                                          .toList();

                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Positioned(
                                              left: 12, child: Container());
                                        default:
                                          if (snapshot.hasError) {
                                            return Positioned(
                                                left: 12, child: Container());
                                          } else {
                                            final users = notify;
                                            if (users.isEmpty || users == null) {
                                              return Positioned(
                                                  left: 12, child: Container());
                                            } else {
                                              return Container(
                                                margin: EdgeInsets.only(left: 12),
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(100)
                                                ),
                                              );
                                            }
                                          }
                                      }
                                    } else {
                                      return Positioned(
                                          left: 12, child: Container());
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ])),
          backgroundColor: Colors.white,
          forceElevated: true,
        ),
        SliverFillRemaining(
          child: StreamBuilder(
            stream: FirebaseApi.userNotificatioStream(network.userId.toString()),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                notify = snapshot.data.docs
                    .map((doc) => Notify.fromMap(doc.data(), doc.id))
                    .toList();

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Color(0xFF9B049B)),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                            strokeWidth: 2,
                            backgroundColor: Colors.white,
                          )),
                    );
                  default:
                    if (snapshot.hasError) {
                      return buildText('Something Went Wrong Try later');
                    } else {
                      final users = notify;
                      if (users.isEmpty) {
                        return buildText('No Notification Found');
                      } else
                        return Container(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              var date = data.compareDate(users[index].createdAt);
                              return Material(
                                color: Colors.white,
                                elevation: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.only(top: 0, left: 9),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.7,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: users[index].message,
                                                      style: GoogleFonts.poppins(
                                                          color: Colors.black),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            ' ${users[index].name.toString() == 'null null' ? '' : 'by ${users[index].name}'} ',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87)),
                                                  ]),
                                                ),
                                                users[index].type == 'new_project'
                                                    ? InkWell(
                                                        onTap: () {
                                                          FirebaseApi
                                                                  .updateNotification(
                                                                      users[index]
                                                                          .id,
                                                                      'bided')
                                                              .then((value) {
                                                            network.bidProject(
                                                                context,
                                                                network.userId,
                                                                users[index]
                                                                    .jobid,
                                                                widget
                                                                    .scafoldKey);
                                                          });
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              top: 15, bottom: 5),
                                                          width: 105,
                                                          height: 28,
                                                          child: Center(
                                                              child: Text(
                                                                  'GET THIS JOB',
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          13,
                                                                      color: Color(
                                                                          0xFFA40C85),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600))),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xFFA40C85)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                        ),
                                                      )
                                                    : users[index].type ==
                                                            'new_bid'
                                                        ? Container()
                                                        : users[index].type ==
                                                                'bided'
                                                            ? Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 15,
                                                                        bottom:
                                                                            5),
                                                                width: 105,
                                                                height: 28,
                                                                child: Center(
                                                                    child: Text(
                                                                        'JOB BIDDED',
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
                                                              )
                                                            : users[index].type ==
                                                                    'confirm'
                                                                ? Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                15,
                                                                            bottom:
                                                                                5),
                                                                    width: 105,
                                                                    height: 28,
                                                                    child: Center(
                                                                        child: Text(
                                                                            'CONFIRMED',
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                color: Color(0xFFA40C85),
                                                                                fontWeight: FontWeight.w500))),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Color(
                                                                                0xFFA40C85)),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                4)),
                                                                  )
                                                                : users[index]
                                                                            .type ==
                                                                        'bid_completed'
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                            barrierDismissible:
                                                                                false,
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                dialog(users[index]),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin: EdgeInsets.only(
                                                                              top:
                                                                                  15,
                                                                              bottom:
                                                                                  5),
                                                                          width:
                                                                              170,
                                                                          height:
                                                                              28,
                                                                          child: Center(
                                                                              child:
                                                                                  Text('CONFIRM COMPLETION', style: TextStyle(fontSize: 13, color: Color(0xFFA40C85), fontWeight: FontWeight.w500))),
                                                                          decoration: BoxDecoration(
                                                                              border:
                                                                                  Border.all(color: Color(0xFFA40C85)),
                                                                              borderRadius: BorderRadius.circular(4)),
                                                                        ),
                                                                      )
                                                                    : users[index]
                                                                                .type ==
                                                                            'bid_approval'
                                                                        ? Text('')
                                                                        : users[index].type ==
                                                                                'initiate_bid'
                                                                            ? Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  users[index].budget.toString().isEmpty
                                                                                      ? Container()
                                                                                      : Padding(
                                                                                          padding: const EdgeInsets.only(top: 6.0),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                'Budget amount is: ' '₦' + '${users[index].budget}',
                                                                                                style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 15),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                  InkWell(
                                                                                    onTap: () async {
                                                                                      print('kkkkkkkk');
                                                                                        dialogConfirm(users[index]);
                                                                                    },
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.only(top: 15, bottom: 5),
                                                                                      width: 105,
                                                                                      height: 28,
                                                                                      child: Center(child: Text('CONFIRM', style: TextStyle(fontSize: 13, color: Color(0xFFA40C85), fontWeight: FontWeight.w500))),
                                                                                      decoration: BoxDecoration(border: Border.all(color: Color(0xFFA40C85)), borderRadius: BorderRadius.circular(4)),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Container(),
                                                Text(
                                                  '$date',
                                                  style: TextStyle(
                                                      color: Colors.black38),
                                                ),
                                                Divider(),
                                              ])),
                                      Container(
                                        width: 90,
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6.0),
                                                child: PopupMenuButton(
                                                    offset: const Offset(0, 10),
                                                    elevation: 5,
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      size: 22,
                                                    ),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                              value: 1,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  FirebaseApi
                                                                      .deleteNotification(
                                                                          users[index]
                                                                              .id);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child: Text(
                                                                      'Clear Message'),
                                                                ),
                                                              )),
                                                        ])),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                ),
                              );

//
                            },
                            itemCount: users.length,
                          ),
                        );
                    }
                }
              } else {
                return Center(
                  child: Theme(
                      data: Theme.of(context)
                          .copyWith(accentColor: Color(0xFF9B049B)),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                        strokeWidth: 2,
                        backgroundColor: Colors.white,
                      )),
                );
              }
            },
          ),
        ),
      ]),
    );
  }

  dialog(index) {
    WebServices network = Provider.of<WebServices>(context, listen: false);
    return RatingDialog(
      title: 'Rate this Artisan/Vendor',
      message:
          'Tap a star to set your rating. Write review on this user(optional).',
      image: Container(
          width: 120,
          height: 120,
          child: Image.asset('assets/images/fixme.png')),
      submitButton: 'Submit',
      onSubmitted: (response) {
        print(network.bearer);
        FirebaseApi.updateNotification(index.id, 'confirm').then((value) {
          network.confirmPaymentAndReview(
            rating: response.rating,
            jobid: index.jobid,
            comment: response.comment,
            artisanId: index.artisanId,
            userId: network.userId,
            bidid:  index.bidId,
            serviceId:  index.servicerequestId,
          context:  context,
          );
        });
      },
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
                            bidderUserId: data.bidderId,
                            bidId: data.bidId,
                            invoceId: data.invoice_id,
                            paymentMethod: 'wallet',
                            data: data,
                            myPage: widget.myPage);
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
                              bidderUserId: data.bidderId,
                              bidId: data.bidId,
                              invoceId: data.invoice_id,
                              paymentMethod: 'card',
                              data: data,
                              myPage: widget.myPage);
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

  Widget buildText(String text) => Padding(
        padding: const EdgeInsets.only(top: 200.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.black38),
          textAlign: TextAlign.center,
        ),
      );
}
