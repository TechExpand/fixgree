import 'package:flutter/material.dart';
import 'package:fixme/Services/network_service.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:provider/provider.dart';
import 'package:fixme/Model/UserBankInfo.dart';
import 'package:fixme/Model/TransactionDetails.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:intl/intl.dart';
import 'Providers/WalletProvider.dart';
import 'WalletAddCard.dart';
import 'WalletFund.dart';
import 'WalletHistory.dart';
import 'WalletPay.dart';
import 'WalletWithdraw.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var network = Provider.of<WebServices>(context);
    var walletProvider = Provider.of<WalletProvider>(context);
    return Scaffold(
        backgroundColor: Color(0xFF9B049B),
        body: Column(
          children: [
            Container(
              height: 210,
              margin: const EdgeInsets.only(top: 25),
              width: deviceSize.width,
              child: Center(
                child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.only(
                        top: 25, left: 25, right: 25, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: WaveClipper(), //set our custom wave clipper
                          child: Container(
                            color: Color(0xFFDB5B04),
                            // height: 200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: FutureBuilder<Map>(
                            future: network.getUserWalletInfo(),
                            builder: (context, AsyncSnapshot<Map> snapshot) {
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
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('No Network',
                                            style: TextStyle(
                                                // letterSpacing: 4,
                                                color: Color(0xFF333333),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  );
                                } else {
                                  UserBankInfo userBankInfo =
                                      UserBankInfo.fromJson(snapshot.data);
                                  walletProvider.setUserBankInfo = userBankInfo;
                                  String accountNo = userBankInfo.accountNumber;
                                  mainWidget = Center(
                                      child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                                userBankInfo.accountName
                                                    .capitalizeFirstOfEach,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 21,
                                                    height: 1.4,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                                '\₦${userBankInfo.balance}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    height: 1.5,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Account No:',
                                              style: TextStyle(
                                                  // letterSpacing: 4,
                                                  color: Color(0xFF25262A),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          Text('$accountNo',
                                              style: TextStyle(
                                                  letterSpacing: 3,
                                                  color: Color(0xFF25262A),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ],
                                  ));
                                }
                              } else {
                                mainWidget = Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
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
                            },
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Consumer<WalletProvider>(builder: (context, model, widget) {
              return Container(
                padding: const EdgeInsets.only(right: 19, left: 19),
                margin: const EdgeInsets.only(top: 5),
                height: 90,
                width: deviceSize.width,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          child: Icon(FeatherIcons.refreshCcw,
                              color: Color(0xFF9B049B)),
                          backgroundColor: Colors.white,
                          heroTag: null,
                          onPressed: () {
                            if (walletProvider.getUserBankInfo == null) {
                            } else {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return WalletPay(
                                        userBankInfo: model.userBankInfo);
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
                            }
                          },
                          elevation: 0,
                        ),
                        Text('Pay',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.4,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          child: Icon(Icons.payment,
                              size: 28, color: Color(0xFF9B049B)),
                          backgroundColor: Colors.white,
                          heroTag: null,
                          onPressed: () {
                            if (walletProvider.getUserBankInfo == null) {
                            } else {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return WalletFund(
                                        userBankInfo: model.userBankInfo);
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
                            }
                          },
                          elevation: 0,
                        ),
                        Text('Fund',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.4,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          child: Icon(FeatherIcons.upload,
                              color: Color(0xFF9B049B)),
                          backgroundColor: Colors.white,
                          heroTag: null,
                          onPressed: () {
                            if (walletProvider.getUserBankInfo == null) {
                            } else {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return WalletWithdraw(
                                        userBankInfo: model.userBankInfo);
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
                            }
                          },
                          elevation: 0,
                        ),
                        Text('Withdraw',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.4,
                                fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
              );
            }),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.only(top: 15),
              decoration:
                  BoxDecoration(borderRadius: radius, color: Colors.white),
              child: Column(children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return WalletAddCard();
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FeatherIcons.plus, color: Color(0xFF333333)),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Add payment card',
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 18,
                              height: 1.4,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 19, right: 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Last Transactions',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600)),
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return WalletHistory();
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
                          child: Text('See all',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFBD4591),
                                  fontWeight: FontWeight.w600)),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List>(
                      future: network.getUserTransactions(),
                      builder: (context, AsyncSnapshot<List> snapshot) {
                        Widget mainWidget;
                        if (snapshot.connectionState == ConnectionState.none) {
                          mainWidget = Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('No Network',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        } else {
                          if (snapshot.data == null) {
                            mainWidget = Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Loading',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          } else {
                            mainWidget = ListView.builder(
                              itemCount: snapshot.data.length,
                              padding: const EdgeInsets.only(
                                  top: 10, left: 3, right: 5),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                snapshot.data.sort((a, b) {
                                  var ad =
                                      DateTime.parse(a['transaction_date']);
                                  var bd =
                                      DateTime.parse(b['transaction_date']);
                                  var s = bd.compareTo(ad);
                                  return s;
                                });
                                TransactionDetails transactionDetails =
                                    TransactionDetails.fromJson(
                                        snapshot.data[index]);
                                return ListTile(
                                    leading: Container(
                                      height: 43,
                                      width: 43,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color(0xFF9B049B),
                                      ),
                                      child: Icon(FeatherIcons.checkCircle,
                                          color: Colors.white),
                                    ),
                                    title: Text(
                                        transactionDetails.paymentDescription
                                            .capitalizeFirstOfEach,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.w600)),
                                    subtitle: Text(
                                        '${DateFormat('MMM dd, y').format(transactionDetails.transactionDate)}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w600)),
                                    trailing: buildTransactionText(
                                        transactionDetails.transactionType,
                                        '${transactionDetails.amountPaid}',
                                        transactionDetails.currency));
                              },
                            );
                          }
                        }
                        return mainWidget;
                      }),
                ),
              ]),
            )),
          ],
        ));
  }

  Widget buildTransactionText(String type, String amount, String currency) {
    Widget text;
    switch (type) {
      case "credit":
        text = Text('+ ${currencySymbol(currency)}$amount',
            style: TextStyle(
                fontSize: 17,
                color: Color(0xFF02FF1B),
                fontWeight: FontWeight.w600));
        break;
      case "withdrawal":
        text = Text('- ${currencySymbol(currency)}$amount',
            style: TextStyle(
                fontSize: 17,
                color: Color(0xFFFF0202),
                fontWeight: FontWeight.w600));
        break;
      default:
    }
    return text;
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0,
        size.height * 1.2); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 2.24, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    // path.quadraticBezierTo(
    // firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    // path.quadraticBezierTo(
    //   size.width / 5,
    //   size.height,
    //   size.width,
    //   size.height - 200,
    // );

    path.lineTo(size.height * 1.8,
        0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
